function Save-MGMTCredential {
    $Authsave = @{}
    [byte[]]$Ukey = Merge-MGMTByteArray -ByteArray1 $global:MGMT_Env.Key -ByteArray2 $global:MGMT_Env.UShard
    foreach($SystemTypeKey in $global:MGMT_Env.Auth.SystemType.keys) {
        $AuthSave.($SystemTypeKey) = @{}
        foreach ($obj in ($global:MGMT_Env.Auth.SystemType.($SystemTypeKey).GetEnumerator()|Where-Object{$null -ne $_.Value})) {
            $AuthSave.($SystemTypeKey).($obj.Key) =
                foreach ($CredItem in $obj.Value.Credential){
                    @{
                        UserName = $CredItem.UserName
                        Password = $CredItem.Password | ConvertFrom-SecureString -Key $Ukey
                    }
                }
        }
    }
    Split-Path $global:MGMT_Env.AuthFile|Where-Object{! (Test-Path $_)}|ForEach-Object{New-Item -Path $_ -ItemType Directory -Force} | Out-Null
    Export-MGMTYAML -InputObject $Authsave -LiteralPath $global:MGMT_Env.AuthFile -Encoding utf8
}