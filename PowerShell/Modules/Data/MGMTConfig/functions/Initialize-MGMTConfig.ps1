function Initialize-MGMTConfig {
    if ($null -eq $global:MGMT_Env) {$global:MGMT_Env = [hashtable]::Synchronized(@{})}
    Set-SyncHashtable -InputObject $global:MGMT_Env -Name Auth
    Set-SyncHashtable -InputObject $global:MGMT_Env.Auth -Name SystemType
    $script:ConfigFile                                = "$Datafolder\config.yaml"
    $Global:MGMT_Env.AuthFile                         = "$env:appdata\powershell\MGMTConfig\auth.yaml"
    split-path $Global:MGMT_Env.AuthFile | Where-Object {if (-not (test-path $_)) {new-item -ItemType Directory -Path $_ -Force}}
                                                        Set-SyncHashtable -InputObject $global:MGMT_Env -Name config
    $global:MGMT_Env.config                           = Get-MGMTConfig
    if ($null -eq $global:MGMT_Env.config) {
        $global:MGMT_Env.config = [hashtable]::Synchronized(@{})
    }
    [byte[]]$Shard = 0,11,159,136,217,167,1,185,196,169,243,35,234,88,147,217,223,229,80,38,100,181,255,250,223,177,45,128,109,107,253,110
    # Define the credentials for each site hosts.
    if ($null -eq $global:MGMT_Env.config.Shard) {
        $global:MGMT_Env.config.Shard = [int[]](Get-MGMTRandomBytes -ByteLength 32)
        Save-MGMTConfig -Force
    }
    if ($global:MGMT_Env.config.shard       -match '^\w{4}' ) {$global:MGMT_Env.config.shard       = ConvertFrom-MGMTBase64 -Base64 $global:MGMT_Env.config.shard}
    if ($global:MGMT_Env.config.Crypto.salt -match '^\w{4}' ) {$global:MGMT_Env.config.Crypto.salt = ConvertFrom-MGMTBase64 -Base64 $global:MGMT_Env.config.Crypto.salt}
    if ($global:MGMT_Env.config.Crypto.iv   -match '^\w{4}' ) {$global:MGMT_Env.config.Crypto.iv   = ConvertFrom-MGMTBase64 -Base64 $global:MGMT_Env.config.Crypto.iv}
    if ($global:MGMT_Env.config.Crypto.key  -match '^\w{4}' ) {$global:MGMT_Env.config.Crypto.key  = ConvertFrom-MGMTBase64 -Base64 $global:MGMT_Env.config.Crypto.key}

    $global:MGMT_Env.Key = Merge-MGMTByteArray -ByteArray1 $global:MGMT_Env.config.Shard -ByteArray2 $shard -Length 32
    $UserKeyRingFile = "$env:appdata\powershell\MGMTConfig\keyring.yaml"
    $UserShard = Get-MGMTShardFileValue -LiteralPath $UserKeyRingFile -KeyName 'UShard' -KeyLength 32 
    $global:MGMT_Env.UShard = $UserShard.UShard
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
