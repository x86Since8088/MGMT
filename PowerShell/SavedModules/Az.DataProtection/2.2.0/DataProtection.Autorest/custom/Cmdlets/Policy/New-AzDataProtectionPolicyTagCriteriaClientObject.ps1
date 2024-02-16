function New-AzDataProtectionPolicyTagCriteriaClientObject{
	[OutputType('Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20231101.IScheduleBasedBackupCriteria')]
    [CmdletBinding(PositionalBinding=$false)]
    [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Description('Creates a new criteria object')]

    param(
        [Parameter(ParameterSetName='AbsoluteCriteria', Mandatory, HelpMessage='Absolute criteria')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.AbsoluteTagCriteria]
        ${AbsoluteCriteria},

        [Parameter(ParameterSetName='ScheduleCriteria', HelpMessage='Days of the week')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.DaysOfWeek[]]
        ${DaysOfWeek},

        [Parameter(ParameterSetName='ScheduleCriteria', HelpMessage='Weeks of the month.')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.WeeksOfMonth[]]
        ${WeeksOfMonth},

        [Parameter(ParameterSetName='ScheduleCriteria', HelpMessage='Months of the year.')]
        [Parameter(ParameterSetName='MonthlyCriteria', HelpMessage='Months of the year.')]
        [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Support.MonthsOfYear[]]
        ${MonthsOfYear},

        [Parameter(ParameterSetName='ScheduleCriteria', HelpMessage='Schedule times.')]
        [Parameter(ParameterSetName='MonthlyCriteria', HelpMessage='Schedule times.')]
        [System.DateTime[]]
        ${ScheduleTimes},

        [Parameter(ParameterSetName='MonthlyCriteria', Mandatory, HelpMessage='Days of the month. Allowed values are 1 to 28 and Last')]
        [System.String[]]
        ${DaysOfMonth}
    )

    process {
        $criteria = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20231101.ScheduleBasedBackupCriteria]::new()
        $criteria.ObjectType = "ScheduleBasedBackupCriteria"
        if($AbsoluteCriteria -ne $null){
            $criteria.AbsoluteCriterion = $AbsoluteCriteria
        }

        if($DaysOfWeek -ne $null){
            $criteria.DaysOfTheWeek = $DaysOfWeek | Foreach-Object { $_ = $_.ToString(); $_ }
        }

        if($WeeksOfMonth -ne $null){
            $criteria.WeeksOfTheMonth = $WeeksOfMonth | Foreach-Object { $_ = $_.ToString(); $_ }
        }

        if($MonthsOfYear -ne $null){
            $criteria.MonthsOfYear = $MonthsOfYear | Foreach-Object { $_ = $_.ToString(); $_ }
        }

        if($DaysOfMonth -ne $null){
            $criteria.DaysOfMonth = @()
            Foreach($dayOfMonth in $DaysOfMonth)
            {
                if($dayOfMonth -match "^[\d]+$")
                {
                    $dayOfMonthNumber = [int]$dayOfMonth
                    if(($dayOfMonthNumber -lt 1) -or ($dayOfMonthNumber -gt 28))
                    {
                        throw "Day of month should be between 1 and 28."
                    }
                    $day = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20231101.Day]::new()
                    $day.Date = $dayOfMonthNumber
                    $day.IsLast = $false
                    $criteria.DaysOfMonth += $day
                }
                else 
                {
                    if($dayOfMonth.ToLower() -ne "last")
                    {
                        thow "Day of month should either be between 1 and 28 or it should be last"
                    }
                    $day = [Microsoft.Azure.PowerShell.Cmdlets.DataProtection.Models.Api20231101.Day]::new()
                    $day.IsLast = $true
                    $criteria.DaysOfMonth += $day
                }
            }
        }

        if($ScheduleTimes -ne $null){
            $criteria.ScheduleTime = $ScheduleTimes
        }


        return $criteria
    }
}
# SIG # Begin signature block
# MIIoOQYJKoZIhvcNAQcCoIIoKjCCKCYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCNhuekXrzzAShw
# BZ8ORzcBG+4CM4CbkQjWZ0zpahntzaCCDYUwggYDMIID66ADAgECAhMzAAADri01
# UchTj1UdAAAAAAOuMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMxMTE2MTkwODU5WhcNMjQxMTE0MTkwODU5WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQD0IPymNjfDEKg+YyE6SjDvJwKW1+pieqTjAY0CnOHZ1Nj5irGjNZPMlQ4HfxXG
# yAVCZcEWE4x2sZgam872R1s0+TAelOtbqFmoW4suJHAYoTHhkznNVKpscm5fZ899
# QnReZv5WtWwbD8HAFXbPPStW2JKCqPcZ54Y6wbuWV9bKtKPImqbkMcTejTgEAj82
# 6GQc6/Th66Koka8cUIvz59e/IP04DGrh9wkq2jIFvQ8EDegw1B4KyJTIs76+hmpV
# M5SwBZjRs3liOQrierkNVo11WuujB3kBf2CbPoP9MlOyyezqkMIbTRj4OHeKlamd
# WaSFhwHLJRIQpfc8sLwOSIBBAgMBAAGjggGCMIIBfjAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUhx/vdKmXhwc4WiWXbsf0I53h8T8w
# VAYDVR0RBE0wS6RJMEcxLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJh
# dGlvbnMgTGltaXRlZDEWMBQGA1UEBRMNMjMwMDEyKzUwMTgzNjAfBgNVHSMEGDAW
# gBRIbmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDEx
# XzIwMTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIB
# AGrJYDUS7s8o0yNprGXRXuAnRcHKxSjFmW4wclcUTYsQZkhnbMwthWM6cAYb/h2W
# 5GNKtlmj/y/CThe3y/o0EH2h+jwfU/9eJ0fK1ZO/2WD0xi777qU+a7l8KjMPdwjY
# 0tk9bYEGEZfYPRHy1AGPQVuZlG4i5ymJDsMrcIcqV8pxzsw/yk/O4y/nlOjHz4oV
# APU0br5t9tgD8E08GSDi3I6H57Ftod9w26h0MlQiOr10Xqhr5iPLS7SlQwj8HW37
# ybqsmjQpKhmWul6xiXSNGGm36GarHy4Q1egYlxhlUnk3ZKSr3QtWIo1GGL03hT57
# xzjL25fKiZQX/q+II8nuG5M0Qmjvl6Egltr4hZ3e3FQRzRHfLoNPq3ELpxbWdH8t
# Nuj0j/x9Crnfwbki8n57mJKI5JVWRWTSLmbTcDDLkTZlJLg9V1BIJwXGY3i2kR9i
# 5HsADL8YlW0gMWVSlKB1eiSlK6LmFi0rVH16dde+j5T/EaQtFz6qngN7d1lvO7uk
# 6rtX+MLKG4LDRsQgBTi6sIYiKntMjoYFHMPvI/OMUip5ljtLitVbkFGfagSqmbxK
# 7rJMhC8wiTzHanBg1Rrbff1niBbnFbbV4UDmYumjs1FIpFCazk6AADXxoKCo5TsO
# zSHqr9gHgGYQC2hMyX9MGLIpowYCURx3L7kUiGbOiMwaMIIHejCCBWKgAwIBAgIK
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
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGgowghoGAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAAOuLTVRyFOPVR0AAAAA
# A64wDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIOGO
# brPg6GbzhdDcr/wmUxr0VvY0OWPaaYPwYGFaqfmpMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAUek1VHRsjhX/Iq5FRl+ij7da+jJxwYytkiLA
# tw+mnuaN0ZbTeygB9Bfy6t4QysdTqi9kiuluYclIGVegCKyhPkjOTNHQ5miP5rxH
# /BhRTW1F/FEjzJ7WX5o0pPLsB+BtbWVJfQqb5PEjcSfoC53WUwytWU+sf/Ot0525
# LSniLjJvEhgE8a6qRtWxDTuhoIPhti69pOebmyI7Z5J59TDHV7tTf/x1o41kbzIC
# dnXPw5SI7jkcDlGl8mrXqqhrT+642MOulPGF2VBfwt/+KNeQBecubb0/lqj760hO
# bbOdqlFqCe/xxaHJBc4GoCUiYSSrEVIYhad7nBXWYPnJhc4KRaGCF5QwgheQBgor
# BgEEAYI3AwMBMYIXgDCCF3wGCSqGSIb3DQEHAqCCF20wghdpAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFSBgsqhkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCDAa78TFQTVCbx6RgMtRQqiWM6VzDjlp9sI
# A2eiL5gxIAIGZXsVlvTsGBMyMDIzMTIyNzA1NTU0Ni4xNjJaMASAAgH0oIHRpIHO
# MIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQL
# ExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxk
# IFRTUyBFU046MzcwMy0wNUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1l
# LVN0YW1wIFNlcnZpY2WgghHqMIIHIDCCBQigAwIBAgITMwAAAdTk6QMvwKxprAAB
# AAAB1DANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MDAeFw0yMzA1MjUxOTEyMjdaFw0yNDAyMDExOTEyMjdaMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046MzcwMy0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Uw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCYU94tmwIkl353SWej1ybW
# cSAbu8FLwTEtOvw3uXMpa1DnDXDwbtkLc+oT8BNti8t+38TwktfgoAM9N/BOHyT4
# CpXB1Hwn1YYovuYujoQV9kmyU6D6QttTIKN7fZTjoNtIhI5CBkwS+MkwCwdaNyyS
# vjwPvZuxH8RNcOOB8ABDhJH+vw/jev+G20HE0Gwad323x4uA4tLkE0e9yaD7x/s1
# F3lt7Ni47pJMGMLqZQCK7UCUeWauWF9wZINQ459tSPIe/xK6ttLyYHzd3DeRRLxQ
# P/7c7oPJPDFgpbGB2HRJaE0puRRDoiDP7JJxYr+TBExhI2ulZWbgL4CfWawwb1Ls
# JmFWJHbqGr6o0irW7IqDkf2qEbMRT1WUM15F5oBc5Lg18lb3sUW7kRPvKwmfaRBk
# rmil0H/tv3HYyE6A490ZFEcPk6dzYAKfCe3vKpRVE4dPoDKVnCLUTLkq1f/pnuD/
# ZGHJ2cbuIer9umQYu/Fz1DBreC8CRs3zJm48HIS3rbeLUYu/C93jVIJOlrKAv/qm
# YRymjDmpfzZvfvGBGUbOpx+4ofwqBTLuhAfO7FZz338NtsjDzq3siR0cP74p9UuN
# X1Tpz4KZLM8GlzZLje3aHfD3mulrPIMipnVqBkkY12a2slsbIlje3uq8BSrj725/
# wHCt4HyXW4WgTGPizyExTQIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFDzajMdwtAZ6
# EoB5Hedcsru0DHZJMB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8G
# A1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMv
# Y3JsL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBs
# BggrBgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0
# LmNvbS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
# MDIwMTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUH
# AwgwDgYDVR0PAQH/BAQDAgeAMA0GCSqGSIb3DQEBCwUAA4ICAQC0xUPP+ytwktdR
# hYlZ9Bk4/bLzLOzq+wcC7VAaRQHGRS+IPyU/8OLiVoXcoyKKKiRQ7K9c90OdM+qL
# 4PizKnStLDBsWT+ds1hayNkTwnhVcZeA1EGKlNZvdlTsCUxJ5C7yoZQmA+2lpk04
# PGjcFhH1gGRphz+tcDNK/CtKJ+PrEuNj7sgmBop/JFQcYymiP/vr+dudrKQeStcT
# V9W13cm2FD5F/XWO37Ti+G4Tg1BkU25RA+t8RCWy/IHug3rrYzqUcdVRq7UgRl40
# YIkTNnuco6ny7vEBmWFjcr7Skvo/QWueO8NAvP2ZKf3QMfidmH1xvxx9h9wVU6rv
# EQ/PUJi3popYsrQKuogphdPqHZ5j9OoQ+EjACUfgJlHnn8GVbPW3xGplCkXbyEHh
# eQNd/a3X/2zpSwEROOcy1YaeQquflGilAf0y40AFKqW2Q1yTb19cRXBpRzbZVO+R
# XUB4A6UL1E1Xjtzr/b9qz9U4UNV8wy8Yv/07bp3hAFfxB4mn0c+PO+YFv2YsVvYA
# TVI2lwL9QDSEt8F0RW6LekxPfvbkmVSRwP6pf5AUfkqooKa6pfqTCndpGT71Hyil
# telaMhRUsNVkaKzAJrUoESSj7sTP1ZGiS9JgI+p3AO5fnMht3mLHMg68GszSH4Wy
# 3vUDJpjUTYLtaTWkQtz6UqZPN7WXhjCCB3EwggVZoAMCAQICEzMAAAAVxedrngKb
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
# ELQdVTNYs6FwZvKhggNNMIICNQIBATCB+aGB0aSBzjCByzELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJp
# Y2EgT3BlcmF0aW9uczEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjM3MDMtMDVF
# MC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMK
# AQEwBwYFKw4DAhoDFQAtM12Wjo2xxA5sduzB/3HdzZmiSKCBgzCBgKR+MHwxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6TYOgTAi
# GA8yMDIzMTIyNzAyNDYyNVoYDzIwMjMxMjI4MDI0NjI1WjB0MDoGCisGAQQBhFkK
# BAExLDAqMAoCBQDpNg6BAgEAMAcCAQACAhh1MAcCAQACAhL6MAoCBQDpN2ABAgEA
# MDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAI
# AgEAAgMBhqAwDQYJKoZIhvcNAQELBQADggEBAInW45/nMaNAWycsBlEXEaS/kDBv
# TkkOQ8gXNurs2DkGf0cDYtvTb4tgt7q1GvFU8sRnvDnZ1QkKpltv7/hw0GZwNw4Y
# clhFdZxH6NzJkH4LpnHtOhmtMdiotKHj4y2YAgeCuXeOmtSa/KuBR0T7r0sLHbv5
# +LxdycgexTzDnQzJ7gUebYMbbeFz15ljwwKKtmGaO1OPivcjQgnRi8ILwbFRgwgK
# NczLEMpjWWoEJVgHXPMwjmNAvzBvyIHKgi+z/EDDI8ieo2mc9/t8DCoJd8QZeYId
# i6YGgMXueGezc/NQpXc68/egbcOJ1Pyx6HMcZHxDCIiki6RWu4mi6k1VIDQxggQN
# MIIECQIBATCBkzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
# MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9u
# MSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAdTk
# 6QMvwKxprAABAAAB1DANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0G
# CyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCAL5e0pzCVPHexr9b3BSpxKVhja
# D4aiQA8Nve3qqLkwujCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIMzqh/rY
# FKXOlzvWS5xCtPi9aU+fBUkxIriXp2WTPWI3MIGYMIGApH4wfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTACEzMAAAHU5OkDL8CsaawAAQAAAdQwIgQgBYEYWujQ
# pUcyoe5r15nRgVWWzS28zu99C6hRCEFVjbUwDQYJKoZIhvcNAQELBQAEggIAayrh
# 92/M4pwx7nvox/JL56RJ/UVeST6LOMx9Z9URc6JGD4GHHxfbGJsu7HIBr3s+9Nu2
# heH43gyLB9c+ONpnU8yMPIwyBrknw9RdqmLfZKU6uzZILGWAMdzihO5dgHL7BXcv
# adzsMD4xVLnpCmgknEICgS5WxGV7ofS7mtNs0fKXcF7Z2WRmEcurrrNd+IzNjumW
# cje7KMUBrE0Mo+0MohfzNAEHSkcGXFjy8i84tw1W4yiS1cA0JPkcZHATnhj2T5Q8
# 3y1gLb9zPUNnC9EUhVS7lgNdyFwy+SAMe5JI8q7xljfY0nt+64Q6W4PJ7nTEUekZ
# 7Zd4cBjlW1YVra4/IdXtVbFkpUS9gsV/ruybdco4TvQwhzxJKzkc/352OdexlpoG
# GptLc1+CBRwSAk7F5riV+IiVKjFUq25ooi1QOJj+IVsg6jguXI8kXY8WlVrxOTKU
# DNhH+z//4aVpC/K9gA28Tmdojh9adtpL+PSqdMRK8Qb3VyOYQCIRCEW5KEYY8Div
# dx/41uLfyLf4vCwzpC0nLe5IOYat+r+C1tMgMhpb7B6GR2zDNhtofxsZ6NMwTHSN
# Z+JePLz9eTXyzUVAkdZ1KWbmZ1HWpTo8DJNa+04CZn8B1cvgJvrA67UomCizsjYA
# mOVnnZY/uNzagn5Z7bxS5udNfj/n1bXaqfUCmeY=
# SIG # End signature block
