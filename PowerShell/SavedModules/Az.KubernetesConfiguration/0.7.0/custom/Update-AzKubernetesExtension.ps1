
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
Patch an existing Kubernetes Cluster Extension.
.Description
Patch an existing Kubernetes Cluster Extension.
.Example
{{ Add code here }}
.Example
{{ Add code here }}

.Inputs
Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Models.IKubernetesConfigurationIdentity
.Outputs
Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Models.Api20221101.IExtension
.Notes
COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.

INPUTOBJECT <IKubernetesConfigurationIdentity>: Identity Parameter
  [ClusterName <String>]: The name of the kubernetes cluster.
  [ClusterResourceName <String>]: The Kubernetes cluster resource name - i.e. managedClusters, connectedClusters, provisionedClusters.
  [ClusterRp <String>]: The Kubernetes cluster RP - i.e. Microsoft.ContainerService, Microsoft.Kubernetes, Microsoft.HybridContainerService.
  [ExtensionName <String>]: Name of the Extension.
  [FluxConfigurationName <String>]: Name of the Flux Configuration.
  [Id <String>]: Resource identity path
  [OperationId <String>]: operation Id
  [ResourceGroupName <String>]: The name of the resource group. The name is case insensitive.
  [SourceControlConfigurationName <String>]: Name of the Source Control Configuration.
  [SubscriptionId <String>]: The ID of the target subscription.
.Link
https://learn.microsoft.com/powershell/module/az.kubernetesconfiguration/update-azkubernetesextension
#>
function Update-AzKubernetesExtension {
    [Alias('Update-AzK8sExtension')]
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Models.Api20221101.IExtension])]
    [CmdletBinding(DefaultParameterSetName = 'UpdateExpanded', PositionalBinding = $false, SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(ParameterSetName = 'UpdateExpanded', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Path')]
        [System.String]
        # The name of the kubernetes cluster.
        ${ClusterName},

        [Parameter(ParameterSetName = 'UpdateExpanded', Mandatory)]
        [ArgumentCompleter({ 'ManagedClusters', 'ConnectedClusters', 'ProvisionedClusters' })]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Path')]
        [System.String]
        # The Kubernetes cluster resource name - i.e.
        # managedClusters, connectedClusters, provisionedClusters.
        ${ClusterType},

        [Parameter(ParameterSetName = 'UpdateExpanded', Mandatory)]
        [Alias('ExtensionName')]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Path')]
        [System.String]
        # Name of the Extension.
        ${Name},

        [Parameter(ParameterSetName = 'UpdateExpanded', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Path')]
        [System.String]
        # The name of the resource group.
        # The name is case insensitive.
        ${ResourceGroupName},

        [Parameter(ParameterSetName = 'UpdateExpanded')]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Runtime.DefaultInfo(Script = '(Get-AzContext).Subscription.Id')]
        [System.String]
        # The ID of the target subscription.
        ${SubscriptionId},

        [Parameter(ParameterSetName = 'UpdateViaIdentityExpanded', Mandatory, ValueFromPipeline)]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Models.IKubernetesConfigurationIdentity]
        # Identity Parameter
        # To construct, see NOTES section for INPUTOBJECT properties and create a hash table.
        ${InputObject},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        # Flag to note if this extension participates in auto upgrade of minor version, or not.
        ${AutoUpgradeMinorVersion},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Runtime.Info(PossibleTypes = ([Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Models.Api20221101.IPatchExtensionPropertiesConfigurationProtectedSettings]))]
        [System.Collections.Hashtable]
        # Configuration settings that are sensitive, as name-value pairs for configuring this extension.
        ${ConfigurationProtectedSetting},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Runtime.Info(PossibleTypes = ([Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Models.Api20221101.IPatchExtensionPropertiesConfigurationSettings]))]
        [System.Collections.Hashtable]
        # Configuration settings, as name-value pairs for configuring this extension.
        ${ConfigurationSetting},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Body')]
        [System.String]
        # ReleaseTrain this extension participates in for auto-upgrade (e.g.
        # Stable, Preview, etc.) - only if autoUpgradeMinorVersion is 'true'.
        ${ReleaseTrain},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Body')]
        [System.String]
        # Version of the extension for this extension, if it is 'pinned' to a specific version.
        # autoUpgradeMinorVersion must be 'false'.
        ${Version},

        [Parameter()]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The DefaultProfile parameter is not functional.
        # Use the SubscriptionId parameter when available if executing the cmdlet against a different subscription.
        ${DefaultProfile},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Run the command as a job
        ${AsJob},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Run the command asynchronously
        ${NoWait},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.KubernetesConfiguration.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
    )

    process {
        try {
            $hasInputObject = $PSBoundParameters.Remove('InputObject')

            if ($hasInputObject) {
                $null = $PSBoundParameters.Add('InputObject', $InputObject)
            }
            else {
                if ($ClusterType -eq 'ManagedClusters') {
                    $PSBoundParameters.Add('ClusterRp', 'Microsoft.ContainerService')
                }
                elseif ($ClusterType -eq 'ConnectedClusters') {
                    $PSBoundParameters.Add('ClusterRp', 'Microsoft.Kubernetes')
                }
                elseif ($ClusterType -eq 'ProvisionedClusters') {
                    $PSBoundParameters.Add('ClusterRp', 'Microsoft.HybridContainerService')
                }
                else {
                    Write-Error "Please select ClusterType from the following three values: 'ManagedClusters', 'ConnectedClusters', 'ProvisionedClusters'"
                }
            }

            write-host "Azure Kubernetes Configuration Extension is being updated, need to wait a few minutes..."
            Az.KubernetesConfiguration.internal\Update-AzKubernetesExtension @PSBoundParameters
        }
        catch {
            throw
        }
    }
}

