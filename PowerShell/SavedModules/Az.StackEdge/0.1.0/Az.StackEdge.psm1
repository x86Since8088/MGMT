#
# Script module for module 'Az.StackEdge' that is executed when 'Az.StackEdge' is imported in a PowerShell session.
#
# Generated by: Microsoft Corporation
#
# Generated on: 05/13/2020 09:27:13
#

$PSDefaultParameterValues.Clear()
Set-StrictMode -Version Latest

function Test-DotNet
{
    try
    {
        if ((Get-PSDrive 'HKLM' -ErrorAction Ignore) -and (-not (Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\' -ErrorAction Stop | Get-ItemPropertyValue -ErrorAction Stop -Name Release | Where-Object { $_ -ge 461808 })))
        {
            throw ".NET Framework versions lower than 4.7.2 are not supported in Az.  Please upgrade to .NET Framework 4.7.2 or higher."
        }
    }
    catch [System.Management.Automation.DriveNotFoundException]
    {
        Write-Verbose ".NET Framework version check failed."
    }
}

if ($true -and ($PSEdition -eq 'Desktop'))
{
    if ($PSVersionTable.PSVersion -lt [Version]'5.1')
    {
        throw "PowerShell versions lower than 5.1 are not supported in Az. Please upgrade to PowerShell 5.1 or higher."
    }

    Test-DotNet
}

if ($true -and ($PSEdition -eq 'Core'))
{
    if ($PSVersionTable.PSVersion -lt [Version]'6.2.4')
    {
        throw "Current Az version doesn't support PowerShell Core versions lower than 6.2.4. Please upgrade to PowerShell Core 6.2.4 or higher."
    }
}

if (Test-Path -Path "$PSScriptRoot\StartupScripts" -ErrorAction Ignore)
{
    Get-ChildItem "$PSScriptRoot\StartupScripts" -ErrorAction Stop | ForEach-Object {
        . $_.FullName
    }
}

if (Get-Module AzureRM.profile -ErrorAction Ignore)
{
    Write-Warning ("AzureRM.Profile already loaded. Az and AzureRM modules cannot be imported in the same session or used in the same script or runbook. If you are running PowerShell in an environment you control you can use the 'Uninstall-AzureRm' cmdlet to remove all AzureRm modules from your machine. " +
        "If you are running in Azure Automation, take care that none of your runbooks import both Az and AzureRM modules. More information can be found here: https://aka.ms/azps-migration-guide.")
    throw ("AzureRM.Profile already loaded. Az and AzureRM modules cannot be imported in the same session or used in the same script or runbook. If you are running PowerShell in an environment you control you can use the 'Uninstall-AzureRm' cmdlet to remove all AzureRm modules from your machine. " +
        "If you are running in Azure Automation, take care that none of your runbooks import both Az and AzureRM modules. More information can be found here: https://aka.ms/azps-migration-guide.")
}

$preloadPath = (Join-Path $PSScriptRoot -ChildPath "PreloadAssemblies")
if($PSEdition -eq 'Desktop' -and (Test-Path $preloadPath -ErrorAction Ignore))
{
    try
    {
        Get-ChildItem -ErrorAction Stop -Path $preloadPath -Filter "*.dll" | ForEach-Object {
            try
            {
                Add-Type -Path $_.FullName -ErrorAction Ignore | Out-Null
            }
            catch {
                Write-Verbose $_
            }
        }
    }
    catch {}
}

$netCorePath = (Join-Path $PSScriptRoot -ChildPath "NetCoreAssemblies")
if($PSEdition -eq 'Core' -and (Test-Path $netCorePath -ErrorAction Ignore))
{
    try
    {
        $loadedAssemblies = ([System.AppDomain]::CurrentDomain.GetAssemblies() | ForEach-Object {New-Object -TypeName System.Reflection.AssemblyName -ArgumentList $_.FullName} )
        Get-ChildItem -ErrorAction Stop -Path $netCorePath -Filter "*.dll" | ForEach-Object {
            $assemblyName = ([System.Reflection.AssemblyName]::GetAssemblyName($_.FullName))
            $matches = ($loadedAssemblies | Where-Object {$_.Name -eq $assemblyName.Name})
            if (-not $matches)
            {
                try
                {
                    Add-Type -Path $_.FullName -ErrorAction Ignore | Out-Null
                }
                catch {
                    Write-Verbose $_
                }
            }
        }
    }
    catch {}
}


$module = Get-Module Az.Accounts 
if ($module -ne $null -and $module.Version.ToString().CompareTo("1.7.5") -lt 0) 
{ 
    Write-Error "This module requires Az.Accounts version 1.7.5. An earlier version of Az.Accounts is imported in the current PowerShell session. Please open a new session before importing this module. This error could indicate that multiple incompatible versions of the Azure PowerShell cmdlets are installed on your system. Please see https://aka.ms/azps-version-error for troubleshooting information." -ErrorAction Stop 
} 
elseif ($module -eq $null) 
{ 
    Import-Module Az.Accounts -MinimumVersion 1.7.5 -Scope Global 
}
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath Microsoft.Azure.PowerShell.Cmdlets.StackEdge.dll)


if (Test-Path -Path "$PSScriptRoot\PostImportScripts" -ErrorAction Ignore)
{
    Get-ChildItem "$PSScriptRoot\PostImportScripts" -ErrorAction Stop | ForEach-Object {
        . $_.FullName
    }
}

$FilteredCommands = @('New-AzStackEdgeUser:ResourceGroupName','New-AzStackEdgeStorageAccountCredential:ResourceGroupName','New-AzStackEdgeShare:ResourceGroupName','New-AzStackEdgeRole:ResourceGroupName','New-AzStackEdgeOrder:ResourceGroupName','New-AzStackEdgeStorageContainer:ResourceGroupName','New-AzStackEdgeStorageAccount:ResourceGroupName','New-AzStackEdgeDevice:ResourceGroupName','New-AzStackEdgeBandwidthSchedule:ResourceGroupName')

if ($Env:ACC_CLOUD -eq $null)
{
    $FilteredCommands | ForEach-Object {

        $existingDefault = $false
        foreach ($key in $global:PSDefaultParameterValues.Keys)
        {
    	    if ($_ -like "$key")
    	        {
        	    $existingDefault = $true
    	        }
	    }

        if (!$existingDefault)
        {
            $global:PSDefaultParameterValues.Add($_,
                {
                    if ((Get-Command Get-AzContext -ErrorAction Ignore) -eq $null)
                    {
                        $context = Get-AzureRmContext
                    }
                    else
                    {
                        $context = Get-AzContext
                    }
                    if (($context -ne $null) -and $context.ExtendedProperties.ContainsKey("Default Resource Group")) {
                        $context.ExtendedProperties["Default Resource Group"]
                    }
                })
        }
    }
}

# SIG # Begin signature block
# MIIjhQYJKoZIhvcNAQcCoIIjdjCCI3ICAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCD6nlGYVUONqvWu
# N+0uy5UQ4hyKUrWA3NAIV0BOhOQmk6CCDYEwggX/MIID56ADAgECAhMzAAABh3IX
# chVZQMcJAAAAAAGHMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjAwMzA0MTgzOTQ3WhcNMjEwMzAzMTgzOTQ3WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDOt8kLc7P3T7MKIhouYHewMFmnq8Ayu7FOhZCQabVwBp2VS4WyB2Qe4TQBT8aB
# znANDEPjHKNdPT8Xz5cNali6XHefS8i/WXtF0vSsP8NEv6mBHuA2p1fw2wB/F0dH
# sJ3GfZ5c0sPJjklsiYqPw59xJ54kM91IOgiO2OUzjNAljPibjCWfH7UzQ1TPHc4d
# weils8GEIrbBRb7IWwiObL12jWT4Yh71NQgvJ9Fn6+UhD9x2uk3dLj84vwt1NuFQ
# itKJxIV0fVsRNR3abQVOLqpDugbr0SzNL6o8xzOHL5OXiGGwg6ekiXA1/2XXY7yV
# Fc39tledDtZjSjNbex1zzwSXAgMBAAGjggF+MIIBejAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUhov4ZyO96axkJdMjpzu2zVXOJcsw
# UAYDVR0RBEkwR6RFMEMxKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1
# ZXJ0byBSaWNvMRYwFAYDVQQFEw0yMzAwMTIrNDU4Mzg1MB8GA1UdIwQYMBaAFEhu
# ZOVQBdOCqhc3NyK1bajKdQKVMFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY0NvZFNpZ1BDQTIwMTFfMjAxMS0w
# Ny0wOC5jcmwwYQYIKwYBBQUHAQEEVTBTMFEGCCsGAQUFBzAChkVodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRzL01pY0NvZFNpZ1BDQTIwMTFfMjAx
# MS0wNy0wOC5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAgEAixmy
# S6E6vprWD9KFNIB9G5zyMuIjZAOuUJ1EK/Vlg6Fb3ZHXjjUwATKIcXbFuFC6Wr4K
# NrU4DY/sBVqmab5AC/je3bpUpjtxpEyqUqtPc30wEg/rO9vmKmqKoLPT37svc2NV
# BmGNl+85qO4fV/w7Cx7J0Bbqk19KcRNdjt6eKoTnTPHBHlVHQIHZpMxacbFOAkJr
# qAVkYZdz7ikNXTxV+GRb36tC4ByMNxE2DF7vFdvaiZP0CVZ5ByJ2gAhXMdK9+usx
# zVk913qKde1OAuWdv+rndqkAIm8fUlRnr4saSCg7cIbUwCCf116wUJ7EuJDg0vHe
# yhnCeHnBbyH3RZkHEi2ofmfgnFISJZDdMAeVZGVOh20Jp50XBzqokpPzeZ6zc1/g
# yILNyiVgE+RPkjnUQshd1f1PMgn3tns2Cz7bJiVUaqEO3n9qRFgy5JuLae6UweGf
# AeOo3dgLZxikKzYs3hDMaEtJq8IP71cX7QXe6lnMmXU/Hdfz2p897Zd+kU+vZvKI
# 3cwLfuVQgK2RZ2z+Kc3K3dRPz2rXycK5XCuRZmvGab/WbrZiC7wJQapgBodltMI5
# GMdFrBg9IeF7/rP4EqVQXeKtevTlZXjpuNhhjuR+2DMt/dWufjXpiW91bo3aH6Ea
# jOALXmoxgltCp1K7hrS6gmsvj94cLRf50QQ4U8Qwggd6MIIFYqADAgECAgphDpDS
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
# RcBCyZt2WwqASGv9eZ/BvW1taslScxMNelDNMYIVWjCCFVYCAQEwgZUwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMQITMwAAAYdyF3IVWUDHCQAAAAABhzAN
# BglghkgBZQMEAgEFAKCBrjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgK7o4drup
# WdCX/q2/kgJBpQ2yfGRAi6gc0xS8uoRuQmgwQgYKKwYBBAGCNwIBDDE0MDKgFIAS
# AE0AaQBjAHIAbwBzAG8AZgB0oRqAGGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbTAN
# BgkqhkiG9w0BAQEFAASCAQB2vOxHUhz2xwFkhdE0AVsZgziarKLo6FmYZskg/nU5
# 9QHN7jG3jrDTTJ2Ukz5NF14sXfChikOc2Q7Uujtzn4dmoFJ7Xrbu9pg5+imnTR7U
# Qq2Edhzon7qSei0POFR2R84g/xPEFB65fakg6sC7ZSeGVoGV8Y/pJYYk62WnAFMR
# iMA9gwZOoTQYZoF+5pftGYCTzQ2ZBuAnZwbl0CQWwuMZjZ2k399fvlCAD+c0MrN4
# 4WibmjduGbhCn/zD3iAEjNg4EwFk6HAREWFbS0MFNkQMtpEfxhcvWVMLbscvX+DF
# ZRmRjzimqtXUAsZ6eZvJ6aJwHNw/N61rQi6tHKw9UUeeoYIS5DCCEuAGCisGAQQB
# gjcDAwExghLQMIISzAYJKoZIhvcNAQcCoIISvTCCErkCAQMxDzANBglghkgBZQME
# AgEFADCCAVAGCyqGSIb3DQEJEAEEoIIBPwSCATswggE3AgEBBgorBgEEAYRZCgMB
# MDEwDQYJYIZIAWUDBAIBBQAEIJAob+b8SMOzyH3voJ6Cpb7I4boRaYxZJIn7ZM3J
# 0NdEAgZeows8JLYYEjIwMjAwNTEzMDk0NTUzLjczWjAEgAIB9KCB0KSBzTCByjEL
# MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
# bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWlj
# cm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEmMCQGA1UECxMdVGhhbGVzIFRTUyBF
# U046N0JGMS1FM0VBLUI4MDgxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFNlcnZpY2Wggg48MIIE8TCCA9mgAwIBAgITMwAAAR9OJc2sCvS4HwAAAAABHzAN
# BgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
# bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
# aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAeFw0x
# OTExMTMyMTQwNDFaFw0yMTAyMTEyMTQwNDFaMIHKMQswCQYDVQQGEwJVUzETMBEG
# A1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWlj
# cm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBP
# cGVyYXRpb25zMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjo3QkYxLUUzRUEtQjgw
# ODElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZTCCASIwDQYJ
# KoZIhvcNAQEBBQADggEPADCCAQoCggEBAKVMD8xW9z8cjH9OOjC1hQrRcJQqc7tc
# D4tunKdEGMWtfcm2z5wxftcZY0NaeqV4/oTy00CILFf8SwJw6Cp0Rpqt+y+HklUl
# 4DJgkw2mS2VMCYtw8rEIHQl/LsKPnJ5XxnxQmdDs0yFYI7eMGtaFrapINHifv4eA
# nohn3Un68/Q7PaP85/FVqX87HFu7xxYwJk915AE5d2dVCFcYm0g4ThkvnzRG/LcH
# duEZ/qgaYrUalS2yRny2pCDI/XDkV14b2FhsgkH8rj5ljymkNfeImYqli/7P/Qll
# uft/NfvuzkWvWqrTpg8kQk1Q7xrS0yGZ7AP1iA+0kFcV4KvLuWLbCLMCAwEAAaOC
# ARswggEXMB0GA1UdDgQWBBQVox8AOjATYwQ3ZSJbK8E2ifrgwDAfBgNVHSMEGDAW
# gBTVYzpcijGQ80N7fEYbxTNoWoVtVTBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8v
# Y3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNUaW1TdGFQQ0Ff
# MjAxMC0wNy0wMS5jcmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRw
# Oi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1RpbVN0YVBDQV8yMDEw
# LTA3LTAxLmNydDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMIMA0G
# CSqGSIb3DQEBCwUAA4IBAQCY0UfA3GTiymKryc6Jz1HELAvZfz8LveDL/u5fF9QV
# tvsyhKgA0/aICQ9zqe3AIN8d8em2hC+qsOIcDglN3VlBJsQEuoTulnfBXYv6FGZT
# OKnrAol/dQ2eT/cV4hA89VF0MW2ZGPyoHoCQCOAjskCLaS8pRoJpsefF9cuYGFFJ
# pcxB2MAnt1GCwpugBNqjfv00OdYcpYpuwTUerNsKiBCYBSxstdWYEiToubUOQaiz
# ofsCLWEaq6GUdECDTU2dPildKspm2p2KiDInxm3OTPXzXPn9kTZxuDGbzAH7CFFZ
# av9zIa1jf5AyoL7e78dCyPzn4NZXBTxT48H7is2LamxEMIIGcTCCBFmgAwIBAgIK
# YQmBKgAAAAAAAjANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlm
# aWNhdGUgQXV0aG9yaXR5IDIwMTAwHhcNMTAwNzAxMjEzNjU1WhcNMjUwNzAxMjE0
# NjU1WjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYD
# VQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBAKkdDbx3EYo6IOz8E5f1+n9plGt0VBDVpQoAgoX7
# 7XxoSyxfxcPlYcJ2tz5mK1vwFVMnBDEfQRsalR3OCROOfGEwWbEwRA/xYIiEVEMM
# 1024OAizQt2TrNZzMFcmgqNFDdDq9UeBzb8kYDJYYEbyWEeGMoQedGFnkV+BVLHP
# k0ySwcSmXdFhE24oxhr5hoC732H8RsEnHSRnEnIaIYqvS2SJUGKxXf13Hz3wV3Ws
# vYpCTUBR0Q+cBj5nf/VmwAOWRH7v0Ev9buWayrGo8noqCjHw2k4GkbaICDXoeByw
# 6ZnNPOcvRLqn9NxkvaQBwSAJk3jN/LzAyURdXhacAQVPIk0CAwEAAaOCAeYwggHi
# MBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBTVYzpcijGQ80N7fEYbxTNoWoVt
# VTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0T
# AQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvXzpoYxDBWBgNV
# HR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9w
# cm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYIKwYBBQUHAQEE
# TjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2Nl
# cnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNydDCBoAYDVR0gAQH/BIGVMIGS
# MIGPBgkrBgEEAYI3LgMwgYEwPQYIKwYBBQUHAgEWMWh0dHA6Ly93d3cubWljcm9z
# b2Z0LmNvbS9QS0kvZG9jcy9DUFMvZGVmYXVsdC5odG0wQAYIKwYBBQUHAgIwNB4y
# IB0ATABlAGcAYQBsAF8AUABvAGwAaQBjAHkAXwBTAHQAYQB0AGUAbQBlAG4AdAAu
# IB0wDQYJKoZIhvcNAQELBQADggIBAAfmiFEN4sbgmD+BcQM9naOhIW+z66bM9TG+
# zwXiqf76V20ZMLPCxWbJat/15/B4vceoniXj+bzta1RXCCtRgkQS+7lTjMz0YBKK
# dsxAQEGb3FwX/1z5Xhc1mCRWS3TvQhDIr79/xn/yN31aPxzymXlKkVIArzgPF/Uv
# eYFl2am1a+THzvbKegBvSzBEJCI8z+0DpZaPWSm8tv0E4XCfMkon/VWvL/625Y4z
# u2JfmttXQOnxzplmkIz/amJ/3cVKC5Em4jnsGUpxY517IW3DnKOiPPp/fZZqkHim
# bdLhnPkd/DjYlPTGpQqWhqS9nhquBEKDuLWAmyI4ILUl5WTs9/S/fmNZJQ96LjlX
# dqJxqgaKD4kWumGnEcua2A5HmoDF0M2n0O99g/DhO3EJ3110mCIIYdqwUB5vvfHh
# AN/nMQekkzr3ZUd46PioSKv33nJ+YWtvd6mBy6cJrDm77MbL2IK0cs0d9LiFAR6A
# +xuJKlQ5slvayA1VmXqHczsI5pgt6o3gMy4SKfXAL1QnIffIrE7aKLixqduWsqdC
# osnPGUFN4Ib5KpqjEWYw07t0MkvfY3v1mYovG8chr1m1rtxEPJdQcdeh0sVV42ne
# V8HR3jDA/czmTfsNv11P6Z0eGTgvvM9YBS7vDaBQNdrvCScc1bN+NR4Iuto229Nf
# j950iEkSoYICzjCCAjcCAQEwgfihgdCkgc0wgcoxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVyaWNhIE9w
# ZXJhdGlvbnMxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNOOjdCRjEtRTNFQS1CODA4
# MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMKAQEwBwYF
# Kw4DAhoDFQDUL0SWtlr8GKpK0dgWAw6LEl5JDKCBgzCBgKR+MHwxCzAJBgNVBAYT
# AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYD
# VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBU
# aW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBBQUAAgUA4mXtEzAiGA8yMDIw
# MDUxMzExNTA0M1oYDzIwMjAwNTE0MTE1MDQzWjB3MD0GCisGAQQBhFkKBAExLzAt
# MAoCBQDiZe0TAgEAMAoCAQACAiPqAgH/MAcCAQACAhHsMAoCBQDiZz6TAgEAMDYG
# CisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAIAgEA
# AgMBhqAwDQYJKoZIhvcNAQEFBQADgYEAQwmt0gvsfIiROUOonKQqtIh0q+gPjv0X
# 3rOvdSP01KSgqOolynKgeaccQOtnKue8oOa/6f1siNjc/lftCGvVcRAoqo7IJFd+
# dyGjjz7yovNajmHBgESjOC6n/tWVziU/ap3AyX25UzuH+7rY0uOm1hneDgEJQVRX
# rWOXp8CrSSoxggMNMIIDCQIBATCBkzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0Eg
# MjAxMAITMwAAAR9OJc2sCvS4HwAAAAABHzANBglghkgBZQMEAgEFAKCCAUowGgYJ
# KoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCA82OyL61jG
# XoPqwhBnAEqfFPeqHU/w3oaJKqPIyFcM/zCB+gYLKoZIhvcNAQkQAi8xgeowgecw
# geQwgb0EIKqlcPcAW3/5O//TcVjn49HhCC0nJgcjRNV+31bBPoOlMIGYMIGApH4w
# fDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
# ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMd
# TWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAEfTiXNrAr0uB8AAAAA
# AR8wIgQgqo9QKgGDmDF7rdT1O/NiexO1QY5NYFGIxaepLsRDHMQwDQYJKoZIhvcN
# AQELBQAEggEAMyjblYaIaVQPrPCIWz8TcDTuFpzP+jtFmR2xd1M++N/qbiwHzhln
# SoeI6g5lKDQzmmrYe5LMA0RJ4PRjr1qn4Ty/2oENQA9UIse1FMjqIkaJWrEaUcCm
# iakjHURePmYgDXzyDDlcbGs1eJfb71jQSYx9Xjlo2cojEq9hiflgCXw9n5sUFOt/
# 3Rci45KcROpuStBSf3GnhPYFfXLyuf16vM4gW0OaMFZ691vzAetd8SIkYZTh5KFh
# B6v8Dn/a+n2rtu6eg+e4c1O9IXX+cvsE7LQFjXLZnKjIn49yPYPGm91EewluGBcj
# TkmtBWp5ntDz2kp+t37pCUSD7D8Dj3zjHg==
# SIG # End signature block
