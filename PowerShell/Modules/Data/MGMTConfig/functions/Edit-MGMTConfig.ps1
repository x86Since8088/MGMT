function Edit-MGMTConfig {
    [string]$keytext = (
        Get-MGMTHashtableKeys -Hashtable $global:MGMT_Env.Auth
    ) -replace '^systemtype\.|\.[^\.]*$' | Sort-Object -Unique
    if (YN -Message "Would you like to save the loaded config first?") {Save-MGMTConfig}
    & $script:ConfigFile
    Write-Host -Message "The config file has been loaded into the editor." -ForegroundColor Green
    Write-Host -Message "Run 'Import-MGMTCredential' to make your changes available." -ForegroundColor Yellow
}