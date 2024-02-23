Function Set-MGMTCredential {
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
            return [string[]]$global:MGMT_Env.Auth.SystemType.Keys | Where-Object { $_ -like "*$WordToComplete*" }
        })]
        [string]$SystemType = 'default',        
        [ArgumentCompleter({
            [OutputType([System.Management.Automation.CompletionResult])]
            param(
                [string] $CommandName,
                [string] $ParameterName,
                [string] $WordToComplete,
                [System.Management.Automation.Language.CommandAst] $CommandAst,
                [System.Collections.IDictionary] $FakeBoundParameters
            )
            return [string[]]($global:MGMT_Env.Auth.SystemType).($FakeBoundParameters['SystemType']).Keys | Where-Object { $_ -like "*$WordToComplete*" }
        })]
        [Alias('fqdn','hostname','ComputerName')]
        [string]$SystemName,
        [System.Management.Automation.PSCredential]$Credential,
        [validateset('currentuser','allusers')]
        [string]$Scope = 'currentuser'
    )
    process {
        Set-SyncHashtable -InputObject $global:MGMT_Env      -Name Auth
        Set-SyncHashtable -InputObject $global:MGMT_Env.Auth -Name SystemType
        if ('' -eq $SystemName) {}
        elseif ('' -eq $SystemType) {
            return Write-Error -Message "The source system type is not found."
        }
        elseif ($null -eq $Credential) {
            return Write-Error -Message "The source credential is not found."
        }
        elseif ($Scope -eq 'global') {
            return write-error -Message "The global scope is not implemented yet."
        }
        else {
            Set-SyncHashtable -InputObject $Global:MGMT_Env.Auth.SystemType -Name $SystemType
            Set-SyncHashtable -InputObject $Global:MGMT_Env.Auth.SystemType.($SystemType) -Name $SystemName
            $Global:MGMT_Env.Auth.SystemType.($SystemType).($SystemName).Credential = $Credential
        }
        Save-MGMTCredential
    }
}