$script:PSSR            = $PSScriptRoot
$script:MGMTFolder       = $script:PSSR -replace "^(.*?[/\\]MGMT).*",'$1'
$script:DataFolder       = $script:PSSR.replace($script:MGMTFolder,"$($script:MGMTFolder)-data")
$script:ConfigFile      = "$script:DataFolder\Config.yaml"
$Script:ModuleFolder    = $script:PSSR
$Script:Mycommand       = $MyInvocation.MyCommand
$Script:ScriptName      = $Script:Mycommand.Name
Write-Host -Message "$Script:ScriptName : Loading module from '$script:PSSR'" -ForegroundColor Yellow
Write-Verbose -Message "$Script:ScriptName : Loading functions from '$Script:ModuleFolder\functions'"
Get-ChildItem "$Script:ModuleFolder\functions\*.ps1" | ForEach-Object{
    Write-Verbose -Message "`tLoading function $($_.Name)" 
    . $_.FullName
    Get-Content $_.FullName|
        Where-Object{$_ -match '^\s*function\s'}|
        foreach-object{
            $functionName = $_ -replace '^\s*function\s*(\S*).*','$1'
            Export-ModuleMember -Function $functionName
        }
}