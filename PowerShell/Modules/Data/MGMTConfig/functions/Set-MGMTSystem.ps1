function Set-MGMTSystem {
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
            return ($global:MGMT_Env.config.sites.($FakeBoundParameters['Environment']).SystemTypes.($FakeBoundParameters['SystemType']).keys |
                Where-Object { $_ -like "*$WordToComplete*" }
            )
        })]
        [string[]]$SystemName,
        [hsahtable]$Data,
        [switch]$Confirm=$true,
        [switch]$SaveConfig
    )
    begin {
        $Clone = $global:MGMT_Env.config.sites.($EnvironmentItem).SystemTypes.($SystemType).($SystemName).clone()
        if ($Confirm) {
            [string]$Message = "Are you sure you want to change the following settings for $($EnvironmentItem) $($SystemType) $($SystemName)?`n`t"
            $Message += ($Data | ConvertTo-Yaml) -split '\n' -join "`n`t"
            if (YN -Message $Message) {
                
            }
        }
        if (!$Confirm -or $Consent) {
            Set-MGMTDataObject -InputObject $global:MGMT_Env -Name config,sites,($EnvironmentItem),SystemTypes,($SystemType),($SystemName) -Value $Data -SaveConfig:$SaveConfig
        }
    }
}