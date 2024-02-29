function Start-MGMTSetup {
    [CmdletBinding()]
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
            $global:MGMT_Env.config.sites.Keys | Where-Object { $_ -like "*$WordToComplete*" }|
                ForEach-Object{[System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)}
        })]
        [string]$DeploymentEnvironment,
        [ArgumentCompleter({
            [OutputType([System.Management.Automation.CompletionResult])]
            param(
                [string] $CommandName,
                [string] $ParameterName,
                [string] $WordToComplete,
                [System.Management.Automation.Language.CommandAst] $CommandAst,
                [System.Collections.IDictionary] $FakeBoundParameters
            )
            $global:MGMT_Env.config.sites.VMwarevCenter.Keys | Where-Object { $_ -like "*$WordToComplete*" }|
                ForEach-Object{[System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)}
        })]
        [string[]]$vCeters,
        [string[]]$DNSServer,
        [string[]]$AWSAccount,
        [string[]]$AzureAccount
    )
}