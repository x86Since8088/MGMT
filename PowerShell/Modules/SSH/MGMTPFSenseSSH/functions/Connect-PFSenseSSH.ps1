#requires -modules Posh-SSH
function Connect-PFSenseSSH {
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
            import-module -name 
            return (Get-MGMTHashtableKeys -Hashtable $global:MGMT_Env.config | 
                Where-Object { $_ -like "*$WordToComplete*" }
            ) -replace '^(.*)','config.$1'
        })]
        [Parameter(Mandatory = $true)]
        [string]$SiteName,
        [Parameter(Mandatory = $true)]
        [pscredential]$Credential,
        [Parameter(Mandatory = $true)]
        [string]$KeyFilePath
    )
    Import-Module -Name 'Plink'
    $ErrorActionPreference = 'Stop'
}