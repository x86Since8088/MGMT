function Get-MGMTCredential {
    [cmdletbinding()]
    param(
        #[parameter(alias='ComputerName','FQDN')]
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
        [string[]]$SystemType = 'default',     
        [ArgumentCompleter({
            [OutputType([System.Management.Automation.CompletionResult])]
            param(
                [string] $CommandName,
                [string] $ParameterName,
                [string] $WordToComplete,
                [System.Management.Automation.Language.CommandAst] $CommandAst,
                [System.Collections.IDictionary] $FakeBoundParameters
            )
            return [string[]]$global:MGMT_Env.Auth.SystemType.($FakeBoundParameters['SystemType']).Keys | Where-Object { $_ -like "*$WordToComplete*" }
        })]
        [string[]]$SystemName,
        [string]$UserName = '.*',
        [string[]]$Tags,
        [string]$SystemNamesMatchingRegex = '^ -nomatch$',
        [validateset('currentuser','allusers')]
        [string]$Scope = 'currentuser',
        [pscredential]$SetCredential,
        [switch]$PromptIfMissing
    )
    begin{
        Import-MGMTCredential
        $Tags = $Taags |Where-Object{$_ -match '\S'} | Sort-Object -unique
        if ($scope -eq 'global') {
            return write-error -Message "The global scope is not implemented yet."
        }
        if ($Tags.count -ne 0) {
            [string]$SystemName = "$SystemName($($Tags -join ','))"
            [string]$SystemNameMatches = "^$($SystemName -replace "^\s*$",'.*?' )"
            if ($Tags.count -ne 0) {
                $SystemNameMatches+="\(\b$($Tags -join '\b.*?\b')\b\)"
            }
        }
        elseif ($SystemNamesMatchingRegex -match '\S') {
            $SystemNameMatches = $SystemNamesMatchingRegex
        }
        foreach ($SystemTypeItem in $SystemType) {
            foreach ($SystemNameItem in 
                ($Global:MGMT_Env.Auth.SystemType.($SystemTypeItem).Keys |
                    Where-Object {
                        ($_ -match $SystemNameMatches) -or
                        ($_ -in $SystemName)
                    }
                )
            )
            {
                foreach ($CredentialItem in (Get-MGMTDataObject -InputObject $global:MGMT_Env.Auth.SystemType -Name $SystemTypeItem,$SystemNameItem,Credential)) {
                    if ($CredentialItem.UserName -match "^$UserName$") {
                        [pscustomobject]@{
                            SystemName=$SystemNameItem
                            SystemType=$SystemTypeItem
                            UserName=$CredentialItem.UserName
                            Credential=$CredentialItem
                        }
                    }
                    if ($SetCredential -ne $null) {
                        if ($CredentialItem.UserName -match "^$UserName$") {
                            $CredentialItem = $SetCredential
                        }
                    }
                }
            }
        }
    }
}