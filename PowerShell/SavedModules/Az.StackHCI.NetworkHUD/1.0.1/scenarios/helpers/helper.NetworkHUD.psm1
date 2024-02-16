Class PublishConnectivity {
    $timerdef = 180000
    $timermax = 360000
    $timermin =  60000
    $defaultstate = $true
    $disableable  = $false
}

Class PublishLLDP { # Ultimate min is set to PublishConnectivity Min Value
    $timerdef = 240000
    $timermax = 360000
    $timermin =  60000
    $defaultstate = $true
    $disableable  = $true
}

Class WatchMTU { # Ultimate min is set to PublishConnectivity Min Value
    $timerdef =  30000
    $timermax = 360000
    $timermin =  30000
    $defaultstate = $true
    $disableable  = $true
}

Class WatchLinkState { # there are no timers in LinkState
    $defaultstate = $true
    $disableable  = $true
}

Class SolutionMetadata {
    $PublishConnectivity = [PublishConnectivity]::new()
    $PublishLLDP         = [PublishLLDP]::new()
    $WatchLinkState      = [WatchLinkState]::new()
    $WatchMTU            = [WatchMTU]::new()

    SolutionMetadata () {}
}

Function Get-NetHudState {
    [CmdletBinding()]
    param ( $SolutionName )

    #TODO: Add a check to ensure that if the solution requested doesn't have a state in the metadata, bail out with information to the user.

    $Metadata = [SolutionMetadata]::new()
    $ExistingState = (Get-ItemProperty -Path HKLM:\Cluster\NetworkHUD\Solutions\$SolutionName -Name Enabled -ErrorAction SilentlyContinue).State

    if ($ExistingState) { # Existing state exists; return that
        return $ExistingState
    }
    else {
        $null = New-Item -Name Solutions -Path HKLM:\Cluster\NetworkHUD -ErrorAction SilentlyContinue
        $null = New-Item -Name $SolutionName -Path HKLM:\Cluster\NetworkHUD\Solutions -ErrorAction SilentlyContinue
        $null = New-ItemProperty -Name Enabled -Path HKLM:\Cluster\NetworkHUD\Solutions\$SolutionName -Value $Metadata.$SolutionName.defaultstate -ErrorAction SilentlyContinue

        return $Metadata.$SolutionName.defaultstate
    }
}
Function Get-NetHudTimer {
    [CmdletBinding()]
    param ( $SolutionName )
    #TODO: Add a check to ensure that if the solution requested doesn't have a timer in the metadata, bail out with information to the user.

    $Metadata = [SolutionMetadata]::new()
    $ExistingInterval = (Get-ItemProperty -Path HKLM:\Cluster\NetworkHUD\Solutions\$SolutionName -Name Timer -ErrorAction SilentlyContinue).Timer

    if ($ExistingInterval) {
        switch ($ExistingInterval) {
            { $ExistingInterval -le $Metadata.$SolutionName.timermax -AND $ExistingInterval -ge $Metadata.$SolutionName.timermin } { # Just right; return existing
                return $ExistingInterval
            }

            { $ExistingInterval -gt $Metadata.$SolutionName.timermax } { # too slow; return max
                $null = New-ItemProperty -Name Timer -Path HKLM:\Cluster\NetworkHUD\Solutions\$SolutionName -Value $Metadata.$SolutionName.timermax -ErrorAction SilentlyContinue
                return $Metadata.$SolutionName.timermax
            }

            { $ExistingInterval -lt $Metadata.$SolutionName.timermin } { # too fast; return min
                $null = New-ItemProperty -Name Timer -Path HKLM:\Cluster\NetworkHUD\Solutions\$SolutionName -Value $Metadata.$SolutionName.timermin -ErrorAction SilentlyContinue
                return $Metadata.$SolutionName.timermin
            }
        }
    }
    else {
        $null = New-Item -Name $SolutionName -Path HKLM:\Cluster\NetworkHUD\Solutions -ErrorAction SilentlyContinue
        $null = New-ItemProperty -Name Timer -Path HKLM:\Cluster\NetworkHUD\Solutions\$SolutionName -Value $Metadata.$SolutionName.timerdef -ErrorAction SilentlyContinue

        return $Metadata.$SolutionName.timerdef
    }
}

