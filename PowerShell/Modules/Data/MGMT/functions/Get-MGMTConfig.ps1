Function Get-MGMTConfig {
    $ConfigData = Import-MGMTYAML -LiteralPath $script:ConfigFile
    return $ConfigData
}