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
            return [string[]]$global:MGMT_Env.Auth.Keys | Where-Object { $_ -like "*$WordToComplete*" }
        })]
        [string]$FQDN,
        [System.Management.Automation.PSCredential]$Credential,
        [validateset('currentuser','allusers')]
        [string]$Scope = 'currentuser',
        [ArgumentCompleter({
            [OutputType([System.Management.Automation.CompletionResult])]
            param(
                [string] $CommandName,
                [string] $ParameterName,
                [string] $WordToComplete,
                [System.Management.Automation.Language.CommandAst] $CommandAst,
                [System.Collections.IDictionary] $FakeBoundParameters
            )
            return [string[]]$global:MGMT_Env.Auth.Keys | Where-Object { $_ -like "*$WordToComplete*" }
        })]
        [string]$From
    )
    process {
        $Global:MGMT_Env.Auth.($FQDN) = $Credential
        $Authsave = @{}
        if ('' -ne $From){
            $Credential = $Global:MGMT_Env.Auth.($From)
        }
        if ($null -eq $Credential) {
            Write-Error -Message "The source credential is not found."
            return
        }
        if ($Scope -eq 'global') {
            return write-error -Message "The global scope is not implemented yet."
        }
        foreach ($obj in ($global:MGMT_Env.Auth.GetEnumerator()|Where-Object{$null -ne $_.Value})) {
            $Authsave.($obj.Key) =
                foreach ($CredItem in $obj.Value){
                    @{
                        UserName = $CredItem.UserName
                        Password = $CredItem.Password | ConvertFrom-SecureString -Key $global:MGMT_Env.UKey
                    }
                }
            if ($null -eq $_.Value){}
            elseif ($null -eq $_.value.password){}
            else {
                $Authsave.($_.Key) = @{
                    UserName = $_.Value.UserName
                    Password = $_.Value.password | ConvertFrom-SecureString -Key $global:MGMT_Env.UKey
                }
            }
        }
        Split-Path $MGMT_Env.AuthFile|Where-Object{! (Test-Path $_)}|ForEach-Object{New-Item -Path $_ -ItemType Directory -Force} | Out-Null
        Export-MGMTYAML -InputObject $Authsave -LiteralPath $MGMT_Env.AuthFile -Encoding utf8
    }
}