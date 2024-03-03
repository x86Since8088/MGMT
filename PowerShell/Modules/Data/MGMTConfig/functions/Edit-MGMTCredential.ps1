function Edit-MGMTCredential {
    [cmdletbinding()]
    param(
        [switch]$Nowait
    )
    begin{
        [string]$keytext = (
            Get-MGMTHashtableKeys -Hashtable $global:MGMT_Env.Auth
        ) -replace '^systemtype\.|\.[^\.]*$' | Sort-Object -Unique
        do {
            [string]$Answer = (Read-Host -Prompt "Would you like to save the loaded credentials first? (Y/N)`n`t").ToUpper()
        }
        until ($Answer -match '^[YN]$')
        if ($Answer -eq 'Y') {Save-MGMTCredential}
        Backup-MGMTFile -Path $global:MGMT_Env.AuthFile
        $CodeEditor = Find-MGMTCodeEditors
        Start-Process -FilePath $CodeEditor -ArgumentList $global:MGMT_Env.AuthFile -Wait:(!$Nowait)
        Backup-MGMTFile -Path $global:MGMT_Env.AuthFile
        Write-Host -Message "The credentials have been loaded into the editor." -ForegroundColor Green
        Write-Host -Message "Run 'Import-MGMTCredential' to make your changes available." -ForegroundColor Yellow
    }
}