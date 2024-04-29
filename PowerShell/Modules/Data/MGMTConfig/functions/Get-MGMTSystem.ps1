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
            return (
                $global:MGMT_Env.config.sites.GetEnumerator()|
                    Where-Object{$_.Key -like $FakeBoundParameters['Environment']}|
                    Select-Object -ExpandProperty Value|
                    Select-Object -ExpandProperty SystemTypes|
                    Select-Object -ExpandProperty Keys|
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
            return (
                $global:MGMT_Env.config.sites.GetEnumerator()|
                    Where-Object{$_.Name -like $FakeBoundParameters['Environment']}|
                    Select-Object -ExpandProperty Value|
                    Select-Object -ExpandProperty SystemTypes|
                    Where-Object{$_.keys -like $FakeBoundParameters['SystemType']}|
                    ForEach-Object{$_.GetEnumerator()}|
                    Select-Object -ExpandProperty Name|
                    Where-Object{$_ -like "*$WordToComplete*"}
            )
        })]
        [string[]]$SystemName = '*'
    )
    begin {
        #Go through some gymnastics to get the hashtable keys and allow wildcards.
        [string[]]$Environment    = $Environment | Where-Object{$_ -ne ''}
        [string[]]$SystemType     = $SystemType | Where-Object{$_ -ne ''}
        [string[]]$SystemName     = $SystemName | Where-Object{$_ -ne ''}
        [string[]]$Enviornments   = foreach ($EnvironmentItem in $Environment) {
                                        ($global:MGMT_Env.config.sites).Keys |
                                            Where-Object{
                                                $_ -like $EnvironmentItem
                                            }
                                    }
        foreach ($EnvironmentItem in $Enviornments) {
            [string[]]$SystemTypes    = foreach($Type in $SystemType) {
                                            ($global:MGMT_Env.config.sites.($EnvironmentItem)).SystemTypes.Keys|
                                                Where-Object{$_ -like $Type}
                                        }
            foreach ($Type in $SystemTypes) {
                [array]$SystemNameKeys    = foreach ($Name in $SystemName) {
                                                ($global:MGMT_Env.config.sites).($EnvironmentItem).SystemTypes.($Type).keys |
                                                    Where-Object{$_ -like $Name}
                                            }
                foreach ($SystemNameKey in $SystemNameKeys) {
                    [pscustomobject]@{
                        Environment = $EnvironmentItem
                        SystemType = $Type
                        SystemName = $SystemNameKey
                        Data = $global:MGMT_Env.config.sites.($EnvironmentItem).SystemTypes.($Type).($SystemNameKey)
                    }
                }
            }
        }
    }
}