Function Get-NetHudLastRun {
    [CmdletBinding()]
    param ( $SolutionName )

    $LastRun = (Get-ItemProperty -Path HKLM:\Cluster\NetworkHUD\Hosts\$($env:COMPUTERNAME)\$thisSolution -Name LastRun -ErrorAction SilentlyContinue).LastRun

    if ($LastRun) { return $LastRun }
    else { return $false }
}

Function Test-NetHUDPrerequisites {
    $helpersPath   = Join-Path -Path $PSScriptRoot -ChildPath '..\helpers'
    $evtString = Import-PowerShellDataFile -Path "$helpersPath\EventStrings.psd1"

    $Prerequisites = @()
    $lldpIsInstalled = Get-WindowsFeature -Name 'RSAT-DataCenterBridging-LLDP-Tools'
    if ($lldpIsInstalled.InstallState.ToString() -ne 'Installed') {
        Write-EventLog -LogName 'NetworkHUD' -Source    $($evtString.NetHUDRequirements.RSATLLDPInstall.Source) `
                                             -EventID   $($evtString.NetHUDRequirements.RSATLLDPInstall.EventID) `
                                             -EntryType $($evtString.NetHUDRequirements.RSATLLDPInstall.EntryType) `
                                             -Message  "$($evtString.NetHUDRequirements.RSATLLDPInstall.Message)"

        $Prerequisites += $false
    }

    $HyperVIsInstalled = Get-WindowsFeature -Name 'Hyper-V', 'Hyper-V-PowerShell'

    $HyperVIsInstalled | ForEach-Object {
        $thisHyperV = $_

        if ($thisHyperV.InstallState.ToString() -ne 'Installed') {
            Write-EventLog -LogName 'NetworkHUD' -Source    $($evtString.NetHUDRequirements.HyperVInstall.Source) `
                                                 -EventID   $($evtString.NetHUDRequirements.HyperVInstall.EventID) `
                                                 -EntryType $($evtString.NetHUDRequirements.HyperVInstall.EntryType) `
                                                 -Message  "$($evtString.NetHUDRequirements.HyperVInstall.Message)"

            $Prerequisites += $false
        }
    }

    $NetworkATCIsInstalled = Get-WindowsFeature -Name 'NetworkATC'
    if ($NetworkATCIsInstalled.InstallState.ToString() -ne 'Installed') {
        Write-EventLog -LogName 'NetworkHUD' -Source    $($evtString.NetHUDRequirements.NetworkATCInstall.Source) `
                                             -EventID   $($evtString.NetHUDRequirements.NetworkATCInstall.EventID) `
                                             -EntryType $($evtString.NetHUDRequirements.NetworkATCInstall.EntryType) `
                                             -Message  "$($evtString.NetHUDRequirements.NetworkATCInstall.Message)"

        $Prerequisites += $false
    }

    $FCIsInstalled = Get-WindowsFeature -Name 'Failover-Clustering'
    if ($FCIsInstalled.InstallState.ToString() -ne 'Installed') {
        Write-EventLog -LogName 'NetworkHUD' -Source    $($evtString.NetHUDRequirements.FCInstall.Source) `
                                             -EventID   $($evtString.NetHUDRequirements.FCInstall.EventID) `
                                             -EntryType $($evtString.NetHUDRequirements.FCInstall.EntryType) `
                                             -Message  "$($evtString.NetHUDRequirements.FCInstall.Message)"

        $Prerequisites += $false
    }

    $DCBIsInstalled = Get-WindowsFeature -Name 'Data-Center-Bridging'
    if ($DCBIsInstalled.InstallState.ToString() -ne 'Installed') {
        Write-EventLog -LogName 'NetworkHUD' -Source    $($evtString.NetHUDRequirements.DCBInstall.Source) `
                                             -EventID   $($evtString.NetHUDRequirements.DCBInstall.EventID) `
                                             -EntryType $($evtString.NetHUDRequirements.DCBInstall.EntryType) `
                                             -Message  "$($evtString.NetHUDRequirements.DCBInstall.Message)"

        $Prerequisites += $false
    }

    $DCBModule = Get-Module DataCenterBridging -ListAvailable | Where-Object Version -ge $($evtString.NetHUDRequirements.DataCenterBridgingModuleInstalled.MinimumVersion) | Select-Object -First 1
    If  ((-not ($DCBModule)) -or
         (-not ($DCBModule.Version -ge $($evtString.NetHUDRequirements.DataCenterBridgingModuleInstalled.MinimumVersion)))) {

            Write-EventLog  -LogName 'NetworkHUD' -Source    $($evtString.NetHUDRequirements.DataCenterBridgingModuleInstalled.Source) `
                                              -EventID   $($evtString.NetHUDRequirements.DataCenterBridgingModuleInstalled.EventID) `
                                              -EntryType $($evtString.NetHUDRequirements.DataCenterBridgingModuleInstalled.EntryType) `
                                              -Message  "$($evtString.NetHUDRequirements.DataCenterBridgingModuleInstalled.Message)"

        $Prerequisites += $false
    }

    $TestNetStackModule = Get-Module Test-NetStack -ListAvailable | Where-Object Version -ge $($evtString.NetHUDRequirements.TestNetStackModuleInstalled.MinimumVersion) | Select-Object -First 1
    If  ((-not ($TestNetStackModule)) -or
         (-not ($TestNetStackModule.Version -ge $($evtString.NetHUDRequirements.TestNetStackModuleInstalled.MinimumVersion)))) {
        Write-EventLog  -LogName 'NetworkHUD' -Source    $($evtString.NetHUDRequirements.TestNetStackModuleInstalled.Source) `
                                              -EventID   $($evtString.NetHUDRequirements.TestNetStackModuleInstalled.EventID) `
                                              -EntryType $($evtString.NetHUDRequirements.TestNetStackModuleInstalled.EntryType) `
                                              -Message  "$($evtString.NetHUDRequirements.TestNetStackModuleInstalled.Message)"

        $Prerequisites += $false
    }

    $isClustered = Get-Cluster -WarningAction SilentlyContinue -ErrorAction SilentlyContinue
    If  (-not ($isClustered)) {
        Write-EventLog  -LogName 'NetworkHUD' `
                        -Source    $($evtString.NetHUDRequirements.NotClustered.Source) `
                        -EventID   $($evtString.NetHUDRequirements.NotClustered.EventID) `
                        -EntryType $($evtString.NetHUDRequirements.NotClustered.EntryType) `
                        -Message  "$($evtString.NetHUDRequirements.NotClustered.Message)"

        $Prerequisites += $false
    }

    $thisAccount = (Get-CimInstance -ClassName Win32_Service | ? Name -eq 'NetworkHUD').StartName

    if ($thisAccount -eq 'localsystem') {
        Write-EventLog  -LogName 'NetworkHUD' `
                        -Source    $($evtString.NetHUDRequirements.NoServiceAccount.Source) `
                        -EventID   $($evtString.NetHUDRequirements.NoServiceAccount.EventID) `
                        -EntryType $($evtString.NetHUDRequirements.NoServiceAccount.EntryType) `
                        -Message  "$($evtString.NetHUDRequirements.NoServiceAccount.Message)"

        $Prerequisites += $false
    }

    if ($false -in $Prerequisites) { return $false }
    else { return $true }
}

Function Stop-NetHud {
    $SvcNetworkHUD = Get-Service -Name NetworkHUD

    Stop-Service $SvcNetworkHUD
    $SvcNetworkHUD.WaitForStatus('Stopped')
}

#region Initiate Solutions
Function Publish-ConnectivityMap {
    $InitRSPublishConnectivityMap = [runspacefactory]::CreateRunspace()
    $InitPSPublishConnectivityMap = [powershell]::Create()

    $InitPSPublishConnectivityMap.runspace = $InitRSPublishConnectivityMap
    $InitRSPublishConnectivityMap.Name     = 'NetHud.Init.PublishConnectivityMap'

    $InitRSPublishConnectivityMap.Open()

    [void]$InitPSPublishConnectivityMap.AddScript({ C:\NetworkHUD\solutions\PublishConnectivityMap\Publish-ConnectivityMap.ps1 })
    $InitPSPublishConnectivityMap.BeginInvoke()
}

Function Publish-LLDP {
    $InitRSPublishLLDP = [runspacefactory]::CreateRunspace()
    $InitPSPublishLLDP = [powershell]::Create()

    $InitPSPublishLLDP.runspace = $InitRSPublishLLDP
    $InitRSPublishLLDP.Name     = 'NetHud.Init.PublishLLDP'

    $InitRSPublishLLDP.Open()

    [void]$InitPSPublishLLDP.AddScript({ C:\NetworkHUD\solutions\PublishLLDP\Publish-LLDP.ps1 })
    $InitPSPublishLLDP.BeginInvoke()
}

Function Trace-LinkState {
    $InitRSWatchLinkState   = [runspacefactory]::CreateRunspace()
    $InitRSMeasureLinkState = [runspacefactory]::CreateRunspace()

    $InitPSWatchLinkState   = [powershell]::Create()
    $InitPSMeasureLinkState = [powershell]::Create()

    $InitPSWatchLinkState.runspace   = $InitRSWatchLinkState
    $InitPSMeasureLinkState.runspace = $InitRSMeasureLinkState

    $InitRSWatchLinkState.Name   = 'NetHud.Init.WatchLinkState'
    $InitRSMeasureLinkState.Name = 'NetHud.Init.MeasureLinkState'

    $InitRSWatchLinkState.Open()
    $InitRSMeasureLinkState.Open()

    [void]$InitPSWatchLinkState.AddScript({ C:\NetworkHUD\solutions\LinkState\Watch-LinkState.ps1 })
    [void]$InitPSMeasureLinkState.AddScript({ C:\NetworkHUD\solutions\LinkState\Measure-LinkState.ps1 })

    $InitPSWatchLinkState.BeginInvoke()
    $InitPSMeasureLinkState.BeginInvoke()
}

Function Test-MTU {
    $InitRSWatchMTU   = [runspacefactory]::CreateRunspace()
    $InitRSMeasureMTU = [runspacefactory]::CreateRunspace()

    $InitPSWatchMTU   = [powershell]::Create()
    $InitPSMeasureMTU = [powershell]::Create()

    $InitPSWatchMTU.runspace   = $InitRSWatchMTU
    $InitPSMeasureMTU.runspace = $InitRSMeasureMTU

    $InitRSWatchMTU.Name     = 'NetHud.Init.WatchMTU'
    $InitRSMeasureMTU.Name   = 'NetHud.Init.MeasureMTU'

    $InitRSWatchMTU.Open()
    $InitRSMeasureMTU.Open()

    [void]$InitPSWatchMTU.AddScript({ C:\NetworkHUD\solutions\MTU\Watch-MTU.ps1 })
    [void]$InitPSMeasureMTU.AddScript({ C:\NetworkHUD\solutions\MTU\Measure-MTU.ps1 })

    $InitPSWatchMTU.BeginInvoke()
    $InitPSMeasureMTU.BeginInvoke()
}
#endregion Initiate Solutions

# SIG # Begin signature block
# MIInoQYJKoZIhvcNAQcCoIInkjCCJ44CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCD3+BzYqC+z0Jt
# aPLl26GfJaP1n4HOp1nMg49FV8/RP6CCDYEwggX/MIID56ADAgECAhMzAAACzI61
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
# RcBCyZt2WwqASGv9eZ/BvW1taslScxMNelDNMYIZdjCCGXICAQEwgZUwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMQITMwAAAsyOtZamvdHJTgAAAAACzDAN
# BglghkgBZQMEAgEFAKCBrjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQg/rqt6MIf
# vRuxtWxaVL3SC90oiMevynbNS5FekGlI0X8wQgYKKwYBBAGCNwIBDDE0MDKgFIAS
# AE0AaQBjAHIAbwBzAG8AZgB0oRqAGGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbTAN
# BgkqhkiG9w0BAQEFAASCAQA6HqQOiHl21Qro5nnCbkiPOMQyWeR4JVN/S+/VbE40
# Mu0PD24+Y/VFh2/Z/9Ij1KNo/J5U2AwQLTuahaOjDADyu0B9CrhSdu1ZMajJEEna
# 0hj3D1Y2ss1KVbMgCfxkQpMoU6f/cJBB7+9FMKs0qjvOS6fu0CQynZjH+P6ED/7J
# QtI7fHgAw/4OlTLNiyRoBC6xibVK4Hs9+AvkBW3FOJ6PKUjjOhL2PfNitAVV3XZu
# ph4ceexPgiYNuE91ZdrUtM8OdkUj+OR8V7rWhg47miq+eI9zZST9Q6LeX9mGQfaT
# XdhGPgypB+sK9Z3ft6f0FBZS3/awkghxx84cuWL6rWwGoYIXADCCFvwGCisGAQQB
# gjcDAwExghbsMIIW6AYJKoZIhvcNAQcCoIIW2TCCFtUCAQMxDzANBglghkgBZQME
# AgEFADCCAVEGCyqGSIb3DQEJEAEEoIIBQASCATwwggE4AgEBBgorBgEEAYRZCgMB
# MDEwDQYJYIZIAWUDBAIBBQAEIFPJcGrIvtcLGpN5JG+YsmYyQ1feHxnkV+41XE9M
# rBhcAgZjbSVzhzEYEzIwMjIxMTEzMDUzODExLjAwM1owBIACAfSggdCkgc0wgcox
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsTHE1p
# Y3Jvc29mdCBBbWVyaWNhIE9wZXJhdGlvbnMxJjAkBgNVBAsTHVRoYWxlcyBUU1Mg
# RVNOOkU1QTYtRTI3Qy01OTJFMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFt
# cCBTZXJ2aWNloIIRVzCCBwwwggT0oAMCAQICEzMAAAG+9CCi7pbWINYAAQAAAb4w
# DQYJKoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
# b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3Jh
# dGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcN
# MjIxMTA0MTkwMTIyWhcNMjQwMjAyMTkwMTIyWjCByjELMAkGA1UEBhMCVVMxEzAR
# BgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1p
# Y3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2Eg
# T3BlcmF0aW9uczEmMCQGA1UECxMdVGhhbGVzIFRTUyBFU046RTVBNi1FMjdDLTU5
# MkUxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2UwggIiMA0G
# CSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQClX/LbPsNrucy7S3KQtjyiWHtnTcSo
# U3PeIWUyn2A59WZkAGaF4JzztG491DY/44dQmKoJABY241Kgj9DWLETD0ADrnuV0
# Pxnf8SS2mbEocdq86HBBIU9ylMYVVcjEoLCg7zbiCLIc8bzh1+F2LpZTt/sP7zkt
# o8HR06w8coowaUL2nrou/3JDO8CFkYWYWGW6wLL96CvPolf84c5P2oLC6CGsvQg9
# /jtQt7WlBIQSKHLjfwnBL6tlTgBXK9BzOUwLbpexO4M+ARAqXPH2u7sS81X32X8o
# JT1tsV/lKeQ3WahSApSrT01aUrHMsYS+GR7ZA0yimfzomHV+X89V683/GtlKlXbe
# sziUHuWHtdKwI94WyVNiiMo3aKg4LqncHLuQSa9kKHqsCw8qwBEkhJ3MpAIyr6ao
# O6I/qav8u+5YqKc/7ZkaYr8LX+yS+VOO0h6G7nTKhc0OWHUI30HdAuCVBj5QIESo
# miD8HECfelZ1HTWj/rpchpyBcj93TAbb/HQ61uMQYCRpx9CWbDRsNzTZ2FAWSL/V
# D1VvCHiQLtWACIkDxsLnMQhhYc1TsL4d7r0Hj/Z1mlGOB3mkSkdsX05iIB/uzkyd
# gScc3/mj9sY7RqMBvtUjh/1q/rawLrG+EpMHlHiWHEQxYXTPi/sFDkIfIw2Qv6hO
# fMkuqctV1ee4zQIDAQABo4IBNjCCATIwHQYDVR0OBBYEFOsqIBahhEGg8a1vC9uG
# Ffprb6KqMB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8GA1UdHwRY
# MFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01p
# Y3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBsBggrBgEF
# BQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9w
# a2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAo
# MSkuY3J0MAwGA1UdEwEB/wQCMAAwEwYDVR0lBAwwCgYIKwYBBQUHAwgwDQYJKoZI
# hvcNAQELBQADggIBAMeV+71zQiaF0GKzXKPnpsG85LIakL+tJK3L7UXj1N/p+YUR
# 6rGHBNMdUc54hE13yBwMtLPR3v2ZcKqrzKerqAmDLa7gvLICvYubDMVW67GgZVHx
# i5SdG2+wMfkn66fJ7+cyTAeIL4bzaHe5Dx9waP7YfSco+ZSlS19Cu4xRe/MuNXk3
# JGMOIIvlz9/l5ybPTV2emcK8TqQjP8VOmS855UmTbYjZqQVmE/PbgPo5PoqRO3AF
# GlIQcNioJDhxn7tJfHuPPN3tv7Sn28NuioLLtLBaAqkZAb7BVsqtObiEqRkPNx0A
# SBip6FfPvwbTSZgguINPJSKTBCmhntqb2kDoF1M9j6jW/oJHNyd4g6clhqcdbPRH
# 4oRH9lEW0sLIEy8vNIcSfSxHT7SQuSWdwqMZ0DVgDjbM5vrXVR4gbK1n1WE3CfjC
# zkYnqfo8mYw877I8SQ7LZ/w4GK6FqqWKmJaHMa23lSwLSB4bSxb2rBrhABbWxBYi
# uFKXbgw45XA2X8Cb39mq8tFavXHie6l5Hwbv4M3KfgxODbzIVlFTWS1K/IExRK83
# Yr30E7qnWBLH/C9KxHjl0bfc8Mbl8qoc6APFy2MFTltfj14mqM0vtL9Sd0sXtLQ5
# Yv2Z2T+M9Uc/Yjpe03QrhWN1HC8iCveM2JvcZnIYmc5Gn9kxtjYO/WYpzHt1MIIH
# cTCCBVmgAwIBAgITMwAAABXF52ueAptJmQAAAAAAFTANBgkqhkiG9w0BAQsFADCB
# iDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
# ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMp
# TWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIwMTAwHhcNMjEw
# OTMwMTgyMjI1WhcNMzAwOTMwMTgzMjI1WjB8MQswCQYDVQQGEwJVUzETMBEGA1UE
# CBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9z
# b2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQ
# Q0EgMjAxMDCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAOThpkzntHIh
# C3miy9ckeb0O1YLT/e6cBwfSqWxOdcjKNVf2AX9sSuDivbk+F2Az/1xPx2b3lVNx
# WuJ+Slr+uDZnhUYjDLWNE893MsAQGOhgfWpSg0S3po5GawcU88V29YZQ3MFEyHFc
# UTE3oAo4bo3t1w/YJlN8OWECesSq/XJprx2rrPY2vjUmZNqYO7oaezOtgFt+jBAc
# nVL+tuhiJdxqD89d9P6OU8/W7IVWTe/dvI2k45GPsjksUZzpcGkNyjYtcI4xyDUo
# veO0hyTD4MmPfrVUj9z6BVWYbWg7mka97aSueik3rMvrg0XnRm7KMtXAhjBcTyzi
# YrLNueKNiOSWrAFKu75xqRdbZ2De+JKRHh09/SDPc31BmkZ1zcRfNN0Sidb9pSB9
# fvzZnkXftnIv231fgLrbqn427DZM9ituqBJR6L8FA6PRc6ZNN3SUHDSCD/AQ8rdH
# GO2n6Jl8P0zbr17C89XYcz1DTsEzOUyOArxCaC4Q6oRRRuLRvWoYWmEBc8pnol7X
# KHYC4jMYctenIPDC+hIK12NvDMk2ZItboKaDIV1fMHSRlJTYuVD5C4lh8zYGNRiE
# R9vcG9H9stQcxWv2XFJRXRLbJbqvUAV6bMURHXLvjflSxIUXk8A8FdsaN8cIFRg/
# eKtFtvUeh17aj54WcmnGrnu3tz5q4i6tAgMBAAGjggHdMIIB2TASBgkrBgEEAYI3
# FQEEBQIDAQABMCMGCSsGAQQBgjcVAgQWBBQqp1L+ZMSavoKRPEY1Kc8Q/y8E7jAd
# BgNVHQ4EFgQUn6cVXQBeYl2D9OXSZacbUzUZ6XIwXAYDVR0gBFUwUzBRBgwrBgEE
# AYI3TIN9AQEwQTA/BggrBgEFBQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29t
# L3BraW9wcy9Eb2NzL1JlcG9zaXRvcnkuaHRtMBMGA1UdJQQMMAoGCCsGAQUFBwMI
# MBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMB
# Af8EBTADAQH/MB8GA1UdIwQYMBaAFNX2VsuP6KJcYmjRPZSQW9fOmhjEMFYGA1Ud
# HwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3By
# b2R1Y3RzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNybDBaBggrBgEFBQcBAQRO
# MEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2Vy
# dHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3J0MA0GCSqGSIb3DQEBCwUAA4IC
# AQCdVX38Kq3hLB9nATEkW+Geckv8qW/qXBS2Pk5HZHixBpOXPTEztTnXwnE2P9pk
# bHzQdTltuw8x5MKP+2zRoZQYIu7pZmc6U03dmLq2HnjYNi6cqYJWAAOwBb6J6Gng
# ugnue99qb74py27YP0h1AdkY3m2CDPVtI1TkeFN1JFe53Z/zjj3G82jfZfakVqr3
# lbYoVSfQJL1AoL8ZthISEV09J+BAljis9/kpicO8F7BUhUKz/AyeixmJ5/ALaoHC
# gRlCGVJ1ijbCHcNhcy4sa3tuPywJeBTpkbKpW99Jo3QMvOyRgNI95ko+ZjtPu4b6
# MhrZlvSP9pEB9s7GdP32THJvEKt1MMU0sHrYUP4KWN1APMdUbZ1jdEgssU5HLcEU
# BHG/ZPkkvnNtyo4JvbMBV0lUZNlz138eW0QBjloZkWsNn6Qo3GcZKCS6OEuabvsh
# VGtqRRFHqfG3rsjoiV5PndLQTHa1V1QJsWkBRH58oWFsc/4Ku+xBZj1p/cvBQUl+
# fpO+y/g75LcVv7TOPqUxUYS8vwLBgqJ7Fx0ViY1w/ue10CgaiQuPNtq6TPmb/wrp
# NPgkNWcr4A245oyZ1uEi6vAnQj0llOZ0dFtq0Z4+7X6gMTN9vMvpe784cETRkPHI
# qzqKOghif9lwY1NNje6CbaUFEMFxBmoQtB1VM1izoXBm8qGCAs4wggI3AgEBMIH4
# oYHQpIHNMIHKMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
# A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUw
# IwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMSYwJAYDVQQLEx1U
# aGFsZXMgVFNTIEVTTjpFNUE2LUUyN0MtNTkyRTElMCMGA1UEAxMcTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgU2VydmljZaIjCgEBMAcGBSsOAwIaAxUAaK1aUve8+7wQ04B7
# 6Lb7jB9MwHuggYMwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAN
# BgkqhkiG9w0BAQUFAAIFAOca75swIhgPMjAyMjExMTMxMjIyNTFaGA8yMDIyMTEx
# NDEyMjI1MVowdzA9BgorBgEEAYRZCgQBMS8wLTAKAgUA5xrvmwIBADAKAgEAAgIQ
# owIB/zAHAgEAAgIRojAKAgUA5xxBGwIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgor
# BgEEAYRZCgMCoAowCAIBAAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBBQUA
# A4GBAEqreeZH1ys923ZSfSAnXfRSLgjVEnVRWX05NMRZBwqShkHZp90HgSHPH8yV
# po4EJtXAykdGkHkjsXaEUXchj9A0CD1H7PmWdnISsK9ih05jkEw7Kreza/1gXoPa
# colnykLmB3NCU+mbhwV/gxAfQLDWmZJEVhp2ANPsIUbqfvQaMYIEDTCCBAkCAQEw
# gZMwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
# B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UE
# AxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAG+9CCi7pbWINYA
# AQAAAb4wDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0B
# CRABBDAvBgkqhkiG9w0BCQQxIgQg+WGilAh1RVaSwF5bjahSlXRn/8lnHlGNs/9J
# Iq+TTjgwgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCCU7oqvrfb87L1ltc+u
# EQ+J00CD8V5/srdJmD4PGOEMLzCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFBDQSAyMDEwAhMzAAABvvQgou6W1iDWAAEAAAG+MCIEINoTZ/DIWVmUN687hsEr
# EIz8lXOv6uGCp6RUVXIEwLeOMA0GCSqGSIb3DQEBCwUABIICAFZNOPe8ZyFTlTqL
# VCYp3oyfo1Cuf3P6kjkljoT66MFbeFT2h7b3B8A7ymg2Jsi0kG+UpwQfBHCJ3xd6
# xr2V+c/TidflzQ+q9Wft90YcWWV8YrptFy9R/CVRnmdix5lUYPCTFVXrHfBpjlxD
# 66AEpx3HAyPaT/20QBG0BKzl4nIguiFS5oSPyDSoB8+KMw4+ex1REhYSSJ3CkpDB
# 0kAl1+Q14FQyIpxCpbL+YPztlysaB5ak/w5gNcnJ8UYPw8pOVCBPDr2+n7epY2jl
# dnCC/LMe2psfL2EpzGUtJMOL1b43iwizDwoJTlAb0qXzeyc/gwyJJJfg7Mvld1Za
# N/dn9br7Vy4HmZnZX2FlZ7gmZD1vsbJdjiHe+el3o2cY9oIu5SA20+55/+T9k90G
# 1kjx+EXcbpLn1o9ZUgbDoHuSsbnadBd7kpIqfz48jljC2vzGM+jdqksJPvsEAMLG
# Y/x61sw7HFx5CFosUWJf3Rv2W7przhH5eY5p93tQwdctcmQt6PDZA2cICgKRScXZ
# GnNnEQazRPgNCTMbTqE2i3sSpye+bS3tiG0zdkZ/9p9+3IV4mY3eYmkWp7uRnuJJ
# LIGogEDntFVzM8R/Pnlj8KL+u/9WKSuHJy9KsBbfI3yfGlOI9Rj5mi0XpnJZANTn
# J1BvFly9piOyqAKxtsrR3RWstuzr
# SIG # End signature block
