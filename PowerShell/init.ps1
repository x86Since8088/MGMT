$WorkingFolder   = $PSScriptRoot
$Datafolder      = $WorkingFolder -replace "^(.*?)\\(.*)$",'$1\Data\$2'
$MGMTFolder      = $WorkingFolder -replace "^(.*?\\MGMT).*",'$1'
Remove-Module -Name Get-MGMTConfig -ErrorAction Ignore -Force
Import-Module "$MGMTFolder\PowerShell\Modules\Data\Get-MGMTConfig.psm1" -DisableNameChecking
if (!(Test-Path $Datafolder)) {New-Item -Path $Datafolder -ItemType Directory | Out-Null}

Initialize-MGMTConfig
