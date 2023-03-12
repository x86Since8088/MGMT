'Microsoft.PowerShell.SecretManagement',
'Microsoft.PowerShell.SecretStore',
'powershell-yaml',
'VMware.powercli',
'proxmox' |
    Where-Object{! (Get-Module -Name $_ -ListAvailable)}|
    ForEach-Object{Install-Module -Force -AllowClobber -Name $_ -Scope AllUsers -Confirm:$false}
$WorkingFolder = $PSScriptRoot
$Module_GetMGMTConfig = "$WorkingFolder\Data\Get-MGMTConfig.psm1"
if (Test-Path $Module_GetMGMTConfig) {Import-Module $Module_GetMGMTConfig}
else {return Write-Error -Message "CAnnot find '$Module_GetMGMTConfig'"} 
$ConfigData = Get-MGMTConfig

$pass = Read-Host -AsSecureString -Prompt 'Enter the extension vault password'
$passwordPath = Join-Path (Split-Path $profile) SecretStore.vault.credential
# Uses the DPAPI to encrypt the password
$pass | Export-CliXml $passwordPath
 
 
Install-Module -Name Microsoft.PowerShell.SecretStore, Microsoft.PowerShell.SecretManagement -Repository PSGallery -Force
 
$pass = Import-CliXml $passwordPath
 
Set-SecretStoreConfiguration -Scope CurrentUser -Authentication Password -PasswordTimeout (60*60) -Interaction None -Password $pass -Confirm:$false
 
Register-SecretVault -Name SecretStore -ModuleName Microsoft.PowerShell.SecretStore -DefaultVault
 
Unlock-SecretStore -Password $pass