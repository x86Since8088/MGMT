Function Save-MGMTConfig {
    [cmdletbinding()]
    param(
        [switch]$Verify,
        [switch]$Force
    )
    process {
        if ($null -eq $global:MGMT_Env) {
            $Global:MGMT_Env = @{}
        }
        $ConfigSave = $global:MGMT_Env.config.clone()
        [string[]]$Keys = $ConfigSave.Crypto.keys
        foreach ($key in $keys) {
            if ($null -eq $ConfigSave.Crypto.$key) {}
            elseif ($ConfigSave.Crypto.$key.gettype().name  -match '^(list|int|byte)') 
                {$ConfigSave.Crypto.$key = ConvertTo-MGMTBase64 -Bytes $ConfigSave.Crypto.$key}
        }

        Backup-MGMTFile -Path $script:ConfigFile
        Export-MGMTYAML -InputObject $ConfigSave -LiteralPath $script:ConfigFile -Encoding utf8 -Verify:$((!$force))
        Backup-MGMTFile -Path $script:ConfigFile
        Save-MGMTCredential
    }
}
