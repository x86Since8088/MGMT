
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
Creates or updates an authorization rule for a namespace.
.Description
Creates or updates an authorization rule for a namespace.
.Example
Set-AzRelayAuthorizationRule -ResourceGroupName lucas-relay-rg -Namespace namespace-pwsh01 -Name authRule-03 -Rights 'Listen' | fl
.Example
$authRule = Get-AzRelayAuthorizationRule -ResourceGroupName lucas-relay-rg -Namespace namespace-pwsh01 -Name authRule-03
$authRule.Rights += 'Send'
Set-AzRelayAuthorizationRule -ResourceGroupName lucas-relay-rg -Namespace namespace-pwsh01 -Name authRule-03 -InputObject $authRule | fl
.Example
Set-AzRelayAuthorizationRule -ResourceGroupName lucas-relay-rg -Namespace namespace-pwsh01 -HybridConnection connection-01 -Name authRule-01 -Rights 'Listen' | fl
.Example
$authRule = Get-AzRelayAuthorizationRule -ResourceGroupName lucas-relay-rg -Namespace namespace-pwsh01 -HybridConnection connection-01 -Name authRule-01
$authRule.Rights += 'Send'
Set-AzRelayAuthorizationRule -ResourceGroupName lucas-relay-rg -Namespace namespace-pwsh01 -HybridConnection connection-01 -Name authRule-01 -InputObject $authRule | fl
.Example
Set-AzRelayAuthorizationRule -ResourceGroupName lucas-relay-rg -Namespace namespace-pwsh01 -WcfRelay wcf-01 -Name authRule-01 -Rights 'Listen' | fl
.Example
$authRule = Get-AzRelayAuthorizationRule -ResourceGroupName lucas-relay-rg -Namespace namespace-pwsh01 -WcfRelay wcf-01 -Name authRule-01
$authRule.Rights += 'Send'
Set-AzRelayAuthorizationRule -ResourceGroupName lucas-relay-rg -Namespace namespace-pwsh01 -WcfRelay wcf-01 -Name authRule-01 -InputObject $authRule | fl

.Inputs
Microsoft.Azure.PowerShell.Cmdlets.Relay.Models.Api20211101.IAuthorizationRule
.Outputs
Microsoft.Azure.PowerShell.Cmdlets.Relay.Models.Api20211101.IAuthorizationRule
.Notes
COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.

INPUTOBJECT <IAuthorizationRule>: Single item in a List or Get AuthorizationRule operation
  [Rights <AccessRights[]>]: The rights associated with the rule.
  [SystemDataCreatedAt <DateTime?>]: The timestamp of resource creation (UTC).
  [SystemDataCreatedBy <String>]: The identity that created the resource.
  [SystemDataCreatedByType <CreatedByType?>]: The type of identity that created the resource.
  [SystemDataLastModifiedAt <DateTime?>]: The timestamp of resource last modification (UTC)
  [SystemDataLastModifiedBy <String>]: The identity that last modified the resource.
  [SystemDataLastModifiedByType <CreatedByType?>]: The type of identity that last modified the resource.
