$MGMTFolder = $psScriptRoot -replace "^(.*?\\MGMT).*",'$1'
. $MGMTFolder\PowerShell\Init.ps1

Import-Module VMware.VimAutomation.Core -DisableNameChecking -SkipEditionCheck *> $null
Set-PowerCLIConfiguration -Scope User -ParticipateInCEIP $false -InvalidCertificateAction Ignore -WebOperationTimeoutSeconds 300 -Confirm:$false | out-null
