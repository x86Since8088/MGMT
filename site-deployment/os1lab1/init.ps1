$PSSR       = $PSScriptRoot  
$MGMTFolder = $PSSR -replace "^(.*?\\MGMT).*",'$1'
. $MGMTFolder\PowerShell\Init.ps1

Import-Module VMware.VimAutomation.Core -DisableNameChecking -SkipEditionCheck *> $null
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -InvalidCertificateAction Ignore -WebOperationTimeoutSeconds 300 -Confirm:$false | out-null
$Environment = $PSSR -replace "^.*?site-deployment(\\|/)" -replace "(/|\\).*"
Write-Host -Message "Environment Name: $Environment pulled from current folder '$script:PSSR'" -ForegroundColor Yellow
$ESXI_Obj = $global:MGMT_Env.config.sites.($Environment).SystemTypes.esxi
$ESXI_Creds = Get-MGMTCredential -SystemType esxi -SystemName $ESXI_Obj.SystemName
$PFSense_Obj = $global:MGMT_Env.config.sites.($Environment).SystemTypes.pfsense
$PFSense_Creds = Get-MGMTCredential -SystemType pfsense -SystemName $PFSense_Obj.SystemName

Set-MGMTDataObject -InputObject $global:MGMT_Env -Name Status,environment,$Environment @{
    Name = $Environment
    SystemTypes = @{
        ESXI = $ESXI_Obj.fqdn
        PFSense = $PFSense_Obj.fqdn
    }
}
