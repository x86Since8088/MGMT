function Import-MGMTCredential {
    $AuthSave = Import-MGMTYAML -LiteralPath $global:MGMT_Env.AuthFile
    $YMLFileDate = (Get-Item $global:MGMT_Env.AuthFile).LastWriteTime
    if ($Global:MGMT_Env.Auth.LastWriteTime -eq $YMLFileDate) {return}
    [byte[]]$Ukey = Merge-MGMTByteArray -ByteArray1 $global:MGMT_Env.Key -ByteArray2 $global:MGMT_Env.UShard
    foreach ($SystemType in $AuthSave.Keys) {
        foreach ($SystemName in $AuthSave.($SystemType).Keys) {
            foreach ($CredItem in $AuthSave.($SystemType).($SystemName)) {
                Set-MGMTDataObject -InputObject $Global:MGMT_Env -Name Auth,SystemType,$SystemType,$SystemName,Credential -Value (
                    [pscredential]::new( 
                        $CredItem.UserName,
                        ($CredItem.Password | ConvertTo-SecureString -Key $Ukey)
                    )
                )
            }
        }
    }
    $Global:MGMT_Env.Auth.LastWriteTime = $YMLFileDate
}
