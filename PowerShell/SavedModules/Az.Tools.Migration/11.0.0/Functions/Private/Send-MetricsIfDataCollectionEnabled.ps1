function Send-MetricsIfDataCollectionEnabled
{
    <#
    .SYNOPSIS
        Sends Az Upgrade Module metrics to Microsoft.

    .DESCRIPTION
        Sends Az Upgrade Module metrics to Microsoft.

        Data collection can be enabled or disabled with the Enable-AzUpgradeDataCollection and Disable-AzUpgradeDataCollection commands.

    .PARAMETER Operation
        Specifies the operation or context for the metrics.

    .PARAMETER ParameterSetName
        Specifies the command parameter set name.

    .PARAMETER Duration
        Specifies the duration (time elapsed) that the operation took.

    .PARAMETER Properties
        Specifies the metric properties.

    .EXAMPLE
        PS C:\ Send-MetricsIfDataCollectionEnabled -Operation Plan -Properties $propertyBag
        Sends 'Plan' operation metrics with the specified properties, if data collection is enabled.
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(
            Mandatory=$true,
            HelpMessage='Specify the operation or context for the metrics.')]
        [System.String]
        [ValidateSet('Find', 'Plan', 'Upgrade')]
        $Operation,

        [Parameter(
            Mandatory=$true,
            HelpMessage='Specify the command parameter set used.')]
        [System.String]
        $ParameterSetName,

        [Parameter(
            Mandatory=$true,
            HelpMessage='Specify the duration (time elapsed) that operation took.')]
        [System.TimeSpan]
        [ValidateNotNull()]
        $Duration,

        [Parameter(
            Mandatory=$true,
            ValueFromPipeline=$true,
            HelpMessage='Specify the metric properties.')]
        [PSCustomObject]
        [ValidateNotNull()]
        $Properties
    )
    Process
    {
        $dataCollectionSettings = Get-ModulePreferences
        if ($dataCollectionSettings.DataCollectionEnabled -eq $true)
        {
            Write-Verbose -Message "Data collection option is enabled. Sending '$Operation' operation metrics."
            Write-Verbose -Message "Operation duration: $($Duration.ToString())"

            try
            {
                # telemetry send errors are not surfaced to the end user (verbose only).

                switch ($Operation)
                {
                    "Find"
                    {
                        $operationProps = @{
                            # common props
                            "Command" = "Find-AzUpgradeCommandReference"
                            "CommandParameterSetName" = $ParameterSetName

                            # custom operation props
                            "find-azure-module-name" = $Properties.AzureModuleName
                            "find-azure-module-version" = $Properties.AzureModuleVersion
                            "find-azure-cmdlet-count" = $Properties.AzureCmdletCount
                            "find-azure-file-count" = $Properties.FileCount
                        }

                        Send-PageViewTelemetry -PageName 'FindAzUpgradeCommandReference' -Duration $Duration -CustomProperties $operationProps
                    }
                    "Plan"
                    {
                        $warningsBuilder = New-Object -TypeName System.Text.StringBuilder
                        $errorsBuilder = New-Object -TypeName System.Text.StringBuilder

                        if ($Properties.PlanWarnings -ne $null)
                        {
                            foreach ($planWarning in $Properties.PlanWarnings)
                            {
                                if ($planWarning.UpgradeType -eq [UpgradeStepType]::Cmdlet)
                                {
                                    # cmdlet. log just the cmdlet name and the warning reason
                                    $null = $warningsBuilder.AppendLine(("{0}={1}" -f `
                                                $planWarning.Original, `
                                                $planWarning.PlanResult.ToString()))
                                }
                                elseif ($planWarning.UpgradeType -eq [UpgradeStepType]::CmdletParameter)
                                {
                                    # cmdlet parameter. log the cmdlet name and the parameter name, with the warning reason
                                    $null = $warningsBuilder.AppendLine(("{0}.{1}={2}" -f `
                                                $planWarning.SourceCommand.CommandName, `
                                                $planWarning.Original, `
                                                $planWarning.PlanResult.ToString()))
                                }
                                else
                                {
                                    throw "Unexpected plan upgrade step type: $($planWarning.UpgradeType)"
                                }
                            }
                        }

                        if ($Properties.PlanErrors -ne $null)
                        {
                            foreach ($planError in $Properties.PlanErrors)
                            {
                                if ($planError.UpgradeType -eq [UpgradeStepType]::Cmdlet)
                                {
                                    # cmdlet. log just the cmdlet name and the error reason
                                    $null = $errorsBuilder.AppendLine(("{0}={1}" -f `
                                                $planError.Original, `
                                                $planError.PlanResult.ToString()))
                                }
                                elseif ($planError.UpgradeType -eq [UpgradeStepType]::CmdletParameter)
                                {
                                    # cmdlet parameter. log the cmdlet name and the parameter name, with the error reason
                                    $null = $errorsBuilder.AppendLine(("{0}.{1}={2}" -f `
                                                $planError.SourceCommand.CommandName, `
                                                $planError.Original, `
                                                $planError.PlanResult.ToString()))
                                }
                                else
                                {
                                    throw "Unexpected plan upgrade step type: $($planError.UpgradeType)"
                                }
                            }
                        }

                        $operationProps = @{
                            # common props
                            "Command" = "New-AzUpgradeModulePlan"
                            "CommandParameterSetName" = $ParameterSetName

                            # custom operation props
                            "plan-to-azure-modulename" = $Properties.ToAzureModuleName
                            "plan-to-azure-moduleversion" = $Properties.ToAzureModuleVersion
                            "plan-upgrade-steps-count" = $Properties.UpgradeStepsCount
                            "plan-warning-steps-count" = $Properties.PlanWarnings.Count
                            "plan-warning-steps" = $warningsBuilder.ToString()
                            "plan-error-steps-count" = $Properties.PlanErrors.Count
                            "plan-error-steps" = $errorsBuilder.ToString()
                        }

                        Send-PageViewTelemetry -PageName 'NewAzUpgradeModulePlan' -Duration $Duration -CustomProperties $operationProps
                    }
                    "Upgrade"
                    {
                        $operationProps = @{
                            # common props
                            "Command" = "Invoke-AzUpgradeModulePlan"
                            "CommandParameterSetName" = $ParameterSetName

                            # custom operation props
                            "file-edit-mode" = $Properties.FileEditMode
                            "upgrade-success-file-count" = $Properties.SuccessFileUpdateCount
                            "upgrade-success-command-count" = $Properties.SuccessCommandUpdateCount
                            "upgrade-failed-file-count" = $Properties.FailedFileUpdateCount
                            "upgrade-failed-command-count" = $Properties.FailedCommandUpdateCount
                        }

                        Send-PageViewTelemetry -PageName 'InvokeAzUpgradeModulePlan' -Duration $Duration -CustomProperties $operationProps
                    }
                }
            }
            catch
            {
                Write-Verbose -Message "Telemetry send failure: $_"
            }
        }
        else
        {
            Write-Verbose -Message "Data collection option is disabled. Metrics will not be sent."
        }
    }
}
# SIG # Begin signature block
# MIInwQYJKoZIhvcNAQcCoIInsjCCJ64CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDRFZdRV9JsJqGr
# 8OFvo0cet/MqUkYUxOKd1MaV3ApReaCCDXYwggX0MIID3KADAgECAhMzAAADTrU8
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGaEwghmdAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAANOtTx6wYRv6ysAAAAAA04wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIAlyxW3ZZ7KxUAvjXkPUIsBg
# qAY3VCMkrCDSBoX8G8GoMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAniyWTcZljnvu4wNIoA9yCTYRKSBm7LjbErIiOPG1g51LoCvtc1ai0P0U
# yajp70mdZZhBfV4096DEbgG86lNM4SKFojUvPntcsHUAQkF0+CPi2B2xzNDS9/pD
# Kl/kqyt6pEPbs4RgtFi1LVFgB2urPE4Iw1aC+Ej0zWpysRL0f91llNBVonisAkT/
# M+RkzL7do0eum8gm0WSRku0xwQhwRK7UqQhmflEF7hcYGX9nBdGk3wm9spJLUAbB
# UITe5iZR0K03wWatfeEley6W7S3OltWcioEvn2hZvoyjFvXgCf9qQjitvXPisgRj
# xAeF9ouJe9vsAZlsCeAMenYdrWv606GCFyswghcnBgorBgEEAYI3AwMBMYIXFzCC
# FxMGCSqGSIb3DQEHAqCCFwQwghcAAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFZBgsq
# hkiG9w0BCRABBKCCAUgEggFEMIIBQAIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCBp32DC9wGAYnvixDsM2jtmITnaPlr9719xh3AotRgXdAIGZUK65D20
# GBMyMDIzMTExNjA2MzQxOC44ODhaMASAAgH0oIHYpIHVMIHSMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJl
# bGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNO
# OjA4NDItNEJFNi1DMjlBMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBT
# ZXJ2aWNloIIRejCCBycwggUPoAMCAQICEzMAAAHajtXJWgDREbEAAQAAAdowDQYJ
# KoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcNMjMx
# MDEyMTkwNjU5WhcNMjUwMTEwMTkwNjU5WjCB0jELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9zb2Z0IElyZWxhbmQgT3Bl
# cmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjowODQyLTRC
# RTYtQzI5QTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZTCC
# AiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAJOQBgh2tVFR1j8jQA4NDf8b
# cVrXSN080CNKPSQo7S57sCnPU0FKF47w2L6qHtwm4EnClF2cruXFp/l7PpMQg25E
# 7X8xDmvxr8BBE6iASAPCfrTebuvAsZWcJYhy7prgCuBf7OidXpgsW1y8p6Vs7sD2
# aup/0uveYxeXlKtsPjMCplHkk0ba+HgLho0J68Kdji3DM2K59wHy9xrtsYK+X9er
# bDGZ2mmX3765aS5Q7/ugDxMVgzyj80yJn6ULnknD9i4kUQxVhqV1dc/DF6UBeuzf
# ukkMed7trzUEZMRyla7qhvwUeQlgzCQhpZjz+zsQgpXlPczvGd0iqr7lACwfVGog
# 5plIzdExvt1TA8Jmef819aTKwH1IVEIwYLA6uvS8kRdA6RxvMcb//ulNjIuGceyy
# kMAXEynVrLG9VvK4rfrCsGL3j30Lmidug+owrcCjQagYmrGk1hBykXilo9YB8Qyy
# 5Q1KhGuH65V3zFy8a0kwbKBRs8VR4HtoPYw9z1DdcJfZBO2dhzX3yAMipCGm6Smv
# mvavRsXhy805jiApDyN+s0/b7os2z8iRWGJk6M9uuT2493gFV/9JLGg5YJJCJXI+
# yxkO/OXnZJsuGt0+zWLdHS4XIXBG17oPu5KsFfRTHREloR2dI6GwaaxIyDySHYOt
# vIydla7u4lfnfCjY/qKTAgMBAAGjggFJMIIBRTAdBgNVHQ4EFgQUoXyNyVE9ZhOV
# izEUVwhNgL8PX0UwHwYDVR0jBBgwFoAUn6cVXQBeYl2D9OXSZacbUzUZ6XIwXwYD
# VR0fBFgwVjBUoFKgUIZOaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9j
# cmwvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3JsMGwG
# CCsGAQUFBwEBBGAwXjBcBggrBgEFBQcwAoZQaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIw
# MjAxMCgxKS5jcnQwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcD
# CDAOBgNVHQ8BAf8EBAMCB4AwDQYJKoZIhvcNAQELBQADggIBALmDVdTtuI0jAEt4
# 1O2OM8CU237TGMyhrGr7FzKCEFaXxtoqk/IObQriq1caHVh2vyuQ24nz3TdOBv7r
# cs/qnPjOxnXFLyZPeaWLsNuARVmUViyVYXjXYB5DwzaWZgScY8GKL7yGjyWrh78W
# JUgh7rE1+5VD5h0/6rs9dBRqAzI9fhZz7spsjt8vnx50WExbBSSH7rfabHendpeq
# bTmW/RfcaT+GFIsT+g2ej7wRKIq/QhnsoF8mpFNPHV1q/WK/rF/ChovkhJMDvlqt
# ETWi97GolOSKamZC9bYgcPKfz28ed25WJy10VtQ9P5+C/2dOfDaz1RmeOb27Kbeg
# ha0SfPcriTfORVvqPDSa3n9N7dhTY7+49I8evoad9hdZ8CfIOPftwt3xTX2RhMZJ
# CVoFlabHcvfb84raFM6cz5EYk+x1aVEiXtgK6R0xn1wjMXHf0AWlSjqRkzvSnRKz
# FsZwEl74VahlKVhI+Ci9RT9+6Gc0xWzJ7zQIUFE3Jiix5+7KL8ArHfBY9UFLz4sn
# boJ7Qip3IADbkU4ZL0iQ8j8Ixra7aSYfToUefmct3dM69ff4Eeh2Kh9NsKiiph58
# 9Ap/xS1jESlrfjL/g/ZboaS5d9a2fA598mubDvLD5x5PP37700vm/Y+PIhmp2fTv
# uS2sndeZBmyTqcUNHRNmCk+njV3nMIIHcTCCBVmgAwIBAgITMwAAABXF52ueAptJ
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
# tB1VM1izoXBm8qGCAtYwggI/AgEBMIIBAKGB2KSB1TCB0jELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9zb2Z0IElyZWxh
# bmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjow
# ODQyLTRCRTYtQzI5QTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2Vy
# dmljZaIjCgEBMAcGBSsOAwIaAxUAQqIfIYljHUbNoY0/wjhXRn/sSA2ggYMwgYCk
# fjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQD
# Ex1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQUFAAIF
# AOj/rSQwIhgPMjAyMzExMTYwNDQ4MzZaGA8yMDIzMTExNzA0NDgzNlowdjA8Bgor
# BgEEAYRZCgQBMS4wLDAKAgUA6P+tJAIBADAJAgEAAgFMAgH/MAcCAQACAhIGMAoC
# BQDpAP6kAgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEA
# AgMHoSChCjAIAgEAAgMBhqAwDQYJKoZIhvcNAQEFBQADgYEARvfv/GxDKLqcoGdH
# srYXlGjuMeXOCOjq+ZoiBKnlBL6xcLtf8Cb4Tlm/XLw2KTFHRl186ut6+2lCJ3Ho
# fAdjl7RrMDB4UeEABfsoeqMq4UmxD8feJ8yUxLW2f+V/hw7ss+6Or+k3DmwuC1uA
# SM3vTT95/br1YOJsOvcpuB8wT/IxggQNMIIECQIBATCBkzB8MQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGlt
# ZS1TdGFtcCBQQ0EgMjAxMAITMwAAAdqO1claANERsQABAAAB2jANBglghkgBZQME
# AgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJ
# BDEiBCC4TR+o+6h/itVH1z694S34AT6k2JpbsPLw2o8daEWRwzCB+gYLKoZIhvcN
# AQkQAi8xgeowgecwgeQwgb0EICKlo2liwO+epN73kOPULT3TbQjmWOJutb+d0gI7
# GD3GMIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAHa
# jtXJWgDREbEAAQAAAdowIgQgUCFRQQmEBBuyPxzDAvY0kguXg1NcdtD30oWhBRek
# A8kwDQYJKoZIhvcNAQELBQAEggIAGb8yEQPex5T3Z93C6efDUdsfK3kZcYSlW4V+
# vSOAIPotrUz2Gs7jlCkudRGfCzsBF1Ar/GjWz88feEq7pp15iuizwHl7ig9cCpwy
# eS5o1QoiavwanJ2xcvVX9usRSAyiG2OhAuu4mR3qsgOLhkslp73LT8jubXrPliY7
# rLys+SpnLJjXvdikjpy46Og7ixRNaS2cYw94I2hgaFRqq4OEEjcecb5yeJRyIW9C
# Dmy6IAwGbPlx+17lw0xM0v2gO+aIRn3Dap7tgCzbm4fVVeNdUzgaBzbKlW3RT8gn
# 8sEVtr2cTQ0Rijf2v5sWVCK+7/Tw61CIMrNzgCkdTjCxShzaXfhTGLD6WPPoU9p9
# WUOWItF2BBxXTWR/qNt3gSQ0XXYZiDNV1F4jk4cloXSu8CbJdzku+F4jrEQhbDab
# 4Y/rvAQXxMASsRTwbwbTRwUD2tqc+aONexViRxjIMHDUogpSiiF4k71zH2pxn7BK
# yIqNLPuTulcJAye4qmPNoHJsJTxqZAon37zYg2l+UaziqAok7+j69CfAIdU6mHw4
# sybgZH5ww07z6RcrqZdZdi6zsrCdKGx9FOxUgkP/yLNYUM+3Xbgo/VXz70cZ+2t5
# 83IEqB0S8oM1uYV6k6iQyCv6gCFNTmRf0oXnfpe/CC1NfK1SVAsaoyYxsUQRZ2Q4
# KSLg/FI=
# SIG # End signature block
