param (
    [string]$ComputerName,
    [pscredential]$Credential
)
if ($null -ne $Credential)
{
    credstore $ComputerName -Credential $Credential
}
else {
    credstore $ComputerName
    $Credential=Get-Variable -Scope global -Name "cred_$computername" -ValueOnly
}
$SSHSession = New-SSHSession -ComputerName $ComputerName -Credential $Credential -Force 
Invoke-SSHCommand -Command {
    rm -r /etc/vmware/license.cfg
    cp /etc/vmware/.#license.cfg /etc/vmware/license.cfg
    /etc/init.d/vpxa restart
} -SSHSession $SSHSession

Remove-SSHSession -SSHSession $SSHSession