#
# Module manifest for module 'Az.Resources'
#
# Generated by: Microsoft Corporation
#
# Generated on: 2/8/2024
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'Az.Resources.psm1'

# Version number of this module.
ModuleVersion = '6.15.1'

# Supported PSEditions
CompatiblePSEditions = 'Core', 'Desktop'

# ID used to uniquely identify this module
GUID = '48bb344d-4c24-441e-8ea0-589947784700'

# Author of this module
Author = 'Microsoft Corporation'

# Company or vendor of this module
CompanyName = 'Microsoft Corporation'

# Copyright statement for this module
Copyright = 'Microsoft Corporation. All rights reserved.'

# Description of the functionality provided by this module
Description = 'Microsoft Azure PowerShell - Azure Resource Manager and Active Directory cmdlets in Windows PowerShell and PowerShell Core.  Manages subscriptions, tenants, resource groups, deployment templates, providers, and resource permissions in Azure Resource Manager.  Provides cmdlets for managing resources generically across resource providers.
For more information on Resource Manager, please visit the following: https://learn.microsoft.com/azure/azure-resource-manager/
For more information on Active Directory, please visit the following: https://learn.microsoft.com/azure/active-directory/fundamentals/active-directory-whatis'

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '5.1'

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
DotNetFrameworkVersion = '4.7.2'

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
RequiredAssemblies = 'Authorization.Autorest/bin/Az.Authorization.private.dll', 
               'Microsoft.Azure.PowerShell.Authorization.Management.Sdk.dll', 
               'Microsoft.Azure.Management.ManagementGroups.dll', 
               'Microsoft.Azure.Management.ResourceManager.dll', 
               'Microsoft.Azure.PowerShell.Resources.Management.Sdk.dll', 
               'Microsoft.Extensions.Caching.Abstractions.dll', 
               'Microsoft.Extensions.Caching.Memory.dll', 
               'Microsoft.Extensions.DependencyInjection.Abstractions.dll', 
               'Microsoft.Extensions.Options.dll', 
               'Microsoft.Extensions.Primitives.dll', 
               'MSGraph.Autorest/bin/Az.MSGraph.private.dll', 
               'System.Runtime.CompilerServices.Unsafe.dll'

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
FormatsToProcess = 'Authorization.Autorest/Az.Authorization.format.ps1xml', 
               'MSGraph.Autorest/Az.MSGraph.format.ps1xml', 
               'ResourceManager.format.ps1xml', 
               'ResourceManager.generated.format.ps1xml', 
               'Resources.format.ps1xml', 'Tags.format.ps1xml'

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
NestedModules = @('Authorization.Autorest/Az.Authorization.psm1', 'MSGraph.Autorest/Az.MSGraph.psm1')

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 'Add-AzADAppPermission', 'Add-AzADGroupMember', 
               'Get-AzADAppCredential', 'Get-AzADAppFederatedCredential', 
               'Get-AzADApplication', 'Get-AzADAppPermission', 'Get-AzADGroup', 
               'Get-AzADGroupMember', 'Get-AzADGroupOwner', 'Get-AzADOrganization', 
               'Get-AzADServicePrincipal', 
               'Get-AzADServicePrincipalAppRoleAssignment', 'Get-AzADSpCredential', 
               'Get-AzADUser', 'Get-AzRoleAssignmentSchedule', 
               'Get-AzRoleAssignmentScheduleInstance', 
               'Get-AzRoleAssignmentScheduleRequest', 
               'Get-AzRoleEligibilitySchedule', 
               'Get-AzRoleEligibilityScheduleInstance', 
               'Get-AzRoleEligibilityScheduleRequest', 
               'Get-AzRoleEligibleChildResource', 'Get-AzRoleManagementPolicy', 
               'Get-AzRoleManagementPolicyAssignment', 'New-AzADAppCredential', 
               'New-AzADAppFederatedCredential', 'New-AzADApplication', 
               'New-AzADGroup', 'New-AzADGroupOwner', 'New-AzADServicePrincipal', 
               'New-AzADServicePrincipalAppRoleAssignment', 'New-AzADSpCredential', 
               'New-AzADUser', 'New-AzRoleAssignmentScheduleRequest', 
               'New-AzRoleEligibilityScheduleRequest', 
               'New-AzRoleManagementPolicyAssignment', 'Remove-AzADAppCredential', 
               'Remove-AzADAppFederatedCredential', 'Remove-AzADApplication', 
               'Remove-AzADAppPermission', 'Remove-AzADGroup', 
               'Remove-AzADGroupMember', 'Remove-AzADGroupOwner', 
               'Remove-AzADServicePrincipal', 
               'Remove-AzADServicePrincipalAppRoleAssignment', 
               'Remove-AzADSpCredential', 'Remove-AzADUser', 
               'Remove-AzRoleManagementPolicy', 
               'Remove-AzRoleManagementPolicyAssignment', 
               'Stop-AzRoleAssignmentScheduleRequest', 
               'Stop-AzRoleEligibilityScheduleRequest', 
               'Update-AzADAppFederatedCredential', 'Update-AzADApplication', 
               'Update-AzADGroup', 'Update-AzADServicePrincipal', 
               'Update-AzADServicePrincipalAppRoleAssignment', 'Update-AzADUser', 
               'Update-AzRoleManagementPolicy'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = 'Export-AzResourceGroup', 'Export-AzTemplateSpec', 
               'Get-AzDenyAssignment', 'Get-AzDeployment', 
               'Get-AzDeploymentOperation', 'Get-AzDeploymentScript', 
               'Get-AzDeploymentScriptLog', 'Get-AzDeploymentWhatIfResult', 
               'Get-AzLocation', 'Get-AzManagedApplication', 
               'Get-AzManagedApplicationDefinition', 'Get-AzManagementGroup', 
               'Get-AzManagementGroupDeployment', 
               'Get-AzManagementGroupDeploymentOperation', 
               'Get-AzManagementGroupDeploymentStack', 
               'Get-AzManagementGroupDeploymentWhatIfResult', 
               'Get-AzManagementGroupEntity', 
               'Get-AzManagementGroupHierarchySetting', 
               'Get-AzManagementGroupNameAvailability', 
               'Get-AzManagementGroupSubscription', 'Get-AzPolicyAlias', 
               'Get-AzPolicyAssignment', 'Get-AzPolicyDefinition', 
               'Get-AzPolicyExemption', 'Get-AzPolicySetDefinition', 
               'Get-AzPrivateLinkAssociation', 'Get-AzProviderFeature', 
               'Get-AzProviderOperation', 'Get-AzProviderPreviewFeature', 
               'Get-AzResource', 'Get-AzResourceGroup', 
               'Get-AzResourceGroupDeployment', 
               'Get-AzResourceGroupDeploymentOperation', 
               'Get-AzResourceGroupDeploymentStack', 
               'Get-AzResourceGroupDeploymentWhatIfResult', 'Get-AzResourceLock', 
               'Get-AzResourceManagementPrivateLink', 'Get-AzResourceProvider', 
               'Get-AzRoleAssignment', 'Get-AzRoleDefinition', 
               'Get-AzSubscriptionDeploymentStack', 'Get-AzTag', 
               'Get-AzTemplateSpec', 'Get-AzTenantBackfillStatus', 
               'Get-AzTenantDeployment', 'Get-AzTenantDeploymentOperation', 
               'Get-AzTenantDeploymentWhatIfResult', 'Invoke-AzResourceAction', 
               'Move-AzResource', 'New-AzDeployment', 'New-AzManagedApplication', 
               'New-AzManagedApplicationDefinition', 'New-AzManagementGroup', 
               'New-AzManagementGroupDeployment', 
               'New-AzManagementGroupDeploymentStack', 
               'New-AzManagementGroupHierarchySetting', 
               'New-AzManagementGroupSubscription', 'New-AzPolicyAssignment', 
               'New-AzPolicyDefinition', 'New-AzPolicyExemption', 
               'New-AzPolicySetDefinition', 'New-AzPrivateLinkAssociation', 
               'New-AzResource', 'New-AzResourceGroup', 
               'New-AzResourceGroupDeployment', 
               'New-AzResourceGroupDeploymentStack', 'New-AzResourceLock', 
               'New-AzResourceManagementPrivateLink', 'New-AzRoleAssignment', 
               'New-AzRoleDefinition', 'New-AzSubscriptionDeploymentStack', 
               'New-AzTag', 'New-AzTemplateSpec', 'New-AzTenantDeployment', 
               'Publish-AzBicepModule', 'Register-AzProviderFeature', 
               'Register-AzProviderPreviewFeature', 'Register-AzResourceProvider', 
               'Remove-AzDeployment', 'Remove-AzDeploymentScript', 
               'Remove-AzManagedApplication', 
               'Remove-AzManagedApplicationDefinition', 'Remove-AzManagementGroup', 
               'Remove-AzManagementGroupDeployment', 
               'Remove-AzManagementGroupDeploymentStack', 
               'Remove-AzManagementGroupHierarchySetting', 
               'Remove-AzManagementGroupSubscription', 'Remove-AzPolicyAssignment', 
               'Remove-AzPolicyDefinition', 'Remove-AzPolicyExemption', 
               'Remove-AzPolicySetDefinition', 'Remove-AzPrivateLinkAssociation', 
               'Remove-AzResource', 'Remove-AzResourceGroup', 
               'Remove-AzResourceGroupDeployment', 
               'Remove-AzResourceGroupDeploymentStack', 'Remove-AzResourceLock', 
               'Remove-AzResourceManagementPrivateLink', 'Remove-AzRoleAssignment', 
               'Remove-AzRoleDefinition', 'Remove-AzSubscriptionDeploymentStack', 
               'Remove-AzTag', 'Remove-AzTemplateSpec', 'Remove-AzTenantDeployment', 
               'Save-AzDeploymentScriptLog', 'Save-AzDeploymentTemplate', 
               'Save-AzManagementGroupDeploymentStackTemplate', 
               'Save-AzManagementGroupDeploymentTemplate', 
               'Save-AzResourceGroupDeploymentStackTemplate', 
               'Save-AzResourceGroupDeploymentTemplate', 
               'Save-AzSubscriptionDeploymentStackTemplate', 
               'Save-AzTenantDeploymentTemplate', 'Set-AzManagedApplication', 
               'Set-AzManagedApplicationDefinition', 
               'Set-AzManagementGroupDeploymentStack', 'Set-AzPolicyAssignment', 
               'Set-AzPolicyDefinition', 'Set-AzPolicyExemption', 
               'Set-AzPolicySetDefinition', 'Set-AzResource', 'Set-AzResourceGroup', 
               'Set-AzResourceGroupDeploymentStack', 'Set-AzResourceLock', 
               'Set-AzRoleAssignment', 'Set-AzRoleDefinition', 
               'Set-AzSubscriptionDeploymentStack', 'Set-AzTemplateSpec', 
               'Start-AzTenantBackfill', 'Stop-AzDeployment', 
               'Stop-AzManagementGroupDeployment', 
               'Stop-AzResourceGroupDeployment', 'Stop-AzTenantDeployment', 
               'Test-AzDeployment', 'Test-AzManagementGroupDeployment', 
               'Test-AzResourceGroupDeployment', 'Test-AzTenantDeployment', 
               'Unregister-AzProviderFeature', 
               'Unregister-AzProviderPreviewFeature', 
               'Unregister-AzResourceProvider', 'Update-AzManagementGroup', 
               'Update-AzManagementGroupHierarchySetting', 'Update-AzTag'

