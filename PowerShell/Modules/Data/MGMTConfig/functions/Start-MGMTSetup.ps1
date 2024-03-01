function Start-MGMTSetup {
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
            (Get-MGMTSystem -Environment "*$WordToComplete*" ).Environment
                
        })]
        [string]$Environment,
        [ArgumentCompleter({
            [OutputType([System.Management.Automation.CompletionResult])]
            param(
                [string] $CommandName,
                [string] $ParameterName,
                [string] $WordToComplete,
                [System.Management.Automation.Language.CommandAst] $CommandAst,
                [System.Collections.IDictionary] $FakeBoundParameters
            )
            (Get-MGMTSystem -Environment $FakeBoundParameters.Environment -SystemType "*$WordToComplete*" -SystemType VMware  )
        })]
        [string[]]$vCeters,
        [string[]]$DNSServer,
        [string[]]$AWSAccount,
        [string[]]$AzureAccount
    )
    begin {
        
    }
}