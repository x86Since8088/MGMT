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
            return ($global:MGMT_Env.config.sites.Keys | 
                Where-Object { $_ -like "*$WordToComplete*" }
            )
        })]
        [string[]]$Environment = '*',
        [ArgumentCompleter({
            [OutputType([System.Management.Automation.CompletionResult])]
            param(
                [string] $CommandName,
                [string] $ParameterName,
                [string] $WordToComplete,
                [System.Management.Automation.Language.CommandAst] $CommandAst,
                [System.Collections.IDictionary] $FakeBoundParameters
            )
            return ($global:MGMT_Env.config.sites.($FakeBoundParameters['Environment']).SystemTypes.Keys |
                Where-Object { $_ -like "*$WordToComplete*" }
            )
        })]
        [string[]]$SystemType = '*',
        [ArgumentCompleter({
            [OutputType([System.Management.Automation.CompletionResult])]
            param(
                [string] $CommandName,
                [string] $ParameterName,
                [string] $WordToComplete,
                [System.Management.Automation.Language.CommandAst] $CommandAst,
                [System.Collections.IDictionary] $FakeBoundParameters
            )
            return ($global:MGMT_Env.config.sites.($FakeBoundParameters['Environment']).SystemTypes.($FakeBoundParameters['SystemType']).values |
                Where-Object { $_.SystemName -like "*$WordToComplete*" }
            )
        })]
        [string[]]$SystemName = '*'
    )
    begin {
        #Go through some gymnastics to get the hashtable keys and allow wildcards.
        [string[]]$Environment  = $Environment | Where-Object{$_ -ne ''}
        [string[]]$SystemType   = $SystemType | Where-Object{$_ -ne ''}
        [string[]]$SystemName   = $SystemName | Where-Object{$_ -ne ''}
        [string[]]$Enviornments = 
        foreach ($EnvironmentItem in $Environment) {
            ($global:MGMT_Env.config.sites).Keys |
                Where-Object{
                    $_ -like $EnvironmentItem
                }
        }
        foreach ($Env in $Enviornments) {
            [string[]]$SystemTypes = 
                foreach($Type in $SystemType) {
                    ($global:MGMT_Env.config.sites.($EnvironmentItem)).SystemTypes.Keys|
                        Where-Object{$_ -like $Type}
                }
            foreach ($Type in $SystemTypes) {
                [array]$DataObjects = foreach ($Name in $SystemName) {
                    ($global:MGMT_Env.config.sites).($EnvironmentItem).SystemTypes.($Type) |
                        Where-Object{$_.SystemName -like $Name}
                }
                foreach ($DataObject in $DataObjects) {
                    [pscustomobject]@{
                        Environment = $EnvironmentItem
                        SystemType = $Type
                        SystemName = $DataObject.SystemName
                        Data = $DataObject
                    }
                }
            }
        }
    }
}
