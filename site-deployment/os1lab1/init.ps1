$PSSR       = $PSScriptRoot  
$MGMTFolder = $PSSR -replace "^(.*?\\MGMT).*",'$1'
. $MGMTFolder\PowerShell\Init.ps1

Import-Module VMware.VimAutomation.Core -DisableNameChecking -SkipEditionCheck *> $null
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -InvalidCertificateAction Ignore -WebOperationTimeoutSeconds 300 -Confirm:$false | out-null
$Deployment_Environment = $PSSR -replace "^.*?site-deployment(\\|/)" -replace "(/|\\).*"
Write-Host -Message "Environment Name: $Deployment_Environment pulled from current folder '$script:PSSR'" -ForegroundColor Yellow
$ESXI_Obj = $MGMT_Env.config.sites.($Deployment_Environment).esxi
$ESXI_Creds = Get-MGMTCredential -SystemType esxi -SystemName $ESXI_Obj.SystemName
$PFSense_Obj = $MGMT_Env.config.sites.($Deployment_Environment).pfsense
$PFSense_Creds = Get-MGMTCredential -SystemType pfsense -SystemName $PFSense_Obj.SystemName

Set-MGMTDataObject -InputObject $global:MGMT_Env -Name Status,environment,$Deployment_Environment @{
    Name = $Deployment_Environment
    ESXI = $ESXI_Obj.fqdn
    PFSense = $PFSense_Obj.fqdn
}