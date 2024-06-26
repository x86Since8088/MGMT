$script:PSSR             = $PSScriptRoot
$script:MGMTFolder       = $script:PSSR -replace "^(.*?[/\\]MGMT).*",'$1'
$script:DataFolder       = $script:PSSR.replace($script:MGMTFolder,"$($script:MGMTFolder)-data")
$script:ConfigFile       = "$script:DataFolder/config.yaml"
$Script:ModuleFolder     = $script:PSSR
$script:Mycommand        = $MyInvocation.MyCommand
$Script:ScriptName       = $Mycommand.Name
Write-Host -Message "$($Script:ScriptName): Loading MGMT module from '$script:PSSR'" -ForegroundColor Yellow
Write-Verbose -Message "$($Script:ScriptName): Loading individual functions from '$Script:ModuleFolder'"
Get-ChildItem "$Script:ModuleFolder\functions\*.ps1" | ForEach-Object{
    Write-Verbose -Message "`tLoading function $($_.Name)" 
    . $_.FullName
    Get-Content $_.FullName |
        Where-Object{$_ -match '^\s*function\s'}|
        foreach-object{
            $functionName = $_ -replace '^\s*function\s*(\S*).*','$1'
            Export-ModuleMember -Function $functionName
        }
}
$Global:MGMTModule = Get-MGMTConfig -ErrorAction Ignore
Initialize-MGMTConfig