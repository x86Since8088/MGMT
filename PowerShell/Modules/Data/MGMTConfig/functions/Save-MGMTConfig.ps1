Function Save-MGMTConfig {
    [cmdletbinding()]
    param(
        [switch]$Verify,
        [switch]$Force
    )
    process {
        $ConfigSave = $global:MGMT_Env.config.clone()
        if ($ConfigSave.shard.count       ) {$ConfigSave.shard             = ConvertTo-MGMTBase64 -Bytes $ConfigSave.shard}
        if ($ConfigSave.Crypto.salt.count ) {$ConfigSave.Crypto.salt       = ConvertTo-MGMTBase64 -Bytes $ConfigSave.Crypto.salt}
        if ($ConfigSave.Crypto.iv.count   ) {$ConfigSave.Crypto.iv         = ConvertTo-MGMTBase64 -Bytes $ConfigSave.Crypto.iv}
        if ($ConfigSave.Crypto.key.count  ) {$ConfigSave.Crypto.key        = ConvertTo-MGMTBase64 -Bytes $ConfigSave.Crypto.key}

        Export-MGMTYAML -InputObject $ConfigSave -LiteralPath $script:ConfigFile -Encoding utf8 -Verify:$((!$force))
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
        Split-Path $global:MGMT_Env.AuthFile|Where-Object{! (Test-Path $_)}|ForEach-Object{New-Item -Path $_ -ItemType Directory -Force} | Out-Null
        Export-MGMTYAML -InputObject $Authsave -LiteralPath $global:MGMT_Env.AuthFile -Encoding utf8 -Verify:$Verify
    }
}
