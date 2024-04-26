function Initialize-MGMTConfig {
    if ($env:USERPROFILE -notmatch '\w') {$env:USERPROFILE = "~"}
    if ($env:appdata -notmatch '\w') {$env:appdata = "$env:USERPROFILE\AppData\Roaming"}
    if ($env:localappdata -notmatch '\w') {$env:localappdata = "$env:USERPROFILE\AppData\Local"}
    if ($null -eq $global:MGMT_Env) {$global:MGMT_Env = [hashtable]::Synchronized(@{})}
    Set-SyncHashtable -InputObject $global:MGMT_Env -Name Auth
    Set-SyncHashtable -InputObject $global:MGMT_Env.Auth -Name SystemType
    $script:ConfigFile                                = "$script:Datafolder\config.yaml"
                                                        Split-Path $script:ConfigFile | 
                                                            Where-Object{-not (test-path $_)}|
                                                            ForEach-Object{new-item -ItemType Directory -Path $_ -Force}
    $Global:MGMT_Env.AuthFile                         = "$env:appdata\powershell\MGMTConfig\auth.yaml"
                                                        Split-Path $Global:MGMT_Env.AuthFile | 
                                                            Where-Object{-not (test-path $_)}|
                                                            ForEach-Object{new-item -ItemType Directory -Path $_ -Force}
                                                        Set-SyncHashtable -InputObject $global:MGMT_Env -Name config
    $global:MGMT_Env.config                           = Get-MGMTConfig
    if ($null -eq $global:MGMT_Env.config) {
        $global:MGMT_Env.config = [hashtable]::Synchronized(@{})
    }
    # This is not a key, but instead it is only part of the formation of keys.
    # Following key material will be stored outside of this working folder in locations suitable for per system or per user use.
    [byte[]]$Shard = 0,11,159,136,217,167,1,185,196,169,243,35,234,88,147,217,223,229,80,38,100,181,255,250,223,177,45,128,109,107,253,110
    # Define the credentials for each site hosts.
    Set-SyncHashtable -InputObject $global:MGMT_Env -Name Config
    Set-SyncHashtable -InputObject $global:MGMT_Env.config -Name Crypto
    if ($null -eq $global:MGMT_Env.Config.Crypto.salt ) {$global:MGMT_Env.Config.Crypto.salt  = Get-MGMTRandomBytes -ByteLength 16}
    if ($null -eq $global:MGMT_Env.Config.Crypto.iv   ) {$global:MGMT_Env.Config.Crypto.iv    = Get-MGMTRandomBytes -ByteLength 16}
    if ($null -eq $global:MGMT_Env.Config.Crypto.key  ) {$global:MGMT_Env.Config.Crypto.key   = Get-MGMTRandomBytes -ByteLength 32}
    if ($null -eq $global:MGMT_Env.config.Crypto.Shard) {$global:MGMT_Env.config.Crypto.Shard = Get-MGMTRandomBytes -ByteLength 32}
    [string[]]$Keys = $global:MGMT_Env.config.Crypto.keys
    foreach ($key in $keys) {
        if ($null -eq $global:MGMT_Env.config.Crypto.$key) {}
        elseif ($global:MGMT_Env.config.Crypto.$key.count  -gt 1) {}
        elseif ($global:MGMT_Env.config.Crypto.$key.gettype().name  -match '^(list|int|byte)') {}
        else {$global:MGMT_Env.config.Crypto.$key = ConvertFrom-MGMTBase64 -Base64 $global:MGMT_Env.config.Crypto.$key}
    }

    $global:MGMT_Env.Key = Merge-MGMTByteArray -ByteArray1 $global:MGMT_Env.config.Crypto.Shard -ByteArray2 $shard -Length 32
    $UserKeyRingFile = "$env:appdata\powershell\MGMTConfig\keyring.yaml"
    split-path $UserKeyRingFile|Where-Object{!(test-path $_)}|ForEach-Object{new-item -ItemType Directory -Path $_ -Force|Out-Null} 
    $UserShard = Get-MGMTShardFileValue -LiteralPath $UserKeyRingFile -KeyName 'UShard' -KeyLength 32 
    Backup-MGMTFile -Path $UserKeyRingFile
    $global:MGMT_Env.UShard = $UserShard.UShard
    Save-MGMTConfig -Force
    Import-MGMTCredential
    foreach ($SiteKey in $global:MGMT_Env.config.sites.keys) {
        $SystemTypes = $global:MGMT_Env.config.sites.($SiteKey).SystemTypes
        foreach ($SystemTypeKey in $SystemTypes.keys) {
            $SystemTypeObj = $SystemTypes.($SystemTypeKey)
            if ('ip,fqdn,hostname'|Where-Object{$SystemTypeObj.contains($_)}) {
                #This data needs to be moved down in the tree under a SystemNameKey
                $System = $SystemTypeObj.clone()
                $System.keys | ForEach-Object {
                    $SystemTypes.$SystemTypeKey.Remove($_)
                }
                $SystemTypes.$SystemTypeKey.($System) = $System                
                $SystemTypes.$SystemTypeKey.$SystemTypeKey = $System
            }
            foreach ($SystemNameKey in $SystemTypeObj.keys.clone()) {
                $System = $SystemTypeObj.($SystemNameKey)
                if ($SystemNameKey -match '\w') {
                    write-host "Checking for credentials for $($SystemNameKey) in $($SystemTypeKey) for $($SiteKey) " -ForegroundColor Yellow -NoNewline -BackgroundColor Black
                    $Cred = Get-MGMTCredential -SystemType $SystemTypeKey -SystemName $SystemNameKey -Scope currentuser
                    if ($null -eq $Cred) {
                        Write-Host "MISSING" -ForegroundColor Red -BackgroundColor Black
                        write-warning "Set-MGMTCredential -SystemType $SystemTypeKey -SystemName $($SystemNameKey) -Credential (get-Credential) -Scope currentuser" 
                     }
                     else {
                        Write-Host "OK" -ForegroundColor Green -BackgroundColor Black
                     }
                }
            }
        }
    }
}
