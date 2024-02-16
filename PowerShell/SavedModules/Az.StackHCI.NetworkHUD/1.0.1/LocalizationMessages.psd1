ConvertFrom-StringData @'
###PSLOC

###ManagementModuleMessages
networkhud_management_feature_not_installed = Feature {0} is not installed on computer {1}.
networkhud_management_cluster_module_not_installed = Module {0} is not installed.
networkhud_management_remote_node_cluster = Remote Node {0} is part of the Cluster. Use parameter {1} instead.
networkhud_management_service_start_failure = Failed to start service {0} on computer: {1}. Please check {2} event log channel for more details.
networkhud_management_service_stop_failure = Failed to stop service {0} on computer: {1}. Please check {2} event log channel for more details.
networkhud_management_install_failure = Failed to install service and module {0} on computer: {1}. 
###ManagementModuleMessages

###Prerequisitescript
networkhud_prerequisite_req_lldp = Network HUD requires LLDP RSAT tools to be installed.\n\nTo resolve this issue, run the following command: Install-WindowsFeature -Name RSAT-DataCenterBridging-LLDP-Tools.
networkhud_prerequisite_req_hyperv = Network HUD requires Hyper-V and Hyper-V-PowerShell to be installed.\n\nTo resolve this issue, run the following command: Install-WindowsFeature -Name Hyper-V -IncludeManagementTools.
networkhud_prerequisite_req_atc = Network HUD requires NetworkATC to be installed.\n\nTo resolve this issue, run the following command: Install-WindowsFeature -Name NetworkATC.
networkhud_prerequisite_req_cluster = Network HUD requires Failover-Clustering to be installed.\n\nTo resolve this issue, run the following command: Install-WindowsFeature -Name Failover-Clustering -IncludeManagementTools.
networkhud_prerequisite_req_dcb = Network HUD requires Data-Center-Bridging to be installed.\n\nTo resolve this issue, run the following command: Install-WindowsFeature -Name Data-Center-Bridging -IncludeManagementTools.
networkhud_prerequisite_req_dcbmodule = This machine must have the DataCenterBridging Module version 2021.6.23.36 or greater installed for Network HUD.\n\nTo resolve this issue, run the following command: Install-Module -Name DataCenterBridging -Force.\n\nIf this system is not connected to the internet, from an internet-connected system, run Save-Module DataCenterBridging -Path c:\\folderpath then move the module to the disconnected system under the 'C:\\Program Files\\WindowsPowerShell\\Modules' folder.
networkhud_prerequisite_req_netstack = This machine must have the Test-NetStack Module version 2021.1.1.1 or greater installed for Network HUD.\n\nTo resolve this issue, run the following command: Install-Module -Name Test-NetStack -Force.\n\nIf this system is not connected to the internet, from an internet-connected system, run Save-Module DataCenterBridging -Path c:\\folderpath then move the module to the disconnected system under the 'C:\\Program Files\\WindowsPowerShell\\Modules' folder.
networkhud_prerequisite_req_nocluster = The local machine is not a member of a failover cluster. To resolve this issue, join the machine to a failover cluster.
networkhud_prerequisite_req_noserviceacc = Network HUD is using the localsystem account. Change to an account with cluster permissions.
networkhud_prerequisite_req_fail = Network HUD has stopped due to a missing prerequisite. Review the prior errors in the Network HUD log, then try again.
###Prerequisitescript

###WatchLinkState
networkhud_watchlinkstate_linkstatechange = The following interface changed state to DOWN:\nName: [{0}]\nInterfaceDescription: [{1}]\nInterfaceIndex: [{2}]\nMacAddress: [{3}]\nState: [{4}]\nLinkSpeed: [{5}]\n\nIf this continues, Network HUD will attempt to take corrective action. Please investigate the physical adapter, cable, and switchports.
networkhud_watchlinkstate_detectedflap = The Network HUD service has determined that adapter [{0}] is unstable due to frequent disconnect. Remediation actions may be attempted to improve stability. Actions will be indicated in this log.
networkhud_watchlinkstate_notenoughadapters = The Network HUD service has determined that [{0}] has reached a threshold of {1} disconnections inside {2} minute. However, there are not enough usable adapters to take remediation actions. An administrator should take immediate action to identify whether the problem is the adapter, the cable, or the switchport.\n\nTo convert this event data back to readable text, use the following sequence of commands:\n    1) `$Event = Get-EventLog -LogName 'NetworkHUD' -Source 'Network-HUD-Service' -InstanceId 1015 -EntryType Error | Select -First 1\n    2) [System.Text.Encoding]::Unicode.GetString(`$Event.Data) | ConvertFrom-Json
networkhud_watchlinkstate_disable = The Network HUD service has determined that [{0}] has reached a threshold of {1} disconnections inside {2} minute. The adapter will be removed from Intent {3} in order to improve system stability. 
networkhud_watchlinkstate_faultdescription = The Network HUD service has determined that [{0}] in the [{1}] intent is unstable due to too many disconnections.
networkhud_watchlinkstate_faultAction = The Network HUD service has determined that [{0}] has reached a threshold of {1} disconnections inside {2} minutes. The adapter may be removed from the [{3}] intent to improve system stability. An administrator should take immediate action to identify whether the problem is the adapter, cable, or the switchport and replace the malfunctioning hardware.
###WatchLinkState

