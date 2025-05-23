
# ----------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# Code generated by Microsoft (R) AutoRest Code Generator.Changes may cause incorrect behavior and will be lost if the code
# is regenerated.
# ----------------------------------------------------------------------------------

<#
.Synopsis
Update an VolumeGroup.
.Description
Update an VolumeGroup.
.Example
{{ Add code here }}
.Example
{{ Add code here }}

.Inputs
Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Models.IElasticSanIdentity
.Outputs
Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Models.IVolumeGroup
.Notes
COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.

ELASTICSANINPUTOBJECT <IElasticSanIdentity>: Identity Parameter
  [ElasticSanName <String>]: The name of the ElasticSan.
  [Id <String>]: Resource identity path
  [PrivateEndpointConnectionName <String>]: The name of the Private Endpoint connection.
  [ResourceGroupName <String>]: The name of the resource group. The name is case insensitive.
  [SnapshotName <String>]: The name of the volume snapshot within the given volume group.
  [SubscriptionId <String>]: The ID of the target subscription.
  [VolumeGroupName <String>]: The name of the VolumeGroup.
  [VolumeName <String>]: The name of the Volume.

INPUTOBJECT <IElasticSanIdentity>: Identity Parameter
  [ElasticSanName <String>]: The name of the ElasticSan.
  [Id <String>]: Resource identity path
  [PrivateEndpointConnectionName <String>]: The name of the Private Endpoint connection.
  [ResourceGroupName <String>]: The name of the resource group. The name is case insensitive.
  [SnapshotName <String>]: The name of the volume snapshot within the given volume group.
  [SubscriptionId <String>]: The ID of the target subscription.
  [VolumeGroupName <String>]: The name of the VolumeGroup.
  [VolumeName <String>]: The name of the Volume.

NETWORKACLSVIRTUALNETWORKRULE <IVirtualNetworkRule[]>: The list of virtual network rules.
  VirtualNetworkResourceId <String>: Resource ID of a subnet, for example: /subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}.
  [Action <String>]: The action of virtual network rule.
