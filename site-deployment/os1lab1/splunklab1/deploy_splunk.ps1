param (
    $DeploymentEnvironment = ($PSScriptRoot -replace "^.*?site-deployment(\\|/)" -replace "(/|\\).*"),
    [string]$LinuxHostName,
    [string]$VMwareHostName,
    [string]$DNSServer = '10.10.10.10'
)
$LinuxIP = Resolve-DnsName -Name $LinuxHostName -Server $DNSServer | Select-Object -ExpandProperty IPAddress
$VMwareHostIP = Resolve-DnsName -Name $VMwareHostName -Server $DNSServer | Select-Object -ExpandProperty IPAddress
$Workingfolder = $PSScriptRoot
. "$(split-path $workingfolder)\init.ps1"
Connect-VIServer -Server $ESXI_Obj.ip -Credential $ESXI_Creds.Credential -Force
Add-MGMTSSHHostKey -HostName $ESXI_Obj.ip -KeyFilePath $KeyFilePath -Verbose
Add-MGMTSSHHostKey -HostName $PFSense_Obj.ip -KeyFilePath $KeyFilePath -Verbose
$Site     = $MGMT_Env.config.sites.($DeploymentEnvironment)
Set-SyncHashtable -InputObject $Site -Name splunk
if ($null -eq $Site.splunk.splunklab1) {$Site.splunk.splunklab1 = @()}
Set-SyncHashtable -InputObject $Site -Name domain
if ($null -eq $Site.domain.fqdn) {$Site.domain.fqdn = Read-Host -Prompt "Enter the domain name for the site '$DeploymentEnvironment'."}
if ($DNSServer -ne '') {}
elseif ($null -ne $Site.domain.dnsserver) {$DNSServer=$Site.domain.dnsserver}
else{
    return Write-Error -Message "No DNS server specified by -DNSServer for the site $global:MGMT_Env.config.sites.['$DeploymentEnvironment'].domain.dnsserver."
}
if ($null -eq $Site.splunk.splunk.splunklab1) {
    $Site.splunk.splunklab1 = @{
        SystemName = 'splunklab1'
        fqdn = "splunk1.$($Site.domain)"
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


# Define SSH connection details
$HostName = $Site.splunk.splunklab1.IP
$UserName = $Site.splunk.splunklab1
#[string]$KeyFilePath = $Sandbox.SplunkLinuxHostKeyFilePath

# Retrieve the SSH host key (RSA type)

$VM = Get-VM -Name $site.splunk.splunklab1.fqdn -ErrorAction Ignore

Install-MGMTSSHKeyFile -HostName $Site.pfsense.ip -UserName $PFSense_Creds.Credential.UserName -Verbose -RunFirst '8'
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
