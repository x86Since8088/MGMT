$Workingfolder = $PSScriptRoot
. "$workingfolder\init.ps1"
$script:PSSR = $PSScriptRoot
$script:Environment = "$PSSR" | Split-Path| Split-Path -Leaf
Write-Host -Message "Environment Name: $script:Environment pulled from current folder '$script:PSSR'" -ForegroundColor Yellow
$ESXI_Obj = $MGMT_Env.config.sites.($script:Environment).esxi
$ESXI_Creds = $MGMT_Env.Auth.($ESXI_Obj.fqdn)
$PFSense_Obj = $MGMT_Env.config.sites.($script:Environment).pfsense
$PFSense_Creds = $MGMT_Env.Auth.($PFSense_Obj.fqdn)


Set-DataObject -VariableName MGMT_Env -Name "Status.environment.$script:Environment" @{
    Name = $script:Environment
    ESXI = $ESXI_Obj.fqdn
    PFSense = $PFSense_Obj.fqdn
}

Import-Module VMware.VimAutomation.Core -DisableNameChecking -SkipEditionCheck *> $null
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -InvalidCertificateAction Ignore -WebOperationTimeoutSeconds 300 -Confirm:$false | out-null
Connect-VIServer -Server $ESXI_Obj.ip -Credential $ESXI_Creds -Force
Add-SSHHostKey -HostName $ESXI_Obj.ip -KeyFilePath $KeyFilePath
Add-SSHHostKey -HostName $PFSense_Obj.ip -KeyFilePath $KeyFilePath

break
# Define SSH connection details
$HostName = $Sandbox.SplunkLinuxHostIP
$UserName = $Sandbox.UserName
[string]$KeyFilePath = $Sandbox.SplunkLinuxHostKeyFilePath

# Retrieve the SSH host key (RSA type)

Function Install-SSHKeyFile {
  param (
    [string]$HostName,
    [string]$UserName,
    [string]$KeyFilePath
  )
  Add-SSHHostKey -HostName $HostName -KeyFilePath $KeyFilePath
  if ('' -eq $KeyFilePath) {
      $KeyFilePath = "$env:userprofile/.ssh/id_rsa"
      if (!(test-path $KeyFilePath)) {
          ssh-keygen.exe -t rsa -b 4096 -C "default" -f $KeyFilePath -N ""
          icacls $KeyFilePath /inheritance:d
          icacls $KeyFilePath /remove everyone
      }
      #$sandbox.Password| scp $KeyFilePath "$($UserName)@$($HostName):/home/$UserName/$(split-path $KeyFilePath -leaf)"
      ssh -i $KeyFilePath $UserName@$HostName -t bash @"
  export  keyinfo='$(Get-Content "$keyFilePath.pub")'
  echo `$keyinfo
  echo `$keyinfo >> ~/.ssh/authorized_keys
  if (( grep -q "`$keyinfo" ~/.ssh/authorized_keys )); then
    echo "found keyinfo in authorized_keys"
  else
    echo "missing keyinfo in authorized_keys"
    echo `$keyinfo >> ~/.ssh/authorized_keys
    chmod 600 ~/.ssh/authorized_keys
  fi
"@
  }
}

Install-SSHKeyFile -
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
