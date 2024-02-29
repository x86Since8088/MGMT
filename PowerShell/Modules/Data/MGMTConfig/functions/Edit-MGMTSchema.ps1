function Edit-MGMTSchema{
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
        [string]$SchemaName,
        [ArgumentCompleter({
            [OutputType([System.Management.Automation.CompletionResult])]
            param(
                [string] $CommandName,
                [string] $ParameterName,
                [string] $WordToComplete,
                [System.Management.Automation.Language.CommandAst] $CommandAst,
                [System.Collections.IDictionary] $FakeBoundParameters
            )
            $CompletionResults = Get-Command -Name "$WordToComplete*" -CommandType Application -ErrorAction SilentlyContinue | ForEach-Object {
                [System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Name)
            }
            return $CompletionResults
        })]
        [string]$Editor = (Get-Command -Name code,notepad++,notepad,edit -CommandType Application -ErrorAction Ignore|Select-Object -First 1).Name
    )
    begin {
        if ('' -eq $SchemaName) {
            return Write-Error -Message "SchemaName is required."
        }
        $SchemaPath = "$PSScriptRoot\schemas"
        if (-not (Test-Path -Path $SchemaPath)) {
            mkdir -Path $SchemaPath | Out-Null
        }
        Start-Process -FilePath $Editor -ArgumentList "$SchemaPath\$SchemaName"
    }
    process {
        Get-Content -Path "$SchemaPath\$SchemaName" | ConvertFrom-Yaml
    }
}