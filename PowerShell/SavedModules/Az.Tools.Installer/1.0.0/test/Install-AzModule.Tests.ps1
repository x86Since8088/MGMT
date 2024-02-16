param(
  [Parameter()]
  [string] $Repository = "PSGallery"
)

$helper = Join-Path $PSScriptRoot 'Az.Tools.Installer.Tests.Helper'
. $helper

$ProgressPreference = 'SilentlyContinue'

Describe 'Install-AzModule' {
    BeforeAll {
        Get-PSRepository $Repository | Should -Not -Be $null
    }

    BeforeEach {
        Remove-AllAzModule
    }

    It 'InstallByName' {
        $output = Install-AzModule -Name storage,neTwork,compute,Az.keyvault -RequiredAzVersion 6.3 -Repository PSGallery -Scope 'CurrentUser'
        $output.Count | Should -Be 5
        $modules = Get-AzSubModule
        $modules.Count | Should -Be 5
        $modules.Name | Should -Contain 'Az.Accounts'
        $modules.Name | Should -Contain 'Az.Storage'
        $modules.Name | Should -Contain 'Az.Network'
        $modules.Name | Should -Contain 'Az.Compute'
        $modules.Name | Should -Contain 'Az.KeyVault'

        $allmoduleInstalled = @('Az.Accounts', 'Az.Storage', 'Az.Network', 'Az.Compute', 'Az.KeyVault')
        (Get-InstalledModule -Name $allmoduleInstalled).Repository | Sort-Object -Unique | Should -Be 'PSGallery'
    }

    It 'InstallByNamePrerelease' {
        $output = Install-AzModule -Name storage,neTwork,maps,Az.keyvault -Repository PSGallery -AllowPrerelease
        $output.Count | Should -Be 5
        $modules = Get-AzSubModule
        $modules.Count | Should -Be 5
        $modules.Name | Should -Contain 'Az.Accounts'
        $modules.Name | Should -Contain 'Az.Storage'
        $modules.Name | Should -Contain 'Az.Network'
        $modules.Name | Should -Contain 'Az.Maps'
        $modules.Name | Should -Contain 'Az.KeyVault'

        $allmoduleInstalled = @('Az.Accounts', 'Az.Storage', 'Az.Network', 'Az.Maps', 'Az.KeyVault')
        (Get-InstalledModule -Name $allmoduleInstalled).Repository | Sort-Object -Unique | Should -Be 'PSGallery'

        $output = Install-AzModule -Repository PSGallery -Name keyvault,resources,storage -RemovePrevious
        $output.Count | Should -Be 4
        $modules = Get-AzSubModule
        $modules.Count | Should -Be 6
        $modules.Name | Should -Contain 'Az.Accounts'
        $modules.Name | Should -Contain 'Az.Storage'
        $modules.Name | Should -Contain 'Az.Network'
        $modules.Name | Should -Contain 'Az.Maps'
        $modules.Name | Should -Contain 'Az.KeyVault'
        $modules.Name | Should -Contain 'Az.Resources'

        $allmoduleInstalled = @('Az.Accounts', 'Az.Storage', 'Az.Network', 'Az.Maps', 'Az.KeyVault', 'Az.Resources')
        (Get-InstalledModule -Name $allmoduleInstalled).Repository | Sort-Object -Unique | Should -Be 'PSGallery'
    }

    It 'InstallByNameLatest' {
        $output = Install-AzModule -Name storage,maps -Repository PSGallery
        $output.Count | Should -Be 2
        $modules = Get-AzSubModule
        $modules.Count | Should -Be 2
        $modules.Name | Should -Contain 'Az.Accounts'
        $modules.Name | Should -Contain 'Az.Storage'

        $allmoduleInstalled = @('Az.Accounts', 'Az.Storage')
        (Get-InstalledModule -Name $allmoduleInstalled).Repository | Sort-Object -Unique | Should -Be 'PSGallery'
    }

    It 'InstallAllGA' {
        $output = Install-AzModule -Repository PSGallery -UseExactAccountVersion -RequiredAzVersion 6.3
        $azModule = Find-Module -Name Az -Repository PSGallery -RequiredVersion 6.3
        $output.Count | Should -Be $azModule.Dependencies.Count
        $modules = Get-AzSubModule
        $modules.Count | Should -Be $azModule.Dependencies.Count
        $expectedVersion = [Version] ($azModule.Dependencies | Where-Object {$_.Name -eq 'Az.Accounts'})['MinimumVersion']
        ($modules | Where-Object {$_.Name -eq 'Az.Accounts'}).Version | Should -Be $expectedVersion

        (Get-InstalledModule -Name 'Az.Accounts').Repository | Should -Be 'PSGallery'
    }

    It 'InstallByUnexistingName' {
        $output = [Array] (Install-AzModule -Name fakeModule -Repository PSGallery)
        $output.Count | Should -Be 0
        $modules = Get-AzSubModule
        $modules.Count | Should -Be 0
    }

    It 'InstallAndRemoveAzureRm' {
        Install-Module -Name AzureRm -Repository PSGallery
        $output = [Array] (Install-AzModule -Name accounts -Repository PSGallery -RemoveAzureRm)
        $output.Count | Should -Be 1
        (Get-AzSubModule).Name | Should -Be 'Az.Accounts'
        Get-InstalledModule -Name Azure* -ErrorAction 'Continue' | Should -Be $null

        (Get-InstalledModule -Name 'Az.Accounts').Repository | Should -Be 'PSGallery'
    }

    It 'InstallByUnexistingVersion' {
        {Install-AzModule -AllowPrerelease -Repository PSGallery -RequiredAzVersion 5.9} | Should -Throw
    }

    It 'InstallByUri' {
        $output = [Array] (Install-AzModule -Path "https://azposhpreview.blob.core.windows.net/public/Az.Accounts.2.12.3.nupkg")
        $output.Count | Should -Be 1

        $package = Join-Path $PSScriptRoot "resources"
        $package = Join-Path $package "az.storage.5.4.2-preview.nupkg"
        $output = [Array] (Install-AzModule -Path $package)
        $output.Count | Should -Be 1

        $modules = Get-AzSubModule
        $modules.Count | Should -Be 2
        $modules.Name | Should -Contain 'Az.Accounts'
        $modules.Name | Should -Contain 'Az.Storage'
    }

    It 'InstallWithoutRepository' {
        $repos = [Array](Get-PSRepository | Where-Object {$_.Name -ne 'PSGallery'})
        if ($repos -ne $null) {
            $repos | Unregister-PSRepository
        }
        try {
            $output = Install-AzModule -Name storage,neTwork -RequiredAzVersion 6.3 -Scope 'CurrentUser'
            $output.Count | Should -Be 3
            $modules = Get-AzSubModule
            $modules.Count | Should -Be 3
            $modules.Name | Should -Contain 'Az.Accounts'
            $modules.Name | Should -Contain 'Az.Storage'
            $modules.Name | Should -Contain 'Az.Network'

            $allmoduleInstalled = @('Az.Accounts', 'Az.Storage', 'Az.Network')
            (Get-InstalledModule -Name $allmoduleInstalled).Repository | Sort-Object -Unique | Should -Be 'PSGallery'
        }
        finally {
            foreach ($repo in $repos) {
                if ($repo.Name -ne 'PSGallery') {
                    $parameters = @{
                        Name = $repo.Name
                        SourceLocation = $repo.SourceLocation
                        InstallationPolicy = $repo.InstallationPolicy
                    }
                    Register-PSRepository @parameters
                }
            }
        }
    }

    AfterEach {
        Remove-AllAzModule
    }
}

