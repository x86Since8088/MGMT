function Initialize-MGMTConfig {
    if ($null -eq $global:MGMT_Env) {$global:MGMT_Env = [hashtable]::Synchronized(@{})}
    Set-SyncHashtable -InputObject $global:MGMT_Env -Name Auth
    Set-SyncHashtable -InputObject $global:MGMT_Env.Auth -Name SystemType
    $script:ConfigFile                                = "$Datafolder\config.yaml"
    $Global:MGMT_Env.AuthFile                         = "$env:appdata\powershell\MGMTConfig\auth.yaml"
                                                        Set-SyncHashtable -InputObject $global:MGMT_Env -Name config 
    $global:MGMT_Env.config                           = Get-MGMTConfig
    [byte[]]$Shard = 0,11,159,136,217,167,1,185,196,169,243,35,234,88,147,217,223,229,80,38,100,181,255,250,223,177,45,128,109,107,253,110
    # Define the credentials for each site hosts.
    if ($null -eq $global:MGMT_Env.config.Shard) {
        $global:MGMT_Env.config.Shard = [int[]](Get-MGMTRandomBytes -ByteLength 32)
        Save-MGMTConfig -Force
    }

    $global:MGMT_Env.Key = Merge-MGMTByteArray -ByteArray1 $global:MGMT_Env.config.Shard -ByteArray2 $shard -Length 32
    $UserKeyRingFile = "$env:appdata\powershell\MGMTConfig\keyring.yaml"
    $UserShard = Get-MGMTShardFileValue -LiteralPath $UserKeyRingFile -KeyName 'UShard' -KeyLength 32 
    $global:MGMT_Env.UShard = $UserShard
    Import-MGMTCredential
    foreach ($SiteKey in $global:MGMT_Env.config.sites.keys) {
        $SystemTypes = $global:MGMT_Env.config.sites.($SiteKey)
        foreach ($SystemTypeKey in $SystemTypes.keys) {
            $Systems = $SystemTypes.($SystemTypeKey)
            foreach ($System in $Systems) {
                if ($System.SystemName -match '\w') {
                    write-host -Message "Checking for credentials for $($System.SystemName) in $($SystemTypeKey) for $($SiteKey)" -ForegroundColor Yellow
                    $Cred = $System.fqdn,$System.ip,$System.systemname | 
                        ForEach-Object {
                            Get-MGMTCredential -SystemType $SystemTypeKey -SystemName $_ -Scope currentuser
                        }|
                        Where-Object {$_ -ne $null}|
                        Select-Object -First 1
                    if ($null -eq $Cred) {
                        Write-Error -Message "No credentials found for Site:$($SiteKey) SystemType:$($SystemTypeKey) SystemName:$($System.SystemName)" 
                        write-warning -Message "Set-MGMTCredential -SystemType $SystemTypeKey -SystemName $($System.SystemName) -Credential (get-Credential) -Scope currentuser" 
                     }
                }
            }
        }
    }
}
