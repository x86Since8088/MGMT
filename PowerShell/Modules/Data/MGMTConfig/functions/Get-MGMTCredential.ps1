function Get-MGMTCredential {
    [cmdletbinding()]
    param(
        #[parameter(alias='ComputerName','FQDN')]
        [string]$SystemName,
        [string]$UserName = '.',
        [string[]]$Tags,
        [string]$SystemNamesMatchingRegex,
        [validateset('currentuser','allusers')]
        [string]$Scope = 'currentuser',
        [pscredential]$SetCredential,
        [switch]$PromptIfMissing
    )
    begin{
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
        if ($SystemNamesMatchingRegex -match '\S') {
            $SystemNameMatches = $SystemNamesMatchingRegex
        }
        [array]$Results = 
            foreach ($Label in ($Global:MGMT_Env.Auth.Keys | Where-Object {$_ -match $SystemNameMatches})) {
                foreach ($CredentialItem in $Global:MGMT_Env.Auth.($Label)) {
                    if ($CredentialItem.UserName -match "^$UserName$") {
                        [pscustomobject]@{
                            Label=$Label
                            UserName=$CredentialItem.UserName
                            Credential=$CredentialItem
                        }
                    }
                }
            }
        if ($null -ne $SetCredential) {
            [array]$ExactMatches = $Results|
                Where-Object{$_.Label -eq $SystemName}|
                Where-Object{$_.UserName -eq $SetCredential.UserName}
            if ($SystemName -match '\S') {
                if ($ExactMatches.count -eq 1) {
                    Set-MGMTCredential -FQDN $SystemName -Credential $SetCredential
                }
                elseif ($Results.count -ne 0) {
                    $Results +=                         [pscustomobject]@{
                        Label=$SystemName
                        UserName=$Credential.UserName
                    }
                    $SelectedCredential = $Results|Out-GridView -OutputMode Multiple -Title "Select the credentials you want to save"
                    if ($null -ne $SelectedCredential) {
                        foreach ($CredItem in $SelectedCredential) {
                            $global:MGMT_Env.Auth.($CredItem.Label) = $global:MGMT_Env.Auth.($CredItem.Label) | 
                                Where-Object{$_.UserName -ne $CredItem.UserName}
                            Set-MGMTCredential -FQDN $CredItem.Label -Credential $SetCredential
                        }
                    }
                }
                else {
                    Set-MGMTCredential -FQDN $SystemName -Credential $SetCredential
                }
                Set-MGMTCredential -FQDN $SystemName -Credential $SetCredential
            }
            else {
                return Write-Error -Message "The FQDN is required to set the credentials."
            }
            $Global:MGMT_Env.Auth.($SystemName) = $SetCredential
        }
        elseif ($Null -eq $Results) {
            if (! $PromptIfMissing) {
                return Write-Error -Message "The credential for $SystemName is not found."
            }
            else {
                if ('Y' -eq (Read-Host -Prompt "Do you want to set the credentials for $SystemName? (Y/N)").ToUpper()) {
                    $TempCredential = Get-Credential -Message "Enter the credentials for $SystemName"
                    if ($null -ne $TempCredential) {
                        Set-MGMTCredential -FQDN $SystemName -Credential $TempCredential
                        $Global:MGMT_Env.Auth.($SystemName) = $TempCredential
                    }
                }
            }
        }
        
        if ($Null -eq $Global:MGMT_Env.Auth.($SystemName)) {
            $Results.Credential
        }
        else {
            $Global:MGMT_Env.Auth.($SystemName)
        }
    }
}