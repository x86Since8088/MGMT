param (
    [string]$ComputerName,
    [pscredential]$Credential = (.{
        Get-MGMTCredential -SystemType VMware_ESXi -SystemName $ComputerName
        Get-MGMTCredential -SystemType VMware_ESXi -SystemName VMware_ESXi
    }|Where-Object{($_).credential}|Select-Object -First 1).credential
)
$SSHSession = New-SSHSession -ComputerName $ComputerName -Credential $Credential -Force 
Invoke-SSHCommand -Command @'
    rm -r /etc/vmware/license.cfg -f
    cp "/etc/vmware/.#license.cfg" /etc/vmware/license.cfg
    /etc/init.d/vpxa restart
'@ -SSHSession $SSHSession

Remove-SSHSession -SSHSession $SSHSession