# SIG # Begin signature block
# MIIoPAYJKoZIhvcNAQcCoIIoLTCCKCkCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAewz+wkC+U27OJ
# yqQN+HQdBbZE+8Vwb9hrdFFfpwuXIKCCDYUwggYDMIID66ADAgECAhMzAAADTU6R
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
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIHAw
# HbFobZCqk32wXeT/A1OFiAJa3fqwN5F1n3X/EhzBMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEATZ/UcJWPjN2uf6WbwAA80prvwwIYxvfmlHdS
# 3flF+WNEqCtpQg0OTmYUkD9X1tbSggp7ilC+oLFnN1THuyTELDh2FVdGphkGzAfL
# 29eHhbOg+3+U2QMEEOjMMdLRMkTcBRVkH1FNgrO7gKJiPDPnmvViG/lFd8BwR5cM
# jYjVaArY3/jn1JgIp9q0kDfgTI7WVnhd/QE+eWSigPLQv70QeZyrong5SRHrDzd9
# CmKe3c+x8bIh1sPSyNONL5uG3lE0Qa8qvWBO0oU6bUj3TGInENhkZrgaw8AcVn3p
# xRjCIgizV/K/l96+UzjFkkb28j+lCDhwbiG4nXMj0o7mWvfejaGCF5cwgheTBgor
# BgEEAYI3AwMBMYIXgzCCF38GCSqGSIb3DQEHAqCCF3AwghdsAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFSBgsqhkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCBQTwSYcuapcqd+hekl4IV61XUyvRLPS9Av
# ywpnxuW/EAIGZSivzLZXGBMyMDIzMTExNDA5MTA0OS4xNDVaMASAAgH0oIHRpIHO
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
# c29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6P1bBzAi
# GA8yMDIzMTExNDAyMzM0M1oYDzIwMjMxMTE1MDIzMzQzWjB3MD0GCisGAQQBhFkK
# BAExLzAtMAoCBQDo/VsHAgEAMAoCAQACAjLVAgH/MAcCAQACAhX8MAoCBQDo/qyH
# AgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSCh
# CjAIAgEAAgMBhqAwDQYJKoZIhvcNAQELBQADggEBAAQB9dKMwIsj7EZg9fsL/0F5
# JB++ml+3hQ8SiyTXNHiXV13vZ8KzhCVsk0+o7QumkQ09CkN3241TWXR7ozxMwvMU
# P7g8fbKF3kgVf+c0lmlHgN39HafW1GvzIyrQKWK8gDnqADCw7Kygd+C8YWhuuqf5
# HNod6tNMjNhs9fZ3QVjfaQ8E7k+AGLFIRBmhqfqQUCcTH+yxj8lkhIz/zxTD2adJ
# GlZm/a5sIcoPX7CQR2Mu2cImWvTTvphem630AkIg+F/sVDa0NhLYZStTYYV9pUG+
# c0ZyWmu75aPuwBLOX8Km5sqz+rZ7bOS1FaAMOt0A2XHBKmir8ogQk503R7jFuaQx
# ggQNMIIECQIBATCBkzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
# bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
# aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAA
# AdmcXAWSsINrPgABAAAB2TANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkD
# MQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCDqcxtk64jDnLXhR2TUIm/g
# xA4ZYsecQq2VP1QbLwZl5DCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIJ+g
# FbItOm/UMDAnETzbJe0u0DWd2Mgpgb0ScbQgB3nzMIGYMIGApH4wfDELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAHZnFwFkrCDaz4AAQAAAdkwIgQggwu1
# 8FATrRJ73IsZNapX9SIFDtKB2BHGWBcwUs8uMeswDQYJKoZIhvcNAQELBQAEggIA
# AuyKGneLL75f9PsZE36eniR7dSGQBZ/p6Z3tLNlSz8epqsL33Eu9is7p75Az3iVF
# 1YGfcqJDDrvkR59bVfMT0/7YhrL62TxVAY8z6KvGdXnAgGrAXXQtnFAaxsp1QEMK
# HPWyh2jiPg6N92U0lan2uYrWhsViOoKThXLHGM322f63aqIiD+woBomQ4UTPJPUO
# qW/J54DDcrvoNYNZqA2hb4OpdhWS0PR3tX/fPmRybwAWKJM43zxFvvaLdKd+wDyH
# AatVFn0M9VVvpson97Ym8nhqCfRb7AZ6EsCQ692rHYYfw/neTQAUgtbO1usJxYHU
# pL6mM5+4Iu2s2ypVk0c8FSse7EGOqfSDZEgMPbvpT2w+nqBLV2rwxurQi3P8aUGf
# 8x/fcPfKCrVzWe/HcpmWLM30FvbEOugO/XIDNvSYW2F3GHFWd3jySJPzJY1vyIMo
# 7njcDRlTjZ2OBfgFy9Dqc2pwFPjatMWAIrJuOfsScI8jTwU+Jc7LGM+qercDLN+f
# qK8/I69ruj9gAR4TIV00h7ZLXRPj2ggu1+04UPBNTne8wFsQyF28RNylXXjCSl0e
# 92aswJDQhnxdYDoeBbSwRZ7qTVMAD587rgjwgZCdGwJM4S1gY8yKJ+tadYc7nRj2
# 6zW+PM3zS7QIPbtKVHA2EuyIsysS5/43RS2QqpqnhL8=
# SIG # End signature block
