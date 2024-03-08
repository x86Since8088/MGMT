$System = Get-MGMTSystem -Environment os1fw1 -SystemType k8s -SystemName contanerhost
if ($null -eq $System) {
    Set-MGMTSystem -Environment os1fw1 -SystemType Linux -SystemName k8s -Data @{
        IPAddress = (Read-Host -Prompt "Enter the IP Address of the system")
        FQDN = (Read-Host -Prompt "Enter the FQDN of the system")
        HostName = (Read-Host -Prompt "Enter the HostName of the system")
    }
    $System = Get-MGMTSystem -Environment os1fw1 -SystemType k8s -SystemName contanerhost
}
$System = Get-MGMTSystem -Environment os1fw1 -SystemType k8s -SystemName contanerhost 
$Cred_K8s = Get-MGMTCredential -SystemType k8s -SystemName contanerhost -Scope currentuser
if ($null -eq $Cred_K8s) {
    Set-MGMTCredential -SystemType  k8s -SystemName contanerhost -Scope currentuser -Credential (Get-Credential -Message "Please enter a credential for $($System.data.name)") 
    $Cred_K8s = Get-MGMTCredential -SystemType k8s -SystemName contanerhost -Scope currentuser
}

# is ssh key configured on remote server?

$result = ssh -o "IdentitiesOnly=yes" -i ~/.ssh/id_rsa "$($Cred_K8s.credential.username)@$($system.data.ip)" "echo 'connected'" 
if ($result -eq 'connected') {
    Write-Host "SSH Key is configured on the remote server with ssh keys." -ForegroundColor Green
}
else {

    return Write-Host "SSH Key is not configured on the remote server with ssh keys." -ForegroundColor Red
}

$Commands = @'
dnf list installed | tail -n +2 | awk -F '[.]' '{ print $1 }'
'@

$Commands = $Commands -replace '/r'
$Installed = ssh -o "IdentitiesOnly=yes" -i ~/.ssh/id_rsa "$($Cred_K8s.credential.username)@$($system.data.ip)" $Commands