###MeasureResettingNic
networkhud_measureresettingnic_detectedflap = The Network HUD service has determined that adapter [{0}] is unstable due to frequent reset. Remediation actions may be attempted to improve stability. Actions will be indicated in this log.
networkhud_measureresettingnic_notenoughadapters = The Network HUD service has determined that [{0}] has reached a threshold of {1} resets inside {2} minute. However, there are not enough usable adapters to take remediation actions. An administrator should take immediate action to identify whether the problem is the adapter, the cable, or the switchport.
networkhud_measureresettingnic_disable = The Network HUD service has determined that [{0}] has reached a threshold of {1} resets inside {2} minute. The adapter will be disabled in order to improve system stability.
networkhud_measureresettingnic_FaultDescription = A ResettingNIC fault has been detected on the following NIC : [{0}]"
networkhud_measureresettingnic_FaultAction = The Network HUD service has determined that [{0}] has reached a threshold of {1} resets inside {2} minute. The adapter may be disabled in order to improve system stability. An administrator should take immediate action to identify whether the problem is the adapter, the cable, or the switchport.
###MeasureResettingNic

###DriverValidation
networkhud_DriverValidation_InboxDriver = The Network HUD service has determined that adapter [{0}] in the Intent named [{1}] is using an inbox driver. Inbox drivers are not supported.
networkhud_DriverValidation_FailAge = The Network HUD service has determined that the [{0}] driver for adapter [{1}] in the Intent named [{2}] is more than 1 year old. The listed date of the [{0}] driver is [{3}]
networkhud_DriverValidation_WarnAge = The Network HUD service has determined that the [{0}] driver for adapter [{1}] in the Intent named [{2}] is more than 6 months old.The listed date of the [{0}] driver is [{3}]
networkhud_DriverValidation_InboxDriverFaultDescription = A driver fault has been detected on the following adapter(s) [{0}] in the Intent named [{1}]. Inbox drivers are not supported.
networkhud_DriverValidation_InboxDriverFaultAction = Contact your the vendor and install an updated driver.
networkhud_DriverValidation_FailAgeFaultDescription = The [{0}] driver used for the adapter [{1}] in the Intent named [{2}] is over one year old. Out of date drivers reduce system stability and performance. The listed date of the [{0}] driver is [{3}]
networkhud_DriverValidation_FailAgeFaultAction = Contact your the vendor immediately and obtain an updated driver for the adapter or replace the device.
networkhud_DriverValidation_WarnAgeFaultDescription = The [{0}] driver used for the adapter [{1}] in the Intent named [{2}] is over six months old. Out of date drivers reduce system stability and performance. The listed date of the [{0}] driver is [{3}]
networkhud_DriverValidation_WarnAgeFaultAction = Contact your the vendor and obtain an updated driver for the adapter or replace the device.
###DriverValidation

###InfrastructureValidation
networkhud_InfrastructureValidation_MissingIntentTypes = The Network HUD service has determined that the cluster is not configured with the following Network ATC intent types: {0}
networkhud_InfrastructureValidation_MissingIntentTypesFaultDescription = The Network HUD service has determined that the cluster is not configured with the following Network ATC intent types: {0}
networkhud_InfrastructureValidation_MissingIntentTypesFaultAction = Review the Network ATC documentation and add the {0} intent type(s) to the cluster.
###InfrastructureValidation

