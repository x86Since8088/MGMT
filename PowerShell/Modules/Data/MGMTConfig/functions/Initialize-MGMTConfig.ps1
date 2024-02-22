function Initialize-MGMTConfig {
    Set-SyncHashtable -VariableName MGMT_Env -scope global
    Set-SyncHashtable -VariableName MGMT_Env -scope global -Name Auth
    $script:ConfigFile      = "$Datafolder\config.yaml"
    $MGMT_Env.AuthFile        = "$env:appdata\powershell\auth.yaml"
    Set-SyncHashtable -VariableName MGMT_Env -scope global -Name config -Value (Get-MGMTConfig)
    if ($null -eq $global:MGMT_Env) {$global:MGMT_Env = [hashtable]::Synchronized(@{})}
    if ($null -eq $global:MGMT_Env.Auth) {$global:MGMT_Env.Auth = [hashtable]::Synchronized(@{})}
    #$global:MGMT_Env.config = Get-MGMTConfig
    [byte[]]$Shard = 0,11,159,136,217,167,1,185,196,169,243,35,234,88,147,217,223,229,80,38,100,181,255,250,223,177,45,128,109,107,253,110
    # Define the credentials for each site hosts.
    if ($null -eq $global:MGMT_Env.config.Shard) {
        $global:MGMT_Env.config.Shard = [int[]](Get-MGMTRandomBytes -ByteLength 32)
        Save-MGMTConfig -Force
    }

    $global:MGMT_Env.Key = 0..31|ForEach-Object{$global:MGMT_Env.config.Shard[$_] -bxor $shard[$_]}
    $UserKeyRingFile = "$env:appdata\powershell\MGMT\keyring.yaml"
    $UserShard = Get-MGMTShardFileValue -LiteralPath $UserKeyRingFile -KeyName 'UShard' -KeyLength 32
    [byte[]]$Key = 0..32|ForEach-Object{$UserShard[$_] -bxor $global:MGMT_Env.config.Shard[$_]}

    $Authsave = Import-MGMTYAML -LiteralPath $MGMT_Env.AuthFile -ErrorAction SilentlyContinue
    foreach ($obj in $Authsave.GetEnumerator()){
        $global:MGMT_Env.Auth.($obj.Name) = 
            New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList @(
                $obj.Value.UserName,
                ($obj.Value.Password | ConvertTo-SecureString -Key $global:MGMT_Env.Key)
            )
    }
    foreach ($FQDN in ($Global:MGMT_Env.config.sites.values.values.fqdn|Where-Object{$_ -match '\w'}))
    {
        $Cred = $Global:MGMT_Env.Auth.($FQDN)
        if ($null -eq $Cred) {
            
            $Cred = Get-Credential -Message "Enter the credentials for $FQDN"
            $Global:MGMT_Env.Auth.($FQDN) = $Cred
        }
    }
}
