Function Save-MGMTConfig {
    [cmdletbinding()]
    param(
        [switch]$Verify,
        [switch]$Force
    )
    process {
        $ConfigSave = $global:MGMT_Env.config.clone()
        if ($ConfigSave.shard       -notmatch '\w{4}') {$ConfigSave.shard             = ConvertTo-MGMTBase64 -Bytes $ConfigSave.shard}
        if ($ConfigSave.Crypto.salt -notmatch '\w{4}') {$ConfigSave.Crypto.salt       = ConvertTo-MGMTBase64 -Bytes $ConfigSave.Crypto.salt}
        if ($ConfigSave.Crypto.iv   -notmatch '\w{4}') {$ConfigSave.Crypto.iv         = ConvertTo-MGMTBase64 -Bytes $ConfigSave.Crypto.iv}
        if ($ConfigSave.Crypto.key  -notmatch '\w{4}') {$ConfigSave.Crypto.key        = ConvertTo-MGMTBase64 -Bytes $ConfigSave.Crypto.key}

        Backup-MGMTFile -Path $script:ConfigFile
        Export-MGMTYAML -InputObject $ConfigSave -LiteralPath $script:ConfigFile -Encoding utf8 -Verify:$((!$force))
        Backup-MGMTFile -Path $script:ConfigFile
        Save-MGMTCredential
    }
}