###PCIE
networkhud_PCIE_missinginfo = The Network HUD service has determined that adapter(s) [{0}] in the Intent named [{1}] does not have PCIE information
networkhud_PCIE_insufficient = The Network HUD service has determined that adapter [{0}] in the Intent named [{1}] does not have sufficient PCIE bandwidth to reach its maximum linkspeed. The detected linkspeed of this adapter is [{2}] but the available PCIe bandwidth is [{3}]. This can lead to stability problems and should be remediated. To address this issue, move the adapter to a slot with enough PCIe bandwidth or limit the linkspeed of the adapter.
networkhud_PCIE_slotinsufficient = The Network HUD service has determined that the following adapter(s) [{0}] in the Intent named [{1}] in PCIe slot [{2}] do not have sufficient PCIE bandwidth to reach maximum linkspeed on all adapters simultaneously. The detected linkspeed of the adapter(s) is [{3}] Gbps but the available PCIe bandwidth is [{4}] Gbps. This can lead to stability problems and should be remediated. To address this issue, move the adapter(s) to a PCIe slot with enough PCIe bandwidth or limit the linkspeed of the adapter(s).
networkhud_PCIE_disableadapters = The Network HUD service has determined that adapter(s) [{0}] in the Intent named [{1}] does not have sufficient PCIE bandwidth. The adapter will be disabled in order to improve system stability.
networkhud_PCIE_notenoughadapters = The Network HUD service has determined that adapter(s) [{0}] in the Intent named [{1}] does not have sufficient PCIE bandwidth. However, there are not enough usable adapters to take remediation actions. An administrator should take immediate action to identify the problem.
networkhud_PCIE_FaultDescription = A PCIE fault has been detected on the following adapter(s) [{0}] in the Intent named [{1}].
networkhud_PCIE_FaultAction = The Network HUD service has determined that adapter(s) [{0}] in the Intent named [{1}] does not have sufficient PCIE bandwidth.
networkhud_PCIE_SlotFaultDescription = The Network HUD service has determined that adapter(s) [{0}] in the Intent named [{1}] in slot [{2}] does not have sufficient PCIE bandwidth.
networkhud_PCIE_SlotFaultAction = To address this issue, move the adapter(s) [{0}] in the Intent named [{1}] to a PCIe slot with enough PCIe bandwidth or limit the linkspeed of the adapter(s).
###PCIE

