<#
.SYNOPSIS
Attempt to fix RDP issues for non-domain systems after remediating CREDSSP.
.LINK
https://rdpwindows.com/clients/knowledgebase/13/steps-to-fix-rdp-connection-error-credssp-encryption-oracle-remediation.html#:~:text=%20%20%201%20Method%201%3A%20CMD%20OR,...%20Double-click%20the%20line%20%E2%80%9CEncryption%20Oracle...%20More%20 
#>
Set-ItemProperty -Path HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters -Name AllowEncryptionOracle  -value 2

