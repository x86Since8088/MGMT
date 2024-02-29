function Get-MGMTSystem {
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
            return (Get-MGMTHashtableKeys -Hashtable $global:MGMT_Env.config.sites | 
                Where-Object { $_ -like "*$WordToComplete*" }
            )
        })]
        [string[]]$Site,
        [string[]]$SystemType,
        [string[]]$SystemName
    )
    begin {
        $Schema = Get-MGMTSchema -SchemaName 'SystemSchema.yml'
        if ($null -eq $Global:MGMT_Env) {
            Initialize-MGMTConfig
        }
        $global:MGMT_Env.config.sites
        return $System
    }
}
