$script:PSSR             = $PSScriptRoot
$script:DataFolder       = $script:PSSR -replace '^(\\\\.*?|.*?)\\(.*\\.*)','$1\Data\$2'
$script:ConfigFile       = "$script:DataFolder\Config.yaml"
$script:MGMTFolder       = $WorkingFolder -replace "^(.*?\\MGMT).*",'$1'
$Script:ModuleFolder     = $script:PSSR
$Script:ScriptName       = $MyInvocation.MyCommand.Name
Write-Verbose -Message "$($Script:ScriptName): Loading MGMT module from '$script:PSSR'" -ForegroundColor Yellow
Write-Verbose -Message "$($Script:ScriptName): Loading individual functions from '$Script:ModuleFolder'"
Get-ChildItem "$Script:ModuleFolder\functions" -directory | Get-ChildItem -Filter *.ps1 | ForEach-Object{
    Write-Verbose -Message "`tLoading function $($_.Name)" 
    . $_.FullName
    Get-Content $_.FullName|
        Where-Object{$_ -match '^\s*function\s'}|
        foreach-object{
            $functionName = $_ -replace '^\s*function\s*(\S*).*','$1'
            Export-ModuleMember -Function $functionName
        }
}