.Link
https://learn.microsoft.com/powershell/module/az.elasticsan/update-azelasticsanvolumegroup
#>
function Update-AzElasticSanVolumeGroup {
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Models.IVolumeGroup])]
    [CmdletBinding(DefaultParameterSetName='UpdateExpanded', PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(ParameterSetName='UpdateExpanded', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Path')]
        [System.String]
        # The name of the ElasticSan.
        ${ElasticSanName},
    
        [Parameter(ParameterSetName='UpdateExpanded', Mandatory)]
        [Parameter(ParameterSetName='UpdateViaIdentityElasticSanExpanded', Mandatory)]
        [Alias('VolumeGroupName')]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Path')]
        [System.String]
        # The name of the VolumeGroup.
        ${Name},
    
        [Parameter(ParameterSetName='UpdateExpanded', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Path')]
        [System.String]
        # The name of the resource group.
        # The name is case insensitive.
        ${ResourceGroupName},
    
        [Parameter(ParameterSetName='UpdateExpanded')]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
        [System.String]
        # The ID of the target subscription.
        ${SubscriptionId},
    
        [Parameter(ParameterSetName='UpdateViaIdentityElasticSanExpanded', Mandatory, ValueFromPipeline)]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Models.IElasticSanIdentity]
        # Identity Parameter
        # To construct, see NOTES section for ELASTICSANINPUTOBJECT properties and create a hash table.
        ${ElasticSanInputObject},
    
        [Parameter(ParameterSetName='UpdateViaIdentityExpanded', Mandatory, ValueFromPipeline)]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Models.IElasticSanIdentity]
        # Identity Parameter
        # To construct, see NOTES section for INPUTOBJECT properties and create a hash table.
        ${InputObject},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.PSArgumentCompleterAttribute("EncryptionAtRestWithPlatformKey", "EncryptionAtRestWithCustomerManagedKey")]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Body')]
        [System.String]
        # Type of encryption
        ${Encryption},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Body')]
        [System.String]
        # Resource identifier of the UserAssigned identity to be associated with server-side encryption on the volume group.
        ${EncryptionUserAssignedIdentity},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.PSArgumentCompleterAttribute("None", "SystemAssigned", "UserAssigned")]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Body')]
        [System.String]
        # The identity type.
        ${IdentityType},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Body')]
        [System.String]
        # Gets or sets a list of key value pairs that describe the set of User Assigned identities that will be used with this volume group.
        # The key is the ARM resource identifier of the identity.
        ${IdentityUserAssignedIdentityId},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Body')]
        [System.String]
        # The name of KeyVault key.
        ${KeyName},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Body')]
        [System.String]
        # The Uri of KeyVault.
        ${KeyVaultUri},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Body')]
        [System.String]
        # The version of KeyVault key.
        ${KeyVersion},
    
        [Parameter()]
        [AllowEmptyCollection()]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Models.IVirtualNetworkRule[]]
        # The list of virtual network rules.
        # To construct, see NOTES section for NETWORKACLSVIRTUALNETWORKRULE properties and create a hash table.
        ${NetworkAclsVirtualNetworkRule},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.PSArgumentCompleterAttribute("Iscsi", "None")]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Body')]
        [System.String]
        # Type of storage target
        ${ProtocolType},
    
        [Parameter()]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The DefaultProfile parameter is not functional.
        # Use the SubscriptionId parameter when available if executing the cmdlet against a different subscription.
        ${DefaultProfile},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Run the command as a job
        ${AsJob},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Run the command asynchronously
        ${NoWait},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
    )
    
    process {
        if ($PSBoundParameters.ContainsKey('IdentityUserAssignedIdentityId')) {
            $userIdentityObject = [Microsoft.Azure.PowerShell.Cmdlets.ElasticSan.Models.UserAssignedIdentity]::New()
            # $userAssignedIdentityId = $IdentityUserAssignedIdentityId
            $PSBoundParameters.IdentityUserAssignedIdentity = @{$IdentityUserAssignedIdentityId=$userIdentityObject}   
            
            $volumeGroupProperties = $null
            switch ($PSCmdlet.ParameterSetName) {
                "UpdateViaIdentityElasticSanExpanded" {
                    $elasticSanId = $ElasticSanInputObject.Id
                    $volumeGroupProperties = $ElasticSanInputObject | Az.ElasticSan\Get-AzElasticSanVolumeGroup -Name $Name
                    $PSBoundParameters.ElasticSanInputObject.Id = $elasticSanId
                    break
                }
                "UpdateViaIdentityExpanded" {
                    $volumeGroupProperties = $InputObject | Az.ElasticSan\Get-AzElasticSanVolumeGroup
                    break
                }
                Default {
                    $volumeGroupProperties = AZ.ElasticSan\Get-AzElasticSanVolumeGroup -Nam $Name -ResourceGroupName $ResourceGroupName -ElasticSanName $ElasticSanName
                    break 
                }
            }

            if ($volumeGroupProperties.IdentityUserAssignedIdentity -ne $null) {
                $volumeGroupProperties.IdentityUserAssignedIdentity.Keys | ForEach-Object {
                    if ($_ -ne $IdentityUserAssignedIdentityId) {
                        # $PSBoundParameters.IdentityUserAssignedIdentity.Add($_, $userIdentityObject)
                        $PSBoundParameters.IdentityUserAssignedIdentity.Add($_, $null)
                    }
                }
            }
            $null = $PSBoundParameters.Remove('IdentityUserAssignedIdentityId')
        }
        Az.ElasticSan.internal\Update-AzElasticSanVolumeGroup @PSBoundParameters
    }
}
    