# Variables to export from this module
# VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = 'Get-AzADServicePrincipalCredential', 
               'Get-AzResourceProviderAction', 'Get-AzSubscriptionDeployment', 
               'Get-AzSubscriptionDeploymentOperation', 
               'Get-AzSubscriptionDeploymentWhatIfResult', 
               'New-AzADServicePrincipalCredential', 
               'New-AzSubscriptionDeployment', 
               'Remove-AzADServicePrincipalCredential', 
               'Remove-AzSubscriptionDeployment', 
               'Save-AzSubscriptionDeploymentTemplate', 'Set-AzADApplication', 
               'Set-AzADServicePrincipal', 'Set-AzADUser', 
               'Stop-AzSubscriptionDeployment', 'Test-AzSubscriptionDeployment'

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = 'Azure','ResourceManager','ARM','Provider','ResourceGroup','Deployment','ActiveDirectory','Authorization','Management','ManagementGroups','Tags'

        # A URL to the license for this module.
        LicenseUri = 'https://aka.ms/azps-license'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/Azure/azure-powershell'

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = '* Fixed deadlock in Bicep CLI execution. [#24133]'

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

 } # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}


# SIG # Begin signature block
# MIIoKgYJKoZIhvcNAQcCoIIoGzCCKBcCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBFrr25iUQb/P/m
# HmlLroT57oE1DNEGmTPsj1xHKiYx5KCCDXYwggX0MIID3KADAgECAhMzAAADrzBA
# DkyjTQVBAAAAAAOvMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMxMTE2MTkwOTAwWhcNMjQxMTE0MTkwOTAwWjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDOS8s1ra6f0YGtg0OhEaQa/t3Q+q1MEHhWJhqQVuO5amYXQpy8MDPNoJYk+FWA
# hePP5LxwcSge5aen+f5Q6WNPd6EDxGzotvVpNi5ve0H97S3F7C/axDfKxyNh21MG
# 0W8Sb0vxi/vorcLHOL9i+t2D6yvvDzLlEefUCbQV/zGCBjXGlYJcUj6RAzXyeNAN
# xSpKXAGd7Fh+ocGHPPphcD9LQTOJgG7Y7aYztHqBLJiQQ4eAgZNU4ac6+8LnEGAL
# go1ydC5BJEuJQjYKbNTy959HrKSu7LO3Ws0w8jw6pYdC1IMpdTkk2puTgY2PDNzB
# tLM4evG7FYer3WX+8t1UMYNTAgMBAAGjggFzMIIBbzAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQURxxxNPIEPGSO8kqz+bgCAQWGXsEw
# RQYDVR0RBD4wPKQ6MDgxHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEW
# MBQGA1UEBRMNMjMwMDEyKzUwMTgyNjAfBgNVHSMEGDAWgBRIbmTlUAXTgqoXNzci
# tW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3JsMGEG
# CCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3J0
# MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIBAISxFt/zR2frTFPB45Yd
# mhZpB2nNJoOoi+qlgcTlnO4QwlYN1w/vYwbDy/oFJolD5r6FMJd0RGcgEM8q9TgQ
# 2OC7gQEmhweVJ7yuKJlQBH7P7Pg5RiqgV3cSonJ+OM4kFHbP3gPLiyzssSQdRuPY
# 1mIWoGg9i7Y4ZC8ST7WhpSyc0pns2XsUe1XsIjaUcGu7zd7gg97eCUiLRdVklPmp
# XobH9CEAWakRUGNICYN2AgjhRTC4j3KJfqMkU04R6Toyh4/Toswm1uoDcGr5laYn
# TfcX3u5WnJqJLhuPe8Uj9kGAOcyo0O1mNwDa+LhFEzB6CB32+wfJMumfr6degvLT
# e8x55urQLeTjimBQgS49BSUkhFN7ois3cZyNpnrMca5AZaC7pLI72vuqSsSlLalG
# OcZmPHZGYJqZ0BacN274OZ80Q8B11iNokns9Od348bMb5Z4fihxaBWebl8kWEi2O
# PvQImOAeq3nt7UWJBzJYLAGEpfasaA3ZQgIcEXdD+uwo6ymMzDY6UamFOfYqYWXk
# ntxDGu7ngD2ugKUuccYKJJRiiz+LAUcj90BVcSHRLQop9N8zoALr/1sJuwPrVAtx
# HNEgSW+AKBqIxYWM4Ev32l6agSUAezLMbq5f3d8x9qzT031jMDT+sUAoCw0M5wVt
# CUQcqINPuYjbS1WgJyZIiEkBMIIHejCCBWKgAwIBAgIKYQ6Q0gAAAAAAAzANBgkq
# hkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5
# IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEwOTA5WjB+MQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQg
# Q29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIIC
# CgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+laUKq4BjgaBEm6f8MMHt03
# a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc6Whe0t+bU7IKLMOv2akr
# rnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4Ddato88tt8zpcoRb0Rrrg
# OGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+lD3v++MrWhAfTVYoonpy
# 4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nkkDstrjNYxbc+/jLTswM9
# sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6A4aN91/w0FK/jJSHvMAh
# dCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmdX4jiJV3TIUs+UsS1Vz8k
# A/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL5zmhD+kjSbwYuER8ReTB
# w3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zdsGbiwZeBe+3W7UvnSSmn
# Eyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3T8HhhUSJxAlMxdSlQy90
# lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS4NaIjAsCAwEAAaOCAe0w
# ggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRIbmTlUAXTgqoXNzcitW2o
# ynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYD
# VR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBDuRQFTuHqp8cx0SOJNDBa
# BgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2Ny
# bC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNfMjIuY3JsMF4GCCsG
# AQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3dy5taWNyb3NvZnQuY29t
# L3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNfMjIuY3J0MIGfBgNV
# HSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEFBQcCARYzaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1hcnljcHMuaHRtMEAGCCsG
# AQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkAYwB5AF8AcwB0AGEAdABl
# AG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn8oalmOBUeRou09h0ZyKb
# C5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7v0epo/Np22O/IjWll11l
# hJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0bpdS1HXeUOeLpZMlEPXh6
# I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/KmtYSWMfCWluWpiW5IP0
# wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvyCInWH8MyGOLwxS3OW560
# STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBpmLJZiWhub6e3dMNABQam
# ASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJihsMdYzaXht/a8/jyFqGa
# J+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYbBL7fQccOKO7eZS/sl/ah
# XJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbSoqKfenoi+kiVH6v7RyOA
# 9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sLgOppO6/8MO0ETI7f33Vt
# Y5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtXcVZOSEXAQsmbdlsKgEhr
# /Xmfwb1tbWrJUnMTDXpQzTGCGgowghoGAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAOvMEAOTKNNBUEAAAAAA68wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIDH0Tf/ajtu6nJ6l0GawdM4e
# 0eeHWHujEG+o5GMhTXSCMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEADgKOi4GVz/4wvxBftkESLXPI0fxFxzsf9DYzJ3ovcvi9IpjNQEK0woDh
# a82MLierm79xtCZxeSZMxKTflV5Xx+dzNvol47FRXJoy4L7pWJSFDewb2oppvWxm
# v8gBrXz2S/xhGryaDuf+rRIts03jsMLaQuax/f40sl1jqE5MOdYQs0Pj3954f/fC
# Br6T8wEgSvTDVOzQgzZBVjz0N6zUH8t0zz4YzSrcsCGfS1oBB73MxFXclIevOKSJ
# bIeTy0C33Wz5inton9fb95UdFXBMcrAdeZtfzfOZK7Fzw37BunP9yy3CmyCypOCy
# qGR/E5OjqKaCw8Dp/sS0JVtO4DD3BqGCF5QwgheQBgorBgEEAYI3AwMBMYIXgDCC
# F3wGCSqGSIb3DQEHAqCCF20wghdpAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFSBgsq
# hkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCDa7d0mxF3XgtVrJUgboZbASgkh/6IGo4nN+Pp3bxQNKgIGZbwSfFVE
# GBMyMDI0MDIwODA5NTQ0NS43ODZaMASAAgH0oIHRpIHOMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046N0YwMC0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Wg
# ghHqMIIHIDCCBQigAwIBAgITMwAAAfAqfB1ZO+YfrQABAAAB8DANBgkqhkiG9w0B
# AQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYD
# VQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAeFw0yMzEyMDYxODQ1
# NTFaFw0yNTAzMDUxODQ1NTFaMIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25z
# MScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046N0YwMC0wNUUwLUQ5NDcxJTAjBgNV
# BAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2UwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQC1Hi1Tozh3O0czE8xfRnrymlJNCaGWommPy0eINf+4
# EJr7rf8tSzlgE8Il4Zj48T5fTTOAh6nITRf2lK7+upcnZ/xg0AKoDYpBQOWrL9Ob
# FShylIHfr/DQ4PsRX8GRtInuJsMkwSg63bfB4Q2UikMEP/CtZHi8xW5XtAKp95cs
# 3mvUCMvIAA83Jr/UyADACJXVU4maYisczUz7J111eD1KrG9mQ+ITgnRR/X2xTDMC
# z+io8ZZFHGwEZg+c3vmPp87m4OqOKWyhcqMUupPveO/gQC9Rv4szLNGDaoePeK6I
# U0JqcGjXqxbcEoS/s1hCgPd7Ux6YWeWrUXaxbb+JosgOazUgUGs1aqpnLjz0YKfU
# qn8i5TbmR1dqElR4QA+OZfeVhpTonrM4sE/MlJ1JLpR2FwAIHUeMfotXNQiytYfR
# BUOJHFeJYEflZgVk0Xx/4kZBdzgFQPOWfVd2NozXlC2epGtUjaluA2osOvQHZzGO
# oKTvWUPX99MssGObO0xJHd0DygP/JAVp+bRGJqa2u7AqLm2+tAT26yI5veccDmNZ
# sg3vDh1HcpCJa9QpRW/MD3a+AF2ygV1sRnGVUVG3VODX3BhGT8TMU/GiUy3h7ClX
# OxmZ+weCuIOzCkTDbK5OlAS8qSPpgp+XGlOLEPaM31Mgf6YTppAaeP0ophx345oh
# twIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFNCCsqdXRy/MmjZGVTAvx7YFWpslMB8G
# A1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8GA1UdHwRYMFYwVKBSoFCG
# Tmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29mdCUy
# MFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBsBggrBgEFBQcBAQRgMF4w
# XAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2Vy
# dHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3J0MAwG
# A1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwDgYDVR0PAQH/BAQD
# AgeAMA0GCSqGSIb3DQEBCwUAA4ICAQA4IvSbnr4jEPgo5W4xj3/+0dCGwsz863QG
# Z2mB9Z4SwtGGLMvwfsRUs3NIlPD/LsWAxdVYHklAzwLTwQ5M+PRdy92DGftyEOGM
# Hfut7Gq8L3RUcvrvr0AL/NNtfEpbAEkCFzseextY5s3hzj3rX2wvoBZm2ythwcLe
# ZmMgHQCmjZp/20fHWJgrjPYjse6RDJtUTlvUsjr+878/t+vrQEIqlmebCeEi+VQV
# xc7wF0LuMTw/gCWdcqHoqL52JotxKzY8jZSQ7ccNHhC4eHGFRpaKeiSQ0GXtlbGI
# bP4kW1O3JzlKjfwG62NCSvfmM1iPD90XYiFm7/8mgR16AmqefDsfjBCWwf3qheIM
# fgZzWqeEz8laFmM8DdkXjuOCQE/2L0TxhrjUtdMkATfXdZjYRlscBDyr8zGMlprF
# C7LcxqCXlhxhtd2CM+mpcTc8RB2D3Eor0UdoP36Q9r4XWCVV/2Kn0AXtvWxvIfyO
# Fm5aLl0eEzkhfv/XmUlBeOCElS7jdddWpBlQjJuHHUHjOVGXlrJT7X4hicF1o23x
# 5U+j7qPKBceryP2/1oxfmHc6uBXlXBKukV/QCZBVAiBMYJhnktakWHpo9uIeSnYT
# 6Qx7wf2RauYHIER8SLRmblMzPOs+JHQzrvh7xStx310LOp+0DaOXs8xjZvhpn+Wu
# Zij5RmZijDCCB3EwggVZoAMCAQICEzMAAAAVxedrngKbSZkAAAAAABUwDQYJKoZI
# hvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
# DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24x
# MjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0eSAy
# MDEwMB4XDTIxMDkzMDE4MjIyNVoXDTMwMDkzMDE4MzIyNVowfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTAwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoIC
# AQDk4aZM57RyIQt5osvXJHm9DtWC0/3unAcH0qlsTnXIyjVX9gF/bErg4r25Phdg
# M/9cT8dm95VTcVrifkpa/rg2Z4VGIwy1jRPPdzLAEBjoYH1qUoNEt6aORmsHFPPF
# dvWGUNzBRMhxXFExN6AKOG6N7dcP2CZTfDlhAnrEqv1yaa8dq6z2Nr41JmTamDu6
# GnszrYBbfowQHJ1S/rboYiXcag/PXfT+jlPP1uyFVk3v3byNpOORj7I5LFGc6XBp
# Dco2LXCOMcg1KL3jtIckw+DJj361VI/c+gVVmG1oO5pGve2krnopN6zL64NF50Zu
# yjLVwIYwXE8s4mKyzbnijYjklqwBSru+cakXW2dg3viSkR4dPf0gz3N9QZpGdc3E
# XzTdEonW/aUgfX782Z5F37ZyL9t9X4C626p+Nuw2TPYrbqgSUei/BQOj0XOmTTd0
# lBw0gg/wEPK3Rxjtp+iZfD9M269ewvPV2HM9Q07BMzlMjgK8QmguEOqEUUbi0b1q
# GFphAXPKZ6Je1yh2AuIzGHLXpyDwwvoSCtdjbwzJNmSLW6CmgyFdXzB0kZSU2LlQ
# +QuJYfM2BjUYhEfb3BvR/bLUHMVr9lxSUV0S2yW6r1AFemzFER1y7435UsSFF5PA
# PBXbGjfHCBUYP3irRbb1Hode2o+eFnJpxq57t7c+auIurQIDAQABo4IB3TCCAdkw
# EgYJKwYBBAGCNxUBBAUCAwEAATAjBgkrBgEEAYI3FQIEFgQUKqdS/mTEmr6CkTxG
# NSnPEP8vBO4wHQYDVR0OBBYEFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMFwGA1UdIARV
# MFMwUQYMKwYBBAGCN0yDfQEBMEEwPwYIKwYBBQUHAgEWM2h0dHA6Ly93d3cubWlj
# cm9zb2Z0LmNvbS9wa2lvcHMvRG9jcy9SZXBvc2l0b3J5Lmh0bTATBgNVHSUEDDAK
# BggrBgEFBQcDCDAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMC
# AYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvX
# zpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20v
# cGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYI
# KwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNydDANBgkqhkiG
# 9w0BAQsFAAOCAgEAnVV9/Cqt4SwfZwExJFvhnnJL/Klv6lwUtj5OR2R4sQaTlz0x
# M7U518JxNj/aZGx80HU5bbsPMeTCj/ts0aGUGCLu6WZnOlNN3Zi6th542DYunKmC
# VgADsAW+iehp4LoJ7nvfam++Kctu2D9IdQHZGN5tggz1bSNU5HhTdSRXud2f8449
# xvNo32X2pFaq95W2KFUn0CS9QKC/GbYSEhFdPSfgQJY4rPf5KYnDvBewVIVCs/wM
# nosZiefwC2qBwoEZQhlSdYo2wh3DYXMuLGt7bj8sCXgU6ZGyqVvfSaN0DLzskYDS
# PeZKPmY7T7uG+jIa2Zb0j/aRAfbOxnT99kxybxCrdTDFNLB62FD+CljdQDzHVG2d
# Y3RILLFORy3BFARxv2T5JL5zbcqOCb2zAVdJVGTZc9d/HltEAY5aGZFrDZ+kKNxn
# GSgkujhLmm77IVRrakURR6nxt67I6IleT53S0Ex2tVdUCbFpAUR+fKFhbHP+Crvs
# QWY9af3LwUFJfn6Tvsv4O+S3Fb+0zj6lMVGEvL8CwYKiexcdFYmNcP7ntdAoGokL
# jzbaukz5m/8K6TT4JDVnK+ANuOaMmdbhIurwJ0I9JZTmdHRbatGePu1+oDEzfbzL
# 6Xu/OHBE0ZDxyKs6ijoIYn/ZcGNTTY3ugm2lBRDBcQZqELQdVTNYs6FwZvKhggNN
# MIICNQIBATCB+aGB0aSBzjCByzELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEn
# MCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjdGMDAtMDVFMC1EOTQ3MSUwIwYDVQQD
# ExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQDC
# KAZKKv5lsdC2yoMGKYiQy79p/6CBgzCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6W8iljAiGA8yMDI0MDIwODA5NTEx
# OFoYDzIwMjQwMjA5MDk1MTE4WjB0MDoGCisGAQQBhFkKBAExLDAqMAoCBQDpbyKW
# AgEAMAcCAQACAholMAcCAQACAhMYMAoCBQDpcHQWAgEAMDYGCisGAQQBhFkKBAIx
# KDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAIAgEAAgMBhqAwDQYJKoZI
# hvcNAQELBQADggEBAKCcnVtRnyv+kVE7EigAEdyKDmOkz8T7m6X3k2vycloxndtZ
# RFK8eH+1UMeE4PLmClttPjwfV32DmSmQ8swmDB37+T3Hks1qnGcMfEE2IwRjDEfW
# +9mbkzrY6JOsK50HedsRbrSOFqHd5gh51cwKsuzUUC7RPS7d3s5AkIP/1cE74Jwn
# FXjsSP9AbOogC7QBuYM55QweooufjSX0S8AXKmgq8KmV0s0mIfh1NXr/pll0MnLW
# i21X4H+XfxdvF8HayI7sOmOVrs+6MVH/OQCEadklhEdPZ30HyZAHLk/WKlj1MkJs
# XG6WZ0+T+s5nciIkycYBPJOzDXf1o7nLRxhyO7ExggQNMIIECQIBATCBkzB8MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNy
# b3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAfAqfB1ZO+YfrQABAAAB8DAN
# BglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8G
# CSqGSIb3DQEJBDEiBCA/pUXbbQk0FCcAeRV3pLNfbbLT921wN5QeAk8XRhU8SzCB
# +gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIFwBmqOlcv3kU7mAB5sWR74QFAiS
# 6mb+CM6asnFAZUuLMIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
# c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIw
# MTACEzMAAAHwKnwdWTvmH60AAQAAAfAwIgQgG9cuVDEZwVS1dOqLCyp8yBENV6Ca
# rbBcr8CeBIR4aUAwDQYJKoZIhvcNAQELBQAEggIAAnCXJ8YajPX3jW8TaEJskuP8
# 7LJUlYU+mEShg2psuZMXxLzxQCuvy2KhoAhv+iA29kmgslfFb0m7s/JLLlV7trwn
# Ou6H+AV/LKxcYUbpvlLjYedRBrbTAqC04yCSNDzbwRFNXs2QcevkCcWaFGV4USC3
# J5E2QPJoxMpUTxAdtyStqA8tpSZ+Fl55Hkwo0G2weLAb9k3L8RQiMXdXjcqZj4en
# 0+NUscALpiv1teA65c2vy37kSqJJ/TTiNmBG/+0AgIj3Fur0MICV0mQYiv4G4FA4
# 0BV2N8rC5HIBsREebGNqSsmWHmVvOZOEKfKS9fPQlSxt6D62auAaS++rP0tJbs7s
# TgktJ/UNB2YPDWgiVt/hRP549Jyy3kwpj5akVH1d+u15MQhJYMmVzRa+7ycy8lMP
# BwHMw+GM9h+dPdV7T+ThpdfwNVILtkoSfJqxN6bnMYZXXknVvO1n4EGvCYn3XkKE
# 5sGEUzk2x3vQbqYvqWfbU/ptdIIKL/HQXGnV/L1KEpvlVdrrr94SXwRAqKSgiQaP
# Q6T+0rL91nhTX5TCo+VFk22IC1cdFCM0t9Rm0f1rWcRLNTUBS2zgKU2T03ro4Qrg
# aY5BxlUztOwzakkZQAKCxzNps3HyJd629ASFxNIPZ2i2eLK3aCYiqC6ce3mhpsDb
# HOZmQ2Wl1cWstPoiZeE=
# SIG # End signature block
