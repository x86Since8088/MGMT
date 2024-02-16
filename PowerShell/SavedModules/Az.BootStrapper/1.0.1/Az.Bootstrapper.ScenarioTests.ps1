Import-Module -Name Az.Bootstrapper
$RollupModule = 'Az'

# Enable PS Remoting for creating new sessions; This setting is required to create new powershell sessions in Core.
Enable-PSRemoting
$psConfig = Get-PSSessionConfiguration
$psConfigName = $psConfig[0].Name

InModuleScope Az.Bootstrapper {
    $ProfileMap = (Get-AzProfileMap)

    # Helper function to uninstall all profiles
    function Remove-InstalledProfile {
        $installedProfiles = Get-ProfilesInstalled -ProfileMap $ProfileMap
        if ($null -ne $installedProfiles.Keys) {
            foreach ($profile in $installedProfiles.Keys) {
                Write-Host "Removing profile $profile"
                Uninstall-AzProfile -Profile $profile -Force -ErrorAction SilentlyContinue
            }
            
            $profiles = (Get-ProfilesInstalled -ProfileMap $ProfileMap)
            if ($profiles.Count -ne 0) {
                Throw "Uninstallation was not successful: Profile(s) $(@($profiles.Keys) -join ',') were not uninstalled correctly."
            }
        }
    }

    Describe "A machine with no profile installed can install profile" {

        # Using Install-AzProfile
        Context "New Profile Install - 2019-03-01-hybrid" {
            # Arrange
            # Uninstall previously installed profiles
            Remove-InstalledProfile

            # Launch the test in a new powershell session
            # Create a new PS session
            $session = New-PSSession -ComputerName localhost -ConfigurationName $psConfigName
              
            # Keep this for testing private drops
            # Invoke-Command -Session $session -ScriptBlock { Register-PSRepository -Name "azsrepo" -SourceLocation "D:\psrepo" -InstallationPolicy Trusted }
            # Invoke-Command -Session $session -ScriptBlock { Set-BootStrapRepo -Repo azsrepo }

            # Act
            # Install 2019-03-01-hybrid version
            Invoke-Command -Session $session -ScriptBlock { Install-AzProfile -Profile '2019-03-01-hybrid' -Force } 

            # Assert; This test will fail if run on PS 5.1; works only on core due to GMO 'Az' returns empty on 5.1 bug.
            It "Should return 2019-03-01-hybrid Profile" {
                $result = Invoke-Command -Session $session -ScriptBlock { Get-AzApiProfile }
                $result[0].ProfileName.Contains('2019-03-01-hybrid') | Should Be $true
            }

            # Clean up
            Remove-PSSession -Session $session
        } 

        # Using Use-AzProfile
        Context "New Profile Install - 2019-03-01-hybrid using Use-AzProfile" {
            # Arrange
            # Uninstall previously installed profiles
            Remove-InstalledProfile

            # Create a new PS session
            $session = New-PSSession -ComputerName localhost -ConfigurationName $psConfigName

            # Act
            # Install profile '2019-03-01-hybrid'
            # Invoke-Command -Session $session -ScriptBlock { Set-BootStrapRepo -Repo azsrepo }
            Invoke-Command -Session $session -ScriptBlock { Use-AzProfile -Profile '2019-03-01-hybrid' -Force }

            # Assert
            It "Should return 2019-03-01-hybrid" {
                $result = Invoke-Command -Session $session -ScriptBlock { Get-AzApiProfile } 
                $result[0].ProfileName.Contains('2019-03-01-hybrid') | Should Be $true
            }

            # Clean up
            Remove-PSSession -Session $session
        }
    }


    Describe "Attempting to use already installed profile will import the modules to the current session" {
        InModuleScope Az.Bootstrapper {
            Context "Profile 2019-03-01-hybrid is installed" {
                # Should import Latest profile to current session
                # Arrange
                # Create a new PS session
                $session = New-PSSession -ComputerName localhost -ConfigurationName $psConfigName


                # Ensure profile 2019-03-01-hybrid is installed
                $profilesInstalled = Invoke-Command -Session $session -ScriptBlock { Get-AzApiProfile } 
                ($profilesInstalled -like "*hybrid*") -ne $null | Should Be $true

                # Act
                # Invoke-Command -Session $session -ScriptBlock { Set-BootStrapRepo -Repo azsrepo }
                Invoke-Command -Session $session -ScriptBlock { Use-AzProfile -Profile '2019-03-01-hybrid' -Force }

                # Get the version of the 2019-03-01-hybrid profile
                $ProfileMap = Get-AzProfileMap
                $latestVersion = $ProfileMap.'2019-03-01-hybrid'.$RollupModule

                # Assert
                It "Should return Az module 2019-03-01-hybrid version" {
                    # Get-module script block
                    $getModule = {
                        Param($RollupModule)
                        Get-Module -Name $RollupModule 
                    }

                    $modules = Invoke-Command -Session $session -ScriptBlock $getModule -ArgumentList $RollupModule
                
                    $modules.Name | Should Be $RollupModule
                    $modules.version | Should Be $latestVersion
                }

                # Cleanup
                Remove-PSSession -Session $session
            }
        }
    }

    Describe "User can uninstall a profile" {
        InModuleScope Az.Bootstrapper {
            Context "2019-03-01-hybrid profile is installed" {
                # Should uninstall 2019-03-01-hybrid profile
                # Arrange
                # Create a new PS session
                $session = New-PSSession -ComputerName localhost -ConfigurationName $psConfigName

                # Check if '2019-03-01-hybrid' is installed
                # Invoke-Command -Session $session -ScriptBlock { Set-BootStrapRepo -Repo azsrepo }
                $profilesInstalled = Invoke-Command -Session $session -ScriptBlock { Get-AzApiProfile } 
                ($profilesInstalled -like "*hybrid*") -ne $null | Should Be $true

                # Get the version of the Latest profile
                $ProfileMap = Get-AzProfileMap
                $latestVersion = $ProfileMap.'2019-03-01-hybrid'.$RollupModule

                # Act
                Invoke-Command -Session $session -ScriptBlock { Uninstall-AzProfile -Profile '2019-03-01-hybrid' -Force }
            
                # Assert
                It "Profile 2019-03-01-hybrid is uninstalled" {
                    $result = Invoke-Command -Session $session -ScriptBlock { Get-AzApiProfile }
                    if ($result -ne $null) {
                        $result.Contains('2019-03-01-hybrid') | Should Be $false
                    }
                    else {
                        $true
                    }
                }

                It "Available Modules should not contain uninstalled modules" {
                    $getModule = {
                        Param($RollupModule)
                        Get-Module -Name $RollupModule -ListAvailable
                    }
                    $results = Invoke-Command -Session $session -ScriptBlock $getModule -ArgumentList $RollupModule
                    
                    foreach ($result in $results) {
                        $result.Version -eq $latestVersion | Should Be $false
                    }
                        
                }

                # Cleanup
                Remove-PSSession -Session $session
            }
        }
    }

    Describe "Invalid Cases" {
        Context "Install wrong profile name" {
            # Install profile 'abcTest'
            It "Throws Invalid argument error" {
                { Install-AzProfile -Profile 'abcTest' } | Should Throw
            }
        }

        Context "Install null profile name" {
            # Install profile 'null'
            It "Throws Invalid argument error" {
                { Install-AzProfile -Profile $null } | Should Throw
            }
        }

        Context "Install already installed profile" {
            # Arrange
            # Create a new PS session
            $session = New-PSSession -ComputerName localhost -ConfigurationName $psConfigName
            # Invoke-Command -Session $session -ScriptBlock { Set-BootStrapRepo -Repo azsrepo }

            # Ensure profile 2019-03-01-hybrid is installed
            Set-BootStrapRepo -Repo azsrepo
            Install-AzProfile -Profile '2019-03-01-hybrid' -Force
            $installedProfile = Invoke-Command -Session $session -ScriptBlock { Get-AzApiProfile }
            ($installedProfile -like "*hybrid*") -ne $null | Should Be $true
            
            # Act
            # Install profile '2019-03-01-hybrid'
            $result = Invoke-Command -Session $session -ScriptBlock { Install-AzProfile -Profile '2019-03-01-hybrid' -Force } 

            # Get modules imported into the session
            $getModuleList = {
                Param($RollupModule)
                Get-Module -Name $RollupModule
            }
            $modules = Invoke-Command -Session $session -ScriptBlock $getModuleList  -ArgumentList $RollupModule

            It "Doesn't install/import the profile" {
                $result | Should Be $null
                $modules | Should Be $null
            }

            # Cleanup
            Remove-PSSession -Session $session
        }

        Context "Use-AzProfile with wrong profile name" {
            # Install profile 'abcTest'
            It "Throws Invalid argument error" {
                { Use-AzProfile -Profile 'abcTest' } | Should Throw
            }
        }
    }

    Describe "Install profiles using Scope" {
        InModuleScope Az.Bootstrapper {
            Context "Using Install-AzProfile: Scope 'CurrentUser'" {
                # Arrange
                # Create a new PS session
                $session = New-PSSession -ComputerName localhost -ConfigurationName $psConfigName

                # Remove installed profiles
                Remove-InstalledProfile 

                # Act
                # Install profile 2019-03-01-hybrid scope as current user
                # Invoke-Command -Session $session -ScriptBlock { Set-BootStrapRepo -Repo azsrepo }
                Invoke-Command -Session $session -ScriptBlock { Install-AzProfile -Profile '2019-03-01-hybrid' -scope 'CurrentUser' -Force }

                # Assert
                It "Installs & Imports 2019-03-01-hybrid profile to the session" {
                    # Get the version of the Latest profile
                    $ProfileMap = Get-AzProfileMap
                    $latestVersion = $ProfileMap.'2019-03-01-hybrid'.$RollupModule
                    
                    $getModuleList = {
                        Param($RollupModule, $latestVersion)
                        Get-Module -Name $RollupModule -ListAvailable | Where-Object { $_.Version -like $latestVersion }
                    }
                    $modules = Invoke-Command -Session $session -ScriptBlock $getModuleList  -ArgumentList @($RollupModule, $latestVersion)

                    # Are latest modules imported?
                    $modules.Name | Should Be $RollupModule
                    $modules.version | Should Be $latestVersion
                }
            }

            Context "Using Use-AzProfile: Scope 'AllUsers'" {
                # Arrange
                # Create a new PS session
                $session = New-PSSession -ComputerName localhost -ConfigurationName $psConfigName

                # Remove installed profiles
                Remove-InstalledProfile 

                # Act
                # Install profile 2019-03-01-hybrid scope as all users
                # Invoke-Command -Session $session -ScriptBlock { Set-BootStrapRepo -Repo azsrepo }
                Invoke-Command -Session $session -ScriptBlock { Use-AzProfile -Profile '2019-03-01-hybrid' -scope 'AllUsers' -Force }

                # Assert
                It "Installs & Imports 2019-03-01-hybrid profile to the session" {
                    $getModuleList = {
                        Param($RollupModule)
                        Get-Module -Name $RollupModule
                    }
                    $modules = Invoke-Command -Session $session -ScriptBlock $getModuleList  -ArgumentList $RollupModule

                    # Get the version of the 2019-03-01-hybrid profile
                    $ProfileMap = Get-AzProfileMap
                    $version = $ProfileMap.'2019-03-01-hybrid'.$RollupModule
                
                    # Are appropriate modules imported?
                    $modules.Name | Should Be $RollupModule
                    $modules.version | Should Be $version
                }
            }

            Context "Using Update-AzProfile: Scope 'CurrentUser' " {
                # Arrange
                # Create a new PS session
                $session = New-PSSession -ComputerName localhost -ConfigurationName $psConfigName

                # Remove installed profiles
                Remove-InstalledProfile 

                # Act
                # Install profile 2019-03-01-hybrid scope as current user
                # Invoke-Command -Session $session -ScriptBlock { Set-BootStrapRepo -Repo azsrepo }
                Invoke-Command -Session $session -ScriptBlock { Update-AzProfile -Profile '2019-03-01-hybrid' -scope 'CurrentUser' -Force -r }

                # Assert
                It "Installs & Imports 2019-03-01-hybrid profile to the session" {
                    $getModuleList = {
                        Param($RollupModule)
                        Get-Module -Name $RollupModule
                    }
                    $modules = Invoke-Command -Session $session -ScriptBlock $getModuleList  -ArgumentList $RollupModule

                    # Get the version of the 2019-03-01-hybrid profile
                    $ProfileMap = Get-AzProfileMap
                    $version = $ProfileMap.'2019-03-01-hybrid'.$RollupModule
                
                    # Are correct modules imported?
                    $modules.Name | Should Be $RollupModule
                    $modules.version | Should Be $version
                }
            }
        }
    }

    Describe "Load/Import AzProfile modules" {
        InModuleScope Az.Bootstrapper {
            Context "Using Use-AzProfile: Modules are not installed" {
                # Arrange
                # Create a new PS session
                $session = New-PSSession -ComputerName localhost -ConfigurationName $psConfigName

                # Remove installed profiles
                Remove-InstalledProfile 

                # Act
                # Use module from Latest profile scope as current user
                # Invoke-Command -Session $session -ScriptBlock { Set-BootStrapRepo -Repo azsrepo }
                Invoke-Command -Session $session -ScriptBlock { Use-AzProfile -Profile '2019-03-01-hybrid' -Module 'Az.Storage' -Force -scope 'CurrentUser' }

                # Assert
                $RollupModule = 'Az.Storage'
                It "Installs & Imports 2019-03-01-hybrid profile's module to the session" {
                    $getModuleList = {
                        Param($RollupModule)
                        Get-Module -Name $RollupModule
                    }
                    $modules = Invoke-Command -Session $session -ScriptBlock $getModuleList  -ArgumentList $RollupModule

                    # Get the version of the 2019-03-01-hybrid profile
                    $ProfileMap = Get-AzProfileMap
                    $version = $ProfileMap.'2019-03-01-hybrid'.$RollupModule
                
                    # Are 2019-03-01-hybrid modules imported?
                    $modules.Name | Should Be $RollupModule
                    $modules.version | Should Be $version
                }
            }
        }
    }
}
# SIG # Begin signature block
# MIIjkgYJKoZIhvcNAQcCoIIjgzCCI38CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAsoA1Xv4YNIuoZ
# eBrscaEWTb9Y4cJmtI5AttyZ7nzxHKCCDYEwggX/MIID56ADAgECAhMzAAAB32vw
# LpKnSrTQAAAAAAHfMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjAxMjE1MjEzMTQ1WhcNMjExMjAyMjEzMTQ1WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQC2uxlZEACjqfHkuFyoCwfL25ofI9DZWKt4wEj3JBQ48GPt1UsDv834CcoUUPMn
# s/6CtPoaQ4Thy/kbOOg/zJAnrJeiMQqRe2Lsdb/NSI2gXXX9lad1/yPUDOXo4GNw
# PjXq1JZi+HZV91bUr6ZjzePj1g+bepsqd/HC1XScj0fT3aAxLRykJSzExEBmU9eS
# yuOwUuq+CriudQtWGMdJU650v/KmzfM46Y6lo/MCnnpvz3zEL7PMdUdwqj/nYhGG
# 3UVILxX7tAdMbz7LN+6WOIpT1A41rwaoOVnv+8Ua94HwhjZmu1S73yeV7RZZNxoh
# EegJi9YYssXa7UZUUkCCA+KnAgMBAAGjggF+MIIBejAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUOPbML8IdkNGtCfMmVPtvI6VZ8+Mw
# UAYDVR0RBEkwR6RFMEMxKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1
# ZXJ0byBSaWNvMRYwFAYDVQQFEw0yMzAwMTIrNDYzMDA5MB8GA1UdIwQYMBaAFEhu
# ZOVQBdOCqhc3NyK1bajKdQKVMFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY0NvZFNpZ1BDQTIwMTFfMjAxMS0w
# Ny0wOC5jcmwwYQYIKwYBBQUHAQEEVTBTMFEGCCsGAQUFBzAChkVodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRzL01pY0NvZFNpZ1BDQTIwMTFfMjAx
# MS0wNy0wOC5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAgEAnnqH
# tDyYUFaVAkvAK0eqq6nhoL95SZQu3RnpZ7tdQ89QR3++7A+4hrr7V4xxmkB5BObS
# 0YK+MALE02atjwWgPdpYQ68WdLGroJZHkbZdgERG+7tETFl3aKF4KpoSaGOskZXp
# TPnCaMo2PXoAMVMGpsQEQswimZq3IQ3nRQfBlJ0PoMMcN/+Pks8ZTL1BoPYsJpok
# t6cql59q6CypZYIwgyJ892HpttybHKg1ZtQLUlSXccRMlugPgEcNZJagPEgPYni4
# b11snjRAgf0dyQ0zI9aLXqTxWUU5pCIFiPT0b2wsxzRqCtyGqpkGM8P9GazO8eao
# mVItCYBcJSByBx/pS0cSYwBBHAZxJODUqxSXoSGDvmTfqUJXntnWkL4okok1FiCD
# Z4jpyXOQunb6egIXvkgQ7jb2uO26Ow0m8RwleDvhOMrnHsupiOPbozKroSa6paFt
# VSh89abUSooR8QdZciemmoFhcWkEwFg4spzvYNP4nIs193261WyTaRMZoceGun7G
# CT2Rl653uUj+F+g94c63AhzSq4khdL4HlFIP2ePv29smfUnHtGq6yYFDLnT0q/Y+
# Di3jwloF8EWkkHRtSuXlFUbTmwr/lDDgbpZiKhLS7CBTDj32I0L5i532+uHczw82
# oZDmYmYmIUSMbZOgS65h797rj5JJ6OkeEUJoAVwwggd6MIIFYqADAgECAgphDpDS
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
# RcBCyZt2WwqASGv9eZ/BvW1taslScxMNelDNMYIVZzCCFWMCAQEwgZUwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMQITMwAAAd9r8C6Sp0q00AAAAAAB3zAN
# BglghkgBZQMEAgEFAKCBrjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgsiTiilMn
# +iVgLFNod1MtWL0RAZziqPaqyCZxN9mEygYwQgYKKwYBBAGCNwIBDDE0MDKgFIAS
# AE0AaQBjAHIAbwBzAG8AZgB0oRqAGGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbTAN
# BgkqhkiG9w0BAQEFAASCAQCQsZoRbmNuCnjERkdZIa5rJApabB8zA3U+8GgEY+c6
# mCQIhAlTcl+i8FnhaaQzH9DXWq//xgaCX6YNQkXb34gIz5ICMgcZOOofSllYBxK/
# 9esDNXpDY/VGg/kZdak/Rqrz9Uzzi24+znMTtQXSbOIGumr3/A05g6tDbq6UnPE/
# x8ixBYRn1TkKeKZ37SUt/hMZ6tqAt1n93fY8aATc5+N2MfV85djuv630J3UAo71E
# it14abiOTWblLl7CH2MqCDGRJkXH5Bm+i9eCi6hyIOP8nfBwl7TFti6OEND3Wz6r
# E96TlFi+l4y9BjD9HBw5fGzTqxxZRz3VEa1+rJo9lBH+oYIS8TCCEu0GCisGAQQB
# gjcDAwExghLdMIIS2QYJKoZIhvcNAQcCoIISyjCCEsYCAQMxDzANBglghkgBZQME
# AgEFADCCAVUGCyqGSIb3DQEJEAEEoIIBRASCAUAwggE8AgEBBgorBgEEAYRZCgMB
# MDEwDQYJYIZIAWUDBAIBBQAEIHaP3i5xqOqVlLvHwlYIwXXH19t9eIORmsGD0oS+
# XDjMAgZgrruaTaIYEzIwMjEwNjIyMTcxNzQyLjMwNVowBIACAfSggdSkgdEwgc4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKTAnBgNVBAsTIE1p
# Y3Jvc29mdCBPcGVyYXRpb25zIFB1ZXJ0byBSaWNvMSYwJAYDVQQLEx1UaGFsZXMg
# VFNTIEVTTjozMkJELUUzRDUtM0IxRDElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgU2VydmljZaCCDkQwggT1MIID3aADAgECAhMzAAABYtD+AvMB5c1JAAAA
# AAFiMA0GCSqGSIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEw
# MB4XDTIxMDExNDE5MDIyMloXDTIyMDQxMTE5MDIyMlowgc4xCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVy
# YXRpb25zIFB1ZXJ0byBSaWNvMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjozMkJE
# LUUzRDUtM0IxRDElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2Vydmlj
# ZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAO+GodT2ucL3Mr2DQsv2
# ELNbSvKyBpYdUKtUBWiZmFVy18pG/pucgkrc5i9tu8CY7GpWV/CQNmHG2mVeSHMJ
# vbwCc/AAv7JP3bFCt6Zg75IbVSNOGA1eqLbmQiC6UAfSKXLN3dHtQ5diihb3Ymzp
# NP9K0cVPZfv2MXm+ZVU0RES8cyPkXel7+UEGE+kqdiBNDdb8yBXd8sju+90+V4nz
# YC+ZWW7SFJ2FFZlASpVaHpjv+eGohXlQaSBvmM4Q0xe3LhzQM8ViGz9cLeFSKgFf
# SY7qizL7wUg+eqYvDUyjPX8axEQHmk0th23wWH5p0Wduws43qNIo0OQ0mRotBK71
# nykCAwEAAaOCARswggEXMB0GA1UdDgQWBBTLxEoRYEpDtzp84B5WlZN2kP4qazAf
# BgNVHSMEGDAWgBTVYzpcijGQ80N7fEYbxTNoWoVtVTBWBgNVHR8ETzBNMEugSaBH
# hkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNU
# aW1TdGFQQ0FfMjAxMC0wNy0wMS5jcmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUF
# BzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1RpbVN0
# YVBDQV8yMDEwLTA3LTAxLmNydDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsG
# AQUFBwMIMA0GCSqGSIb3DQEBCwUAA4IBAQAtQa3DoXYbW/cXACbcVSFGe4gC8GXs
# FxSHT3JgwFU/NdJOcbkcFTVvTp6vlmTvHm6sIjknRBB0Xi1NBTqPw20u6u/T7Cnc
# /z0gT6mf9crI0VR9C+R1CtjezYKZEdZZ7fuNQWjsyftNDhQy+Rqnqryt0VoezLal
# heiinHzZD/4Y4hZYPf0u8TSv1ZfKtdBweWG3QU0Lp/I9SbIoemDG97RULMcPvq2u
# fhUp3OMiYQGL1WqkykSnqRJsM2IcA4l4dmoPNP6dLg5Dr7NVoYKIMInaQVZjSwDM
# ZhWryvfizX0SrzyLgkMPhLMVkfLxQQSQ37NeFk7F1RfeAkNWAh6mCORBMIIGcTCC
# BFmgAwIBAgIKYQmBKgAAAAAAAjANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJv
# b3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIwMTAwHhcNMTAwNzAxMjEzNjU1WhcN
# MjUwNzAxMjE0NjU1WjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
# bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
# aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDCCASIw
# DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKkdDbx3EYo6IOz8E5f1+n9plGt0
# VBDVpQoAgoX77XxoSyxfxcPlYcJ2tz5mK1vwFVMnBDEfQRsalR3OCROOfGEwWbEw
# RA/xYIiEVEMM1024OAizQt2TrNZzMFcmgqNFDdDq9UeBzb8kYDJYYEbyWEeGMoQe
# dGFnkV+BVLHPk0ySwcSmXdFhE24oxhr5hoC732H8RsEnHSRnEnIaIYqvS2SJUGKx
# Xf13Hz3wV3WsvYpCTUBR0Q+cBj5nf/VmwAOWRH7v0Ev9buWayrGo8noqCjHw2k4G
# kbaICDXoeByw6ZnNPOcvRLqn9NxkvaQBwSAJk3jN/LzAyURdXhacAQVPIk0CAwEA
# AaOCAeYwggHiMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBTVYzpcijGQ80N7
# fEYbxTNoWoVtVTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMC
# AYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvX
# zpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20v
# cGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYI
# KwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNydDCBoAYDVR0g
# AQH/BIGVMIGSMIGPBgkrBgEEAYI3LgMwgYEwPQYIKwYBBQUHAgEWMWh0dHA6Ly93
# d3cubWljcm9zb2Z0LmNvbS9QS0kvZG9jcy9DUFMvZGVmYXVsdC5odG0wQAYIKwYB
# BQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AUABvAGwAaQBjAHkAXwBTAHQAYQB0AGUA
# bQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAAfmiFEN4sbgmD+BcQM9naOh
# IW+z66bM9TG+zwXiqf76V20ZMLPCxWbJat/15/B4vceoniXj+bzta1RXCCtRgkQS
# +7lTjMz0YBKKdsxAQEGb3FwX/1z5Xhc1mCRWS3TvQhDIr79/xn/yN31aPxzymXlK
# kVIArzgPF/UveYFl2am1a+THzvbKegBvSzBEJCI8z+0DpZaPWSm8tv0E4XCfMkon
# /VWvL/625Y4zu2JfmttXQOnxzplmkIz/amJ/3cVKC5Em4jnsGUpxY517IW3DnKOi
# PPp/fZZqkHimbdLhnPkd/DjYlPTGpQqWhqS9nhquBEKDuLWAmyI4ILUl5WTs9/S/
# fmNZJQ96LjlXdqJxqgaKD4kWumGnEcua2A5HmoDF0M2n0O99g/DhO3EJ3110mCII
# YdqwUB5vvfHhAN/nMQekkzr3ZUd46PioSKv33nJ+YWtvd6mBy6cJrDm77MbL2IK0
# cs0d9LiFAR6A+xuJKlQ5slvayA1VmXqHczsI5pgt6o3gMy4SKfXAL1QnIffIrE7a
# KLixqduWsqdCosnPGUFN4Ib5KpqjEWYw07t0MkvfY3v1mYovG8chr1m1rtxEPJdQ
# cdeh0sVV42neV8HR3jDA/czmTfsNv11P6Z0eGTgvvM9YBS7vDaBQNdrvCScc1bN+
# NR4Iuto229Nfj950iEkSoYIC0jCCAjsCAQEwgfyhgdSkgdEwgc4xCzAJBgNVBAYT
# AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYD
# VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKTAnBgNVBAsTIE1pY3Jvc29mdCBP
# cGVyYXRpb25zIFB1ZXJ0byBSaWNvMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjoz
# MkJELUUzRDUtM0IxRDElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2Vy
# dmljZaIjCgEBMAcGBSsOAwIaAxUAmrP6Chrbz0ax7s57n5Pop3VC8gyggYMwgYCk
# fjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQD
# Ex1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQUFAAIF
# AOR8KSswIhgPMjAyMTA2MjIxMzE3MzFaGA8yMDIxMDYyMzEzMTczMVowdzA9Bgor
# BgEEAYRZCgQBMS8wLTAKAgUA5HwpKwIBADAKAgEAAgIcdwIB/zAHAgEAAgIRfDAK
# AgUA5H16qwIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMCoAowCAIB
# AAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBBQUAA4GBAEfbSvpo+tj2QqZ6
# 9xJ1YPzPasO38UMmD0F6rZ8ZJCKgDmlWr751/p1MXYsK6+TcdbXxNFFxwPJOlkH3
# lAqq2jg3DweatebJUnQcrt/o7x8pgzn4SMjTkgSOq6iFlUxYizykaJNlRndoLbcX
# pmRTA1kx0/XzauJdpwfS0N9Qj3aeMYIDDTCCAwkCAQEwgZMwfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTACEzMAAAFi0P4C8wHlzUkAAAAAAWIwDQYJYIZIAWUD
# BAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0B
# CQQxIgQgVEncnRgibXfeuOvjEpw8lfB4Edmqn7Nn3+w/rsjS3AYwgfoGCyqGSIb3
# DQEJEAIvMYHqMIHnMIHkMIG9BCCKqhiV+zwNDrpU7DRB7Mi57xi6GBNYsGjgZqq2
# qVMKMjCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
# MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
# b24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB
# YtD+AvMB5c1JAAAAAAFiMCIEIOGph8zSu2ucwDJL+3tgUP47d6Bhh5Npo8alHELA
# 2cb4MA0GCSqGSIb3DQEBCwUABIIBAGqMwC+iEa6mWNKbKcnDbnd3+73/VUdF34jo
# 9DLkKQjwDhkooulC0y9B0jxvI9FaSVzSdBzvirylIx4t3dFLQg3P3YXikajoqf3j
# iKslAfwuHLr2jVt3yl7y2/hypa0rtHRTdcQn+DWmbg8VZAwxW7h5L+ACV7n12raG
# VeAUF/Wkn94lIZlIfRCG+60oc1cUGwtFei9QDV+uTECafiAVL43ka3mDgbJAXC0a
# 5a0/4hgKRU9KIOkiJIBc47vawfib83rq9z6gxqHlGZmQtDjbJlh1U81Xddcyla7j
# Pr5dDM0M+daL43Po4piTTZLszBdHsqUcSQnmvI8uVXReO4bMPNU=
# SIG # End signature block
