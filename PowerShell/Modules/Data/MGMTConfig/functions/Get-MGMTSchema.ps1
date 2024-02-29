function Get-MGMTSchema{
    [CmdletBinding()]
    param (
        [ArgumentCompleter({
            [OutputType([System.Management.Automation.CompletionResult])]
            param(
                [string] $CommandName,
                [string] $ParameterName,
                [string] $WordToComplete,
                [System.Management.Automation.Language.CommandAst] $CommandAst,
                [System.Collections.IDictionary] $FakeBoundParameters
            )
            $SchemaPath = "$PSScriptRoot\Schemas"
            $SchemaFiles = Get-ChildItem $SchemaPath -Filter *.yml
            return $SchemaFiles.Name |
                Where-Object{$_ -like "*$WordToComplete*"} | 
                ForEach-Object {
                    [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
                }
        })]
        [string]$SchemaName="*"
    )
    begin {
        if ($null -eq $Global:MGMT_Env) {
            return "MGMT_Env is not defined. Please run Initialize-MGMTConfig to load the environment."
        }
        if ('' -eq $SchemaName) {
            return Write-Error -Message "SchemaName is required."
        }
    }
    process {
        $SchemaPath = "$PSScriptRoot\Schemas"
        Get-Content -Path "$SchemaPath\$SchemaName" | ConvertFrom-Yaml   
    }
}