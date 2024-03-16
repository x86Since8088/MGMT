$System = Get-MGMTSystem -Environment os1fw1 -SystemType k8s -SystemName contanerhost
if ($null -eq $System) {
    Set-MGMTSystem -Environment os1fw1 -SystemType Linux -SystemName k8s -Data @{
        IPAddress = (Read-Host -Prompt "Enter the IP Address of the system")
        FQDN = (Read-Host -Prompt "Enter the FQDN of the system")
        HostName = (Read-Host -Prompt "Enter the HostName of the system")
    }
    $System = Get-MGMTSystem -Environment os1fw1 -SystemType k8s -SystemName contanerhost
}
[array]$System = Get-MGMTSystem -Environment os1fw1 -SystemType k8s -SystemName contanerhost 
$Cred_K8s = Get-MGMTCredential -SystemType k8s -SystemName contanerhost -Scope currentuser
if ($null -eq $Cred_K8s) {
    Set-MGMTCredential -SystemType  k8s -SystemName contanerhost -Scope currentuser -Credential (Get-Credential -Message "Please enter a credential for $($System.data.name)") 
    $Cred_K8s = Get-MGMTCredential -SystemType k8s -SystemName contanerhost -Scope currentuser
}

$Deployments = @{}
$DeploymentsAborted = @{}

$System[0].Data | ForEach-Object {
    $Deployments[$_.ip] = $_
}
# is ssh key configured on remote server?

foreach ($Deployment in ([string[]]$Deployments.keys)) {
    $result = ssh -o "IdentitiesOnly=yes" -i ~/.ssh/id_rsa "$($Cred_K8s.credential.username)@$($Deployments[$Deployment].ip)" "echo 'connected'" 
    $Deployments[$Deployment].ConnectionTest = $result
    if ($result -eq 'connected') {
        Write-Host "SSH Key is configured on '$($Deployments[$Deployment].IP)' with ssh keys." -ForegroundColor Green
    }
    else {
        return Write-Host "SSH Key is not configured on '$($Deployments[$Deployment].IP)' with ssh keys." -ForegroundColor Red
        $DeploymentsAborted[$Deployment] = $Deployments[$Deployment]
        $Deployments.Remove($Deployment)
    }
}

$Commands = @'
dnf list installed | tail -n +2 | awk -F '[.]' '{ print $1 }'
'@

$Commands = $Commands -replace '/r'
$Installed = ssh -o "IdentitiesOnly=yes" -i ~/.ssh/id_rsa "$($Cred_K8s.credential.username)@$($system.data.ip)" $Commands
