param (
    $Environment = ($PSScriptRoot -replace "^.*?site-deployment(\\|/)" -replace "(/|\\).*"),
    $EnvironmentObj = $global:MGMT_Env.config.sites.($Environment),
    $Domain = ($EnvironmentObj.domain.fqdn,$EnvironmentObj.domain|Where-Object {$_ -match '\w'}|Select-Object -First 1),
    $SplunkHostName = 'splunk1',
    [string]$VMwareHostName = 'esxi1',
    [validateset('host','k8s','docker','aws')]
    [string]$Container = 'VM',
    [validateset('VMware','Hyper-V','KVM','XenServer','Proxmox','azure','aws','gcp','openstack')]
    [string]$Hypervisor = 'VMware',
    [string]$DNSServer = '10.10.10.10',
    [string]$VLAN = '10',
    [string]$VMNetwork = 'VM Network',
    [string]$Subnet = $EnvironmentObj.network.subnet,
    $LinuxISOFIleName = 'AlmaLinux-9.1-x86_64-minimal.iso'
)
$ErrorActionPreference = 'Stop'
$Workingfolder = $PSScriptRoot
. "$(split-path $workingfolder)\init.ps1"

$VMwareHostObject = $EnvironmentObj.SystemTypes.VMware_ESXi | Select-Object -First 1
if ($null -eq $VMwareHostObject) {
    return Write-Error -Message "No VMware ESXi host found for the site '$Environment'."
}
$VMwareHostIP = $VMwareHostObject.ip
if ($null -eq $VMwareHostIP) {
    return Write-Error -Message "No IP address found for the hostname '$VMwareHostName' on the DNS server '$DNSServer'."
}
$VMwareHostCreds = Get-MGMTCredential -SystemType VMware_Esxi -SystemName $VMwareHostObject.SystemName
if ($null -eq $VMwareHostCreds) {
    return Write-Error -Message "No credentials found for the VMware ESXi host '$VMwareHostObject.SystemName'."
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

Add-MGMTSSHHostKey -HostName $VMwareHostIP 
Add-MGMTSSHHostKey -HostName $PFSense_Obj.ip 

Set-SyncHashtable -InputObject $EnvironmentObj -Name splunk
if ($null -eq $EnvironmentObj.splunk.splunklab1) {$EnvironmentObj.SystemTypes.splunk.splunklab1 = @()}
if ($EnvironmentObj.domain -is [string]){
    $EnvironmentObj.domain = @{'fqdn' = $EnvironmentObj.domain}
}
Set-SyncHashtable -InputObject $EnvironmentObj -Name domain
if ($null -eq $EnvironmentObj.domain.fqdn) {$EnvironmentObj.domain.fqdn = Read-Host -Prompt "Enter the domain name for the site '$Environment'."}
if ($DNSServer -ne '') {}
elseif ($null -ne $EnvironmentObj.domain.dnsserver) {$DNSServer=$EnvironmentObj.domain.dnsserver}
else{
    return Write-Error -Message "No DNS server specified by -DNSServer for the site $global:MGMT_Env.config.sites.['$Environment'].domain.dnsserver."
}
if ($null -eq $EnvironmentObj.SystemTypes.splunk.splunklab1) {
    $EnvironmentObj.SystemTypes.splunk.splunklab1 = @{
        SystemName = 'splunklab1'
        fqdn = "splunk1.$($EnvironmentObj.domain)"
        IP  = Read-Host -Prompt "Enter the IP address for splunklab1"
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

if ($null -eq $EnvironmentObj.SystemTypes.splunk.splunklab1.fqdn) {
    $EnvironmentObj.splunk.splunklab1.fqdn = "splunk1.$($EnvironmentObj.domain)"
}


$DeploymentTargetObject = $EnvironmentObj.SystemTypes.splunk.splunklab1

# Define SSH connection details
$HostName = $DeploymentTargetObject.IP

#[string]$KeyFilePath = $Sandbox.SplunkLinuxHostKeyFilePath

$VM = Get-VM -Name $EnvironmentObj.SystemTypes.splunk.splunklab1.fqdn -ErrorAction Ignore

if ($null -eq $VM) {
    . Deploy-MGMTVMwareVM -VMName $DeploymentTargetObject.fqdn -VMHost $VMwareHostObject.ip -VMDatastore $VMwareHostObject.datastore `
    -VMNetwork $VMNetwork -VMTemplate 'AlmaLinux 8.4' -ISOFileName $LinuxISOFIleName `
    -VMCpuCount 2 -VMRamSizeGB 4 -VMHDDSizeGB 64 -VMHDDType Thin -VMHDDStorageFormat `
    Thin -HostName $DeploymentTargetObject.fqdn -DomainName $Domain -IPAddress $DeploymentTargetObject.IP `
    -Subnet $EnvironmentObj.network.subnet -Gateway $EnvironmentObj.network.gateway -DNSServer $DNSServer  `
    -OS Linux
}
$VM = Get-VM -Name $EnvironmentObj.SystemTypes.splunk.splunklab1.fqdn -ErrorAction Ignore


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