.Link
https://learn.microsoft.com/powershell/module/az.relay/set-azrelayauthorizationrule
#>
function Set-AzRelayAuthorizationRule {
[OutputType([Microsoft.Azure.PowerShell.Cmdlets.Relay.Models.Api20211101.IAuthorizationRule])]
[CmdletBinding(DefaultParameterSetName='UpdateExpanded', PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
param(
    [Parameter(Mandatory)]
    [Alias('AuthorizationRuleName')]
    [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Path')]
    [System.String]
    # The authorization rule name.
    ${Name},

    [Parameter(Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Path')]
    [System.String]
    # The namespace name
    ${Namespace},

    [Parameter(Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Path')]
    [System.String]
    # Name of the Resource group within the Azure subscription.
    ${ResourceGroupName},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Path')]
    [Microsoft.Azure.PowerShell.Cmdlets.Relay.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
    [System.String]
    # Subscription credentials which uniquely identify the Microsoft Azure subscription.
    # The subscription ID forms part of the URI for every service call.
    ${SubscriptionId},

    [Parameter(ParameterSetName='Update1', Mandatory)]
    [Parameter(ParameterSetName='UpdateExpanded1', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Path')]
    [System.String]
    # The hybrid connection name.
    ${HybridConnection},

    [Parameter(ParameterSetName='Update2', Mandatory)]
    [Parameter(ParameterSetName='UpdateExpanded2', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Path')]
    [System.String]
    # The relay name.
    ${WcfRelay},

    [Parameter(ParameterSetName='Update', Mandatory, ValueFromPipeline)]
    [Parameter(ParameterSetName='Update1', Mandatory, ValueFromPipeline)]
    [Parameter(ParameterSetName='Update2', Mandatory, ValueFromPipeline)]
    [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Relay.Models.Api20211101.IAuthorizationRule]
    # Single item in a List or Get AuthorizationRule operation
    # To construct, see NOTES section for INPUTOBJECT properties and create a hash table.
    ${InputObject},

    [Parameter(ParameterSetName='UpdateExpanded')]
    [Parameter(ParameterSetName='UpdateExpanded1')]
    [Parameter(ParameterSetName='UpdateExpanded2')]
    [AllowEmptyCollection()]
    [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.Relay.Support.AccessRights])]
    [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Relay.Support.AccessRights[]]
    # The rights associated with the rule.
    ${Rights},

    [Parameter()]
    [Alias('AzureRMContext', 'AzureCredential')]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.Relay.Category('Azure')]
    [System.Management.Automation.PSObject]
    # The DefaultProfile parameter is not functional.
    # Use the SubscriptionId parameter when available if executing the cmdlet against a different subscription.
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
        $outBuffer = $null
        if ($PSBoundParameters.TryGetValue('OutBuffer', [ref]$outBuffer)) {
            $PSBoundParameters['OutBuffer'] = 1
        }
        # 1. Get
        $parameterSet = $PSCmdlet.ParameterSetName

        if (('Update', 'Update1', 'Update2', 'UpdateExpanded', 'UpdateExpanded1', 'UpdateExpanded2') -contains $parameterSet -and -not $PSBoundParameters.ContainsKey('SubscriptionId')) {
            $PSBoundParameters['SubscriptionId'] = (Get-AzContext).Subscription.Id
        }

        $null = $PSBoundParameters.Remove('Rights')
        $hasInputObject = $PSBoundParameters.Remove('InputObject')

        $authorizationRule = $null

        if (('UpdateExpanded') -contains $parameterSet) {
            $authorizationRule = Get-AzRelayAuthorizationRule @PSBoundParameters
            $parameterSet = 'Update'
        }

        if (('UpdateExpanded1') -contains $parameterSet) {
            $authorizationRule = Get-AzRelayAuthorizationRule @PSBoundParameters
            $parameterSet = 'Update1'
        }

        if (('UpdateExpanded2') -contains $parameterSet) {
            $authorizationRule = Get-AzRelayAuthorizationRule @PSBoundParameters
            $parameterSet = 'Update2'
        }

        # 2. Put
        if ( $hasInputObject ) {
            $authorizationRule = $InputObject
        }
        else {
            $authorizationRule.Rights = $Rights
        }

        if (('Update') -contains $parameterSet) {
            Az.Relay.private\Set-AzRelayAuthorizationRule_Update -InputObject $authorizationRule @PSBoundParameters
        }

        if (('Update1') -contains $parameterSet) {
            Az.Relay.private\Set-AzRelayAuthorizationRule_Update1 -InputObject $authorizationRule @PSBoundParameters
        }

        if (('Update2') -contains $parameterSet) {
            Az.Relay.private\Set-AzRelayAuthorizationRule_Update2 -InputObject $authorizationRule @PSBoundParameters
        }

    } catch {

        throw
    }
}

}
# SIG # Begin signature block
# MIInogYJKoZIhvcNAQcCoIInkzCCJ48CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAa+eN/U0PkSeBm
# fonwCsbpxNYkVpZ2IM7MHFXEXpNgeqCCDYUwggYDMIID66ADAgECAhMzAAADTU6R
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
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGXMwghlvAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAANNTpGmGiiweI8AAAAA
# A00wDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIFM0
# wOMkKdylm1t5SqVB+jhhSI9RIUn81KkIl7PYlrKpMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAf0uHeDXtXz1cLPLvu34NeH+Ro6gM52zJlZXI
# QvWHpJBH8xRweNqxw8tCYXWtg0TadzjM13sZPKML9uE+U6AREMw4SlzADKXPT/+p
# v611g0a9FYyJhLw5prxl93fn28nFAyuHDVEonAycc7J17gh5GcYvFQa4fAfqcREA
# rgaSCdJTf7KAsuadk5Hh+heCRq8AvLq83ImT+qGuEGc+IFp/XUAooj2LdzlYC4b/
# 4wGJpeTUzhh+FAKTTFrTlbhb/NQ4TC+PSQ0tL2CYcgFPjk2hhqNbSp1f0vtgEARy
# 9kvRDBm8F2ArzilB2e4s5d6SN8xFmLTiEho5hDTwwLmvPbqrZaGCFv0wghb5Bgor
# BgEEAYI3AwMBMYIW6TCCFuUGCSqGSIb3DQEHAqCCFtYwghbSAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFRBgsqhkiG9w0BCRABBKCCAUAEggE8MIIBOAIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCB+3tSQytC0g/P3ldUI5VaAL8uiRalulQqH
# 4AmJmqEGWwIGZFzViSxhGBMyMDIzMDUyMjExNDU0NC42MzRaMASAAgH0oIHQpIHN
# MIHKMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQL
# ExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMSYwJAYDVQQLEx1UaGFsZXMg
# VFNTIEVTTjpERDhDLUUzMzctMkZBRTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgU2VydmljZaCCEVQwggcMMIIE9KADAgECAhMzAAABxQPNzSGh9O85AAEA
# AAHFMA0GCSqGSIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEw
# MB4XDTIyMTEwNDE5MDEzMloXDTI0MDIwMjE5MDEzMlowgcoxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVy
# aWNhIE9wZXJhdGlvbnMxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNOOkREOEMtRTMz
# Ny0yRkFFMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNlMIIC
# IjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAq0hds70eX23J7pappaKXRhz+
# TT7JJ3OvVf3+N8fNpxRs5jY4hEv3BV/w5EWXbZdO4m3xj01lTI/xDkq+ytjuiPe8
# xGXsZxDntv7L1EzMd5jISqJ+eYu8kgV056mqs8dBo55xZPPPcxf5u19zn04aMQF5
# PXV/C4ZLSjFa9IFNcribdOm3lGW1rQRFa2jUsup6gv634q5UwH09WGGu0z89Rbtb
# yM55vmBgWV8ed6bZCZrcoYIjML8FRTvGlznqm6HtwZdXMwKHT3a/kLUSPiGAsrIg
# Ezz7NpBpeOsgs9TrwyWTZBNbBwyIACmQ34j+uR4et2hZk+NH49KhEJyYD2+dOIaD
# GB2EUNFSYcy1MkgtZt1eRqBB0m+YPYz7HjocPykKYNQZ7Tv+zglOffCiax1jOb0u
# 6IYC5X1Jr8AwTcsaDyu3qAhx8cFQN9DDgiVZw+URFZ8oyoDk6sIV1nx5zZLy+hNt
# akePX9S7Y8n1qWfAjoXPE6K0/dbTw87EOJL/BlJGcKoFTytr0zPg/MNJSb6f2a/w
# DkXoGCGWJiQrGTxjOP+R96/nIIG05eE1Lpky2FOdYMPB4DhW7tBdZautepTTuShm
# gn+GKER8AoA1gSSk1EC5ZX4cppVngJpblMBu8r/tChfHVdXviY6hDShHwQCmZqZe
# bgSYHnHl4urE+4K6ZC8CAwEAAaOCATYwggEyMB0GA1UdDgQWBBRU6rs4v1mxNYG/
# rtpLwrVwek0FazAfBgNVHSMEGDAWgBSfpxVdAF5iXYP05dJlpxtTNRnpcjBfBgNV
# HR8EWDBWMFSgUqBQhk5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2Ny
# bC9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcmwwbAYI
# KwYBBQUHAQEEYDBeMFwGCCsGAQUFBzAChlBodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NlcnRzL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAy
# MDEwKDEpLmNydDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMIMA0G
# CSqGSIb3DQEBCwUAA4ICAQCMqN58frMHOScciK+Cdnr6dK8fTsgQDeZ9bvQjCuxN
# IJZJ92+xpeKRCf3Xq47qdRykkKUnZC6dHhLwt1fhwyiy/LfdVQ9yf1hYZ/RpTS+z
# 0hnaoK+P/IDAiUNm32NXLhDBu0P4Sb/uCV4jOuNUcmJhppBQgQVhFx/57JYk1LCd
# jIee//GrcfbkQtiYob9Oa93DSjbsD1jqaicEnkclUN/mEm9ZsnCnA1+/OQDp/8Q4
# cPfH94LM4J6X0NtNBeVywvWH0wuMaOJzHgDLCeJUkFE9HE8sBDVedmj6zPJAI+7o
# zLjYqw7i4RFbiStfWZSGjwt+lLJQZRWUCcT3aHYvTo1YWDZskohWg77w9fF2QbiO
# 9DfnqoZ7QozHi7RiPpbjgkJMAhrhpeTf/at2e9+HYkKObUmgPArH1Wjivwm1d7PY
# WsarL7u5qZuk36Gb1mETS1oA2XX3+C3rgtzRohP89qZVf79lVvjmg34NtICK/pMk
# 99SButghtipFSMQdbXUnS2oeLt9cKuv1MJu+gJ83qXTNkQ2QqhxtNRvbE9QqmqJQ
# w5VW/4SZze1pPXxyOTO5yDq+iRIUubqeQzmUcCkiyNuCLHWh8OLCI5mIOC1iLtVD
# f2lw9eWropwu5SDJtT/ZwqIU1qb2U+NjkNcj1hbODBRELaTTWd91RJiUI9ncJkGg
# /jCCB3EwggVZoAMCAQICEzMAAAAVxedrngKbSZkAAAAAABUwDQYJKoZIhvcNAQEL
# BQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
# EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xMjAwBgNV
# BAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0eSAyMDEwMB4X
# DTIxMDkzMDE4MjIyNVoXDTMwMDkzMDE4MzIyNVowfDELMAkGA1UEBhMCVVMxEzAR
# BgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1p
# Y3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3Rh
# bXAgUENBIDIwMTAwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDk4aZM
# 57RyIQt5osvXJHm9DtWC0/3unAcH0qlsTnXIyjVX9gF/bErg4r25PhdgM/9cT8dm
# 95VTcVrifkpa/rg2Z4VGIwy1jRPPdzLAEBjoYH1qUoNEt6aORmsHFPPFdvWGUNzB
# RMhxXFExN6AKOG6N7dcP2CZTfDlhAnrEqv1yaa8dq6z2Nr41JmTamDu6GnszrYBb
# fowQHJ1S/rboYiXcag/PXfT+jlPP1uyFVk3v3byNpOORj7I5LFGc6XBpDco2LXCO
# Mcg1KL3jtIckw+DJj361VI/c+gVVmG1oO5pGve2krnopN6zL64NF50ZuyjLVwIYw
# XE8s4mKyzbnijYjklqwBSru+cakXW2dg3viSkR4dPf0gz3N9QZpGdc3EXzTdEonW
# /aUgfX782Z5F37ZyL9t9X4C626p+Nuw2TPYrbqgSUei/BQOj0XOmTTd0lBw0gg/w
# EPK3Rxjtp+iZfD9M269ewvPV2HM9Q07BMzlMjgK8QmguEOqEUUbi0b1qGFphAXPK
# Z6Je1yh2AuIzGHLXpyDwwvoSCtdjbwzJNmSLW6CmgyFdXzB0kZSU2LlQ+QuJYfM2
# BjUYhEfb3BvR/bLUHMVr9lxSUV0S2yW6r1AFemzFER1y7435UsSFF5PAPBXbGjfH
# CBUYP3irRbb1Hode2o+eFnJpxq57t7c+auIurQIDAQABo4IB3TCCAdkwEgYJKwYB
# BAGCNxUBBAUCAwEAATAjBgkrBgEEAYI3FQIEFgQUKqdS/mTEmr6CkTxGNSnPEP8v
# BO4wHQYDVR0OBBYEFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMFwGA1UdIARVMFMwUQYM
# KwYBBAGCN0yDfQEBMEEwPwYIKwYBBQUHAgEWM2h0dHA6Ly93d3cubWljcm9zb2Z0
# LmNvbS9wa2lvcHMvRG9jcy9SZXBvc2l0b3J5Lmh0bTATBgNVHSUEDDAKBggrBgEF
# BQcDCDAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYD
# VR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvXzpoYxDBW
# BgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2Ny
# bC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYIKwYBBQUH
# AQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtp
# L2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNydDANBgkqhkiG9w0BAQsF
# AAOCAgEAnVV9/Cqt4SwfZwExJFvhnnJL/Klv6lwUtj5OR2R4sQaTlz0xM7U518Jx
# Nj/aZGx80HU5bbsPMeTCj/ts0aGUGCLu6WZnOlNN3Zi6th542DYunKmCVgADsAW+
# iehp4LoJ7nvfam++Kctu2D9IdQHZGN5tggz1bSNU5HhTdSRXud2f8449xvNo32X2
# pFaq95W2KFUn0CS9QKC/GbYSEhFdPSfgQJY4rPf5KYnDvBewVIVCs/wMnosZiefw
# C2qBwoEZQhlSdYo2wh3DYXMuLGt7bj8sCXgU6ZGyqVvfSaN0DLzskYDSPeZKPmY7
# T7uG+jIa2Zb0j/aRAfbOxnT99kxybxCrdTDFNLB62FD+CljdQDzHVG2dY3RILLFO
# Ry3BFARxv2T5JL5zbcqOCb2zAVdJVGTZc9d/HltEAY5aGZFrDZ+kKNxnGSgkujhL
# mm77IVRrakURR6nxt67I6IleT53S0Ex2tVdUCbFpAUR+fKFhbHP+CrvsQWY9af3L
# wUFJfn6Tvsv4O+S3Fb+0zj6lMVGEvL8CwYKiexcdFYmNcP7ntdAoGokLjzbaukz5
# m/8K6TT4JDVnK+ANuOaMmdbhIurwJ0I9JZTmdHRbatGePu1+oDEzfbzL6Xu/OHBE
# 0ZDxyKs6ijoIYn/ZcGNTTY3ugm2lBRDBcQZqELQdVTNYs6FwZvKhggLLMIICNAIB
# ATCB+KGB0KSBzTCByjELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEmMCQGA1UE
# CxMdVGhhbGVzIFRTUyBFU046REQ4Qy1FMzM3LTJGQUUxJTAjBgNVBAMTHE1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFNlcnZpY2WiIwoBATAHBgUrDgMCGgMVACEAGvYXZJK7
# cUo62+LvEYQEx7/noIGDMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldh
# c2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBD
# b3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIw
# MTAwDQYJKoZIhvcNAQEFBQACBQDoFdL4MCIYDzIwMjMwNTIyMTkzOTM2WhgPMjAy
# MzA1MjMxOTM5MzZaMHQwOgYKKwYBBAGEWQoEATEsMCowCgIFAOgV0vgCAQAwBwIB
# AAICDzEwBwIBAAICEdswCgIFAOgXJHgCAQAwNgYKKwYBBAGEWQoEAjEoMCYwDAYK
# KwYBBAGEWQoDAqAKMAgCAQACAwehIKEKMAgCAQACAwGGoDANBgkqhkiG9w0BAQUF
# AAOBgQCpix+BUOU0C4dUux9c32fJikiG7cH0Wb3KnMuhgcBCYc5z1OLxbu6/j8kj
# YxoOzQw+R/unGGLUEOiRLMyoaTvhc9CbwmOkp/yjn3qOR9F/0YLyNeQ8Y0z9cE74
# j4a2jmZ6wuWdw/lGf4YxlCe8XTz3mmr/7PGf8WBfkaeQe3pNrjGCBA0wggQJAgEB
# MIGTMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
# EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNV
# BAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAABxQPNzSGh9O85
# AAEAAAHFMA0GCWCGSAFlAwQCAQUAoIIBSjAaBgkqhkiG9w0BCQMxDQYLKoZIhvcN
# AQkQAQQwLwYJKoZIhvcNAQkEMSIEILjWXtIs6h4OQtYB1afgaTJTAiXekgkuoe+d
# fft0moGeMIH6BgsqhkiG9w0BCRACLzGB6jCB5zCB5DCBvQQgGQGxkfYkd0wK+V09
# wO0sO+sm8gAMyj5EuKPqvNQ/fLEwgZgwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEG
# A1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWlj
# cm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFt
# cCBQQ0EgMjAxMAITMwAAAcUDzc0hofTvOQABAAABxTAiBCCOCICK30cB+r1n4oRk
# Iqf5WdlDl0Uhx8O1cMgWI0nrATANBgkqhkiG9w0BAQsFAASCAgAMc8vOolp0/XUD
# rzp+jcbFWdGlISLvpAeCPuVUOinS94Luajz4gt88+8FwuNNTOyTE4gJsNJ5X+BlE
# c5nbrJzlnc2ieRQeU0CKsWYDsG152gS8Mdiy3DFohOijev4m1j8wkrltCadPpSyz
# ttvXMNTtRUFHhZPaYZC5yD0TkCVgn5Cx82ScgubpyR8ROBQWow7MeBwt3xXE6aq1
# iCaXJRh4732/7mDABaszF8O8J4oEpGS8X9lp5ooA9lUiszriGXrmUwj6Z2bBOEuw
# /+asVoTdxQqzN/dG1VJKgfpXcu0rhv7WZTlKM6CHF2pfACgfa214uIyrbTDfnhr4
# GOHJyD6wwn70jK4zhnZu/MPRwjgPOo137CIisKabXhTKMi+pMkc2kxr+T7TyOWcb
# Jiyfat95yJAprp3wUgBY2M6p1oueCqKTuvzvEMa17UtTf0l6T0pJ/CLUUagNHBqo
# LwbBb4Z9fkgWcyX2Q/ww9IkcKPQfc5nsGpCKYQ/P21Hd05zPHBUMJPOaZTwDnMEG
# /E+0zLGDUD8AXZ0gsf7xWginwDKkCv8acWSME+bz5GlAr5I1hqZB6fZxtCZXQOgq
# a9NnFacZTFMdjjitfKM2IbzkmKoT5d6wd0K+VAO4tEOrrRCDKC67LkuVeXhXLxaQ
# S0a5d5yE3st6wYT8eu6Qi5Y2dVg7mQ==
# SIG # End signature block