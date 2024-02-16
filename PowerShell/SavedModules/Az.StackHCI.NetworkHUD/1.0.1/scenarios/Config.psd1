@{
    HyperVKey                          = "Hyper-V"
    HyperVPowerShellKey                = "Hyper-V-PowerShell"
    DataCenterBridgingKey              = "Data-Center-Bridging"
    RSATDataCenterBridgingLLDPToolsKey = "RSAT-DataCenterBridging-LLDP-Tools"
    NetworkATCKey                      = "NetworkATC"
    FailoverClusteringKey              = "Failover-Clustering"

    # 100 - 109
    NetHUDRequirements                 = @(
        @{
            "RSAT-DataCenterBridging-LLDP-Tools" = @{
                Source     = 'Network-HUD-Service'
                EventID    = 100
                EntryType  = 'Error'
                MessageKey = 'networkhud_prerequisite_req_lldp'
            }

            "Hyper-V"                            = @{
                Source     = 'Network-HUD-Service'
                EventID    = 101
                EntryType  = 'Error'
                MessageKey = 'networkhud_prerequisite_req_hyperv'
            }

            "NetworkATC"                         = @{
                Source     = 'Network-HUD-Service'
                EventID    = 102
                EntryType  = 'Error'
                MessageKey = 'networkhud_prerequisite_req_atc'
            }

            "Failover-Clustering"                = @{
                Source     = 'Network-HUD-Service'
                EventID    = 103
                EntryType  = 'Error'
                MessageKey = 'networkhud_prerequisite_req_cluster'
            }

            "Data-Center-Bridging"               = @{
                Source     = 'Network-HUD-Service'
                EventID    = 104
                EntryType  = 'Error'
                MessageKey = 'networkhud_prerequisite_req_dcb'
            }

            "NetworkHUD" = @{
                EventID        = 105
                EntryType      = 'Error'
                RequiredVersion = '1.0.0'
                MessageKey     = 'networkhud_prerequisite_req_NetworkHUDmodule'
            }

            NotClustered                         = @{
                Source     = 'Network-HUD-Service'
                EventID    = 107
                EntryType  = 'Error'
                MessageKey = 'networkhud_prerequisite_req_nocluster'
            }

            NoServiceAccount                     = @{
                Source     = 'Network-HUD-Service'
                EventID    = 108
                EntryType  = 'Error'
                MessageKey = 'networkhud_prerequisite_req_noserviceacc'
            }

            PrerequisiteFailed                   = @{
                Source     = 'Network-HUD-Service'
                EventID    = 109
                EntryType  = 'Error'
                MessageKey = 'networkhud_prerequisite_req_fail'
            }
        }
    )

    # 120 - 129
    NetMapping                         = @(
        @{
            NoIntentsDefined      = @{
                Source    = 'Network-HUD-Service'
                EventID   = 120
                EntryType = 'Error'
                Message   = "No testable cluster networks have been found because no Network ATC intents have been defined. It is recommended
to use Network ATC to increase networking reliability and Network HUD relies on this data. To resolve this issue, use Network ATC to define
the networking configuration."
            }

            IntentTypeComputeOnly = @{
                Source    = 'Network-HUD-Service'
                EventID   = 121
                EntryType = 'Warning'
                Message   = "No testable cluster networks have been found because only Compute intents are defined in Network ATC.
Compute-only intents do not use addressed adapters and do not provide a network mapping. It is recommended to use Network ATC
on management and storage networks to increase networking reliability and Network HUD relies on this data.

To resolve this issue, use Network ATC to define the networking configuration."
            }

            NoTestableNetsFound   = @{
                Source    = 'Network-HUD-Service'
                EventID   = 122
                EntryType = 'Error'
                Message   = "No testable cluster networks have been found. This information is used by Network HUD to detect operational issues.

To resolve this issue, review the information in other events and resolve the issues identified."
            }

            Connectivity          = @{
                Source    = 'Network-HUD-Control'
                EventID   = 123
                EntryType = 'SuccessAudit'
                Message   = "Cluster connectivity information has been logged in the event data of this message in the form of JSON Bytes. This information is used by Network HUD to detect operational issues.

To convert this event data back to readable text, use the following sequence of commands:
    1) `$Event = Get-EventLog -LogName 'NetworkHUD' -Source 'Network-HUD-Control' -InstanceId 123 -EntryType SuccessAudit | Select -First 1
    2) [System.Text.Encoding]::Unicode.GetString(`$Event.Data) | ConvertFrom-Json"

            }

            TestableNets          = @{
                Source    = 'Network-HUD-Control'
                EventID   = 124
                EntryType = 'SuccessAudit'
                Message   = "Testable cluster networks has been logged in the event data of this message in the form of JSON Bytes. This information is used by Network HUD to detect operational issues.

To convert this event data back to readable text, use the following sequence of commands:
    1) `$Event = Get-EventLog -LogName 'NetworkHUD' -Source 'Network-HUD-Control' -InstanceId 124 -EntryType SuccessAudit | Select -First 1
    2) [System.Text.Encoding]::Unicode.GetString(`$Event.Data) | ConvertFrom-Json"

            }
        }
    )

    #region Solutions in use - Start at 1000
    # 1010 - 1014
    WatchLinkState                     = @(
        @{
            LinkStateChange = @{
                Source     = 'Network-HUD-Service'
                EventID    = 1010
                EntryType  = 'Warning'
                MessageKey = 'networkhud_watchlinkstate_linkstatechange'
            }
            DetectedFlap            = @{
                Source     = 'Network-HUD-Service'
                EventID    = 1015
                EntryType  = 'Error'
                MessageKey = 'networkhud_watchlinkstate_detectedflap'
            }

            NotEnoughAdapters       = @{
                Source     = 'Network-HUD-Service'
                EventID    = 1016
                EntryType  = 'Error'
                MessageKey = 'networkhud_watchlinkstate_notenoughadapters'
            }

            DisableFlappingNIC      = @{
                Source     = 'Network-HUD-Service'
                EventID    = 1017
                EntryType  = 'Error'
                MessageKey = 'networkhud_watchlinkstate_disable'
            }

            FaultIntervalSeconds    = 300
            DisconnectThreshold     = 5
            ClearIntervalMultiplier = 12
            ClearThreshold          = 0
            EntityType              = "Microsoft.Health.EntityType.NetworkAdapter"
            FaultType               = "Microsoft.Health.FaultType.NetworkAdapter.AdapterUnstableDisconnect"
            FaultDescriptionKey     = "networkhud_watchlinkstate_faultdescription"
            FaultActionKey          = "networkhud_watchlinkstate_faultAction"
        }
    )

    # 1015 - 1019
    MeasureLinkState                   = @(
        @{
            ClearIntervalSeconds = 3600
            ClearThreshold       = 0
        }
    )

    ResettingNic = @{
        DetectedReset = @{
            Source     = 'Network-HUD-Service'
            EventID    = 1018
            EntryType  = 'Error'
            MessageKey = 'networkhud_measureresettingnic_detectedflap'
        }

        NotEnoughAdapters       = @{
            Source     = 'Network-HUD-Service'
            EventID    = 1019
            EntryType  = 'Error'
            MessageKey = 'networkhud_measureresettingnic_notenoughadapters'
        }

        DisableResettingNIC     = @{
            Source     = 'Network-HUD-Service'
            EventID    = 1020
            EntryType  = 'Error'
            MessageKey = 'networkhud_measureresettingnic_disable'
        }

        FaultIntervalSeconds    = 3600
        ClearIntervalSeconds    = 10800
        ClearIntervalMultiplier = 3
        ResetThreshold          = 1
        ClearThreshold          = 0
        EntityType              = "Microsoft.Health.EntityType.NetworkAdapter"
        FaultType               = "Microsoft.Health.FaultType.NetworkAdapter.Resetting"
        FaultDescriptionKey     = "networkhud_measureresettingnic_FaultDescription"
        FaultActionKey          = "networkhud_measureresettingnic_FaultAction"
    }

    # 1020 - 1025
    WatchMTU = @(
        @{
            Connectivity                   = @{
                Source    = 'Network-HUD-Service'
                EventID   = 1020
                EntryType = 'Error'
                Message   = "The Network HUD service has determined that the host [PMTUDNameSource] with IP Address [PMTUDIPSource] does not have connectivity
to host [PMTUDNameTarget] with IP Address [PMTUDIPTarget].

The path had the following characteristics:
- Connectivity: [PathConnectivity]
- Maximum Segment Size (MSS): [PMTUDMSS]
- Maximum Transmission Unit (MTU): [PMTUDMTU]"

            }

            OperationalMTULBelowConfigured = @{
                Source    = 'Network-HUD-Service'
                EventID   = 1021
                EntryType = 'Error'
                Message   = "The configured MTU on adapter [PMTUDNameSource] with IP Address [PMTUDIPSource] is greater than the operational limit of the link
to the adapter on adapter [PMTUDNameTarget] with IP Address [PMTUDIPTarget].

To resolve this issue, ensure the Network ATC intents have completed successfully using Get-NetIntentStatus -Cluster __ClusterName__

If the Network ATC intents have completed successfully, ensure that all switchports between [PMTUDIPSource] and [PMTUDIPTarget] allows the
configured MTU of [ConfiguredMTU]"

            }

            StartedMTUFix                  = @{
                Source    = 'Network-HUD-Service'
                EventID   = 1022
                EntryType = 'Information'
                Message   = "Network HUD is attempting to fix the configured MTU for the Network ATC intent `'__ATCIntentName__`' to resolve the identified issues in Event 1021. Events 1023 and 1024 indicate completion of this attempt."
            }

            LoweredATCMTU                  = @{
                Source    = 'Network-HUD-Service'
                EventID   = 1023
                EntryType = 'Information'
                Message   = "Network HUD has lowered the configured MTU to __ATCNewMTU__ in the Network ATC intent `'__ATCIntentName__`' to resolve the issues identified in Event 1021."
            }

            CantFixMTU                     = @{
                Source    = 'Network-HUD-Service'
                EventID   = 1024
                EntryType = 'Information'
                Message   = "Network HUD could not fix the operational issue identified in event 1021. Review the information in this event and resolve the issue manually."
            }
        }
    )

    # 1030 - 1039
    PublishLLDP = @(
        @{
            LLDPNotInstalled  = @{
                Source    = 'Network-HUD-Service'
                EventID   = 1030
                EntryType = 'Error'
                Message   = "The RSAT-DataCenterBridging-LLDP-Tools feature is not installed. Network HUD has attempted to remediate this but was unsuccessful. Please install the feature or contact Microsoft support."
            }

            LLDPLogNotFound   = @{
                Source    = 'Network-HUD-Service'
                EventID   = 1031
                EntryType = 'Error'
                Message   = "The LinkLayerDiscoveryProtocol event log was not found. Network HUD has attempted to remediate this but was unsuccessful. Please contact Microsoft support."
            }

            LLDPLogNotEnabled = @{
                Source    = 'Network-HUD-Service'
                EventID   = 1032
                EntryType = 'Error'
                Message   = "The LinkLayerDiscoveryProtocol event log is disabled. Network HUD has attempted to remediate this but was unsuccessful. Please enable the log or contact Microsoft support."
            }

            LLDPLogFull       = @{
                Source    = 'Network-HUD-Service'
                EventID   = 1033
                EntryType = 'Error'
                Message   = "The LinkLayerDiscoveryProtocol event log is full. Network HUD has attempted to remediate this but was unsuccessful. Please clear the log or contact Microsoft support."
            }

            AdapterDown       = @{
                Source    = 'Network-HUD-Service'
                EventID   = 1034
                EntryType = 'Error'
                Message   = "Network HUD could not retrieve the physical network configuration because the following interface is down:
InterfaceName: __InterfaceName__
InterfaceIndex: __InterfaceIndex__

To resolve this issue, reconnect the adapter."
            }

            IntNotEthernet    = @{
                Source    = 'Network-HUD-Service'
                EventID   = 1035
                EntryType = 'Error'
                Message   = "Network HUD could not retrieve the physical network configuration because the following interface is not an Ethernet Adapter.
InterfaceName: __InterfaceName__
InterfaceIndex: __InterfaceIndex__

To resolve this issue, use a supported adapter."
            }

            NoLLDPReceived    = @{
                Source    = 'Network-HUD-Service'
                EventID   = 1036
                EntryType = 'Error'
                Message   = "LLDP packets are sent approximately every 30 seconds however no LLDP Packets were received on the following interface in the past 2 minutes:
InterfaceName: __InterfaceName__
InterfaceIndex: __InterfaceIndex__

Network HUD has already attempted to autoremediate any issues on the host. If you continue to see this message for the same interface,
    - Ensure the network administrator has enabled LLDP (802.1AB) on the switchports

    - Review the list of network switches that support the required LLDP capabilities https://aka.ms/Switch.AzureStackHCI"
            }

            ParsedPacket      = @{
                Source    = 'Network-HUD-Control'
                EventID   = 1037
                EntryType = 'SuccessAudit'
                Message   = "Select LLDP information from the switch has been logged in the event data of this message in the form of JSON Bytes

To convert this event data back to readable text, use the following sequence of commands:
    1) `$Event = Get-EventLog -LogName 'NetworkHUD' -Source 'Network-HUD-Control' -InstanceId 1037 -EntryType SuccessAudit | Select -First 1
    2) [System.Text.Encoding]::Unicode.GetString(`$Event.Data) | ConvertFrom-Json"
            }

            PropertyChange      = @{
                Source    = 'Network-HUD-Service'
                EventID   = -1
                EntryType = 'Information'
                MessageKey   = 'networkhud_LLDP_PropertyChange'
            }

            UnknownPropertyChange      = @{
                Source    = 'Network-HUD-Service'
                EventID   = 1038
                EntryType = 'Error'
                MessageKey   = 'networkhud_LLDP_UnkownPropertyChange'
            }

            MissingProperty     = @{
                Source    = 'Network-HUD-Service'
                EventID   = 1039
                EntryType = 'Error'
                MessageKey   = 'networkhud_LLDP_MissingProperty'
            }

            EntityType              = "Microsoft.Health.EntityType.PhysicalSwitch"
            FaultType               = "Microsoft.Health.FaultType.PhysicalSwitch.LLDP"
            FaultDescriptionKey     = "networkhud_LLDP_FaultDescription"
            FaultActionKey          = "networkhud_LLDP_FaultAction"
        }
    )


    # 1020 - 1029 - Driver Validation
    DriverValidation = @{
        InboxDriver  = @{
            Source     = 'Network-HUD-Service'
            EventID    = 1020
            EntryType  = 'Error'
            MessageKey = 'networkhud_DriverValidation_InboxDriver'
        }

        WarnDriverAge           = @{
            Source     = 'Network-HUD-Service'
            EventID    = 1021
            EntryType  = 'Error'
            MessageKey = 'networkhud_DriverValidation_WarnAge'
        }

        FailDriverAge           = @{
            Source     = 'Network-HUD-Service'
            EventID    = 1022
            EntryType  = 'Error'
            MessageKey = 'networkhud_DriverValidation_FailAge'
        }

        VersionMissMatch           = @{
            Source     = 'Network-HUD-Service'
            EventID    = 1023
            EntryType  = 'Warning'
            MessageKey = 'networkhud_DriverValidation_VersionMissMatch'
        }

        FailDriverAgeMonths = 36
        WarnDriverAgeMonths = 24

        EntityType              = "Microsoft.Health.EntityType.NetworkAdapter"
        FaultType               = "Microsoft.Health.FaultType.NetworkAdapter.DriverValidation"

        InboxDriverFaultDescriptionKey   = "networkhud_DriverValidation_InboxDriverFaultDescription"
        InboxDriverFaultActionKey        = "networkhud_DriverValidation_InboxDriverFaultAction"

        FailDriverAgeFaultDescriptionKey = "networkhud_DriverValidation_FailAgeFaultDescription"
        FailDriverAgeFaultActionKey      = "networkhud_DriverValidation_FailAgeFaultAction"

        WarnDriverAgeFaultDescriptionKey = "networkhud_DriverValidation_WarnAgeFaultDescription"
        WarnDriverAgeFaultActionKey      = "networkhud_DriverValidation_WarnAgeFaultAction"

        DriverVersionFaultDescriptionKey  = "networkhud_DriverValidation_DriverVersionDescription"
        DriverVersionFaultActionKey       = "networkhud_DriverValidation_DriverVersionAction"
    }

    # 1070 - 1079 - Infrastructure Validation
    InfrastructureValidation = @{
        MissingIntentTypes = @{
            Source     = 'Network-HUD-Service'
            EventID    = 1070
            EntryType  = 'Error'
            MessageKey = 'networkhud_InfrastructureValidation_MissingIntentTypes'
        }

        FailedIntent = @{
            Source     = 'Network-HUD-Service'
            EventID    = 1071
            EntryType  = 'Error'
            MessageKey = 'networkhud_InfrastructureValidation_FailedIntent'
        }

        MissingIntentTypesFaultDescriptionKey = "networkhud_InfrastructureValidation_MissingIntentTypesFaultDescription"
        MissingIntentTypesFaultActionKey      = "networkhud_InfrastructureValidation_MissingIntentTypesFaultAction"

        FailedIntentFaultDescriptionKey = "networkhud_InfrastructureValidation_FailedIntentFaultDescription"
        FailedIntentFaultActionKey      = "networkhud_InfrastructureValidation_FailedIntentFaultAction"

        EntityType              = "Microsoft.Health.EntityType.NetworkInfrastructure"
        FaultType               = "Microsoft.Health.FaultType.NetworkInfrastructure.Intent"
    }

    # 1040 - 1045 - PCIe
    PCIE = @{
        MissingInfo = @{
            Source     = 'Network-HUD-Service'
            EventID    = 1040
            EntryType  = 'Error'
            MessageKey = 'networkhud_PCIE_missinginfo'
        }

        Insufficient = @{
            Source     = 'Network-HUD-Service'
            EventID    = 1041
            EntryType  = 'Error'
            MessageKey = 'networkhud_PCIE_insufficient'
        }

        SlotInsufficient = @{
            Source     = 'Network-HUD-Service'
            EventID    = 1042
            EntryType  = 'Error'
            MessageKey = 'networkhud_PCIE_slotinsufficient'
        }

        DisableAdapters = @{
            Source     = 'Network-HUD-Service'
            EventID    = 1043
            EntryType  = 'Error'
            MessageKey = 'networkhud_PCIE_disableadapters'
        }

        NotEnoughAdapters = @{
            Source     = 'Network-HUD-Service'
            EventID    = 1044
            EntryType  = 'Error'
            MessageKey = 'networkhud_PCIE_notenoughadapters'
        }

        EntityType              = "Microsoft.Health.EntityType.NetworkAdapter"
        FaultType               = "Microsoft.Health.FaultType.NetworkAdapter.PCIeOverSubscription"
        FaultDescriptionKey     = "networkhud_PCIE_FaultDescription"
        FaultActionKey          = "networkhud_PCIE_FaultAction"
        SlotFaultDescriptionKey = "networkhud_PCIE_SlotFaultDescription"
        SlotFaultActionKey      = "networkhud_PCIE_SlotFaultAction"
    }

    #1050 - 1059 - VLAN
    VLAN = @{
        MissingVlanLocalSymmetry = @{
            Source     = 'Network-HUD-Service'
            EventID    = 1051
            EntryType  = 'Error'
            MessageKey = 'networkhud_VLANs_MissingLocalSymmetry'
        }

        MissingVlanLocalSymmetryFaultDescriptionKey = "networkhud_VLANs_MissingLocalSymmetry_FaultDescription"
        MissingVlanLocalSymmetryFaultActionKey      = "networkhud_VLANs_MissingLocalSymmetry_FaultAction"

        MissingVLANClusterSymmetry = @{
            Source     = 'Network-HUD-Service'
            EventID    = 1052
            EntryType  = 'Error'
            MessageKey = 'networkhud_VLANs_MissingClusterSymmetry'
        }


        MissingVLANClusterSymmetryFaultDescriptionKey = "networkhud_VLANs_MissingClusterSymmetry_FaultDescription"
        MissingVLANClusterSymmetryFaultActionKey      = "networkhud_VLANs_MissingClusterSymmetry_FaultAction"

        MissingLocalWorkloadVLAN = @{
            Source     = 'Network-HUD-Service'
            EventID    = 1053
            EntryType  = 'Error'
            MessageKey = 'networkhud_VLAN_MissingLocalWorkloadVLAN'
        }

        MissingLocalWorkloadVLANFaultDescriptionKey = "networkhud_VLAN_MissingLocalWorkloadVLAN_FaultDescription"
        MissingLocalWorkloadVLANFaultActionKey      = "networkhud_VLAN_MissingLocalWorkloadVLAN_FaultAction"

        EntityType              = "Microsoft.Health.EntityType.PhysicalSwitch"
        FaultType               = "Microsoft.Health.FaultType.PhysicalSwitch.MissingVlanIDs"
    }

    #1060 - 1069 - VLAN
    DCB = @{
        PFCDisabled = @{
            Source     = 'Network-HUD-Service'
            EventID    = 1060
            EntryType  = 'Error'
            MessageKey = 'networkhud_DCB_MissingSMBPFC'
        }

        MissingSMBPFCFaultDescriptionKey = "networkhud_DCB_MissingSMBPFC_FaultDescription"
        MissingSMBPFCFaultActionKey      = "networkhud_DCB_MissingSMBPFC_FaultAction"

        EntityType = "Microsoft.Health.EntityType.PhysicalSwitch"
        FaultType  = "Microsoft.Health.FaultType.PhysicalSwitch.MissingPFC"
    }
}
# SIG # Begin signature block
# MIInwgYJKoZIhvcNAQcCoIInszCCJ68CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDp7DSSGj5fAuoe
# eWIFZoeXVn6rOyTHP25s8AzBJK6CaaCCDXYwggX0MIID3KADAgECAhMzAAADTrU8
# esGEb+srAAAAAANOMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMwMzE2MTg0MzI5WhcNMjQwMzE0MTg0MzI5WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDdCKiNI6IBFWuvJUmf6WdOJqZmIwYs5G7AJD5UbcL6tsC+EBPDbr36pFGo1bsU
# p53nRyFYnncoMg8FK0d8jLlw0lgexDDr7gicf2zOBFWqfv/nSLwzJFNP5W03DF/1
# 1oZ12rSFqGlm+O46cRjTDFBpMRCZZGddZlRBjivby0eI1VgTD1TvAdfBYQe82fhm
# WQkYR/lWmAK+vW/1+bO7jHaxXTNCxLIBW07F8PBjUcwFxxyfbe2mHB4h1L4U0Ofa
# +HX/aREQ7SqYZz59sXM2ySOfvYyIjnqSO80NGBaz5DvzIG88J0+BNhOu2jl6Dfcq
# jYQs1H/PMSQIK6E7lXDXSpXzAgMBAAGjggFzMIIBbzAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUnMc7Zn/ukKBsBiWkwdNfsN5pdwAw
# RQYDVR0RBD4wPKQ6MDgxHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEW
# MBQGA1UEBRMNMjMwMDEyKzUwMDUxNjAfBgNVHSMEGDAWgBRIbmTlUAXTgqoXNzci
# tW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3JsMGEG
# CCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3J0
# MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIBAD21v9pHoLdBSNlFAjmk
# mx4XxOZAPsVxxXbDyQv1+kGDe9XpgBnT1lXnx7JDpFMKBwAyIwdInmvhK9pGBa31
# TyeL3p7R2s0L8SABPPRJHAEk4NHpBXxHjm4TKjezAbSqqbgsy10Y7KApy+9UrKa2
# kGmsuASsk95PVm5vem7OmTs42vm0BJUU+JPQLg8Y/sdj3TtSfLYYZAaJwTAIgi7d
# hzn5hatLo7Dhz+4T+MrFd+6LUa2U3zr97QwzDthx+RP9/RZnur4inzSQsG5DCVIM
# pA1l2NWEA3KAca0tI2l6hQNYsaKL1kefdfHCrPxEry8onJjyGGv9YKoLv6AOO7Oh
# JEmbQlz/xksYG2N/JSOJ+QqYpGTEuYFYVWain7He6jgb41JbpOGKDdE/b+V2q/gX
# UgFe2gdwTpCDsvh8SMRoq1/BNXcr7iTAU38Vgr83iVtPYmFhZOVM0ULp/kKTVoir
# IpP2KCxT4OekOctt8grYnhJ16QMjmMv5o53hjNFXOxigkQWYzUO+6w50g0FAeFa8
# 5ugCCB6lXEk21FFB1FdIHpjSQf+LP/W2OV/HfhC3uTPgKbRtXo83TZYEudooyZ/A
# Vu08sibZ3MkGOJORLERNwKm2G7oqdOv4Qj8Z0JrGgMzj46NFKAxkLSpE5oHQYP1H
# tPx1lPfD7iNSbJsP6LiUHXH1MIIHejCCBWKgAwIBAgIKYQ6Q0gAAAAAAAzANBgkq
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGaIwghmeAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAANOtTx6wYRv6ysAAAAAA04wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIIA/804smdy5aQqx2ElTXNtW
# jIWXjJ6Pzz0B0PvSNgz/MEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAUeyzWAtD1UleLPrPzBh+QjCwbspzI/c4wM7v3KQ+JJUXsSgHjbnBaaFX
# cVzoRxx4R8h0hRSTuLG9CtGcuN1e3pIJrGrXIk8hwvDKLLirZi2GVd1a0o2LutLv
# x9z3uxW5HmcBJeoxuD5jTRD+D7qQKLfoT3lwy7IA+0P3FeyIXUfbF/WUA+JUipVi
# 0ElT4fIvDcb3FztMrVmzuYLny8GcE3WeX9APJfi8zDRen75SxWrtnpirGGda7pAy
# Z7p70zUVE5lZ6T7zxR4uIfjhZLR2tqJzcw8jF4KfTu98AWp+DIUnO7bHIM1F0sh+
# ZJieD3g258f/vKzXN6xGJy4SsRFsy6GCFywwghcoBgorBgEEAYI3AwMBMYIXGDCC
# FxQGCSqGSIb3DQEHAqCCFwUwghcBAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFZBgsq
# hkiG9w0BCRABBKCCAUgEggFEMIIBQAIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCAntBp6GFuG6jbBZpURlXX38qRg3OpwFMVHflumLeJWTQIGZWdHtvva
# GBMyMDIzMTIwMTAwNDAxMy41MDRaMASAAgH0oIHYpIHVMIHSMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJl
# bGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNO
# OkZDNDEtNEJENC1EMjIwMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBT
# ZXJ2aWNloIIRezCCBycwggUPoAMCAQICEzMAAAHimZmV8dzjIOsAAQAAAeIwDQYJ
# KoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcNMjMx
# MDEyMTkwNzI1WhcNMjUwMTEwMTkwNzI1WjCB0jELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9zb2Z0IElyZWxhbmQgT3Bl
# cmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjpGQzQxLTRC
# RDQtRDIyMDElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZTCC
# AiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALVjtZhV+kFmb8cKQpg2mzis
# DlRI978Gb2amGvbAmCd04JVGeTe/QGzM8KbQrMDol7DC7jS03JkcrPsWi9WpVwsI
# ckRQ8AkX1idBG9HhyCspAavfuvz55khl7brPQx7H99UJbsE3wMmpmJasPWpgF05z
# ZlvpWQDULDcIYyl5lXI4HVZ5N6MSxWO8zwWr4r9xkMmUXs7ICxDJr5a39SSePAJR
# IyznaIc0WzZ6MFcTRzLLNyPBE4KrVv1LFd96FNxAzwnetSePg88EmRezr2T3HTFE
# lneJXyQYd6YQ7eCIc7yllWoY03CEg9ghorp9qUKcBUfFcS4XElf3GSERnlzJsK7s
# /ZGPU4daHT2jWGoYha2QCOmkgjOmBFCqQFFwFmsPrZj4eQszYxq4c4HqPnUu4hT4
# aqpvUZ3qIOXbdyU42pNL93cn0rPTTleOUsOQbgvlRdthFCBepxfb6nbsp3fcZaPB
# fTbtXVa8nLQuMCBqyfsebuqnbwj+lHQfqKpivpyd7KCWACoj78XUwYqy1HyYnStT
# me4T9vK6u2O/KThfROeJHiSg44ymFj+34IcFEhPogaKvNNsTVm4QbqphCyknrwBy
# qorBCLH6bllRtJMJwmu7GRdTQsIx2HMKqphEtpSm1z3ufASdPrgPhsQIRFkHZGui
# hL1Jjj4Lu3CbAmha0lOrAgMBAAGjggFJMIIBRTAdBgNVHQ4EFgQURIQOEdq+7Qds
# lptJiCRNpXgJ2gUwHwYDVR0jBBgwFoAUn6cVXQBeYl2D9OXSZacbUzUZ6XIwXwYD
# VR0fBFgwVjBUoFKgUIZOaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9j
# cmwvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3JsMGwG
# CCsGAQUFBwEBBGAwXjBcBggrBgEFBQcwAoZQaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIw
# MjAxMCgxKS5jcnQwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcD
# CDAOBgNVHQ8BAf8EBAMCB4AwDQYJKoZIhvcNAQELBQADggIBAORURDGrVRTbnulf
# sg2cTsyyh7YXvhVU7NZMkITAQYsFEPVgvSviCylr5ap3ka76Yz0t/6lxuczI6w7t
# Xq8n4WxUUgcj5wAhnNorhnD8ljYqbck37fggYK3+wEwLhP1PGC5tvXK0xYomU1nU
# +lXOy9ZRnShI/HZdFrw2srgtsbWow9OMuADS5lg7okrXa2daCOGnxuaD1IO+65E7
# qv2O0W0sGj7AWdOjNdpexPrspL2KEcOMeJVmkk/O0ganhFzzHAnWjtNWneU11WQ6
# Bxv8OpN1fY9wzQoiycgvOOJM93od55EGeXxfF8bofLVlUE3zIikoSed+8s61NDP+
# x9RMya2mwK/Ys1xdvDlZTHndIKssfmu3vu/a+BFf2uIoycVTvBQpv/drRJD68eo4
# 01mkCRFkmy/+BmQlRrx2rapqAu5k0Nev+iUdBUKmX/iOaKZ75vuQg7hCiBA5xIm5
# ZIXDSlX47wwFar3/BgTwntMq9ra6QRAeS/o/uYWkmvqvE8Aq38QmKgTiBnWSS/uV
# PcaHEyArnyFh5G+qeCGmL44MfEnFEhxc3saPmXhe6MhSgCIGJUZDA7336nQD8fn4
# y6534Lel+LuT5F5bFt0mLwd+H5GxGzObZmm/c3pEWtHv1ug7dS/Dfrcd1sn2E4gk
# 4W1L1jdRBbK9xwkMmwY+CHZeMSvBMIIHcTCCBVmgAwIBAgITMwAAABXF52ueAptJ
# mQAAAAAAFTANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
# dCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNh
# dGUgQXV0aG9yaXR5IDIwMTAwHhcNMjEwOTMwMTgyMjI1WhcNMzAwOTMwMTgzMjI1
# WjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQD
# Ex1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDCCAiIwDQYJKoZIhvcNAQEB
# BQADggIPADCCAgoCggIBAOThpkzntHIhC3miy9ckeb0O1YLT/e6cBwfSqWxOdcjK
# NVf2AX9sSuDivbk+F2Az/1xPx2b3lVNxWuJ+Slr+uDZnhUYjDLWNE893MsAQGOhg
# fWpSg0S3po5GawcU88V29YZQ3MFEyHFcUTE3oAo4bo3t1w/YJlN8OWECesSq/XJp
# rx2rrPY2vjUmZNqYO7oaezOtgFt+jBAcnVL+tuhiJdxqD89d9P6OU8/W7IVWTe/d
# vI2k45GPsjksUZzpcGkNyjYtcI4xyDUoveO0hyTD4MmPfrVUj9z6BVWYbWg7mka9
# 7aSueik3rMvrg0XnRm7KMtXAhjBcTyziYrLNueKNiOSWrAFKu75xqRdbZ2De+JKR
# Hh09/SDPc31BmkZ1zcRfNN0Sidb9pSB9fvzZnkXftnIv231fgLrbqn427DZM9itu
# qBJR6L8FA6PRc6ZNN3SUHDSCD/AQ8rdHGO2n6Jl8P0zbr17C89XYcz1DTsEzOUyO
# ArxCaC4Q6oRRRuLRvWoYWmEBc8pnol7XKHYC4jMYctenIPDC+hIK12NvDMk2ZItb
# oKaDIV1fMHSRlJTYuVD5C4lh8zYGNRiER9vcG9H9stQcxWv2XFJRXRLbJbqvUAV6
# bMURHXLvjflSxIUXk8A8FdsaN8cIFRg/eKtFtvUeh17aj54WcmnGrnu3tz5q4i6t
# AgMBAAGjggHdMIIB2TASBgkrBgEEAYI3FQEEBQIDAQABMCMGCSsGAQQBgjcVAgQW
# BBQqp1L+ZMSavoKRPEY1Kc8Q/y8E7jAdBgNVHQ4EFgQUn6cVXQBeYl2D9OXSZacb
# UzUZ6XIwXAYDVR0gBFUwUzBRBgwrBgEEAYI3TIN9AQEwQTA/BggrBgEFBQcCARYz
# aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9Eb2NzL1JlcG9zaXRvcnku
# aHRtMBMGA1UdJQQMMAoGCCsGAQUFBwMIMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIA
# QwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFNX2
# VsuP6KJcYmjRPZSQW9fOmhjEMFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwu
# bWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dF8yMDEw
# LTA2LTIzLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93
# d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYt
# MjMuY3J0MA0GCSqGSIb3DQEBCwUAA4ICAQCdVX38Kq3hLB9nATEkW+Geckv8qW/q
# XBS2Pk5HZHixBpOXPTEztTnXwnE2P9pkbHzQdTltuw8x5MKP+2zRoZQYIu7pZmc6
# U03dmLq2HnjYNi6cqYJWAAOwBb6J6Gngugnue99qb74py27YP0h1AdkY3m2CDPVt
# I1TkeFN1JFe53Z/zjj3G82jfZfakVqr3lbYoVSfQJL1AoL8ZthISEV09J+BAljis
# 9/kpicO8F7BUhUKz/AyeixmJ5/ALaoHCgRlCGVJ1ijbCHcNhcy4sa3tuPywJeBTp
# kbKpW99Jo3QMvOyRgNI95ko+ZjtPu4b6MhrZlvSP9pEB9s7GdP32THJvEKt1MMU0
# sHrYUP4KWN1APMdUbZ1jdEgssU5HLcEUBHG/ZPkkvnNtyo4JvbMBV0lUZNlz138e
# W0QBjloZkWsNn6Qo3GcZKCS6OEuabvshVGtqRRFHqfG3rsjoiV5PndLQTHa1V1QJ
# sWkBRH58oWFsc/4Ku+xBZj1p/cvBQUl+fpO+y/g75LcVv7TOPqUxUYS8vwLBgqJ7
# Fx0ViY1w/ue10CgaiQuPNtq6TPmb/wrpNPgkNWcr4A245oyZ1uEi6vAnQj0llOZ0
# dFtq0Z4+7X6gMTN9vMvpe784cETRkPHIqzqKOghif9lwY1NNje6CbaUFEMFxBmoQ
# tB1VM1izoXBm8qGCAtcwggJAAgEBMIIBAKGB2KSB1TCB0jELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9zb2Z0IElyZWxh
# bmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjpG
# QzQxLTRCRDQtRDIyMDElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2Vy
# dmljZaIjCgEBMAcGBSsOAwIaAxUAFpuZafp0bnpJdIhfiB1d8pTohm+ggYMwgYCk
# fjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQD
# Ex1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQUFAAIF
# AOkTF4kwIhgPMjAyMzExMzAyMjE1MzdaGA8yMDIzMTIwMTIyMTUzN1owdzA9Bgor
# BgEEAYRZCgQBMS8wLTAKAgUA6RMXiQIBADAKAgEAAgILpQIB/zAHAgEAAgIStTAK
# AgUA6RRpCQIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMCoAowCAIB
# AAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBBQUAA4GBAFTbqJIbViXIe97H
# 6jgUZWmXpL6xaOHi2aqjE02h+b9wzXkADQ57cZefLECEpzyipZijIqQWI/7XKR3L
# ZfOaJsmg5pmbJOhi7W4jpadCGXsLwJ0RxJrYVf4v17BUEOiJB4SBYYX2oZrgE1UL
# iOH4c1OKxLJlJpo8+2zEKWH54cR5MYIEDTCCBAkCAQEwgZMwfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTACEzMAAAHimZmV8dzjIOsAAQAAAeIwDQYJYIZIAWUD
# BAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0B
# CQQxIgQgwepAGJc6eQX6+UnWxIIjP6cwz0A7TuF8SV/zIkAvc9cwgfoGCyqGSIb3
# DQEJEAIvMYHqMIHnMIHkMIG9BCAriSpKEP0muMbBUETODoL4d5LU6I/bjucIZkOJ
# CI9//zCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
# MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
# b24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB
# 4pmZlfHc4yDrAAEAAAHiMCIEIB8GcjnP448s4wisE9/RJ1GYiqIuKK3NKpW9tOPT
# JH2RMA0GCSqGSIb3DQEBCwUABIICAHE0OPF1RTvbb/LIst3nUWyIgqPFYoxQAro2
# E/84ycWuOYRRfaeWKffgdLUCK8T9BAEcyjhex1hU+IF8kJOnI98nE5n882dS89Fy
# +n777nBwR5rB1+SDvVoqWAgPBcyvRDe5jUQjYvcrFCF2aJ0Zjc/G1f2jSjIerX8O
# zFtPoyewmPznOxi/KNYcH3Q9/sP1lgmuzsuzQHfxsRVnFAZImNnBa5gzhyiUnTpS
# nhfzowYQuRcb3ubzUpIjvsZ95v/UHd+10sL4GBR+ijumK86dVmrRXt53WS/6pFNS
# GtqoZNneb90noUpUJ2t74t0Ls4Fs0iSTyFjtiuYwJCNIWLdZEZjX605maaGNfQMh
# wT9TS5tqjHrIDwogDyvlIpaSGnviPVBwNtJJeppDehYQTjwec7m97wBBZiLBENPA
# e7iqF11bdJZYBeLpM7sYKaJNX49oGaradDKRxKe77gEQVtn7CIHJxU1odlrUVI+H
# /oNdhIEf9Za1vk+wow40Vmw5Ury1g95kEdHmrfEx3D/CrBy5nHoN2SYifaqogzHa
# +b57qKf9OsvSTxGmKDALlsvXsVW2b8qbsumPrSd0zsgm5pI4LfKw2Q7s3/ifh6cB
# e2/lfL1zroFCAXlCxtZTvEUH5rs7GZoqdbNJXbDq+QQSJHj/OtDFCBR/a3ElhSAT
# RgcISGfV
# SIG # End signature block
