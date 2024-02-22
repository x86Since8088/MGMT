$script:PSSR             = $PSScriptRoot
$script:DataFolder       = $script:PSSR  -replace '^(\\\\.*?|.*?)\\(.*\\.*)','$1\Data\$2'
$script:ConfigFile       = "$script:DataFolder\Config.yaml"
$script:MGMTFolder       = $WorkingFolder -replace "^(.*?\\MGMT).*",'$1'
$Script:ModuleFolder     = $script:PSSR
Write-Host -Message "MGMT: Loading MGMT module from '$Script:ModuleFolder'" -ForegroundColor Yellow
Write-Verbose -Message "MGMT: Loading indivifual functions from '$Script:ModuleFolder'" -Verbose
Get-ChildItem "$Script:ModuleFolder\functions\*.ps1" | ForEach-Object{
    Write-Verbose -Message "`tLoading function $($_.Name)" -Verbose
    . $_.FullName
    Get-Content $_.FullName|
        Where-Object{$_ -match '^\s*function\'}|
        foreach-object{
            $functionName = $_ -replace '^\s*function\s*([^\s\(]+).*','$1'
            Export-ModuleMember -Function $functionName
        }
}
$Global:MGMTModule = Get-MGMTConfig -ErrorAction Ignore