###PSLOC
'@
# SIG # Begin signature block
# MIInqgYJKoZIhvcNAQcCoIInmzCCJ5cCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCC8ewPGwMHJh0hR
# 6tfBAvvYFnX8+MZbKWDE9hNfk8Ud66CCDYEwggX/MIID56ADAgECAhMzAAACzI61
# lqa90clOAAAAAALMMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjIwNTEyMjA0NjAxWhcNMjMwNTExMjA0NjAxWjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQCiTbHs68bADvNud97NzcdP0zh0mRr4VpDv68KobjQFybVAuVgiINf9aG2zQtWK
# No6+2X2Ix65KGcBXuZyEi0oBUAAGnIe5O5q/Y0Ij0WwDyMWaVad2Te4r1Eic3HWH
# UfiiNjF0ETHKg3qa7DCyUqwsR9q5SaXuHlYCwM+m59Nl3jKnYnKLLfzhl13wImV9
# DF8N76ANkRyK6BYoc9I6hHF2MCTQYWbQ4fXgzKhgzj4zeabWgfu+ZJCiFLkogvc0
# RVb0x3DtyxMbl/3e45Eu+sn/x6EVwbJZVvtQYcmdGF1yAYht+JnNmWwAxL8MgHMz
# xEcoY1Q1JtstiY3+u3ulGMvhAgMBAAGjggF+MIIBejAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUiLhHjTKWzIqVIp+sM2rOHH11rfQw
# UAYDVR0RBEkwR6RFMEMxKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1
# ZXJ0byBSaWNvMRYwFAYDVQQFEw0yMzAwMTIrNDcwNTI5MB8GA1UdIwQYMBaAFEhu
# ZOVQBdOCqhc3NyK1bajKdQKVMFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY0NvZFNpZ1BDQTIwMTFfMjAxMS0w
# Ny0wOC5jcmwwYQYIKwYBBQUHAQEEVTBTMFEGCCsGAQUFBzAChkVodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRzL01pY0NvZFNpZ1BDQTIwMTFfMjAx
# MS0wNy0wOC5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAgEAeA8D
# sOAHS53MTIHYu8bbXrO6yQtRD6JfyMWeXaLu3Nc8PDnFc1efYq/F3MGx/aiwNbcs
# J2MU7BKNWTP5JQVBA2GNIeR3mScXqnOsv1XqXPvZeISDVWLaBQzceItdIwgo6B13
# vxlkkSYMvB0Dr3Yw7/W9U4Wk5K/RDOnIGvmKqKi3AwyxlV1mpefy729FKaWT7edB
# d3I4+hldMY8sdfDPjWRtJzjMjXZs41OUOwtHccPazjjC7KndzvZHx/0VWL8n0NT/
# 404vftnXKifMZkS4p2sB3oK+6kCcsyWsgS/3eYGw1Fe4MOnin1RhgrW1rHPODJTG
# AUOmW4wc3Q6KKr2zve7sMDZe9tfylonPwhk971rX8qGw6LkrGFv31IJeJSe/aUbG
# dUDPkbrABbVvPElgoj5eP3REqx5jdfkQw7tOdWkhn0jDUh2uQen9Atj3RkJyHuR0
# GUsJVMWFJdkIO/gFwzoOGlHNsmxvpANV86/1qgb1oZXdrURpzJp53MsDaBY/pxOc
# J0Cvg6uWs3kQWgKk5aBzvsX95BzdItHTpVMtVPW4q41XEvbFmUP1n6oL5rdNdrTM
# j/HXMRk1KCksax1Vxo3qv+13cCsZAaQNaIAvt5LvkshZkDZIP//0Hnq7NnWeYR3z
# 4oFiw9N2n3bb9baQWuWPswG0Dq9YT9kb+Cs4qIIwggd6MIIFYqADAgECAgphDpDS
# AAAAAAADMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0
# ZSBBdXRob3JpdHkgMjAxMTAeFw0xMTA3MDgyMDU5MDlaFw0yNjA3MDgyMTA5MDla
# MH4xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMT
# H01pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTEwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQCr8PpyEBwurdhuqoIQTTS68rZYIZ9CGypr6VpQqrgG
# OBoESbp/wwwe3TdrxhLYC/A4wpkGsMg51QEUMULTiQ15ZId+lGAkbK+eSZzpaF7S
# 35tTsgosw6/ZqSuuegmv15ZZymAaBelmdugyUiYSL+erCFDPs0S3XdjELgN1q2jz
# y23zOlyhFvRGuuA4ZKxuZDV4pqBjDy3TQJP4494HDdVceaVJKecNvqATd76UPe/7
# 4ytaEB9NViiienLgEjq3SV7Y7e1DkYPZe7J7hhvZPrGMXeiJT4Qa8qEvWeSQOy2u
# M1jFtz7+MtOzAz2xsq+SOH7SnYAs9U5WkSE1JcM5bmR/U7qcD60ZI4TL9LoDho33
# X/DQUr+MlIe8wCF0JV8YKLbMJyg4JZg5SjbPfLGSrhwjp6lm7GEfauEoSZ1fiOIl
# XdMhSz5SxLVXPyQD8NF6Wy/VI+NwXQ9RRnez+ADhvKwCgl/bwBWzvRvUVUvnOaEP
# 6SNJvBi4RHxF5MHDcnrgcuck379GmcXvwhxX24ON7E1JMKerjt/sW5+v/N2wZuLB
# l4F77dbtS+dJKacTKKanfWeA5opieF+yL4TXV5xcv3coKPHtbcMojyyPQDdPweGF
# RInECUzF1KVDL3SV9274eCBYLBNdYJWaPk8zhNqwiBfenk70lrC8RqBsmNLg1oiM
# CwIDAQABo4IB7TCCAekwEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFEhuZOVQ
# BdOCqhc3NyK1bajKdQKVMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1Ud
# DwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFHItOgIxkEO5FAVO
# 4eqnxzHRI4k0MFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwubWljcm9zb2Z0
# LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcmwwXgYIKwYBBQUHAQEEUjBQME4GCCsGAQUFBzAChkJodHRwOi8vd3d3Lm1p
# Y3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcnQwgZ8GA1UdIASBlzCBlDCBkQYJKwYBBAGCNy4DMIGDMD8GCCsGAQUFBwIB
# FjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2RvY3MvcHJpbWFyeWNw
# cy5odG0wQAYIKwYBBQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AcABvAGwAaQBjAHkA
# XwBzAHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAGfyhqWY
# 4FR5Gi7T2HRnIpsLlhHhY5KZQpZ90nkMkMFlXy4sPvjDctFtg/6+P+gKyju/R6mj
# 82nbY78iNaWXXWWEkH2LRlBV2AySfNIaSxzzPEKLUtCw/WvjPgcuKZvmPRul1LUd
# d5Q54ulkyUQ9eHoj8xN9ppB0g430yyYCRirCihC7pKkFDJvtaPpoLpWgKj8qa1hJ
# Yx8JaW5amJbkg/TAj/NGK978O9C9Ne9uJa7lryft0N3zDq+ZKJeYTQ49C/IIidYf
# wzIY4vDFLc5bnrRJOQrGCsLGra7lstnbFYhRRVg4MnEnGn+x9Cf43iw6IGmYslmJ
# aG5vp7d0w0AFBqYBKig+gj8TTWYLwLNN9eGPfxxvFX1Fp3blQCplo8NdUmKGwx1j
# NpeG39rz+PIWoZon4c2ll9DuXWNB41sHnIc+BncG0QaxdR8UvmFhtfDcxhsEvt9B
# xw4o7t5lL+yX9qFcltgA1qFGvVnzl6UJS0gQmYAf0AApxbGbpT9Fdx41xtKiop96
# eiL6SJUfq/tHI4D1nvi/a7dLl+LrdXga7Oo3mXkYS//WsyNodeav+vyL6wuA6mk7
# r/ww7QRMjt/fdW1jkT3RnVZOT7+AVyKheBEyIXrvQQqxP/uozKRdwaGIm1dxVk5I
# RcBCyZt2WwqASGv9eZ/BvW1taslScxMNelDNMYIZfzCCGXsCAQEwgZUwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMQITMwAAAsyOtZamvdHJTgAAAAACzDAN
# BglghkgBZQMEAgEFAKCBrjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgpe+VGVnC
# yIkIij5G6632NUwOOTAYxrRQF3+tx7aT35EwQgYKKwYBBAGCNwIBDDE0MDKgFIAS
# AE0AaQBjAHIAbwBzAG8AZgB0oRqAGGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbTAN
# BgkqhkiG9w0BAQEFAASCAQCgdevMgTOd/Ay3Z5KXs3LNesq8ydYV7iL3BtA8GQDR
# aF5pdyQWUBR+6cVxI+KMbXHSh6qyBCFRx8LPHWsm2M6arzKnodRPB8IpjzRvouCm
# Tl25FVUd05YAH5dpsSsb7uH22sML7tfFsnEVdl4Ig0U5b/7CP6BjKOSXBwBiDkdO
# 2okDzq3YS6D0rdSjfTXfB7q2mppxwd3ujelb6dk7XZp0oP0kvgpe6o3f2IDPFdA7
# vO5TrNKXv0PM+bu5TdNwuTm1mN/fmvlk69KVdcEBGaOAqZh2xN2ifC3Rp68gUPgh
# 7u/d9qE5e4A9yodGkAK6ur/clND1I2Hud35wPz0F/tuUoYIXCTCCFwUGCisGAQQB
# gjcDAwExghb1MIIW8QYJKoZIhvcNAQcCoIIW4jCCFt4CAQMxDzANBglghkgBZQME
# AgEFADCCAVUGCyqGSIb3DQEJEAEEoIIBRASCAUAwggE8AgEBBgorBgEEAYRZCgMB
# MDEwDQYJYIZIAWUDBAIBBQAEIBJ2c62VAv112Md26E1P3bQZz3ILsKQnZTs4ASuP
# vxtMAgZjYsXXIc8YEzIwMjIxMTEzMDUzODEwLjAxM1owBIACAfSggdSkgdEwgc4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKTAnBgNVBAsTIE1p
# Y3Jvc29mdCBPcGVyYXRpb25zIFB1ZXJ0byBSaWNvMSYwJAYDVQQLEx1UaGFsZXMg
# VFNTIEVTTjo0RDJGLUUzREQtQkVFRjElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgU2VydmljZaCCEVwwggcQMIIE+KADAgECAhMzAAABsKHjgzLojTvAAAEA
# AAGwMA0GCSqGSIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEw
# MB4XDTIyMDMwMjE4NTE0MloXDTIzMDUxMTE4NTE0Mlowgc4xCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVy
# YXRpb25zIFB1ZXJ0byBSaWNvMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjo0RDJG
# LUUzREQtQkVFRjElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2Vydmlj
# ZTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAJzGbTsM19KCnQc5RC7V
# oglySXMKLut/yWWPQWD6VAlJgBexVKx2n1zgX3o/xA2ZgZ/NFGcgNDRCJ7mJiOeW
# 7xeHnoNXPlg7EjYWulfk3oOAj6a7O15GvckpYsvLcx+o8Se8CrfIb40EJ8W0Qx4T
# IXf0yDwAJ4/qO94dJ/hGabeJYg4Gp0G0uQmhwFovAWTHlD1ci+sp36AxT9wIhHqw
# /70tzMvrnDF7jmQjaVUPnjOgPOyFWZiVr7e6rkSl4anT1tLv23SWhXqMs14wolv4
# ZeQcWP84rV2Frr1KbwkIa0vlHjlv4xG9a6nlTRfo0CYUQDfrZOMXCI5KcAN2BZ6f
# Vb09qtCdsWdNNxB0y4lwMjnuNmx85FNfzPcMZjmwAF9aRUUMLHv626I67t1+dZoV
# PpKqfSNmGtVt9DETWkmDipnGg4+BdTplvgGVq9F3KZPDFHabxbLpSWfXW90MZXOu
# FH8yCMzDJNUzeyAqytFFyLZir3j4T1Gx7lReCOUPw1puVzbWKspV7ModZjtN/IUW
# dVIdk3HPp4QN1wwdVvdXOsYdhG8kgjGyAZID5or7C/75hyKQb5F0Z+Ee04uY9K+s
# DZ3l3z8TQZWAfYurbZCMWWnmJVsu5V4PR5PO+U6D7tAtMvMULNYibT9+sxVZK/WQ
# er2JJ9q3Z7ljFs4lgpmfc6AVAgMBAAGjggE2MIIBMjAdBgNVHQ4EFgQUOt8BJDcB
# Jm4dy6ASZHrXIEfWNj8wHwYDVR0jBBgwFoAUn6cVXQBeYl2D9OXSZacbUzUZ6XIw
# XwYDVR0fBFgwVjBUoFKgUIZOaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9w
# cy9jcmwvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3Js
# MGwGCCsGAQUFBwEBBGAwXjBcBggrBgEFBQcwAoZQaHR0cDovL3d3dy5taWNyb3Nv
# ZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENB
# JTIwMjAxMCgxKS5jcnQwDAYDVR0TAQH/BAIwADATBgNVHSUEDDAKBggrBgEFBQcD
# CDANBgkqhkiG9w0BAQsFAAOCAgEA3XPih5sNtUfAyLnlXq6MZSpCh0TF+uG+nhIJ
# 44//cMcQGEViZ2N263NwvrQjCFOni/+oxf76jcmUhcKWLXk9hhd7vfFBhZZzcF5a
# Ns07Uligs24pveasFuhmJ4y82OYm1G1ORYsFndZdvF//NrYGxaXqUNlRHQlskV/p
# mccqO3Oi6wLHcPB1/WRTLJtYbIiiwE/uTFEFEL45wWD/1mTCPEkFX3hliXEypxXz
# dZ1k6XqGTysGAtLXUB7IC6CH26YygKQuXG8QjcJBAUG/9F3yNZOdbFvn7FinZyNc
# IVLxld7h0bELfQzhIjelj+5sBKhLcaFU0vbjbmf0WENgFmnyJNiMrL7/2FYOLsgi
# QDbJx6Dpy1EfvuRGsdL5f+jVVds5oMaKrhxgV7oEobrA6Z56nnWYN47swwouucHf
# 0ym1DQWHy2DHOFRRN7yv++zes0GSCOjRRYPK7rr1Qc+O3nsd604Ogm5nR9QqhOOc
# 2OQTrvtSgXBStu5vF6W8DPcsns53cQ4gdcR1Y9Ng5IYEwxCZzzYsq9oalxlH+ZH/
# A6J7ZMeSNKNkrXPx6ppFXUxHuC3k4mzVyZNGWP/ZgcUOi2qV03m6Imytvi1kfGe6
# YdCh32POgWeNH9lfKt+d1M+q4IhJLmX0E2ZZICYEb9Q0romeMX8GZ+cbhuNsFimJ
# ga/fjjswggdxMIIFWaADAgECAhMzAAAAFcXna54Cm0mZAAAAAAAVMA0GCSqGSIb3
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
# vzhwRNGQ8cirOoo6CGJ/2XBjU02N7oJtpQUQwXEGahC0HVUzWLOhcGbyoYICzzCC
# AjgCAQEwgfyhgdSkgdEwgc4xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5n
# dG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9y
# YXRpb24xKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1ZXJ0byBSaWNv
# MSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjo0RDJGLUUzREQtQkVFRjElMCMGA1UE
# AxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZaIjCgEBMAcGBSsOAwIaAxUA
# Ap4vkN3fD5FNBVYZklZeS/JFPBiggYMwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEG
# A1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWlj
# cm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFt
# cCBQQ0EgMjAxMDANBgkqhkiG9w0BAQUFAAIFAOcacvIwIhgPMjAyMjExMTIyMzMw
# NThaGA8yMDIyMTExMzIzMzA1OFowdDA6BgorBgEEAYRZCgQBMSwwKjAKAgUA5xpy
# 8gIBADAHAgEAAgIPPDAHAgEAAgIQvjAKAgUA5xvEcgIBADA2BgorBgEEAYRZCgQC
# MSgwJjAMBgorBgEEAYRZCgMCoAowCAIBAAIDB6EgoQowCAIBAAIDAYagMA0GCSqG
# SIb3DQEBBQUAA4GBAA8oJEtWXDhC064kU4zz20YATsS0sZqYUkK0yVCz749Y7fjb
# AkAInIxcSINiXF7CgdH6CWzC1kHzrmuI4l8SwNA8YztdEVszy7pvziO0PqMqA76W
# jebzt+2phhODXpz1PmMZcYAm22BUjqagF0YsB9WOsVH9urQerVQjZmwz80yOMYIE
# DTCCBAkCAQEwgZMwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAGw
# oeODMuiNO8AAAQAAAbAwDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJAzEN
# BgsqhkiG9w0BCRABBDAvBgkqhkiG9w0BCQQxIgQgqhCR5UTrQm5ymG5PSUgsiciJ
# VLyiZu1R83Hw2NVQgTwwgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCDNBgtD
# d8uf9KTjGf1G67IfKmcNFJmeWTd6ilAy5xWEoDCBmDCBgKR+MHwxCzAJBgNVBAYT
# AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYD
# VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBU
# aW1lLVN0YW1wIFBDQSAyMDEwAhMzAAABsKHjgzLojTvAAAEAAAGwMCIEIFjFGfk7
# Ga9lgxqhEkxN7nL7WzI1ntIA53e0Fk4vseNMMA0GCSqGSIb3DQEBCwUABIICABVt
# sK6IreleMiP+hHzRa+lv7UlvRJjZOR1o952SP6AIkOEw02GJ5eu0WHY9V7Pi7IvB
# bdQn1Pl+Jd0ZAn3EUiYgkhW6AfL6JS3ax/d6SJBXxHJCcCxZVGPFZo87xWt/+YUC
# rQqJZjXAINVBJGwW1x/z5soNbTQpvv+3zNWCpFgnqTJfM34breEJX51R6HtXiI+K
# IqynBD2FtMZuZXgOFWxH6g2DggQp1usQkdQPsQVYGnzXmLZSFcXniFzt/tP0bW+I
# Rz4ekBcqrKRUbShl8afWdkNMnVgh+76fdif9tUVCu+V21Wk/2R0ozJbotd2fhXBi
# JbPbJ4jOd1yQ+NxNl5w51vUKL8+LqvQN5toQ96lIOU2UotvjuhNQC4wL8vgpLfZN
# pGrQqu1NEr1CoRdpIA6m+NdO/L9GiukrNCSbItuPoWs0bn46PCGAQH3430dccvH1
# r3mqVxfQ6pao8Itbp3UBlh2BPI4b+r7ijAX+tLJADRDeAjh9P7dYwEYyaKQzdw2n
# Tz8kG116Qz+JLQMwyOmAojmWql9pcHUnvFuoQXFoF6L/qSCEQsLtEykoJWkPSI90
# csBGCZwuPWraoR8Ld3DWAcAq9/EzTTHkSkoXLj+Vg3ZmtXajvlhb6z+52sbQk/fk
# /RMFbr7RyQKaXFq9IadNCCex1WnOdZk4Zbe0Vmdn
# SIG # End signature block
