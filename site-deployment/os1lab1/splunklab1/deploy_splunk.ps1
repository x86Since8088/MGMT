#Requires -modules MGMTConfig
[cmdletbinding()]
param (
    $Environment = ($PSScriptRoot -replace "^.*?site-deployment(\\|/)" -replace "(/|\\).*"),
    $EnvironmentObj = $global:MGMT_Env.config.sites.($Environment),
    $Domain = ($EnvironmentObj.domain.fqdn,$EnvironmentObj.domain|Where-Object {$_ -match '\w'}|Select-Object -First 1),
    $Systemtype = 'splunk',
    $SystemName = 'splunklab1',
    $DeploymentTargetObject = $EnvironmentObj.SystemTypes.$SystemType.$SystemName,
    $SplunkHostName = $DeploymentTargetObject.hostname,
    $MGMTSystem_VMware = (Get-MGMTSystem -Environment $Environment -SystemType VMware_ESXi -SystemName VMware_ESXi),
    [validateset('host','k8s','docker','aws')]
    [string]$Container = 'VM',
    [validateset('VMware')]
    [string]$Hypervisor = 'VMware',
    [string[]]$DNSServer = $EnvironmentObj.domain.dnsserver,
    [string]$VLAN = '10',
    [string]$VMNetwork = 'VM Network',
    [string]$Subnet = $EnvironmentObj.network.subnet,
    $LinuxISOFIleName = 'AlmaLinux-9.1-x86_64-minimal.iso'
)
begin {
   $ErrorActionPreference = 'Stop'
    $Workingfolder = $PSScriptRoot
    . "$(split-path $workingfolder)\init.ps1"

    $MGMTSystem_VMware = $EnvironmentObj.SystemTypes.VMware_ESXi | Select-Object -First 1
    if ($null -eq $MGMTSystem_VMware) {
        return Write-Error -Message "No VMware ESXi host found for the site '$Environment'."
    }
    $VMwareHostIP = $MGMTSystem_VMware.ip
    if ($null -eq $VMwareHostIP) {
        return Write-Error -Message "No IP address found for the hostname '$VMwareHostName' on the DNS server '$DNSServer'."
    }
    $VMwareHostCreds = Get-MGMTCredential -SystemType VMware_Esxi -SystemName $MGMTSystem_VMware.SystemName
    if ($null -eq $VMwareHostCreds) {
        return Write-Error -Message "No credentials found for the VMware ESXi host '$MGMTSystem_VMware.SystemName'."
    }
    $VMwareConnection = Connect-VIServer -Server $VMwareHostIP -Credential $VMwareHostCreds.Credential -Force
    if ($null -eq $VMwareConnection) {
        return Write-Error -Message "Failed to connect to the VMware host '$($ESXI_Obj.ip)' using the credentials '$($ESXI_Creds.Credential.UserName)'."
    }
    $PFSense_Obj = $EnvironmentObj.SystemTypes.pfsense
    if ($null -eq $PFSense_Obj) {
        return Write-Error -Message "No PFSense firewall found for the site '$Environment'."
    }
    $PFSense_Creds = Get-MGMTCredential -SystemType PFSense -SystemName $PFSense_Obj.SystemName
    if ($null -eq $PFSense_Creds) {
        return Write-Error -Message "No credentials found for the PFSense firewall '$($EnvironmentObj.SystemTypes.pfsense.SystemName)'."
    }

    Set-SyncHashtable -InputObject $EnvironmentObj -Name domain
    if  (
        ($DNSServer.count -eq 0) -or 
        ($DNSServer|Where-Object{!($_ -match '^\d+\.\d+\.\d+\.\d+$')})
        ) {
        return Write-Error -Message ("Invalid or no no DNS server specified by -DNSServer for the site $global:MGMT_Env.config.sites.['$Environment'].domain.dnsserver.`nRun:`n`t" +
        "Set-MGMTDataObject -InputObject `$global:MGMT_Env -Name config,sites,'$Environment',domain,dnsserver  -Value ip[,ip][,ip]`n`tSave-MGMTConfig")
    }
    Set-SyncHashtable -InputObject $EnvironmentObj -Name splunk
    if ($null -eq $EnvironmentObj.$SystemType.$SystemName) {$EnvironmentObj.SystemTypes.$SystemType.$SystemName = @()}
    if ($null -eq $EnvironmentObj.SystemTypes.$SystemType.$SystemName) {
        $EnvironmentObj.SystemTypes.$SystemType.$SystemName = @{
            SystemName = $SystemName
            fqdn = "$SplunkHostName.$Domain"
            IP  = Read-Host -Prompt "Enter the IP address for $SystemName"
            SplunkEnterpriseForLinuxDownloadURLTGZ = 
                if (YN -Message "Enter the Splunk Enterprise for Linux download URL (tar.gz)" ) {
                    Read-Host -Prompt "Enter the Splunk Enterprise for Linux download URL (tar.gz)"
                }
                ELSE {
                    'https://download.splunk.com/products/splunk/releases/9.2.0.1/linux/splunk-9.2.0.1-d8ae995bf219-Linux-x86_64.tgz'
                }
        }
        Save-MGMTConfig
    }

    if ($null -eq $EnvironmentObj.SystemTypes.$SystemType.$SystemName.fqdn) {
        $EnvironmentObj.$SystemType.$SystemName.fqdn = "$SplunkHostName.$Domain"
    }


    $DeploymentTargetObject = $EnvironmentObj.SystemTypes.$SystemType.$SystemName

    # Define SSH connection details
    $HostName = $DeploymentTargetObject.IP

    #[string]$KeyFilePath = $Sandbox.SplunkLinuxHostKeyFilePath

    $VM = Get-VM -Name $EnvironmentObj.SystemTypes.$SystemType.$SystemName.fqdn -ErrorAction Ignore

    if ($null -eq $VM) {
        . Deploy-MGMTVMwareVM -VMName $DeploymentTargetObject.fqdn -VMHost $MGMTSystem_VMware.ip -VMDatastore $MGMTSystem_VMware.datastore `
        -VMNetwork $VMNetwork -VMTemplate 'AlmaLinux 8.4' -ISOFileName $LinuxISOFIleName `
        -VMCpuCount 2 -VMRamSizeGB 4 -VMHDDSizeGB 64 -VMHDDType Thin -VMHDDStorageFormat `
        Thin -HostName $DeploymentTargetObject.fqdn -DomainName $Domain -IPAddress $DeploymentTargetObject.IP `
        -Subnet $EnvironmentObj.network.subnet -Gateway $EnvironmentObj.network.gateway -DNSServer $DNSServer  `
        -OS Linux
    }
    $VM = Get-VM -Name $EnvironmentObj.SystemTypes.$SystemType.$SystemName.fqdn -ErrorAction Ignore

    Add-MGMTSSHHostKey -HostName $VMwareHostIP 
    Add-MGMTSSHHostKey -HostName $PFSense_Obj.ip 
    Install-MGMTSSHKeyFile -HostName $EnvironmentObj.SystemTypes.pfsense.ip -UserName $PFSense_Creds.Credential.UserName -Verbose -RunFirst '8'
    # SSH into the Alma Linux system
    ssh -i $KeyFilePath $UserName@$HostName "yum install -y wget"  # Install wget (if not already installed)

    # Download Splunk Enterprise package
    ssh -i $KeyFilePath $UserName@$HostName "wget $($sandbox.SplunkEnterpriseForLinuxDownloadURL) splunk.tgz"

    # Extract Splunk package
    ssh -i $KeyFilePath $UserName@$HostName "sudo mkdir /opt/splunk"
    ssh -i $KeyFilePath $UserName@$HostName "sudo tar xvzf splunk.tgz -C /opt"
    ssh -i $KeyFilePath $UserName@$HostName "sudo chown $UserName /opt/splunk"

    # Start Splunk
    ssh -i $KeyFilePath $UserName@$HostName @'
    export SPLUNK_USERNAME=admin
    export SPLUNK_PASSWORD=$plunk@DMIN
    export SPLUNK_HOME=/opt/splunk
    echo "[user_info]" >> /opt/splunk/etc/system/local/user-seed.conf
    echo "USERNAME = $SPLUNK_USERNAME" >> /opt/splunk/etc/system/local/user-seed.conf
    echo "PASSWORD = $SPLUNK_PASSWORD" >> /opt/splunk/etc/system/local/user-seed.conf
    sudo /opt/splunk/bin/splunk enable boot-start
    #sudo $SPLUNK_HOME/bin/splunk enable boot-start -user splunk -systemd-managed 1
    sudo /opt/splunk/bin/splunk start --accept-license"
    sudo /opt/splunk/bin/splunk enable web-ssl
    sudo /opt/splunk/bin/splunk set web-port 443
    sudo /opt/splunk/bin/splunk stop
    sudo /opt/splunk/bin/splunk start
'@

    # Access Splunk Web UI (optional)
    Write-Host "Splunk Web UI is accessible at: https://$HostName`:443"
}