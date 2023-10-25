'Microsoft.PowerShell.SecretManagement',
'Microsoft.PowerShell.SecretStore',
'powershell-yaml',
'VMware.powercli',
'Corsinvest.ProxmoxVE.Api' |
    Where-Object{! (Get-Module -Name $_ -ListAvailable)}|
    ForEach-Object{Install-Module -Force -AllowClobber -Name $_ -Scope AllUsers -Confirm:$false}
$WorkingFolder = $PSScriptRoot
$Module_GetMGMTConfig = "$WorkingFolder\Data\Get-MGMTConfig.psm1"
if (Test-Path $Module_GetMGMTConfig) {Import-Module $Module_GetMGMTConfig}
else {return Write-Error -Message "Cannot find '$Module_GetMGMTConfig'"} 
$ConfigData = Get-MGMTConfig
$passwordPath = Join-Path (Split-Path $profile) SecretStore.vault.credential
if (!(Test-Path $passwordPath)) {
    $pass = "$(convertto-base64 (Get-RandomBytes -ByteLength 20|ForEach-Object{[char]$_}))"|ConvertTo-SecureString -AsPlainText -Force
    $pass | Export-CliXml $passwordPath
    try {
        Set-SecretStoreConfiguration -Scope CurrentUser -Authentication Password -PasswordTimeout (60*60) -Interaction None -Password $pass -Confirm:$false
        Register-SecretVault -Name SecretStore -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault
    }
    catch {
        Reset-SecretStore -Scope CurrentUser -Authentication Password -Password $pass -PasswordTimeout (60*60) -Confirm:$False -Force
    }
}
ELSE {
    $pass = Import-CliXml $passwordPath
}
# Uses the DPAPI to encrypt the passwordGet-SecretStoreConfiguration
Unlock-SecretStore -Password $pass
