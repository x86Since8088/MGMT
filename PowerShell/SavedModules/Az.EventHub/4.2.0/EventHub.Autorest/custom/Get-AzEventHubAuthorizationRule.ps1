# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------

<#
.Synopsis
Gets an EventHub Authorization Rule
.Description
Gets an EventHub Authorization Rule
#>

function Get-AzEventHubAuthorizationRule{
	[OutputType([Microsoft.Azure.PowerShell.Cmdlets.EventHub.Models.Api202301Preview.IAuthorizationRule])]
    [CmdletBinding(DefaultParameterSetName = 'GetExpandedNamespace', PositionalBinding = $false, ConfirmImpact = 'Medium')]
	param(
        [Parameter(ParameterSetName = 'GetExpandedEntity', HelpMessage = "The name of the Authorization Rule")]
        [Parameter(ParameterSetName = 'GetExpandedNamespace', HelpMessage = "The name of the Authorization Rule")]
        [Parameter(ParameterSetName = 'GetExpandedAlias', HelpMessage = "The name of the Authorization Rule")]
        [Alias('AuthorizationRuleName')]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Path')]
        [System.String]
        # The name of the Authorization Rule.
        ${Name},

        [Parameter(ParameterSetName = 'GetExpandedAlias', Mandatory, HelpMessage = "The name of the Disaster Recovery alias")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Path')]
        [System.String]
        # The name of the Disaster Recovery alias
        ${AliasName},

        [Parameter(ParameterSetName = 'GetExpandedEntity', Mandatory, HelpMessage = "The name of the EventHub entity.")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Path')]
        [System.String]
        # The name of the EventHub entity.
        ${EventHubName},

        [Parameter(ParameterSetName = 'GetExpandedNamespace', Mandatory, HelpMessage = "The name of EventHub namespace")]
        [Parameter(ParameterSetName = 'GetExpandedEntity', Mandatory, HelpMessage = "The name of the EventHub namespace.")]
        [Parameter(ParameterSetName = 'GetExpandedAlias', Mandatory, HelpMessage = "The name of the EventHub namespace.")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Path')]
        [System.String]
        # The name of EventHub namespace
        ${NamespaceName},

        [Parameter(ParameterSetName = 'GetExpandedNamespace', Mandatory, HelpMessage = "The name of the resource group. The name is case insensitive.")]
        [Parameter(ParameterSetName = 'GetExpandedEntity', Mandatory, HelpMessage = "The name of the resource group. The name is case insensitive.")]
        [Parameter(ParameterSetName = 'GetExpandedAlias', Mandatory, HelpMessage = "The name of the resource group. The name is case insensitive.")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Path')]
        [System.String]
        # The name of the resource group.
        # The name is case insensitive.
        ${ResourceGroupName},

        [Parameter(ParameterSetName = 'GetExpandedNamespace', HelpMessage = "The ID of the target subscription.")]
        [Parameter(ParameterSetName = 'GetExpandedEntity', HelpMessage = "The ID of the target subscription.")]
        [Parameter(ParameterSetName = 'GetExpandedAlias', HelpMessage = "The ID of the target subscription.")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Runtime.DefaultInfo(Script = '(Get-AzContext).Subscription.Id')]
        [System.String[]]
        # The ID of the target subscription.
        ${SubscriptionId},

        [Parameter(ParameterSetName = 'GetViaIdentityExpanded', Mandatory, ValueFromPipeline, HelpMessage = "Identity parameter. To construct, see NOTES section for INPUTOBJECT properties and create a hash table.")]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Models.IEventHubIdentity]
        # Identity Parameter
        # To construct, see NOTES section for INPUTOBJECT properties and create a hash table.
        ${InputObject},
		
        [Parameter(HelpMessage = "The credentials, account, tenant, and subscription used for communication with Azure.")]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.EventHub.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
	)
	process{
		try{
            $null = $PSBoundParameters.Remove('WhatIf')
            $null = $PSBoundParameters.Remove('Confirm')

            if ($PSCmdlet.ParameterSetName -eq 'GetExpandedNamespace'){
                if(-not $PSBoundParameters.ContainsKey('Name')){
                    Az.EventHub.private\Get-AzEventHubNamespaceAuthorizationRule_List @PSBoundParameters
                }
                else{
                    Az.EventHub.private\Get-AzEventHubNamespaceAuthorizationRule_Get @PSBoundParameters
                }
            }

            elseif ($PSCmdlet.ParameterSetName -eq 'GetExpandedEntity'){
                if(-not $PSBoundParameters.ContainsKey('Name')){
                    Az.EventHub.private\Get-AzEventHubAuthorizationRule_List @PSBoundParameters
                }
                else{
                    Az.EventHub.private\Get-AzEventHubAuthorizationRule_Get @PSBoundParameters
                }
            }

            elseif ($PSCmdlet.ParameterSetName -eq 'GetExpandedAlias'){
                $null = $PSBoundParameters.Remove('AliasName')
                if(-not $PSBoundParameters.ContainsKey('Name')){
                    Az.EventHub.private\Get-AzEventHubDisasterRecoveryConfigAuthorizationRule_List -Alias $AliasName @PSBoundParameters
                }
                else{
                    Az.EventHub.private\Get-AzEventHubDisasterRecoveryConfigAuthorizationRule_Get -Alias $AliasName @PSBoundParameters
                }
            }

            elseif ($PSCmdlet.ParameterSetName -eq 'GetViaIdentityExpanded'){
                if($InputObject.Id -ne $null){
                    $ResourceHashTable = ParseResourceId -ResourceId $InputObject.Id
                }
                else{
                    $ResourceHashTable = ParseResourceId -ResourceId $InputObject
                }

                if ($ResourceHashTable['EventHubName'] -ne $null){
                    Az.EventHub.private\Get-AzEventHubAuthorizationRule_GetViaIdentity @PSBoundParameters
                }
                elseif ($ResourceHashTable['AliasName'] -ne $null){
                    Az.EventHub.private\Get-AzEventHubDisasterRecoveryConfigAuthorizationRule_GetViaIdentity @PSBoundParameters
                }
                elseif ($ResourceHashTable['NamespaceName'] -ne $null){
                    Az.EventHub.private\Get-AzEventHubNamespaceAuthorizationRule_GetViaIdentity @PSBoundParameters
                }
                else{
                    throw 'Invalid -InputObject'
                }
            }
		}
		catch{
			throw
		}
	}
}


function ParseResourceId{
    param (
        [string]$ResourceId
    )
    $array = $resourceID.ToLower().Split('/')
    $indexSubscription = 0..($array.Length -1) | where {$array[$_] -eq 'subscriptions'}
    $indexResourceGroup = 0..($array.Length -1) | where {$array[$_] -eq 'resourcegroups'}
    $indexNamespace = 0..($array.Length -1) | where {$array[$_] -eq 'namespaces'}
    $indexEventHub = 0..($array.Length -1) | where {$array[$_] -eq 'eventhubs'}
    $indexAlias = 0..($array.Length -1) | where {$array[$_] -eq 'disasterrecoveryconfigs'}
    $indexAuthRule = 0..($array.Length -1) | where {$array[$_] -eq 'authorizationrules'}
    
    if (($indexResourceGroup+1) > $array.Length){
        throw 'Invalid -InputObject Id'
    }
    if (($indexNamespace+1) > $array.Length){
        throw 'Invalid -InputObject Id'
    }

    $result = @{
        'ResourceGroupName' = $array.get($indexResourceGroup+1)
        'NamespaceName' = $array.get($indexNamespace+1)
    }

    if ($indexEventHub -ne $null){
        if (($indexEventHub+1) > $array.Length){
            throw 'Invalid -InputObject Id'
        }
        else{
            $result.add('EventHubName', $array.get($indexEventHub+1))
        }
    }

    if ($indexSubscription -ne $null){
        if (($indexSubscription+1) > $array.Length){
            throw 'Invalid -InputObject Id'
        }
        else{
            $result.add('SubscriptionName', $array.get($indexSubscription+1))
        }
    }

    if ($indexAuthRule -ne $null){
        if (($indexAuthRule+1) > $array.Length){
            throw 'Invalid -InputObject Id'
        }
        else{
            $result.add('AuthorizationRuleName', $array.get($indexAuthRule+1))
        }
    }

    if ($indexAlias -ne $null){
        if (($indexAlias+1) > $array.Length){
            throw 'Invalid -InputObject Id'
        }
        else{
            $result.add('AliasName', $array.get($indexAlias+1))
        }
    }

    return $result
}

# SIG # Begin signature block
# MIIoPAYJKoZIhvcNAQcCoIIoLTCCKCkCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCC2g5eaV1BftuWZ
# doAYrOcKNBfuQpfbaH2BsdyG2yVeMqCCDYUwggYDMIID66ADAgECAhMzAAADTU6R
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
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGg0wghoJAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAANNTpGmGiiweI8AAAAA
# A00wDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEILgk
# UsXLsAQCYemuQ80dQUE0VVc9TriTWHXw8DqpOnDLMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAM1lMdjbRUkT+c5++bRf0fC17PRLMWryVvf89
# gXxlWUsMcvhzN+eVbJJ/Uk9LuMGlwj8FYe9SypVIHm8cJ+wVrCpn8gKZEMQAvW56
# CrjUH3NsGtNTZrAaTfj9rAIiDs3iAus/vugZ+KNW6V1Tc5yiNky4qB9c1tvQvdwW
# QwyI8IIlbwLfwdqUn+nCJuW0rsujZOxOjgd99tdGv6qKNqRW+SQP22+m5Fnqs0Jy
# eEurZ6+6al46sUVV2r3pMQyyuYe0uuQZRadGASNugzi8pRfsHEyREjVfNW2mb7Sa
# aUxRXGkEJSXBVY45IgqENiQutzQ/Q3ybSC8GZvTDQzELmxdiXqGCF5cwgheTBgor
# BgEEAYI3AwMBMYIXgzCCF38GCSqGSIb3DQEHAqCCF3AwghdsAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFSBgsqhkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCDfZ2D7jbCh1HKab0eD5bGwdvU6TV6uyb6P
# BFPhcIFGmAIGZSivkvSCGBMyMDIzMTExMDA0MjUyMC4wMTZaMASAAgH0oIHRpIHO
# MIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQL
# ExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxk
# IFRTUyBFU046RTAwMi0wNUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1l
# LVN0YW1wIFNlcnZpY2WgghHtMIIHIDCCBQigAwIBAgITMwAAAdmcXAWSsINrPgAB
# AAAB2TANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MDAeFw0yMzA2MDExODMyNThaFw0yNDAyMDExODMyNThaMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046RTAwMi0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Uw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDV6SDN1rgY2305yLdCdUNv
# HCEE4Z0ucD6CKvL5lA7HM81SMkW36RU77UaBL9PScviqfVzE2r2pRbRMtDBMwEx1
# iaizV2EZsNGGuzeR3XNYObQvJVLaCiBktAZdq75BNFIil+SfdpXgKzVQZiDBJDN5
# 0WCADNrrb48Z4Z7/KvyzaD4Gb+aZeCioB2Gg1m53d+6pUTBc3WO5xHZi/rrI/Xdn
# hiE6/bspjpU5aufClIDx0QDq1QRw04adrKhcDWyGL3SaBp/hjN+4JJU7KzvsKWZV
# dTuXPojnaTwWcHdEGfzxiaF30zd8SY4YRUcMGPOQORH1IPwkwwlqQkc0HBkJCQzi
# aXY/IpgMRw/XP4Uv+JBJ8RZGKZN1zRPWT9d5vHGUSmX3m77RKoCfkgSJifIiQi6F
# c0OYKS6gZOA7nd4t+liArr9niqeC/UcNOuVrcVC4CbkwfJ2eHkaWh18sUt3UD8QH
# YLQwn95P+Hm8PZJigr1SRLcsm8pOPee7PBbndI/VeKJsmQdjek2aFO9VGnUtzDDB
# owlhXshswZMMkLJ/4jUzQmUBfm+JAH1516E+G02wS7NgzMwmpHWCmAaFdd7DyJIq
# Ga6bcZrR7QALdkwIhVQDgzZAuNxqwvh4Ia4ZI5Voyj4b7zWAhmurpwpMpijz+iee
# Wwf6ZdmysRjR/yZ6UXmGawIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFBw6wSlTZ6gF
# Xl05w/s3Ga1f51wnMB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8G
# A1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMv
# Y3JsL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBs
# BggrBgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0
# LmNvbS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
# MDIwMTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUH
# AwgwDgYDVR0PAQH/BAQDAgeAMA0GCSqGSIb3DQEBCwUAA4ICAQAqNtVYLO61TMuI
# anC7clt0i+XRRbHwnwNo05Q3s4ppFtd4nCmB/TJPDJ6uvEryxs0vw5Y+jQwUiKnh
# l2VGGwIq0pWDIuaW4ppMV1pYQfJ6dtBGkRiTP1eKVvARYZMRaITe9ZhwJJnYP83p
# MxHCxaEsZC4ilY3/55dqd4ZXTCz/cpG5anmDartnWmgysygNstTwbWJJRj85gYRk
# jxi/nxKAiEFxl6GfkcnXVy8DRFQj1d3AiqsePoeIzxu1iuAJRwDrfe4NnKHqoTgW
# sv7eCWJnWjWWRt7RRGrpvzLQo/BxUb8i49UwRg9G5bxpd5Su1b224Gv6G1HRU+qJ
# HB1zoe41D2r/ic2BPousV9neYK5qI5PHLshAn6YTQllbV9pCbOUvZO0dtdwp5HH2
# fw6ofJNwKcPElaqkEcxvrhhRWqwNgaEVTyIV4jMc8jPbx2Nh9zAztnb9NfnDFOE+
# /gF8cZqTa/T65TGNP3uMiP3gr8nIXQ2IRwMVUoLmGu2qfmhDoews3dcvk6s1aA6m
# XHw+MANEIDKKjw3i2G6JtZkEemu1OXtskg/tGnfywaMgq5CauU9b6enTtA+UE+GK
# nmiQW6YUHPhBI0L2QG76TRBre5PpNVHiyc/01bjUEMpeaB+InAH4nDxYXx18wbJE
# +e/IbMv0147EFL792dELF0XwqqcU0TCCB3EwggVZoAMCAQICEzMAAAAVxedrngKb
# SZkAAAAAABUwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQI
# EwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
# ZnQgQ29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmlj
# YXRlIEF1dGhvcml0eSAyMDEwMB4XDTIxMDkzMDE4MjIyNVoXDTMwMDkzMDE4MzIy
# NVowfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
# B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UE
# AxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQDk4aZM57RyIQt5osvXJHm9DtWC0/3unAcH0qlsTnXI
# yjVX9gF/bErg4r25PhdgM/9cT8dm95VTcVrifkpa/rg2Z4VGIwy1jRPPdzLAEBjo
# YH1qUoNEt6aORmsHFPPFdvWGUNzBRMhxXFExN6AKOG6N7dcP2CZTfDlhAnrEqv1y
# aa8dq6z2Nr41JmTamDu6GnszrYBbfowQHJ1S/rboYiXcag/PXfT+jlPP1uyFVk3v
# 3byNpOORj7I5LFGc6XBpDco2LXCOMcg1KL3jtIckw+DJj361VI/c+gVVmG1oO5pG
# ve2krnopN6zL64NF50ZuyjLVwIYwXE8s4mKyzbnijYjklqwBSru+cakXW2dg3viS
# kR4dPf0gz3N9QZpGdc3EXzTdEonW/aUgfX782Z5F37ZyL9t9X4C626p+Nuw2TPYr
# bqgSUei/BQOj0XOmTTd0lBw0gg/wEPK3Rxjtp+iZfD9M269ewvPV2HM9Q07BMzlM
# jgK8QmguEOqEUUbi0b1qGFphAXPKZ6Je1yh2AuIzGHLXpyDwwvoSCtdjbwzJNmSL
# W6CmgyFdXzB0kZSU2LlQ+QuJYfM2BjUYhEfb3BvR/bLUHMVr9lxSUV0S2yW6r1AF
# emzFER1y7435UsSFF5PAPBXbGjfHCBUYP3irRbb1Hode2o+eFnJpxq57t7c+auIu
# rQIDAQABo4IB3TCCAdkwEgYJKwYBBAGCNxUBBAUCAwEAATAjBgkrBgEEAYI3FQIE
# FgQUKqdS/mTEmr6CkTxGNSnPEP8vBO4wHQYDVR0OBBYEFJ+nFV0AXmJdg/Tl0mWn
# G1M1GelyMFwGA1UdIARVMFMwUQYMKwYBBAGCN0yDfQEBMEEwPwYIKwYBBQUHAgEW
# M2h0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvRG9jcy9SZXBvc2l0b3J5
# Lmh0bTATBgNVHSUEDDAKBggrBgEFBQcDCDAZBgkrBgEEAYI3FAIEDB4KAFMAdQBi
# AEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV
# 9lbLj+iiXGJo0T2UkFvXzpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3Js
# Lm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAx
# MC0wNi0yMy5jcmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2
# LTIzLmNydDANBgkqhkiG9w0BAQsFAAOCAgEAnVV9/Cqt4SwfZwExJFvhnnJL/Klv
# 6lwUtj5OR2R4sQaTlz0xM7U518JxNj/aZGx80HU5bbsPMeTCj/ts0aGUGCLu6WZn
# OlNN3Zi6th542DYunKmCVgADsAW+iehp4LoJ7nvfam++Kctu2D9IdQHZGN5tggz1
# bSNU5HhTdSRXud2f8449xvNo32X2pFaq95W2KFUn0CS9QKC/GbYSEhFdPSfgQJY4
# rPf5KYnDvBewVIVCs/wMnosZiefwC2qBwoEZQhlSdYo2wh3DYXMuLGt7bj8sCXgU
# 6ZGyqVvfSaN0DLzskYDSPeZKPmY7T7uG+jIa2Zb0j/aRAfbOxnT99kxybxCrdTDF
# NLB62FD+CljdQDzHVG2dY3RILLFORy3BFARxv2T5JL5zbcqOCb2zAVdJVGTZc9d/
# HltEAY5aGZFrDZ+kKNxnGSgkujhLmm77IVRrakURR6nxt67I6IleT53S0Ex2tVdU
# CbFpAUR+fKFhbHP+CrvsQWY9af3LwUFJfn6Tvsv4O+S3Fb+0zj6lMVGEvL8CwYKi
# excdFYmNcP7ntdAoGokLjzbaukz5m/8K6TT4JDVnK+ANuOaMmdbhIurwJ0I9JZTm
# dHRbatGePu1+oDEzfbzL6Xu/OHBE0ZDxyKs6ijoIYn/ZcGNTTY3ugm2lBRDBcQZq
# ELQdVTNYs6FwZvKhggNQMIICOAIBATCB+aGB0aSBzjCByzELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJp
# Y2EgT3BlcmF0aW9uczEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOkUwMDItMDVF
# MC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMK
# AQEwBwYFKw4DAhoDFQDiHEW6Ca3n5BgZV/tQ/fCR09Tf96CBgzCBgKR+MHwxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6PgVBzAi
# GA8yMDIzMTExMDAyMzM0M1oYDzIwMjMxMTExMDIzMzQzWjB3MD0GCisGAQQBhFkK
# BAExLzAtMAoCBQDo+BUHAgEAMAoCAQACAi5fAgH/MAcCAQACAhRoMAoCBQDo+WaH
# AgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSCh
# CjAIAgEAAgMBhqAwDQYJKoZIhvcNAQELBQADggEBAHjnpiUhsMDpMV2CnET9NEVK
# fX57gJaGpYPdq+VR5ZFZNwxNjmJbkMkNRJiuYuLmds1uNUD1fowJGDa6+NgCkvOY
# 5bmShLfGLDwP9wk2ITSFjFailT7NyajWpFSkd59D6ZwBwpskamsQ0bcZcedpfLip
# nK9iMIDrBRc7kCU/jGLSySbq2kuhFDCEUQiJwTnGtMBbU/XsT2JF4Wv61saIF4D6
# TixdJHJJ9gmejorLwd/TF5+xg15EQ/q9JsaZYbFF+udDWLQaSw9+bOV+Nq8+wzXK
# dS6mvvBHz7XV7O5K4ybi1XapnxbNI1Ef4tC2ILpf/PwZYGEQO//fRlH7F1g7QQ0x
# ggQNMIIECQIBATCBkzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
# bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
# aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAA
# AdmcXAWSsINrPgABAAAB2TANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkD
# MQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCC8+xVoM6vuL8zIK9Q6ml0m
# 6w0CjtKzSQvMhgjOU9891zCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIJ+g
# FbItOm/UMDAnETzbJe0u0DWd2Mgpgb0ScbQgB3nzMIGYMIGApH4wfDELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAHZnFwFkrCDaz4AAQAAAdkwIgQg40tG
# 4hY9//EO0J52qbgnMed+EUwK7+0+B1Rn38opSiYwDQYJKoZIhvcNAQELBQAEggIA
# Ni3IMIhDR2GBWJWsVn25FlhnQkUBIcWb0E1EMlkjX0+REYP2McoUSGgAIv+Jq8Qs
# ckSouaMJsHLowfsewxvTHPv/2giGbcPw1Ox+acBCGk6UUkcXH8QNPRP2WTnVEVCQ
# Dp9Niy8hI9OgBmvN4aqpcmqvRCWn6NSNouEAeWJMIWQ/YcEriOrFGE93JHmazzyM
# GuIz7o6+LPRk5e1U+8VernNDS0K8NePtPplVNjDPmJmyW3Lg9FDKATELowfUalwB
# McbT6dkBh1e3Js+CNGvAvWgl6EU459XSHbjwOMOSuVaviqXaC1WdbCJUtV6ZFteI
# RZH+j6iahPrsA+9SQxYqhx4zby68bjFns4AlIGTXWxmuubMVgxUat47DqurClTaO
# EU9qLXbTqJalYiRehYEMAyvmFuVR8EDuxR1LCTaKMIgeJ0NtXPQKSfZnQVyEyrKp
# 76VOE7IBMJ5AMSfx40yQ+RZe3Tllo5gUp63umZ8EfbuXmxvYXRBqOlaJGEM8ULof
# x0uWsIUXavqnhiOHESYq4MYBejmDehaB1+MtZiH2mmLRzLYQTBLMhEQDXWqEv/m6
# k7hrTSKNR3eRNk51yKHT2P8CWaO3sAySeDXAh0FYHftDx0HBH6tTYPFQ+BsAvswI
# m2u+xvkAsxLdjlJKUx9Fyy1FdXmtgwehJF2UiMnDVq8=
# SIG # End signature block
