function Import-MGMTCredential {
    Split-path $global:MGMT_Env.AuthFile|Where-Object{!(test-path $_)}|ForEach-Object{new-item -ItemType Directory -Path $_ -Force|Out-Null}
    Backup-MGMTFile -Path $global:MGMT_Env.AuthFile
    if (-not (Test-Path $global:MGMT_Env.AuthFile)) {
        Export-MGMTYAML -LiteralPath $global:MGMT_Env.AuthFile -Encoding utf8 -InputObject @{'SystemType' = @{}}
    }
    $AuthSave = Import-MGMTYAML -LiteralPath $global:MGMT_Env.AuthFile
    $YMLFileDate = (Get-Item $global:MGMT_Env.AuthFile).LastWriteTime
    if ($Global:MGMT_Env.Auth.LastWriteTime -eq $YMLFileDate) {return}
    $UShard = $global:MGMT_Env.UShard
    if ($UShard -is [string]) {
        $UShard = ConvertFrom-MGMTBase64 -Base64 $UShard
    }
    [byte[]]$Ukey = Merge-MGMTByteArray -ByteArray1 $global:MGMT_Env.Key -ByteArray2 $UShard
    foreach ($SystemType in $AuthSave.Keys) {
        foreach ($SystemName in $AuthSave.($SystemType).Keys) {
            foreach ($CredItem in $AuthSave.($SystemType).($SystemName)) {
                try {
                    $SS = $CredItem.Password | ConvertTo-SecureString -Key $Ukey -ErrorAction Continue
                }
                catch {
                    Write-Error -Message "Failed to read the stored password for $($SystemName) user $($CredItem.UserName) in $($SystemType).  Your Keys may have changed.  Saving the credentials or restoring backup shard files can resolve this issue."
                }
                Set-MGMTDataObject -InputObject $Global:MGMT_Env -Name Auth,SystemType,$SystemType,$SystemName,Credential -Value (
                    [pscredential]::new( 
                        $CredItem.UserName,
                        $SS
                    )
                )
            }
        }
    }
    $Global:MGMT_Env.Auth.LastWriteTime = $YMLFileDate
}
