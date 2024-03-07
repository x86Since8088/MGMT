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
        Initialize-MGMTConfig
        Write-Host "Starting MGMT Setup" -ForegroundColor Yellow
        Write-Host "Lets register the environments."
        Write-host "Environments are the groups of systems, networks, virtualization, containers, and services that are managed together.  They are often named by the location, the cloud provider, and the purpose of the environment."
        write-host "Provide a comma seperated list of one or more environments.  it is best to have a naming standard.  Here are some recomendations"
        Write-Host "`tOS1Splunklab, os1ansiblelab, os1ansibleprod, os1home, az1lab, aws1lab"
        Write-Host "`t`tOS1lab is an on-site computing environment #1 where a lab environment exists, this might be segmented from os1home."
        Write-Host "`t`taz1lab is the first azure environment and aws1 is the first aws environment"
        [string[]]$Environments = Read-Host -Prompt "Provide a comma seperated list of one or more environments:" 
        $Environments =$Environments -split ',' -replace '^\s*|\s*$'
        
        
    }
}