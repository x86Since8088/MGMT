$WorkingFolder   = $PSScriptRoot
$Datafolder      = $WorkingFolder -replace "^(.*?)\\(.*)$",'$1\Data\$2'
$MGMTFolder      = $WorkingFolder -replace "^(.*?\\MGMT).*",'$1'
Remove-Module -Name MGMTConfig -ErrorAction Ignore -Force
Import-Module "$MGMTFolder\PowerShell\Modules\Data\MGMTConfig" -DisableNameChecking 
if (!(Test-Path $Datafolder)) {New-Item -Path $Datafolder -ItemType Directory | Out-Null}


foreach ($ModulePathItem in @(
    "$MGMTFolder\PowerShell\Modules"
    "$MGMTFolder\PowerShell\SavedModules"
))
{
    if (test-path $ModulePathItem) {
        Write-Warning -Message "Adding Env:PSModulePath: '$ModulePathItem'"
        [string]$env:PSModulePath = 
            [string[]]$ModulePathItem + 
            (
                $env:PSModulePath -split ';' | 
                    Where-Object {$_ -ne $ModulePathItem}
            ) -join ';'
    }
    else {
        Write-Warning -Message "Module path '$ModulePathItem' does not exist."
    }
}
