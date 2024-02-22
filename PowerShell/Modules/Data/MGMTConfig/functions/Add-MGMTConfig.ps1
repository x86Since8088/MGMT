function Add-MGMTConfig {
    [cmdletbinding()]
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
            return (Get-MGMTHashtableKeys -Hashtable $global:MGMT_Env.config | 
                Where-Object { $_ -like "*$WordToComplete*" }
            ) -replace '^(.*)','config.$1'
        })]
        [string]$ConfigPath
    )
    process {
        $Global:MGMT_Env.config = $Global:MGMT_Env.config + $OptionalParameters
    }
}