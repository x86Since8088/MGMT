function Edit-MGMTCredential {
    [string]$keytext = (
        Get-MGMTHashtableKeys -Hashtable $global:MGMT_Env.Auth
    ) -replace '^systemtype\.|\.[^\.]*$' | Sort-Object -Unique
    do {
        [string]$Answer = (Read-Host -Prompt "Would you like to save the loaded credentials first? (Y/N)`n`t").ToUpper()
    }
    until ($Answer -match '^[YN]$')
    if ($Answer -eq 'Y') {Save-MGMTCredential}
    Start-Process $global:MGMT_Env.AuthFile -Wait
    Write-Host -Message "The credentials have been loaded into the editor." -ForegroundColor Green
    Write-Host -Message "Run 'Import-MGMTCredential' to make your changes available." -ForegroundColor Yellow
}