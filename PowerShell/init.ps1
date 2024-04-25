$WorkingFolder   = $PSScriptRoot
$Datafolder      = $WorkingFolder -replace "^(.*?)[/\\](.*)$",'$1\Data\$2'
$MGMTFolder      = $WorkingFolder -replace "^(.*?[/\\]MGMT).*",'$1'
Remove-Module -Name MGMTConfig -ErrorAction Ignore -Force
Import-Module "$MGMTFolder\PowerShell\Modules\Data\MGMTConfig" -DisableNameChecking 
if (!(Test-Path $Datafolder)) {New-Item -Path $Datafolder -ItemType Directory | Out-Null}

[array]$AddModulePath = @(
    (gci "$MGMTFolder\PowerShell\Modules" -Directory).FullName
    "$MGMTFolder\PowerShell\SavedModules"
)

# The loop needs to iterate in reverse order to have paths appended to the beginning of $ENV:PAModulePath in the listed order.
[array]::Reverse($AddModulePath)
foreach ($ModulePathItem in $AddModulePath)
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
