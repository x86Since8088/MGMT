$Workingfolder = $PSScriptRoot
$MGMTFolder      = $WorkingFolder -replace "^(.*?\\MGMT).*",'$1'
. "$MGMTFolder\PowerShell\init.ps1"
$script:PSSR = $PSScriptRoot
$script:Environment = "$PSSR" -replace "^.*?site-deployment(\\|/)" -replace "(/|\\).*"
$Script:ConfigInfo = $global:MGMT_Env.config.sites.($script:Environment)
Write-Host -Message "Environment Name: $script:Environment pulled from current folder '$script:PSSR'" -ForegroundColor Yellow
$AZCredentialID = @{
    SystemType = "Azure"
    SystemName = "Skarke.net"
}

#Test-MGMTCredentialAZ
$AZCredential = Get-MGMTCredential @AZCredentialID -Scope currentuser
if ($Null -eq $AZCredential) {
    $AZCredential = Get-Credential -Message "Enter your Azure credentials for:`n$($AZCredentialID|convertto-yaml)"
    #$test = Test-MGMTCredentialAZ -credential $AZCredential
    $Connection = Connect-AzAccount -Credential $AZCredential
    if ($null -eq $Connection) {
        Write-Host -Message "Failed to connect to Azure" -ForegroundColor Red
    } else {
        Write-Host -Message "Successfully connected to Azure" -ForegroundColor Green
        Set-MGMTCredential @AZCredentialID -Credential $AZCredential -Scope currentuser
    }
}
$AZTennantInfo = Get-AzTenant
#$AZSubscription = Get-AzSubscription
$AZOrganization = Get-AzADOrganization
$AZOrganization.VerifiedDomain
foreach ($VerifiedDomain in $AZOrganization.VerifiedDomain) {
    Set-MGMTCredential -SystemType "Azure" -SystemName $VerifiedDomain.Name -Credential $AZCredential -Scope currentuser 
}

$AZContext = get-AZContext
#$AZContext = Set-AzContext -SubscriptionId $AZOrganization.DefaultSubscription -TenantId $AZOrganization.Id -Credential $AZCredential

$AzADApplication = Get-AzADApplication
$ResourceGroup = Get-AzResourceGroup  

$AzVirtualNetworkGateway = Get-AzVirtualNetworkGateway -ResourceGroupName $ResourceGroup.ResourceGroupName
$AZContext.Subscription.ExtendedProperties

Get-AzUserSubscription 