# SIG # Begin signature block
# MIInzgYJKoZIhvcNAQcCoIInvzCCJ7sCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCVomdgAk7nYcw2
# O351kcXesWNVuCMgpKL59tBDLq8xnKCCDYUwggYDMIID66ADAgECAhMzAAADTU6R
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
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGZ8wghmbAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAANNTpGmGiiweI8AAAAA
# A00wDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIIXO
# dpgW8dWSda8u0PF74maJfUZ8t7DkshGYeHwEUOaPMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAoA1tUHHZlZzUONZJB7jYauF9kmHaP0GDzei8
# UCbyj67e1vXVymqHrRjdd4kkDFFJPYj56o01XdoQsWRron/jD1JBZL9L3dvtp1bd
# xXxY2HPPxHT8du2UDfrMa3Yv28L92iN+3BwSJky61rTa4qhukQNOB5N+hWroq9aT
# dOczf983LYQh5hcfG6BDz7ZiZIppBMkzkrGx/R+7KUdAiwcj0XoY9M80ampRWBJP
# fGoBEuHAm7EuF5qOL4WAku5y17Mc2+YPs9d6BT3YZAnn2LA+bPilWnCjHfOKFnT+
# O6RXhian3nKS69/VFRmqsmLAJiVJyhaMSjeYDb/TBsXHPVOeo6GCFykwghclBgor
# BgEEAYI3AwMBMYIXFTCCFxEGCSqGSIb3DQEHAqCCFwIwghb+AgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFZBgsqhkiG9w0BCRABBKCCAUgEggFEMIIBQAIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCA/1WbELd5diDOzpi3BzuqAs5Mra3NXsPTT
# 7xuIJ4W0vQIGZJL70B4fGBMyMDIzMDYyOTA4MDQ1OC4zNTJaMASAAgH0oIHYpIHV
# MIHSMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQL
# EyRNaWNyb3NvZnQgSXJlbGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJjAkBgNVBAsT
# HVRoYWxlcyBUU1MgRVNOOjhENDEtNEJGNy1CM0I3MSUwIwYDVQQDExxNaWNyb3Nv
# ZnQgVGltZS1TdGFtcCBTZXJ2aWNloIIReDCCBycwggUPoAMCAQICEzMAAAGz/iXO
# KRsbihwAAQAAAbMwDQYJKoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# UENBIDIwMTAwHhcNMjIwOTIwMjAyMjAzWhcNMjMxMjE0MjAyMjAzWjCB0jELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9z
# b2Z0IElyZWxhbmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMg
# VFNTIEVTTjo4RDQxLTRCRjctQjNCNzElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgU2VydmljZTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALR8
# D7rmGICuLLBggrK9je3hJSpc9CTwbra/4Kb2eu5DZR6oCgFtCbigMuMcY31QlHr/
# 3kuWhHJ05n4+t377PHondDDbz/dU+q/NfXSKr1pwU2OLylY0sw531VZ1sWAdyD2E
# QCEzTdLD4KJbC6wmAConiJBAqvhDyXxJ0Nuvlk74rdVEvribsDZxzClWEa4v62EN
# j/HyiCUX3MZGnY/AhDyazfpchDWoP6cJgNCSXmHV9XsJgXJ4l+AYAgaqAvN8N+Ep
# N+0TErCgFOfwZV21cg7vgenOV48gmG/EMf0LvRAeirxPUu+jNB3JSFbW1WU8Z5xs
# LEoNle35icdET+G3wDNmcSXlQYs4t94IWR541+PsUTkq0kmdP4/1O4GD54ZsJ5eU
# nLaawXOxxT1fgbWb9VRg1Z4aspWpuL5gFwHa8UNMRxsKffor6qrXVVQ1OdJOS1Jl
# evhpZlssSCVDodMc30I3fWezny6tNOofpfaPrtwJ0ukXcLD1yT+89u4uQB/rqUK6
# J7HpkNu0fR5M5xGtOch9nyncO9alorxDfiEdb6zeqtCfcbo46u+/rfsslcGSuJFz
# lwENnU+vQ+JJ6jJRUrB+mr51zWUMiWTLDVmhLd66//Da/YBjA0Bi0hcYuO/WctfW
# k/3x87ALbtqHAbk6i1cJ8a2coieuj+9BASSjuXkBAgMBAAGjggFJMIIBRTAdBgNV
# HQ4EFgQU0BpdwlFnUgwYizhIIf9eBdyfw40wHwYDVR0jBBgwFoAUn6cVXQBeYl2D
# 9OXSZacbUzUZ6XIwXwYDVR0fBFgwVjBUoFKgUIZOaHR0cDovL3d3dy5taWNyb3Nv
# ZnQuY29tL3BraW9wcy9jcmwvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
# MDIwMTAoMSkuY3JsMGwGCCsGAQUFBwEBBGAwXjBcBggrBgEFBQcwAoZQaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNyb3NvZnQlMjBUaW1l
# LVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcnQwDAYDVR0TAQH/BAIwADAWBgNVHSUB
# Af8EDDAKBggrBgEFBQcDCDAOBgNVHQ8BAf8EBAMCB4AwDQYJKoZIhvcNAQELBQAD
# ggIBAFqGuzfOsAm4wAJfERmJgWW0tNLLPk6VYj53+hBmUICsqGgj9oXNNatgCq+j
# Ht03EiTzVhxteKWOLoTMx39cCcUJgDOQIH+GjuyjYVVdOCa9Fx6lI690/OBZFlz2
# DDuLpUBuo//v3e4Kns412mO3A6mDQkndxeJSsdBSbkKqccB7TC/muFOhzg39mfij
# GICc1kZziJE/6HdKCF8p9+vs1yGUR5uzkIo+68q/n5kNt33hdaQ234VEh0wPSE+d
# CgpKRqfxgYsBT/5tXa3e8TXyJlVoG9jwXBrKnSQb4+k19jHVB3wVUflnuANJRI9a
# zWwqYFKDbZWkfQ8tpNoFfKKFRHbWomcodP1bVn7kKWUCTA8YG2RlTBtvrs3CqY3m
# ADTJUig4ckN/MG6AIr8Q+ACmKBEm4OFpOcZMX0cxasopdgxM9aSdBusaJfZ3Itl3
# vC5C3RE97uURsVB2pvC+CnjFtt/PkY71l9UTHzUCO++M4hSGSzkfu+yBhXMGeBZq
# LXl9cffgYPcnRFjQT97Gb/bg4ssLIFuNJNNAJub+IvxhomRrtWuB4SN935oMfvG5
# cEeZ7eyYpBZ4DbkvN44ZvER0EHRakL2xb1rrsj7c8I+auEqYztUpDnuq6BxpBIUA
# lF3UDJ0SMG5xqW/9hLMWnaJCvIerEWTFm64jthAi0BDMwnCwMIIHcTCCBVmgAwIB
# AgITMwAAABXF52ueAptJmQAAAAAAFTANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0
# IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIwMTAwHhcNMjEwOTMwMTgyMjI1
# WhcNMzAwOTMwMTgzMjI1WjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDCC
# AiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAOThpkzntHIhC3miy9ckeb0O
# 1YLT/e6cBwfSqWxOdcjKNVf2AX9sSuDivbk+F2Az/1xPx2b3lVNxWuJ+Slr+uDZn
# hUYjDLWNE893MsAQGOhgfWpSg0S3po5GawcU88V29YZQ3MFEyHFcUTE3oAo4bo3t
# 1w/YJlN8OWECesSq/XJprx2rrPY2vjUmZNqYO7oaezOtgFt+jBAcnVL+tuhiJdxq
# D89d9P6OU8/W7IVWTe/dvI2k45GPsjksUZzpcGkNyjYtcI4xyDUoveO0hyTD4MmP
# frVUj9z6BVWYbWg7mka97aSueik3rMvrg0XnRm7KMtXAhjBcTyziYrLNueKNiOSW
# rAFKu75xqRdbZ2De+JKRHh09/SDPc31BmkZ1zcRfNN0Sidb9pSB9fvzZnkXftnIv
# 231fgLrbqn427DZM9ituqBJR6L8FA6PRc6ZNN3SUHDSCD/AQ8rdHGO2n6Jl8P0zb
# r17C89XYcz1DTsEzOUyOArxCaC4Q6oRRRuLRvWoYWmEBc8pnol7XKHYC4jMYcten
# IPDC+hIK12NvDMk2ZItboKaDIV1fMHSRlJTYuVD5C4lh8zYGNRiER9vcG9H9stQc
# xWv2XFJRXRLbJbqvUAV6bMURHXLvjflSxIUXk8A8FdsaN8cIFRg/eKtFtvUeh17a
# j54WcmnGrnu3tz5q4i6tAgMBAAGjggHdMIIB2TASBgkrBgEEAYI3FQEEBQIDAQAB
# MCMGCSsGAQQBgjcVAgQWBBQqp1L+ZMSavoKRPEY1Kc8Q/y8E7jAdBgNVHQ4EFgQU
# n6cVXQBeYl2D9OXSZacbUzUZ6XIwXAYDVR0gBFUwUzBRBgwrBgEEAYI3TIN9AQEw
# QTA/BggrBgEFBQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9E
# b2NzL1JlcG9zaXRvcnkuaHRtMBMGA1UdJQQMMAoGCCsGAQUFBwMIMBkGCSsGAQQB
# gjcUAgQMHgoAUwB1AGIAQwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/
# MB8GA1UdIwQYMBaAFNX2VsuP6KJcYmjRPZSQW9fOmhjEMFYGA1UdHwRPME0wS6BJ
# oEeGRWh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01p
# Y1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYB
# BQUHMAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljUm9v
# Q2VyQXV0XzIwMTAtMDYtMjMuY3J0MA0GCSqGSIb3DQEBCwUAA4ICAQCdVX38Kq3h
# LB9nATEkW+Geckv8qW/qXBS2Pk5HZHixBpOXPTEztTnXwnE2P9pkbHzQdTltuw8x
# 5MKP+2zRoZQYIu7pZmc6U03dmLq2HnjYNi6cqYJWAAOwBb6J6Gngugnue99qb74p
# y27YP0h1AdkY3m2CDPVtI1TkeFN1JFe53Z/zjj3G82jfZfakVqr3lbYoVSfQJL1A
# oL8ZthISEV09J+BAljis9/kpicO8F7BUhUKz/AyeixmJ5/ALaoHCgRlCGVJ1ijbC
# HcNhcy4sa3tuPywJeBTpkbKpW99Jo3QMvOyRgNI95ko+ZjtPu4b6MhrZlvSP9pEB
# 9s7GdP32THJvEKt1MMU0sHrYUP4KWN1APMdUbZ1jdEgssU5HLcEUBHG/ZPkkvnNt
# yo4JvbMBV0lUZNlz138eW0QBjloZkWsNn6Qo3GcZKCS6OEuabvshVGtqRRFHqfG3
# rsjoiV5PndLQTHa1V1QJsWkBRH58oWFsc/4Ku+xBZj1p/cvBQUl+fpO+y/g75LcV
# v7TOPqUxUYS8vwLBgqJ7Fx0ViY1w/ue10CgaiQuPNtq6TPmb/wrpNPgkNWcr4A24
# 5oyZ1uEi6vAnQj0llOZ0dFtq0Z4+7X6gMTN9vMvpe784cETRkPHIqzqKOghif9lw
# Y1NNje6CbaUFEMFxBmoQtB1VM1izoXBm8qGCAtQwggI9AgEBMIIBAKGB2KSB1TCB
# 0jELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
# ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMk
# TWljcm9zb2Z0IElyZWxhbmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1U
# aGFsZXMgVFNTIEVTTjo4RDQxLTRCRjctQjNCNzElMCMGA1UEAxMcTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgU2VydmljZaIjCgEBMAcGBSsOAwIaAxUAcYtE6JbdHhKlwkJe
# KoCV1JIkDmGggYMwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAN
# BgkqhkiG9w0BAQUFAAIFAOhHXVUwIhgPMjAyMzA2MjkwOTMxMDFaGA8yMDIzMDYz
# MDA5MzEwMVowdDA6BgorBgEEAYRZCgQBMSwwKjAKAgUA6EddVQIBADAHAgEAAgIX
# qTAHAgEAAgIQ2TAKAgUA6Eiu1QIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEE
# AYRZCgMCoAowCAIBAAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBBQUAA4GB
# AGC2ff6bLMGjIET/yGOgKutA8UFTtE4LtyPED8VF3Ueh5KjRflf1VU6GhB+3eG6E
# Hum1Pkms7p4HP/TnWOJvZDbLiUqXhnuqrU/uwVfoui3O2w+TXae/DAuQVpfAY0nr
# P9by72oW/CPidKvyZjr5YGTNNGQasa5GyrvKwOwWAOIGMYIEDTCCBAkCAQEwgZMw
# fDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
# ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMd
# TWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAGz/iXOKRsbihwAAQAA
# AbMwDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRAB
# BDAvBgkqhkiG9w0BCQQxIgQgA66+6TUcu/v95uVsAaHKEeGUpTLTEYb7RSl3WTTU
# X1wwgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCCGoTPVKhDSB7ZG0zJQZUM2
# jk/ll1zJGh6KOhn76k+/QjCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQI
# EwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
# ZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBD
# QSAyMDEwAhMzAAABs/4lzikbG4ocAAEAAAGzMCIEIMV8Fnftq2Cq7dlgaYe3gED/
# UHzv6tDWeWcA4f/WciDZMA0GCSqGSIb3DQEBCwUABIICAJ0Ser/pO/DUmC/EAFs3
# vzMCM22DzpJiR51Ihhty9gwtxim4gjVFls9+RIIJmu4G4rFl7DdnYkzyQnfQ9zbR
# wRJc4tH9/9hPVE2DhoAfqJ1ZT0jTAaeUGpJ8tLmIUaYif4r8rHUmeOmfaj9a8BkN
# a6Dw2Owrb8QPET55ooqB7cUSMFDyLBD3Wg2xvGkp6rRtK3N1epv2mVIGfTMQsEY3
# xt+CscRme+arf6rDf2FfCex9NOWzCciBfu8UABpWL4h5gQA6B6EwrRclcFyj1NO2
# LyihnqSkPUjXljTVuTv0CID31GxEB3lF7/E1xm9NHR/tNBs3kkVrp10wbN6mYGKe
# FEohsu70dQ2A7PwK4IB1Z5xjTxuQaWfixd46VHgcmaebFqm5mihfDwCkEomQ9vV3
# Sti81gipOSBSHfCGfYwxKIRJ5PozpPbj+kw6T/V243KNrbeMHIKLR8GSkD2bhMYr
# AWzi3lL3lxYmXOTC6hbSLp/zaVUKcUQM5zynvwAw4fp6vKjM8xQY59J0pHDprHF+
# YCjrHc/OicHFo2KcJY/Sk11Y3U24/dU7bSuBAm3YvolqSK6xMOHA3Ho+7PmYTN2K
# NcTWEwFKF4FOG21zvWcaY0reP7ptnNzVf2TfzyfpNKF99RX/0IPXv3gxPyT97JSZ
# 78RPAti++FMKWjxr6s67JQlV
# SIG # End signature block
