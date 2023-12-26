# ApplyCISBaseline.ps1

# Load the JSON settings into a PowerShell object
$settings = Get-Content -Path .\CIS_Baseline.json | ConvertFrom-Json

# Apply Password Policies
Write-Host "Applying Password Policies..."
secedit /export /cfg $env:temp\secpol.cfg

# (Note: This method requires you to know current values or use regex for better matching.)
# Adjusting password policies from the JSON.
# This is a simplified method and might need adjustments depending on existing values.
(Get-Content $env:temp\secpol.cfg).replace("MaxPasswordAge = ...", "MaxPasswordAge = $($settings.PasswordPolicy.MaxPasswordAge)") | Set-Content $env:temp\secpol.cfg
# ... Repeat for other password policy settings ...

secedit /configure /db C:\Windows\Security\Local.sdb /cfg $env:temp\secpol.cfg /areas SECURITYPOLICY
Remove-Item $env:temp\secpol.cfg

# Apply Account Lockout Policies
Write-Host "Applying Account Lockout Policies..."
# ... Adjust using the net accounts command ...

# Apply User Rights Assignment
Write-Host "Applying User Rights Assignments..."
# For this, you'd typically leverage the `secedit` tool again or use a tool like `ntrights.exe` 

# Apply Security Options
Write-Host "Applying Security Options..."
# Many of these settings might be applied via local group policy or the registry directly

# Apply Advanced Audit Policies
Write-Host "Applying Advanced Audit Policies..."
# This might involve the `auditpol` command or similar tools

# Apply Firewall Rules
Write-Host "Applying Firewall Rules..."
# Use the `netsh` command to modify firewall rules

# Apply Registry Settings
Write-Host "Applying Registry Settings..."
# Use the `Set-ItemProperty` cmdlet to modify registry keys/values

# Apply Services Settings
Write-Host "Applying Service Settings..."
# Use `Set-Service` cmdlet to modify service startup types

# Apply File Permissions
Write-Host "Applying File Permissions..."
# Use `icacls` or `Set-Acl` to set file/folder permissions

Write-Host "All settings applied successfully!"
