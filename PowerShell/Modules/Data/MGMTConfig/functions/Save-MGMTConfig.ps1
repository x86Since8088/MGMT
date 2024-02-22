Function Save-MGMTConfig {
    [cmdletbinding()]
    param(
        [switch]$Verify,
        [switch]$Force
    )
    process {
        Export-MGMTYAML -InputObject $global:MGMT_Env.config -LiteralPath $script:ConfigFile -Encoding utf8 -Verify:$((!$force))
        $Authsave = @{}
        $global:MGMT_Env.Auth.GetEnumerator()|ForEach-Object{
            if ($null -eq $_.Value){}
            elseif ($null -eq $_.value.password){}
            else {
                $Authsave.($_.Key) = @{
                    UserName = $_.Value.UserName
                    Password = $_.Value.password | ConvertFrom-SecureString -Key $global:MGMT_Env.Key
                }
            }
        }
        Split-Path $MGMT_Env.AuthFile|Where-Object{! (Test-Path $_)}|ForEach-Object{New-Item -Path $_ -ItemType Directory -Force} | Out-Null
        Export-MGMTYAML -InputObject $Authsave -LiteralPath $MGMT_Env.AuthFile -Encoding utf8 -Verify:$Verify
    }
}