# SIG # Begin signature block
# MIIoKwYJKoZIhvcNAQcCoIIoHDCCKBgCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCVOtje8s2tfrCm
# VgvO+yUGZRmuhzHQLdCtGOyV4dm0qqCCDXYwggX0MIID3KADAgECAhMzAAADrzBA
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGgswghoHAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAOvMEAOTKNNBUEAAAAAA68wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEILKZWS7aRPGZzseaJ5995gBS
# b/hJdgdaFkKv7j3GF2SEMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEANOD1z66WWTGKNsgiP1RukmPmpExggBiRR8Ao4Dxb9c6dpvj959cVHhwS
# sfyLf4iCoqHeO/rIiA768Q2CGr6bC/o5BkTk38hzO/7BTaveEfru7w0gpQpcv3jt
# hF0RHsGNkLTez8P6mjcgC6F27LWlbpE3Q/kJpuEspUOaVU02ftIRPHlQWdq94n8i
# ACsuGJfRDFF6C0C0dfoyuFBZ9940NdBNN8bC3t+ONdq5CCruPqFwlHnBqrfKT7On
# ZX/T/uhuaQPS5Vog6rOn7m2JGnf2m/QI/cPzVu1FdOPhZs5OHPu5ZnAZRiE666vo
# R0yhaohpWBwinVfh5ZrAxqijeR6gdaGCF5UwgheRBgorBgEEAYI3AwMBMYIXgTCC
# F30GCSqGSIb3DQEHAqCCF24wghdqAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFQBgsq
# hkiG9w0BCRABBKCCAT8EggE7MIIBNwIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCARkCjH6TNasBeLCUu6OWYb0lPk91n5PRpFqcSwnxeqsQIGZZ/xOhWC
# GBEyMDI0MDEzMDA1MDQ1Ny42WjAEgAIB9KCB0aSBzjCByzELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJp
# Y2EgT3BlcmF0aW9uczEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjhEMDAtMDVF
# MC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloIIR
# 7TCCByAwggUIoAMCAQICEzMAAAHNVQcq58rBmR0AAQAAAc0wDQYJKoZIhvcNAQEL
# BQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
# B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UE
# AxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcNMjMwNTI1MTkxMjA1
# WhcNMjQwMjAxMTkxMjA1WjCByzELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEn
# MCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjhEMDAtMDVFMC1EOTQ3MSUwIwYDVQQD
# ExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNlMIICIjANBgkqhkiG9w0BAQEF
# AAOCAg8AMIICCgKCAgEA0zgi1Uto5hFjqsc8oFu7OmC5ptvaY7wPgoelS+x5Uy/M
# lLd2dCiM02tjvx76/2ic2tahFZJauzT4jq6QQCM+uey1ccBHOAcSYr+gevGvA0Ih
# elgBRTWit1h4u038UZ6i6IYDc+72T8pWUF+/ea/DEL1+ersI4/0eIV50ezWuC5bu
# JlrJpf8KelSagrsWZ7vY1+KmlMZ4HK3xU+/s75VwpcC2odp9Hhip2tXTozoMitNI
# 2Kub7c6+TWfqlcamsPQ5hLI/b36mJH0Ga8tiTucJoF1+/TsezyzFH6k+PvMOSZHU
# jKF99m9Q+nAylkVL+ao4mIeKP2vXoRPygJFFpUj22w0f2hpzySwBj8tqgPe2AgXn
# iCY0SlEYHT5YROTuOpDo7vJ2CZyL8W7gtkKdo8cHOqw/TOj73PLGSHENdGCmVWCr
# PeGD0pZIcF8LbW0WPo2Z0Ig5tmRYx/Ej3tSOhEXH3mF9cwmIxM3cFnJvnxWZpSQP
# R0Fu2SQJjhAjjbXytvBERBBOcs6vk90DFT4YhHxIYHGLIdA3qFomBrA4ihLkvhRJ
# TDMk+OevlNmUWtoW0UPe0HG72gHejlUC6d00KjRLtHrOWatMINggA3/kCkEf2Ovn
# xoJPaiTSVtzLu+9SrYbj5TXyrLNAdc4dMWtcjeKgt86BPVKuk/K+xt/zrUhZrOMC
# AwEAAaOCAUkwggFFMB0GA1UdDgQWBBShk/mmNmmawQCVSGYeZInKJHzVmjAfBgNV
# HSMEGDAWgBSfpxVdAF5iXYP05dJlpxtTNRnpcjBfBgNVHR8EWDBWMFSgUqBQhk5o
# dHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNyb3NvZnQlMjBU
# aW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcmwwbAYIKwYBBQUHAQEEYDBeMFwG
# CCsGAQUFBzAChlBodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRz
# L01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNydDAMBgNV
# HRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMA4GA1UdDwEB/wQEAwIH
# gDANBgkqhkiG9w0BAQsFAAOCAgEAUqht6aSiFPovxDMMLaLaMZyn8NEl/909ehD2
# 48LACJljmeZywG2raKZfMxWPONYG+Xoi9Y/NYeA4hIl7fgSYByANiyISoUrHHe/a
# DG6+t9Q4hKn/V+S2Ud1dyiGLLVNyu3+Q5O7W6G7h7vun2DP4DseOLIEVO2EPmE2B
# 77/JOJjJ7omoSUZVPxdr2r3B1OboV4tO/CuJ0kQD51sl+4FYuolTAQVBePNt6Dxc
# 5xHB7qe1TRkbRntcb55THdQrssXLTPHf6Ksk7McJSQDORf5Q8ZxFqEswJGndZ1r5
# GgHjFe/t/SKV4bn/Rt8W33yosgZ493EHogOEsUsAnZ8dNEQZV0uq/bRg2v6PUUtN
# RTgAcypD+QgQ6ZuMKSnSFO+CrQR9rBOUGGJ+5YmFma9n/1PoIU5nThDj5FxHF/NR
# +HUSVNvE4/4FGXcC/NcWofCp/nAe7zPx7N/yfLRdd2Tz/vDbV977uDa3IRwyWIIz
# ovtSbkn/uI6Rf6RBD16fQLrIs5kppASuIlU+zcFbUZ0tbbPKgBhxj4Nhz2uG9rvZ
# nrnlKKjVbTIW7piNcvnfWZE4TVwV89miLU9gvfQzN096mKgFJrylK8lUqTC1abHu
# I3uVjelVZQgxSlhUR9tNmMRFVrGeW2jfQmqgmwktBGu7PThS2hDOXzZ/ZubOvZQ/
# 3pHFtqkwggdxMIIFWaADAgECAhMzAAAAFcXna54Cm0mZAAAAAAAVMA0GCSqGSIb3
# DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
# A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMTIw
# MAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkgMjAx
# MDAeFw0yMTA5MzAxODIyMjVaFw0zMDA5MzAxODMyMjVaMHwxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1l
# LVN0YW1wIFBDQSAyMDEwMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA
# 5OGmTOe0ciELeaLL1yR5vQ7VgtP97pwHB9KpbE51yMo1V/YBf2xK4OK9uT4XYDP/
# XE/HZveVU3Fa4n5KWv64NmeFRiMMtY0Tz3cywBAY6GB9alKDRLemjkZrBxTzxXb1
# hlDcwUTIcVxRMTegCjhuje3XD9gmU3w5YQJ6xKr9cmmvHaus9ja+NSZk2pg7uhp7
# M62AW36MEBydUv626GIl3GoPz130/o5Tz9bshVZN7928jaTjkY+yOSxRnOlwaQ3K
# Ni1wjjHINSi947SHJMPgyY9+tVSP3PoFVZhtaDuaRr3tpK56KTesy+uDRedGbsoy
# 1cCGMFxPLOJiss254o2I5JasAUq7vnGpF1tnYN74kpEeHT39IM9zfUGaRnXNxF80
# 3RKJ1v2lIH1+/NmeRd+2ci/bfV+AutuqfjbsNkz2K26oElHovwUDo9Fzpk03dJQc
# NIIP8BDyt0cY7afomXw/TNuvXsLz1dhzPUNOwTM5TI4CvEJoLhDqhFFG4tG9ahha
# YQFzymeiXtcodgLiMxhy16cg8ML6EgrXY28MyTZki1ugpoMhXV8wdJGUlNi5UPkL
# iWHzNgY1GIRH29wb0f2y1BzFa/ZcUlFdEtsluq9QBXpsxREdcu+N+VLEhReTwDwV
# 2xo3xwgVGD94q0W29R6HXtqPnhZyacaue7e3PmriLq0CAwEAAaOCAd0wggHZMBIG
# CSsGAQQBgjcVAQQFAgMBAAEwIwYJKwYBBAGCNxUCBBYEFCqnUv5kxJq+gpE8RjUp
# zxD/LwTuMB0GA1UdDgQWBBSfpxVdAF5iXYP05dJlpxtTNRnpcjBcBgNVHSAEVTBT
# MFEGDCsGAQQBgjdMg30BATBBMD8GCCsGAQUFBwIBFjNodHRwOi8vd3d3Lm1pY3Jv
# c29mdC5jb20vcGtpb3BzL0RvY3MvUmVwb3NpdG9yeS5odG0wEwYDVR0lBAwwCgYI
# KwYBBQUHAwgwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQDAgGG
# MA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU1fZWy4/oolxiaNE9lJBb186a
# GMQwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQuY29tL3Br
# aS9jcmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3JsMFoGCCsG
# AQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3NvZnQuY29t
# L3BraS9jZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcnQwDQYJKoZIhvcN
# AQELBQADggIBAJ1VffwqreEsH2cBMSRb4Z5yS/ypb+pcFLY+TkdkeLEGk5c9MTO1
# OdfCcTY/2mRsfNB1OW27DzHkwo/7bNGhlBgi7ulmZzpTTd2YurYeeNg2LpypglYA
# A7AFvonoaeC6Ce5732pvvinLbtg/SHUB2RjebYIM9W0jVOR4U3UkV7ndn/OOPcbz
# aN9l9qRWqveVtihVJ9AkvUCgvxm2EhIRXT0n4ECWOKz3+SmJw7wXsFSFQrP8DJ6L
# GYnn8AtqgcKBGUIZUnWKNsIdw2FzLixre24/LAl4FOmRsqlb30mjdAy87JGA0j3m
# Sj5mO0+7hvoyGtmW9I/2kQH2zsZ0/fZMcm8Qq3UwxTSwethQ/gpY3UA8x1RtnWN0
# SCyxTkctwRQEcb9k+SS+c23Kjgm9swFXSVRk2XPXfx5bRAGOWhmRaw2fpCjcZxko
# JLo4S5pu+yFUa2pFEUep8beuyOiJXk+d0tBMdrVXVAmxaQFEfnyhYWxz/gq77EFm
# PWn9y8FBSX5+k77L+DvktxW/tM4+pTFRhLy/AsGConsXHRWJjXD+57XQKBqJC482
# 2rpM+Zv/Cuk0+CQ1ZyvgDbjmjJnW4SLq8CdCPSWU5nR0W2rRnj7tfqAxM328y+l7
# vzhwRNGQ8cirOoo6CGJ/2XBjU02N7oJtpQUQwXEGahC0HVUzWLOhcGbyoYIDUDCC
# AjgCAQEwgfmhgdGkgc4wgcsxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5n
# dG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9y
# YXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVyaWNhIE9wZXJhdGlvbnMxJzAl
# BgNVBAsTHm5TaGllbGQgVFNTIEVTTjo4RDAwLTA1RTAtRDk0NzElMCMGA1UEAxMc
# TWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZaIjCgEBMAcGBSsOAwIaAxUAaKn3
# ptiis7kWYyEmInxqJVTncgSggYMwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UE
# CBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9z
# b2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQ
# Q0EgMjAxMDANBgkqhkiG9w0BAQsFAAIFAOli0vgwIhgPMjAyNDAxMzAwMTQ0MjRa
# GA8yMDI0MDEzMTAxNDQyNFowdzA9BgorBgEEAYRZCgQBMS8wLTAKAgUA6WLS+AIB
# ADAKAgEAAgIMcwIB/zAHAgEAAgITeTAKAgUA6WQkeAIBADA2BgorBgEEAYRZCgQC
# MSgwJjAMBgorBgEEAYRZCgMCoAowCAIBAAIDB6EgoQowCAIBAAIDAYagMA0GCSqG
# SIb3DQEBCwUAA4IBAQCpeLWwv2QiRjDhFWYak2aVz4RXWzBtcbig6aqsMa3WB/tN
# lEuTBRiUnzFlZNrsqXeKlg27I9G56FCnPdUsn+dL2VhRnI9ewNRlnXuFeMEPClth
# BJibCgM4Elg4fbclKO9AnfhuvnyoQaXg4hXE2X8L5MxnxygmmQrZn5GLI/EXelJN
# tBDIDCCDLo4X79hsvHa7NVnEPlYnCORboSKPjV1BkMxjH/QpeYIA7sDTMt5EZTTY
# dAeK7CngRficlPBGotYf9xSu1dmUUS6ZRxofnHKktW6Lv9B4UUQejS1nAFcMuzHY
# WIXEDOnkSTgaAYl5t2ARegAjXvce/2Y0buviyGR9MYIEDTCCBAkCAQEwgZMwfDEL
# MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
# bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWlj
# cm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAHNVQcq58rBmR0AAQAAAc0w
# DQYJYIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAv
# BgkqhkiG9w0BCQQxIgQgmRz6FGbKEg0G+1iXvYihunwITypznHPqT31esrM5tagw
# gfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCDiZqX4rVa9T2RoL0xHU6UrVHOh
# jYeyza6EASsKVEaZCjCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpX
# YXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQg
# Q29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAy
# MDEwAhMzAAABzVUHKufKwZkdAAEAAAHNMCIEIKDGw4/oxQCF4Y0FsGq/FDXzTnJm
# 7vSHpdA21LKi/yCIMA0GCSqGSIb3DQEBCwUABIICAEfRyhCcjleANMRlgFAIRJ3P
# LI976hcOjrPn8s7qEbUb/65FK+/hIiDRpfENza92TQcDt8BfgD4JjXX70dkobsPA
# /7UXb+7imQc3G2BOhkHec7rz2PjPgUyJJ4DVOHzUGcDyHG0PGnZpJXkZ5NMwS14r
# dLdovcrlu3cl1tORwGMvnXOdC1mRIr1BXQIknlNxZa0elPjPRXVktSPea4hzQNl/
# tcWnTeGsZVzfuoI0hyRIK5gXLzsIwIMaQruty5Od6N4hAJJhTg9Ofm7WiHhuwhip
# uHMxJUDcRaVfuthOFSs7rkwLwp7MJP6qG5WLTLKHbBaEYdxyFmcUPUq3RlEYSUBc
# oJPW9g8GVD8IYrp2ewbTWabohJXiLfeQ5WB1eQQqJttYt2FJDrkaO+JVhLO85S3c
# +Bf+xv6m+N4tzkQYSdX3bgSF+rAGCYVRXVEKb7Ru0wD8y/GYFlN0UXyvC6DVC1jn
# lbv6E8+CvBiAdxkdPzyIDNRzNeq2Xmaoc6zR29Q1ZVNHQuXISoIspDl5HT5z/Qf0
# RYUTSk6HOqvyIFfK9ZPmDbSJTKFQ8Z7SrzrAupIKGkuPBELp9xmE+/yCprwhF9nX
# kICS7vRmI6v0ZShPzp/lCyxUy59m3KDCl3+yrbP5D/7rRlC6n9TcqCK/JJNc19Iu
# qyY6fFuMB9ejKk58DLUG
# SIG # End signature block
