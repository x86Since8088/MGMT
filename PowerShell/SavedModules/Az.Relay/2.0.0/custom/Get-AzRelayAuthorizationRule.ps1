
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
Authorization rule for a namespace by name.
.Description
Authorization rule for a namespace by name.
.Example
{{ Add code here }}
.Example
{{ Add code here }}

.Inputs
Microsoft.Azure.PowerShell.Cmdlets.Relay.Models.IRelayIdentity
.Outputs
Microsoft.Azure.PowerShell.Cmdlets.Relay.Models.Api20211101.IAuthorizationRule
.Notes
COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.

INPUTOBJECT <IRelayIdentity>: Identity Parameter
  [AuthorizationRuleName <String>]: The authorization rule name.
  [HybridConnectionName <String>]: The hybrid connection name.
  [Id <String>]: Resource identity path
  [NamespaceName <String>]: The namespace name
  [PrivateEndpointConnectionName <String>]: The PrivateEndpointConnection name
  [PrivateLinkResourceName <String>]: The PrivateLinkResource name
  [RelayName <String>]: The relay name.
  [ResourceGroupName <String>]: Name of the Resource group within the Azure subscription.
  [SubscriptionId <String>]: Subscription credentials which uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
.Link
https://learn.microsoft.com/powershell/module/az.relay/get-azrelayauthorizationrule
#>
function Get-AzRelayAuthorizationRule {
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.Relay.Models.Api20211101.IAuthorizationRule])]
    [CmdletBinding(DefaultParameterSetName='List', PositionalBinding=$false)]
    param(
        [Parameter(ParameterSetName='Get', Mandatory)]
        [Parameter(ParameterSetName='Get1', Mandatory)]
        [Parameter(ParameterSetName='Get2', Mandatory)]
        [Alias('AuthorizationRuleName')]
        [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Path')]
        [System.String]
        # The authorization rule name.
        ${Name},
    
        [Parameter(ParameterSetName='Get', Mandatory)]
        [Parameter(ParameterSetName='Get1', Mandatory)]
        [Parameter(ParameterSetName='Get2', Mandatory)]
        [Parameter(ParameterSetName='List', Mandatory)]
        [Parameter(ParameterSetName='List1', Mandatory)]
        [Parameter(ParameterSetName='List2', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Path')]
        [System.String]
        # The namespace name
        ${Namespace},
    
        [Parameter(ParameterSetName='Get', Mandatory)]
        [Parameter(ParameterSetName='Get1', Mandatory)]
        [Parameter(ParameterSetName='Get2', Mandatory)]
        [Parameter(ParameterSetName='List', Mandatory)]
        [Parameter(ParameterSetName='List1', Mandatory)]
        [Parameter(ParameterSetName='List2', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Path')]
        [System.String]
        # Name of the Resource group within the Azure subscription.
        ${ResourceGroupName},
    
        [Parameter(ParameterSetName='Get')]
        [Parameter(ParameterSetName='Get1')]
        [Parameter(ParameterSetName='Get2')]
        [Parameter(ParameterSetName='List')]
        [Parameter(ParameterSetName='List1')]
        [Parameter(ParameterSetName='List2')]
        [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Relay.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
        [System.String[]]
        # Subscription credentials which uniquely identify the Microsoft Azure subscription.
        # The subscription ID forms part of the URI for every service call.
        ${SubscriptionId},
    
        [Parameter(ParameterSetName='Get1', Mandatory)]
        [Parameter(ParameterSetName='List1', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Path')]
        [System.String]
        # The hybrid connection name.
        ${HybridConnection},
    
        [Parameter(ParameterSetName='Get2', Mandatory)]
        [Parameter(ParameterSetName='List2', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Path')]
        [System.String]
        # The relay name.
        ${WcfRelay},
    
        [Parameter(ParameterSetName='GetViaIdentity', Mandatory, ValueFromPipeline)]
        [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Relay.Models.IRelayIdentity]
        # Identity Parameter
        # To construct, see NOTES section for INPUTOBJECT properties and create a hash table.
        ${InputObject},
    
        [Parameter()]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Relay.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Relay.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
    )

    process {
        try {
            if (('Get', 'Get1', 'Get2', 'List', 'List1', 'List2') -contains $parameterSet -and -not $PSBoundParameters.ContainsKey('SubscriptionId')) {
                $PSBoundParameters['SubscriptionId'] = (Get-AzContext).Subscription.Id
            }
            $parameterSet = $PSCmdlet.ParameterSetName
            if ($parameterSet -eq 'List') {
                Az.Relay.private\Get-AzRelayAuthorizationRule_List @PSBoundParameters
            }
            if ($parameterSet -eq 'List1') {
                Az.Relay.private\Get-AzRelayAuthorizationRule_List1 @PSBoundParameters
            }
            if ($parameterSet -eq 'List2') {
                Az.Relay.private\Get-AzRelayAuthorizationRule_List2 @PSBoundParameters
            }
            if ($parameterSet -eq 'Get') {
                Az.Relay.private\Get-AzRelayAuthorizationRule_Get @PSBoundParameters
            }
            if ($parameterSet -eq 'Get1') {
                Az.Relay.private\Get-AzRelayAuthorizationRule_Get1 @PSBoundParameters
            }
            if ($parameterSet -eq 'Get2') {
                Az.Relay.private\Get-AzRelayAuthorizationRule_Get2 @PSBoundParameters
            }
            if ($parameterSet -eq 'GetViaIdentity') {
                if ($InputObject.Id -ilike '*hybridConnections*') {
                    Az.Relay.private\Get-AzRelayAuthorizationRule_GetViaIdentity1 @PSBoundParameters
                } elseif ($InputObject.Id -ilike '*wcfRelays*') {
                    Az.Relay.private\Get-AzRelayAuthorizationRule_GetViaIdentity2 @PSBoundParameters
                } else {
                    Az.Relay.private\Get-AzRelayAuthorizationRule_GetViaIdentity @PSBoundParameters
                }
            }
            
        } catch {
    
            throw
        }
    
    }
}   
# SIG # Begin signature block
# MIInoQYJKoZIhvcNAQcCoIInkjCCJ44CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCANc20fqH1GSagn
# Ur2SP7C0jBY10FJB7Nt14kraJr5nfqCCDYUwggYDMIID66ADAgECAhMzAAADTU6R
# phoosHiPAAAAAANNMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMwMzE2MTg0MzI4WhcNMjQwMzE0MTg0MzI4WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDUKPcKGVa6cboGQU03ONbUKyl4WpH6Q2Xo9cP3RhXTOa6C6THltd2RfnjlUQG+
# Mwoy93iGmGKEMF/jyO2XdiwMP427j90C/PMY/d5vY31sx+udtbif7GCJ7jJ1vLzd
# j28zV4r0FGG6yEv+tUNelTIsFmmSb0FUiJtU4r5sfCThvg8dI/F9Hh6xMZoVti+k
# bVla+hlG8bf4s00VTw4uAZhjGTFCYFRytKJ3/mteg2qnwvHDOgV7QSdV5dWdd0+x
# zcuG0qgd3oCCAjH8ZmjmowkHUe4dUmbcZfXsgWlOfc6DG7JS+DeJak1DvabamYqH
# g1AUeZ0+skpkwrKwXTFwBRltAgMBAAGjggGCMIIBfjAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUId2Img2Sp05U6XI04jli2KohL+8w
# VAYDVR0RBE0wS6RJMEcxLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJh
# dGlvbnMgTGltaXRlZDEWMBQGA1UEBRMNMjMwMDEyKzUwMDUxNzAfBgNVHSMEGDAW
# gBRIbmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDEx
# XzIwMTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIB
# ACMET8WuzLrDwexuTUZe9v2xrW8WGUPRQVmyJ1b/BzKYBZ5aU4Qvh5LzZe9jOExD
# YUlKb/Y73lqIIfUcEO/6W3b+7t1P9m9M1xPrZv5cfnSCguooPDq4rQe/iCdNDwHT
# 6XYW6yetxTJMOo4tUDbSS0YiZr7Mab2wkjgNFa0jRFheS9daTS1oJ/z5bNlGinxq
# 2v8azSP/GcH/t8eTrHQfcax3WbPELoGHIbryrSUaOCphsnCNUqUN5FbEMlat5MuY
# 94rGMJnq1IEd6S8ngK6C8E9SWpGEO3NDa0NlAViorpGfI0NYIbdynyOB846aWAjN
# fgThIcdzdWFvAl/6ktWXLETn8u/lYQyWGmul3yz+w06puIPD9p4KPiWBkCesKDHv
# XLrT3BbLZ8dKqSOV8DtzLFAfc9qAsNiG8EoathluJBsbyFbpebadKlErFidAX8KE
# usk8htHqiSkNxydamL/tKfx3V/vDAoQE59ysv4r3pE+zdyfMairvkFNNw7cPn1kH
# Gcww9dFSY2QwAxhMzmoM0G+M+YvBnBu5wjfxNrMRilRbxM6Cj9hKFh0YTwba6M7z
# ntHHpX3d+nabjFm/TnMRROOgIXJzYbzKKaO2g1kWeyG2QtvIR147zlrbQD4X10Ab
# rRg9CpwW7xYxywezj+iNAc+QmFzR94dzJkEPUSCJPsTFMIIHejCCBWKgAwIBAgIK
# YQ6Q0gAAAAAAAzANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlm
# aWNhdGUgQXV0aG9yaXR5IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEw
# OTA5WjB+MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYD
# VQQDEx9NaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+la
# UKq4BjgaBEm6f8MMHt03a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc
# 6Whe0t+bU7IKLMOv2akrrnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4D
# dato88tt8zpcoRb0RrrgOGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+
# lD3v++MrWhAfTVYoonpy4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nk
# kDstrjNYxbc+/jLTswM9sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6
# A4aN91/w0FK/jJSHvMAhdCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmd
# X4jiJV3TIUs+UsS1Vz8kA/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL
# 5zmhD+kjSbwYuER8ReTBw3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zd
# sGbiwZeBe+3W7UvnSSmnEyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3
# T8HhhUSJxAlMxdSlQy90lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS
# 4NaIjAsCAwEAAaOCAe0wggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRI
# bmTlUAXTgqoXNzcitW2oynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAL
# BgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBD
# uRQFTuHqp8cx0SOJNDBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jv
# c29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFf
# MDNfMjIuY3JsMF4GCCsGAQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFf
# MDNfMjIuY3J0MIGfBgNVHSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEF
# BQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1h
# cnljcHMuaHRtMEAGCCsGAQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkA
# YwB5AF8AcwB0AGEAdABlAG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn
# 8oalmOBUeRou09h0ZyKbC5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7
# v0epo/Np22O/IjWll11lhJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0b
# pdS1HXeUOeLpZMlEPXh6I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/
# KmtYSWMfCWluWpiW5IP0wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvy
# CInWH8MyGOLwxS3OW560STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBp
# mLJZiWhub6e3dMNABQamASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJi
# hsMdYzaXht/a8/jyFqGaJ+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYb
# BL7fQccOKO7eZS/sl/ahXJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbS
# oqKfenoi+kiVH6v7RyOA9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sL
# gOppO6/8MO0ETI7f33VtY5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtX
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGXIwghluAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAANNTpGmGiiweI8AAAAA
# A00wDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIHGf
# x+DMH1F2H62b+Bh6ozhLnmIa5/OTV2naxJVlq9/gMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAmLzLtZ/HLdmQqeqfeUk4sZGKiY/9uotjlaLM
# 4lcYIRBeXLUImeaznWg5X9arzwmagwnOSh4YnIbVw/0YpdcjbB7ypfTCp/sZMq9h
# 6a3GGhb5+K/84e30lAtVLTJqBr4MebBBu1fj677HvZfzhR74E0sgkaczKoGqXjQv
# o/0HP3IJwSi3fA9RpqZOP6fKg0PxlNN5Ie7Oqu7DKx1eviVZlliNprZ5TDqpu3pv
# ZerYg+eDMDQXCE+gx+QkhHkr2jkNA3LjMHLksuPXIuCp9TkR9rj65E7sEnYQLPkl
# vlv9e/6w6PtxFfWe/tZ4nZhPGlO0PcX7U95UI33x4TSaGYpLrKGCFvwwghb4Bgor
# BgEEAYI3AwMBMYIW6DCCFuQGCSqGSIb3DQEHAqCCFtUwghbRAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFQBgsqhkiG9w0BCRABBKCCAT8EggE7MIIBNwIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCB7sVdDlj8/qLkEH0/Ekf593lFo4hv8kstb
# EDhuPYCqewIGZF1fAppcGBIyMDIzMDUyMjExNDU0MS4yMVowBIACAfSggdCkgc0w
# gcoxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsT
# HE1pY3Jvc29mdCBBbWVyaWNhIE9wZXJhdGlvbnMxJjAkBgNVBAsTHVRoYWxlcyBU
# U1MgRVNOOjIyNjQtRTMzRS03ODBDMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1T
# dGFtcCBTZXJ2aWNloIIRVDCCBwwwggT0oAMCAQICEzMAAAHBPqCDnOAJr8UAAQAA
# AcEwDQYJKoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAw
# HhcNMjIxMTA0MTkwMTI3WhcNMjQwMjAyMTkwMTI3WjCByjELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJp
# Y2EgT3BlcmF0aW9uczEmMCQGA1UECxMdVGhhbGVzIFRTUyBFU046MjI2NC1FMzNF
# LTc4MEMxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2UwggIi
# MA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDksdczJ3DaFQLiklTQjm48mcx5
# GbwsoLjFogO7cXHHciln9Z7apcuPg06ajD9Y8V5ji9pPj9LhP3GgOwUaDnAQkzo4
# tlV9rsFQ27S0O3iuSXtAFg0fPPqlyv1vBqraqbvHo/3KLlbRjyyOiP5BOC2aZejE
# Kg1eEnWgboZuoANBcNmRNwOMgCK14TpPGuEGkhvt7q6mJ9MZk19wKE9+7MerrUVI
# jAnRcLFxpHUHACVIqFv81Q65AY+v1nN3o6chwD5Fy3HAqB84oH1pYQQeW3SOEoqC
# kQG9wmcww/5ZpPCYyGhvV76GgIQXH+cjRge6mLrTzaQV00WtoTvaaw5hCvCtTJYJ
# 5KY3bTYtkOlPPFlW3LpCsE6T5/4ESuxH4zl6+Qq5RNZUkcje+02Bvorn6CToS5DD
# ShywN2ymI+n6qXEFpbnTJRuvrCd/NiMmHtCQ9x8EhlskCFZAdpXS5LdPs6Q5t0Ky
# wJExYftVZQB5Jt6a5So5cJHut2kVN9j9Jco72UIhAEBBKH7DPCHlm/Vv6NPbNbBW
# XzYHLdgeZJPxvwIqdFdIKMu2CjLLsREvCRvM8iQJ8FdzJWd4LXDb/BSeo+ICMrTB
# B/O19cV+gxCvxhRwsecC16Tw5U0+5EhXptwRFsXqu0VeaeOMPhnBXEhn8czhyN5U
# awTCQUD1dPOpf1bU/wIDAQABo4IBNjCCATIwHQYDVR0OBBYEFF+vYwnrHvIT6A/m
# 5f3FYZPClEL6MB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8GA1Ud
# HwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY3Js
# L01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBsBggr
# BgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0LmNv
# bS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIw
# MTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwEwYDVR0lBAwwCgYIKwYBBQUHAwgwDQYJ
# KoZIhvcNAQELBQADggIBAF+6JoGCx5we8z3RFmJMOV8duUvT2v1f7mr1yS4xHQGz
# VKvkHYwAuFPljRHeCAu59FfpFBBtJztbFFcgyvm0USAHnPL/tiDzUKfZ2FN/UbOM
# Jvv+ffC0lIa2vZDAexrV6FhZ0x+L4RMugRfUbv1U8WuzS3oaLCmvvi2/4IsTezqb
# XRU7B7zTA/jK5Pd6IV+pFXymhQVJ0vbByWBAqhLBsKlsmU0L8RJoNBttAWWL247m
# PZ/8btLhMwb+DLLG8xDlAm6L0XDazuqSWajNChfYCHhoq5sp739Vm96IRM1iXUBk
# +PSSPWDnVU3JaO8fD4fPXFl6RYil8xdASLTCsZ1Z6JbiLyX3atjdlt0ewSsVirOH
# oVEU55eBrM2x+QubDL5MrXuYDsJMRTNoBYyrn5/0rhj/eaEHivpSuKy2Ral2Q9YS
# jxv21uR0pJjTQT4VLkNS2OAB0JpEE1oG7xwVgJsSuH2uhYPFz4iy/zIxABQO4TBd
# LLQTGcgCVxUiuHMvjQ6wbZxrlHkGAB68Y/UeP16PiX/L5KHQdVw303ouY8OYj8xp
# TasRntj6NF8JnV36XkMRJ0tcjENPKxheRP7dUz/XOHrLazRmxv/e89oaenbN6PB/
# ZiUZaXVekKE1lN6UXl44IJ9LNRSfeod7sjLIMqFqGBucqmbBwSQxUGz5EdtWQ1ao
# MIIHcTCCBVmgAwIBAgITMwAAABXF52ueAptJmQAAAAAAFTANBgkqhkiG9w0BAQsF
# ADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
# B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UE
# AxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIwMTAwHhcN
# MjEwOTMwMTgyMjI1WhcNMzAwOTMwMTgzMjI1WjB8MQswCQYDVQQGEwJVUzETMBEG
# A1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWlj
# cm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFt
# cCBQQ0EgMjAxMDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAOThpkzn
# tHIhC3miy9ckeb0O1YLT/e6cBwfSqWxOdcjKNVf2AX9sSuDivbk+F2Az/1xPx2b3
# lVNxWuJ+Slr+uDZnhUYjDLWNE893MsAQGOhgfWpSg0S3po5GawcU88V29YZQ3MFE
# yHFcUTE3oAo4bo3t1w/YJlN8OWECesSq/XJprx2rrPY2vjUmZNqYO7oaezOtgFt+
# jBAcnVL+tuhiJdxqD89d9P6OU8/W7IVWTe/dvI2k45GPsjksUZzpcGkNyjYtcI4x
# yDUoveO0hyTD4MmPfrVUj9z6BVWYbWg7mka97aSueik3rMvrg0XnRm7KMtXAhjBc
# TyziYrLNueKNiOSWrAFKu75xqRdbZ2De+JKRHh09/SDPc31BmkZ1zcRfNN0Sidb9
# pSB9fvzZnkXftnIv231fgLrbqn427DZM9ituqBJR6L8FA6PRc6ZNN3SUHDSCD/AQ
# 8rdHGO2n6Jl8P0zbr17C89XYcz1DTsEzOUyOArxCaC4Q6oRRRuLRvWoYWmEBc8pn
# ol7XKHYC4jMYctenIPDC+hIK12NvDMk2ZItboKaDIV1fMHSRlJTYuVD5C4lh8zYG
# NRiER9vcG9H9stQcxWv2XFJRXRLbJbqvUAV6bMURHXLvjflSxIUXk8A8FdsaN8cI
# FRg/eKtFtvUeh17aj54WcmnGrnu3tz5q4i6tAgMBAAGjggHdMIIB2TASBgkrBgEE
# AYI3FQEEBQIDAQABMCMGCSsGAQQBgjcVAgQWBBQqp1L+ZMSavoKRPEY1Kc8Q/y8E
# 7jAdBgNVHQ4EFgQUn6cVXQBeYl2D9OXSZacbUzUZ6XIwXAYDVR0gBFUwUzBRBgwr
# BgEEAYI3TIN9AQEwQTA/BggrBgEFBQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9Eb2NzL1JlcG9zaXRvcnkuaHRtMBMGA1UdJQQMMAoGCCsGAQUF
# BwMIMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1UdDwQEAwIBhjAPBgNV
# HRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFNX2VsuP6KJcYmjRPZSQW9fOmhjEMFYG
# A1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3Js
# L3Byb2R1Y3RzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNybDBaBggrBgEFBQcB
# AQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kv
# Y2VydHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3J0MA0GCSqGSIb3DQEBCwUA
# A4ICAQCdVX38Kq3hLB9nATEkW+Geckv8qW/qXBS2Pk5HZHixBpOXPTEztTnXwnE2
# P9pkbHzQdTltuw8x5MKP+2zRoZQYIu7pZmc6U03dmLq2HnjYNi6cqYJWAAOwBb6J
# 6Gngugnue99qb74py27YP0h1AdkY3m2CDPVtI1TkeFN1JFe53Z/zjj3G82jfZfak
# Vqr3lbYoVSfQJL1AoL8ZthISEV09J+BAljis9/kpicO8F7BUhUKz/AyeixmJ5/AL
# aoHCgRlCGVJ1ijbCHcNhcy4sa3tuPywJeBTpkbKpW99Jo3QMvOyRgNI95ko+ZjtP
# u4b6MhrZlvSP9pEB9s7GdP32THJvEKt1MMU0sHrYUP4KWN1APMdUbZ1jdEgssU5H
# LcEUBHG/ZPkkvnNtyo4JvbMBV0lUZNlz138eW0QBjloZkWsNn6Qo3GcZKCS6OEua
# bvshVGtqRRFHqfG3rsjoiV5PndLQTHa1V1QJsWkBRH58oWFsc/4Ku+xBZj1p/cvB
# QUl+fpO+y/g75LcVv7TOPqUxUYS8vwLBgqJ7Fx0ViY1w/ue10CgaiQuPNtq6TPmb
# /wrpNPgkNWcr4A245oyZ1uEi6vAnQj0llOZ0dFtq0Z4+7X6gMTN9vMvpe784cETR
# kPHIqzqKOghif9lwY1NNje6CbaUFEMFxBmoQtB1VM1izoXBm8qGCAsswggI0AgEB
# MIH4oYHQpIHNMIHKMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
# MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9u
# MSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMSYwJAYDVQQL
# Ex1UaGFsZXMgVFNTIEVTTjoyMjY0LUUzM0UtNzgwQzElMCMGA1UEAxMcTWljcm9z
# b2Z0IFRpbWUtU3RhbXAgU2VydmljZaIjCgEBMAcGBSsOAwIaAxUARIo61IrtFVUr
# 5KL5qoV3RhJj5U+ggYMwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MDANBgkqhkiG9w0BAQUFAAIFAOgVtHowIhgPMjAyMzA1MjIxNzI5MzBaGA8yMDIz
# MDUyMzE3MjkzMFowdDA6BgorBgEEAYRZCgQBMSwwKjAKAgUA6BW0egIBADAHAgEA
# AgIIRTAHAgEAAgISNzAKAgUA6BcF+gIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgor
# BgEEAYRZCgMCoAowCAIBAAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBBQUA
# A4GBAF5+5fNdMVPdxnIQtmPK9egAVTqh6IBzJSqsjnpmsUPdRML2vDaLYZ++0vYB
# Zau8GYJm8+qm1VZb0wNPtUQyEGXJpcECXgdImDqRI4Up0SEC1k1ZDGYP8xjX+131
# 3WKlg2MKGrXsNrO5fM1DqbfJ9ghm2JrDv+Z4yBtNMX1si2OpMYIEDTCCBAkCAQEw
# gZMwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
# B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UE
# AxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAHBPqCDnOAJr8UA
# AQAAAcEwDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0B
# CRABBDAvBgkqhkiG9w0BCQQxIgQgx3NDh5B2p9KWOtRUk1sBLdLrhRg7Xny0yoP6
# Jt8Ebz0wgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCAKuSDq2Bgd5KAiw3ei
# lHbPsQTFYDRiSKuS9VhJMGB21DCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFBDQSAyMDEwAhMzAAABwT6gg5zgCa/FAAEAAAHBMCIEIKfhgUeyNunlSJGoMSzC
# srLGo5rm1nGHaMNOf0V9qgV1MA0GCSqGSIb3DQEBCwUABIICAHxK6HOlnPmt9fw/
# VICPetWpADsb2LftoaZInGbBC+x7EPNvEeddsD9W7ZplPVyG8E+ugnEAxtu1txT9
# WmlgC0AsTLsap8T+qDtJlkw1sfh58cy6bHSo6QO1ZdVS98xantujZmryeAVRLl1k
# FlAxIaydmuOPkZAjpTDGgyGaLtl9DC793XgApsUeNSrpaTx9MdVaCswUsbk5CD9C
# sRkREhDdn0g7T8W3RekSlEiS+fAhGxoQX3Vi1IW1KmpeoIxvaoNbC5jYVCy9CifG
# kHbxrB24c9bCJomN8M89ROz2RJFdnELSXhxMkmJ6dQuHIzYaeTtShIaOC/Bypry1
# PnqsVTQJWNNONBt/nDEjQpThl3UW9Q2X7NevCQXevI9oB1ruOko3uHjTCrL/QnoT
# CL/zOhtQrOqmQDQjW7BCeYvTThkrBiD45VBBovvMEVglUgQ7V7R7Zr07B+m4OpaY
# ba8XPK1Siy3r9pDCogszzxTc2/cwIieiCEsh5FnXdSbOaEnOgdadK5l0ptzWYLiP
# reswmiWd/oA2w9L4VrXuD5NZlQeKXKL/B55b63fIvjWyzBTvVcrs2ZwJe3J/l/Ad
# u1xHzOh6ZFMEvydAdXSDgxbafGyN7wBlx5MxtziO7vCsxz9MGCR3NPQewgqeXRjc
# z6OVdtHFTXCbnQ5MelGB7WZEzzbc
# SIG # End signature block