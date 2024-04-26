$WorkingFolder   = $PSScriptRoot
$MGMTFolder      = $WorkingFolder -replace "^(.*?[/\\]MGMT).*",'$1'
[string[]]$Paths = $env:PSModulePath -split ';'
[array]$AddModulePath = @(
    (Get-ChildItem "$MGMTFolder\PowerShell\Modules" -Directory).FullName
    "$MGMTFolder\PowerShell\SavedModules"
)
# The loop needs to iterate in reverse order to have paths appended to the beginning of $ENV:PAModulePath in the listed order.
[array]::Reverse($AddModulePath)
$AddModulePath|
    Where-Object{$_ -notin $Paths}|
    ForEach-Object{
        if (Test-Path $_) {
            Write-Warning -Message "Adding Env:PSModulePath: '$_'"
            [string]$env:PSModulePath = "$_;$env:PSModulePath"
        }
        else {
            Write-Warning -Message "Module path '$_' does not exist."
        }
    }
Import-Module "$MGMTFolder\PowerShell\SavedModules\powershell-yaml" -DisableNameChecking
Remove-Module -Name MGMTConfig -ErrorAction Ignore -Force
Import-Module "$MGMTFolder\PowerShell\Modules\Data\MGMTConfig" -DisableNameChecking 
