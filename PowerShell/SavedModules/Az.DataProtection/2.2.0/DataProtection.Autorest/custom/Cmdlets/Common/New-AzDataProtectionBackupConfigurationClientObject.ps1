﻿
function New-AzDataProtectionBackupConfigurationClientObject{
	[OutputType('PSObject')]
    [CmdletBinding(PositionalBinding=$false)]
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Description('Creates new backup configuration object')]

    param(
        [Parameter(Mandatory, HelpMessage='Datasource Type')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.DatasourceTypes]
        [ValidateSet('AzureKubernetesService', 'AzureBlob')]
        ${DatasourceType},
        
        [Parameter(Mandatory=$false, HelpMessage='List of resource types to be excluded from backup')]
        [System.String[]]
        ${ExcludedResourceType},

        [Parameter(Mandatory=$false, HelpMessage='List of resource types to be included for backup')]
        [System.String[]]
        ${IncludedResourceType},

        [Parameter(Mandatory=$false, HelpMessage='List of namespaces to be excluded from backup')]
        [System.String[]]
        ${ExcludedNamespace},

        [Parameter(Mandatory=$false, HelpMessage='List of namespaces to be included for backup')]
        [System.String[]]
        ${IncludedNamespace},

        [Parameter(Mandatory=$false, HelpMessage='List of labels for internal filtering for backup')]
        [System.String[]]
        ${LabelSelector},

        [Parameter(Mandatory=$false, HelpMessage='Boolean parameter to decide whether snapshot volumes are included for backup. By default this is taken as true.')]        
        [Nullable[System.Boolean]]
        ${SnapshotVolume},

        [Parameter(Mandatory=$false, HelpMessage='Boolean parameter to decide whether cluster scope resources are included for backup. By default this is taken as true.')]        
        [Nullable[System.Boolean]]
        ${IncludeClusterScopeResource},

        [Parameter(Mandatory=$false, HelpMessage='Hook reference to be executed during backup.')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20231101.NamespacedNameResource[]]
        ${BackupHookReference},
        
        [Parameter(Mandatory=$false, HelpMessage='List of containers to be backed up inside the VaultStore. Use this parameter for DatasourceType AzureBlob.')]
        [System.String[]]
        ${VaultedBackupContainer},
        
        [Parameter(Mandatory=$false, HelpMessage='Switch parameter to include all containers to be backed up inside the VaultStore. Use this parameter for DatasourceType AzureBlob.')]
        [Switch]
        ${IncludeAllContainer},
        
        [Parameter(Mandatory=$false, HelpMessage='Storage account where the Datasource is present. Use this parameter for DatasourceType AzureBlob.')]
        [System.String]
        ${StorageAccountName},
        
        [Parameter(Mandatory=$false, HelpMessage='Storage account resource group name where the Datasource is present. Use this parameter for DatasourceType AzureBlob.')]
        [System.String]
        ${StorageAccountResourceGroupName}
    )

    process {        
        # need to have parameter validation when this command supports another DatasourceType           
        $dataSourceParam = $null

        if($DatasourceType.ToString() -eq "AzureKubernetesService"){

            # parameter validation
            if($VaultedBackupContainer -ne $null -or $IncludeAllContainer){
                $message = "Invalid parameter VaultedBackupContainer or IncludeAllContainer for given DatasourceType."
                throw $message
            }

            $dataSourceParam = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20231101.KubernetesClusterBackupDatasourceParameters]::new()
            $dataSourceParam.ObjectType = "KubernetesClusterBackupDatasourceParameters"
        
            $dataSourceParam.ExcludedResourceType = $ExcludedResourceType
            $dataSourceParam.IncludedResourceType = $IncludedResourceType
            $dataSourceParam.ExcludedNamespace = $ExcludedNamespace
            $dataSourceParam.IncludedNamespace = $IncludedNamespace
            $dataSourceParam.LabelSelector = $LabelSelector
            $dataSourceParam.BackupHookReference = $BackupHookReference

            if ($SnapshotVolume -ne $null) {
                $dataSourceParam.SnapshotVolume = $SnapshotVolume
            }
            else{
                $dataSourceParam.SnapshotVolume = $true
            }

            if($IncludeClusterScopeResource -ne $null){
                $dataSourceParam.IncludeClusterScopeResource = $IncludeClusterScopeResource
            }
            else{
                $dataSourceParam.IncludeClusterScopeResource = $true        
            }
        }

        if($DatasourceType.ToString() -eq "AzureBlob"){
            $dataSourceParam = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20231101.BlobBackupDatasourceParameters]::new()
            $dataSourceParam.ObjectType = "BlobBackupDatasourceParameters"
            
            if($VaultedBackupContainer -ne $null){

                # exclude containers which start with $ except $web, $root
                $unsupportedContainers = $VaultedBackupContainer | Where-Object { $_ -like '$*' -and $_ -ne "`$root" -and $_ -ne "`$web"}
                if($unsupportedContainers.Count -gt 0){
                    $message = "Following containers are not allowed for configure protection with AzureBlob - $unsupportedContainers. Please remove them and proceed."
                    throw $message
                }

                $dataSourceParam.ContainersList = $VaultedBackupContainer
            }
            elseif($IncludeAllContainer){
                if($StorageAccountName -eq $null -or $StorageAccountResourceGroupName -eq $null){
                    $message = "Please input StorageAccountName and StorageAccountResourceGroupName parameters for fetching all vaulted containers."
                    throw $message
                }

                CheckStorageModuleDependency
                $storageAccount = Get-AzStorageAccount -ResourceGroupName $StorageAccountResourceGroupName -Name $StorageAccountName 
                $containers = Get-AzStorageContainer -Context $storageAccount.Context

                # exclude containers which start with $ except $web, $root
                $allContainers = $containers.Name | Where-Object { -not($_ -like '$*' -and $_ -ne "`$root" -and $_ -ne "`$web")}
                $dataSourceParam.ContainersList = $allContainers
            }
            elseif($ExcludedResourceType -ne $null -or $IncludedResourceType -ne $null -or $ExcludedNamespace -ne $null -or $IncludedNamespace -ne $null -or $LabelSelector -ne $null -or $SnapshotVolume -ne $null -or $IncludeClusterScopeResource -ne $null){
                $message = "Invalid parameters ExcludedResourceType, IncludedResourceType, ExcludedNamespace, IncludedNamespace, LabelSelector, SnapshotVolume, IncludeClusterScopeResource for given DatasourceType."
                throw $message
            }
            else {
                 $message = "Please input VaultedBackupContainer or IncludeAllContainer parameters for given workload type."
                 throw $message
            }
        }

        $dataSourceParam
    }
}
# SIG # Begin signature block
# MIIoLAYJKoZIhvcNAQcCoIIoHTCCKBkCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAPaOmvEn+a0QBw
# 4Gw4pJxIgAOW+kZiJbT7tPUy/kDi/qCCDXYwggX0MIID3KADAgECAhMzAAADrzBA
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGgwwghoIAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAOvMEAOTKNNBUEAAAAAA68wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIKMhqS4mEoLIGrO+7kjEfH4Z
# CSAr9QX+9jsCzB785LtSMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEArcJ4mVz2oHpQeSCzvJeuQLmZu5m1dQIDYP8hJpUdaMh2wfnNl0J1F7BT
# eJiwsbx93R06Ho+I05vf7Bc/w0zIhnRxIpGSsKj+zH9uq8NY1nNX8TgriMNQsZ7H
# rHouZAUdZIG4vajILOLm3fCuAdqvOsmAtzkpoYBw3cUPesMESuVerbpy9+WL4vIG
# 3W4pnHghbQ1UrPgf1DoXtWyGUGarUw5+T3tc0+i6v+i/9wKyllKlWB6JJPUo86ky
# /KdcOle+n+x/P6xbGxsroW0Baz15cQw2oqsHDvdsi60mtRbLU5iV3M8XxODApRxU
# kI8BQ2fXjliHQ5Gr4YksfeL/Kw8YoaGCF5YwgheSBgorBgEEAYI3AwMBMYIXgjCC
# F34GCSqGSIb3DQEHAqCCF28wghdrAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFSBgsq
# hkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCD1o8j9ri+aDd2EBxTSIRCKBkbSoyGKRR4hw+y7bptgpAIGZXr/gNDp
# GBMyMDIzMTIyNzA1NTU0NC4wNTlaMASAAgH0oIHRpIHOMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046ODYwMy0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Wg
# ghHsMIIHIDCCBQigAwIBAgITMwAAAdebDR5XLoxRjgABAAAB1zANBgkqhkiG9w0B
# AQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYD
# VQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAeFw0yMzA1MjUxOTEy
# MzdaFw0yNDAyMDExOTEyMzdaMIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25z
# MScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046ODYwMy0wNUUwLUQ5NDcxJTAjBgNV
# BAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2UwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQDErGCkN2X/UvuNCcfl0yVBNo+LIIyzG7A10X5kVgGn
# p9s8mf4aZsukZu5rvLs7NqaNExcwnPuHIWdp6kswja1Yw9SxTX+E0leq+WBucIRK
# WdcMumIDBgLE0Eb/3/BY95ZtT1XsnnatBFZhr0uLkDiT9HgrRb122sm7/YkyMigF
# kT0JuoiSPXoLL7waUE9teI9QOkojqjRlcIC4YVNY+2UIBM5QorKNaOdz/so+TIF6
# mzxX5ny2U/o/iMFVTfvwm4T8g/Yqxwye+lOma9KK98v6vwe/ii72TMTVWwKXFdXO
# ysP9GiocXt38cuP9c8aE1eH3q4FdGTgKOd0rG+xhCgsRF8GqLT7k58VpQnJ8u+yj
# RW6Lomt5Rcropgf9EH8e4foDUoUyU5Q7iPgwOJxYhoKxRjGZlthDmp5ex+6U6zv9
# 5rd973668pGpCku0IB43L/BTzMcDAV4/xu6RfcVFwarN/yJq5qfZyMspH5gcaTCV
# AouXkQTc8LwtfxtgIz53qMSVR9c9gkSnxM5c1tHgiMX3D2GBnQan95ty+CdTYAAh
# jgBTcyj9P7OGEMhr3lyaZxjr3gps6Zmo47VOTI8tsSYHhHtD8BpBog39L5e4/lDJ
# g/Oq4rGsFKSxMXuIRZ1E08dmX67XM7qmvm27O804ChEmb+COR8Wb46MFEEz62ju+
# xQIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFK6nwLv9WQL3NIxEJyPuJMZ6MI2NMB8G
# A1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8GA1UdHwRYMFYwVKBSoFCG
# Tmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29mdCUy
# MFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBsBggrBgEFBQcBAQRgMF4w
# XAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2Vy
# dHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3J0MAwG
# A1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwDgYDVR0PAQH/BAQD
# AgeAMA0GCSqGSIb3DQEBCwUAA4ICAQBSBd3UJ+IsvdMCX+K7xqHa5UBtVC1CaXZv
# HRd+stW0lXA/dTNneCW0TFrBoJY59b9fnbTouPReaku2l3X5bmhsao6DCRVuqcmh
# VPAZySXGeoVfj52cLGiyZLEw6TQzu6D++vjNOGmSibO0KE9Gdv8hQERx5RG0KgrT
# mk8ckeC1VUqueUQHKVCESqTDUDD8dXTLWCmm6HqmQX6/+gKDSXggwpc75hi2AbKS
# o4tulMwTfXJdGdwrsiHjkz8nzIW/Z3PnMgGFU76KuzYFV0XyH9DTS/DPO86RLtQj
# A5ZlVGymTPfTnw7kxoiLJN/yluMHIkHSzpaJvCiqX+Dn1QGREEnNIZeRekvLourq
# PREIOTm1bJRJ065c9YX7bJ0naPixzm5y8Y2B+YIIEAi4jUraOh3oE7a4JvIW3Eg3
# oNqP7qhpd7xMLxq2WnM+U9bqWTeT4VCopAhXu2uGQexdLq7bWdcYwyEFDhS4Z9N0
# uw3h6bjB7S4MX96pfYSEV0MKFGOKbmfCUS7WemkuFqZy0oNHPPx+cfdNYeSF6bhO
# PHdsro1EVd3zWIkdD1G5kEDPnEQtFartM8H+bv5zUhAUJs8qLzuFAdBZQLueD9XZ
# eynjQKwEeAz63xATICh8tOUM2zMgSEhVL8Hm45SB6foes4BTC0Y8SZWov3Iahtvw
# yHFbUqs1YjCCB3EwggVZoAMCAQICEzMAAAAVxedrngKbSZkAAAAAABUwDQYJKoZI
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
# 6Xu/OHBE0ZDxyKs6ijoIYn/ZcGNTTY3ugm2lBRDBcQZqELQdVTNYs6FwZvKhggNP
# MIICNwIBATCB+aGB0aSBzjCByzELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEn
# MCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjg2MDMtMDVFMC1EOTQ3MSUwIwYDVQQD
# ExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQAx
# W9uizG3hEY89uL2uu+X+mG/rdaCBgzCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6TX4WjAiGA8yMDIzMTIyNzAxMTE1
# NFoYDzIwMjMxMjI4MDExMTU0WjB2MDwGCisGAQQBhFkKBAExLjAsMAoCBQDpNfha
# AgEAMAkCAQACARQCAf8wBwIBAAICE0IwCgIFAOk3SdoCAQAwNgYKKwYBBAGEWQoE
# AjEoMCYwDAYKKwYBBAGEWQoDAqAKMAgCAQACAwehIKEKMAgCAQACAwGGoDANBgkq
# hkiG9w0BAQsFAAOCAQEAufD8MyjAGueLZDY9+bQHeW2fmBvPrsy8SzOFgxueHtkj
# MgFe5GVRJTgqoK5Z5QCkxCVMWU6lRneYH+RseaunzmdsNHe+UzuzA+DuCRv1irQW
# bZ7WwoQaoqbegOBWDX3II1ex0R2xCl5kEWJ1bdSobNiuSdov8QL6b9+cgLgqLG2P
# cEKcZ7RiC1FXYwirCN5UEDVXv5FL2w56AJxx4EL3apBj0+p2dhCqIhRdr51F8Acr
# 3g4y1l63UQ3L1qlb1AJ0rxlnaRVWPfZRkZiNDFUCUVTSEY+ubEpMAFtzeqh3N5+t
# UCV/aPfdW/tQ8rBRez766AYS5tSxEObCoAeTnZIoszGCBA0wggQJAgEBMIGTMHwx
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1p
# Y3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB15sNHlcujFGOAAEAAAHX
# MA0GCWCGSAFlAwQCAQUAoIIBSjAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQw
# LwYJKoZIhvcNAQkEMSIEICs2GtBrsHYqeO+is7mAPlrUPw5/MQkV7DLzyuqY6yzP
# MIH6BgsqhkiG9w0BCRACLzGB6jCB5zCB5DCBvQQgnN4+XktefU+Ko2PHxg3tM3Vk
# jR3Vlf/bNF2cj3usmjswgZgwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0Eg
# MjAxMAITMwAAAdebDR5XLoxRjgABAAAB1zAiBCAbgnEMWvuu+/mEnfAUBUjXlp07
# zMxzTRENQV5RrvzSEDANBgkqhkiG9w0BAQsFAASCAgA1CywxQvGzktFAR9dHZdLU
# dTJPrHrRyf0PTDvQclA3M4InCQlxSNoanEBwiOXDpPUY49CIpI1u4eHETMQNKRU6
# Bv03AUe2ICRQ8kixGZa2BtWhppuOE3GE1TPREdr5qTmsIlk8eysF+gbMyQNE+akw
# paiQcLUfoGgOVQY4pSl4BaANYLH+YBhefUByurRzWZQVB7RkJrYD45W3nkO1soLF
# ob6tr6Vdqq02DSDcB5I6wB3j1TkyIw42xEGGKpd4BOL+u8X49S4zuqlNqR1+aM6V
# yfNrQBfbnT2EdPErpiePZvvL1gCrkV/0c9thznMM32w9pxTKuYS6DhNQTyc3v2L4
# 3Ii8LTAPYmW5S/Yd1x9/u6B41YJqQj2HmFWAvwy2qWnG3fXpADDHmzl2g7tgOcGG
# 4o/Pu1NyM3TU8vc2CgWu+fxxRPrYZmyXOiknQAm1AonL9nC+94th3TiUikL/DW+R
# +vCPANXJhKFae9FxC3GtPY+sNfFg6D5pT7S/HtQbo6h8boUefRPLHA+/jm4yRBWX
# MfYberutkkPy3rY4yku1NEQ5jzZki3rBTfzqx4lS+KhWmb6zzs17xbOw2Alo3mkE
# Qo6vRf0Iu0zGLa4sn50n5dc5pI7BS7BRW297VhBcYAxQRSPeM/iqHkH2KwdNCSgz
# 1mkwlRFmPgvDtXiNOqLubQ==
# SIG # End signature block