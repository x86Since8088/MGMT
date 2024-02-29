$WorkingFolder   = $PSScriptRoot
$Datafolder      = $WorkingFolder -replace "^(.*?)\\(.*)$",'$1\Data\$2'
$MGMTFolder      = $WorkingFolder -replace "^(.*?\\MGMT).*",'$1'
Remove-Module -Name MGMTConfig -ErrorAction Ignore -Force
Import-Module "$MGMTFolder\PowerShell\Modules\Data\MGMTConfig" -DisableNameChecking 
if (!(Test-Path $Datafolder)) {New-Item -Path $Datafolder -ItemType Directory | Out-Null}

Write-Warning -Message "Adding Env:PSModulePath: '$MGMTFolder\PowerShell\SavedModules'"
[string]$env:PSModulePath = [string[]]"$MGMTFolder\PowerShell\SavedModules" + ($env:PSModulePath -split ';' | 
    Where-Object {!($_ -eq "$MGMTFolder\PowerShell\SavedModules")}) -join ';'


