function Save-MGMTCredential {
    $Authsave = Import-MGMTYAML -LiteralPath $global:MGMT_Env.AuthFile
    if ($null -eq $Authsave) {$Authsave = @{}}
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
    if ($Authsave.count -eq 0) {
        Write-Warning -Message "No credentials to save."
        return
    }
    Split-Path $global:MGMT_Env.AuthFile|Where-Object{! (Test-Path $_)}|ForEach-Object{New-Item -Path $_ -ItemType Directory -Force} | Out-Null
    Backup-MGMTFile -Path $global:MGMT_Env.AuthFile
    write-verbose -Message "Saving the credentials to '$($global:MGMT_Env.AuthFile)'"
    Export-MGMTYAML -InputObject $Authsave -LiteralPath $global:MGMT_Env.AuthFile -Encoding utf8
    Backup-MGMTFile -Path $global:MGMT_Env.AuthFile
}