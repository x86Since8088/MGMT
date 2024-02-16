# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------

function Install-AzModuleInternal {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [ModuleInfo[]]
        ${ModuleList},

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        ${Repository},

        [Parameter()]
        [Switch]
        ${AllowPrerelease},

        [Parameter(Mandatory)]
        [ValidateSet('CurrentUser', 'AllUsers')]
        [string]
        ${Scope},

        [Parameter()]
        [Switch]
        ${RemovePrevious},

        [Parameter()]
        [Switch]
        ${Force},

        [Parameter()]
        [string]
        ${Invoker},

        [Parameter()]
        [Switch]
        ${DontClean}
    )

    process {

        try {
            Write-Progress -Id $script:FixProgressBarId "Download packages from $Repository."
            $RepositoryUrl = Get-RepositoryUrl $Repository

            if ($Force -or !$WhatIfPreference) {
                [string]$tempRepo = Join-Path ([Path]::GetTempPath()) ((New-Guid).Guid)
                #$tempRepo = Join-Path 'D:/PSLocalRepo/' (Get-Date -Format "yyyyddMM-HHmm")
                if (Test-Path -Path $tempRepo) {
                    Microsoft.PowerShell.Management\Remove-Item -Path $tempRepo -Recurse -WhatIf:$false
                }
                $null = Microsoft.PowerShell.Management\New-Item -ItemType Directory -Path $tempRepo -WhatIf:$false
                Write-Debug "[$Invoker] The repository folder $tempRepo is created."

                $null = PowerShellGet\Unregister-PSRepository -Name $script:AzTempRepoName -ErrorAction 'SilentlyContinue'
                $null = PowerShellGet\Register-PSRepository -Name $script:AzTempRepoName -SourceLocation $tempRepo -ErrorAction 'Stop' -ErrorVariable +errorRecords
                PowerShellGet\Set-PSRepository -Name $script:AzTempRepoName -InstallationPolicy Trusted
                Write-Debug "[$Invoker] The temporary repository $script:AzTempRepoName is registered."

                $InstallStarted = Get-Date
                $downloader = [ParallelDownloader]::new($RepositoryUrl)

                try {
                    $module = $null
                    $fileList = @()
                    foreach ($module in $ModuleList) {
                        Write-Debug "[$Invoker] Downloading $($module.Name) version $($module.Version)."
                        $filePath = $downloader.Download($module.Name, [string] $module.Version, $tempRepo)
                        $fileList += @{
                            Name = $module.Name
                            Path = $filePath
                        }
                    }
                    $downloader.WaitForAllTasks()
                    $file = $null
                    foreach ($file in $fileList) {
                        if (!(Test-Path -Path $file.Path)) {
                            Throw "[$Invoker] Fail to download $($file.Name) to $tempRepo. Please check your network connection and retry."
                        }
                    }
                    $durationInstallation = (Get-Date) - $InstallStarted
                    Write-Debug "[$Invoker] All download tasks are finished. Time Elapsed Total:$($durationInstallation.TotalSeconds)s."
                }
                finally {
                    $downloader.Dispose()
                }
            }

            Write-Progress -Id $script:FixProgressBarId  "Install packages from local."

            $moduleInstalled = @()

            $InstallStarted = Get-Date
            Write-Debug "[$Invoker] Will install modules $($ModuleList.Name)."
            $installModuleParams = @{
                Scope = $Scope
                Repository = $script:AzTempRepoName
                AllowClobber = $true
                Confirm = $false
                ErrorAction = 'Stop'
                SkipPublisherCheck = $true
                AllowPrerelease = if ($AllowPrerelease) {$AllowPrerelease} else {$false}
            }

            $modules = [Array] $moduleList
            if ($modules[0].Name -eq 'Az.Accounts') {
                $confirmInstallation = $Force -or $PSCmdlet.ShouldProcess("Install module Az.Accounts version $($modules[0].Version)", "Az.Accounts version $($modules[0].Version)", "Install")
                $confirmUninstallation = $false
                if ($RemovePrevious) {
                    $confirmUninstallation = $Force -or $PSCmdlet.ShouldProcess("Remove previously installed Az.Accounts", "Az.Accounts", 'Remove')
                }
                if ($confirmInstallation) {
                    if ($confirmUninstallation) {
                        PowerShellGet\Uninstall-Module -Name "Az.Accounts" -AllVersion -AllowPrerelease -ErrorAction 'SilentlyContinue'
                    }
                    PowerShellGet\Install-Module @installModuleParams -Name "Az.Accounts" -RequiredVersion "$($modules[0].Version)"
                    Update-ModuleInstallationRepository -ModuleName "Az.Accounts" -InstalledVersion "$($modules[0].Version)" -Repository $Repository
                }
                $moduleInstalled += [PSCustomObject]@{
                    Name = "Az.Accounts"
                    Version = ($modules[0].Version | Select-Object -First 1)
                }
                $modules = [Array] ($modules | Select-Object -Last ($modules.Length - 1))
            }

            try
            {
                $jobs = @()
                $module = $null
                $maxJobCount = 5
                $index = 0
                $functions = {
                    function Install-SingleModule {
                        param (
                            [Parameter(Mandatory)]
                            [ValidateNotNullOrEmpty()]
                            [string]
                            ${ModuleName},

                            [Parameter(Mandatory)]
                            [ValidateNotNullOrEmpty()]
                            [version[]]
                            ${ModuleVersion},

                            [Parameter()]
                            [Switch]
                            ${RemovePrevious},

                            [Parameter(Mandatory)]
                            [ValidateNotNullOrEmpty()]
                            [hashtable]
                            ${InstallModuleParam}
                        )

                        process {
                            $state = $null
                            $errorString = $null
                            try {
                                Import-Module PackageManagement
                                Import-Module PowerShellGet -MinimumVersion 2.1.3 -MaximumVersion 3.0.0.0 -Scope Global
                                if ($RemovePrevious) {
                                    PowerShellGet\Uninstall-Module -Name $moduleName -AllVersion -AllowPrerelease -ErrorAction 'SilentlyContinue'
                                }
                                PowerShellGet\Install-Module @installModuleParam -Name $moduleName -RequiredVersion "$moduleVersion"
                                $state = "succeeded"
                            }
                            catch {
                                $state = "failed"
                                $errorString = $_
                                Write-Error $errorString -ErrorVariable +errorRecords
                            }
                            finally {
                                Write-Output @{
                                    "ModuleName" = $moduleName
                                    "ModuleVersion" = $moduleVersion
                                    "Result" = $state
                                    "Error" = $errorString
                                }
                            }
                        }
                    }
                }
                $index = 1
                $module = $null
                foreach ($module in $modules) {
                    if ($PSVersionTable.PSEdition -eq "Core") {
                        $confirmInstallation = $Force -or $PSCmdlet.ShouldProcess("Install module $($module.Name) version $($module.Version)", "$($module.Name) version $($module.Version)", "Install")
                        $confirmUninstallation = $false
                        if ($RemovePrevious) {
                            $confirmUninstallation = $Force -or $PSCmdlet.ShouldProcess("Remove previously installed $($module.Name)", "$($module.Name)", 'Remove')
                        }
                        if ($confirmInstallation) {
                            $jobs  += Start-ThreadJob -Name "Az.Tools.Installer" -InitializationScript $functions -ScriptBlock {
                                $tmodule = $using:module
                                $tInstallModuleParam = $using:installModuleParams
                                $result = Install-SingleModule -ModuleName $tmodule.Name -ModuleVersion $tmodule.Version -InstallModuleParam $tInstallModuleParam -RemovePrevious:($using:confirmUninstallation)
                                Write-Output $result
                            } -ThrottleLimit $maxJobCount
                        }
                    }
                    else {
                        $runningJob = @()
                        $runningJob += Get-Job -State Running
                        if ($runningJob -and ($runningJob.Count -ge $maxJobCount)) {
                            Get-Job -State Running | Wait-Job -Any -Timeout 120 | Out-Null
                            $runningJob = @()
                            $runningJob += Get-Job -State Running
                            if ($runningJob -and ($runningJob.Count -ge $maxJobCount)) {
                                Throw "[$Invoker] You have enough background jobs currently. Please use 'Get-Job -State Running' to check them."
                            }
                        }
                        $confirmInstallation = $Force -or $PSCmdlet.ShouldProcess("Install module $($module.Name) version $($module.Version)", "$($module.Name) version $($module.Version)", "Install")
                        $confirmUninstallation = $false
                        if ($RemovePrevious) {
                            $confirmUninstallation = $Force -or $PSCmdlet.ShouldProcess("Remove previously installed $($module.Name)", "$($module.Name)", 'Remove')
                        }
                        if ($confirmInstallation) {
                            $jobs += Start-Job -Name "Az.Tools.Installer"  -InitializationScript $functions -ScriptBlock {
                                $tmodule = $using:module
                                $tInstallModuleParam = $using:installModuleParams
                                $result = Install-SingleModule -ModuleName $tmodule.Name -ModuleVersion $tmodule.Version -InstallModuleParam $tInstallModuleParam -RemovePrevious:($using:confirmUninstallation)
                                Write-Output $result
                            }
                            Write-Progress -ParentId $script:FixProgressBarId -Activity "Install Module" -Status "$($module.Name) version $($module.Version)" -PercentComplete ($index / $modules.Count * 100)
                            $index += 1
                        }
                    }
                }

                if ($Force -or !$WhatIfPreference) {
                    $result = $null
                    $job = $null
                    $index = 1
                    foreach ($job in $jobs) {
                        $job = Wait-Job $job
                        $result = $null
                        $result = Receive-Job $job
                        if ($job.State -eq 'Completed' -and $result.Result -eq "succeeded") {
                            Write-Debug  "[$Invoker] Installing $($result.ModuleName) of version $($result.ModuleVersion) is complete."
                            $moduleInstalled += [PSCustomObject]@{
                                Name = $result.ModuleName
                                Version = ($result.ModuleVersion | Select-Object -First 1)
                            }
                            Update-ModuleInstallationRepository -ModuleName $result.ModuleName -InstalledVersion $result.ModuleVersion[0] -Repository $Repository
                        }
                        else {
                            Write-Error "[$Invoker] Installing $($result.ModuleName) of version $($result.ModuleVersion) is failed. `n$($result.Error)"
                        }
                        Remove-Job $job -Confirm:$false
                        if ($PSVersionTable.PSEdition -eq "Core") {
                            Write-Progress -ParentId $script:FixProgressBarId -Activity "Install Module" -Status "$($result.ModuleName) of version $($result.ModuleVersion)" -PercentComplete ($index / $jobs.Count * 100)
                            $index += 1
                        }
                    }
                    Write-Output $moduleInstalled
                }
            }
            finally
            {
                $jobs = Get-Job -Name "Az.Tools.Installer" -ErrorAction 'SilentlyContinue'
                if ($jobs) {
                    Stop-Job $jobs
                    Remove-Job $jobs -Confirm:$false
                }
            }

            $durationInstallation = (Get-Date) - $InstallStarted
            Write-Debug "[$Invoker] All installing tasks are completed; Time Elapsed Total: $($durationInstallation.TotalSeconds)s."
        }
        finally {
            if ($Force -or !$WhatIfPreference) {
                if (!$DontClean) {
                    Write-Debug "[$Invoker] The temporary repository $script:AzTempRepoName is unregistered."
                    $null = PowerShellGet\Unregister-PSRepository -Name $script:AzTempRepoName -ErrorAction 'Continue'

                    Write-Debug "[$Invoker] The Repository folder $tempRepo is removed."
                    if (Test-Path -Path $tempRepo) {
                        Microsoft.PowerShell.Management\Remove-Item -Path $tempRepo -Recurse -WhatIf:$false
                    }
                }
            }
        }
    }
}

# SIG # Begin signature block
# MIIoPAYJKoZIhvcNAQcCoIIoLTCCKCkCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAfQYB61hJPt10z
# wJqDg8k/+BqcqOzxbh1927jNgXA4dKCCDYUwggYDMIID66ADAgECAhMzAAADTU6R
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
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIJ8k
# Tk2MWvJcS/XmaFlQzkO45xoMbeC0YmICzTp8GSXxMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAmE/1wWMFU2llGwMuQAiuMgKAgZmNYEK+HwCO
# M/Mm7B16wQal+PvWW39AAmSviXEN+UueDJnEOIob8EOfNDe7xlSyCoBFrf4pvK7w
# K92WIKvlm5u0kbLpKFlQ6HDc37Tf7D0UINbp6GyxRblyzNZ6nxcg6Dlu9QyOOlkd
# 1YKX949HJiBC8otS9MsaJbtJSp5aJMDW41d9d8vdt7sWaaEvftaBQuhhPvstuZ28
# /lhyEri0n/lLnhfuxskOjhW/R7RmCCLzSgM6C0sU6k16W2FO16s2MrTUXL4IdVIj
# vDOhj2XNaRjbki+AFhrwDrg6HZjfD3XsFtIYLpaDy8OV3d7aqqGCF5cwgheTBgor
# BgEEAYI3AwMBMYIXgzCCF38GCSqGSIb3DQEHAqCCF3AwghdsAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFSBgsqhkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCAtFz1K6F7fjzHxGT1NQ5nrE8tgToBYIjsN
# GTEzeOiQpAIGZShw8raPGBMyMDIzMTExNDA5MTA1Ni44NTdaMASAAgH0oIHRpIHO
# MIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQL
# ExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxk
# IFRTUyBFU046QTAwMC0wNUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1l
# LVN0YW1wIFNlcnZpY2WgghHtMIIHIDCCBQigAwIBAgITMwAAAdB3CKrvoxfG3QAB
# AAAB0DANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MDAeFw0yMzA1MjUxOTEyMTRaFw0yNDAyMDExOTEyMTRaMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046QTAwMC0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Uw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDfMlfn35fvM0XAUSmI5qiG
# 0UxPi25HkSyBgzk3zpYO311d1OEEFz0QpAK23s1dJFrjB5gD+SMw5z6EwxC4CrXU
# 9KaQ4WNHqHrhWftpgo3MkJex9frmO9MldUfjUG56sIW6YVF6YjX+9rT1JDdCDHbo
# 5nZiasMigGKawGb2HqD7/kjRR67RvVh7Q4natAVu46Zf5MLviR0xN5cNG20xwBwg
# ttaYEk5XlULaBH5OnXz2eWoIx+SjDO7Bt5BuABWY8SvmRQfByT2cppEzTjt/fs0x
# p4B1cAHVDwlGwZuv9Rfc3nddxgFrKA8MWHbJF0+aWUUYIBR8Fy2guFVHoHeOze7I
# sbyvRrax//83gYqo8c5Z/1/u7kjLcTgipiyZ8XERsLEECJ5ox1BBLY6AjmbgAzDd
# Nl2Leej+qIbdBr/SUvKEC+Xw4xjFMOTUVWKWemt2khwndUfBNR7Nzu1z9L0Wv7TA
# Y/v+v6pNhAeohPMCFJc+ak6uMD8TKSzWFjw5aADkmD9mGuC86yvSKkII4MayzoUd
# seT0nfk8Y0fPjtdw2Wnejl6zLHuYXwcDau2O1DMuoiedNVjTF37UEmYT+oxC/OFX
# UGPDEQt9tzgbR9g8HLtUfEeWOsOED5xgb5rwyfvIss7H/cdHFcIiIczzQgYnsLyE
# GepoZDkKhSMR5eCB6Kcv/QIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFDPhAYWS0oA+
# lOtITfjJtyl0knRRMB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8G
# A1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMv
# Y3JsL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBs
# BggrBgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0
# LmNvbS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
# MDIwMTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUH
# AwgwDgYDVR0PAQH/BAQDAgeAMA0GCSqGSIb3DQEBCwUAA4ICAQCXh+ckCkZaA06S
# NW+qxtS9gHQp4x7G+gdikngKItEr8otkXIrmWPYrarRWBlY91lqGiilHyIlZ3iNB
# UbaNEmaKAGMZ5YcS7IZUKPaq1jU0msyl+8og0t9C/Z26+atx3vshHrFQuSgwTHZV
# pzv7k8CYnBYoxdhI1uGhqH595mqLvtMsxEN/1so7U+b3U6LCry5uwwcz5+j8Oj0G
# UX3b+iZg+As0xTN6T0Qa8BNec/LwcyqYNEaMkW2VAKrmhvWH8OCDTcXgONnnABQH
# BfXK/fLAbHFGS1XNOtr62/iaHBGAkrCGl6Bi8Pfws6fs+w+sE9r3hX9Vg0gsRMoH
# RuMaiXsrGmGsuYnLn3AwTguMatw9R8U5vJtWSlu1CFO5P0LEvQQiMZ12sQSsQAkN
# DTs9rTjVNjjIUgoZ6XPMxlcPIDcjxw8bfeb4y4wAxM2RRoWcxpkx+6IIf2L+b7gL
# HtBxXCWJ5bMW7WwUC2LltburUwBv0SgjpDtbEqw/uDgWBerCT+Zty3Nc967iGaQj
# yYQH6H/h9Xc8smm2n6VjySRx2swnW3hr6Qx63U/xY9HL6FNhrGiFED7ZRKrnwvvX
# vMVQUIEkB7GUEeN6heY8gHLt0jLV3yzDiQA8R8p5YGgGAVt9MEwgAJNY1iHvH/8v
# zhJSZFNkH8svRztO/i3TvKrjb8ZxwjCCB3EwggVZoAMCAQICEzMAAAAVxedrngKb
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
# Y2EgT3BlcmF0aW9uczEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOkEwMDAtMDVF
# MC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMK
# AQEwBwYFKw4DAhoDFQC8t8hT8KKUX91lU5FqRP9Cfu9MiaCBgzCBgKR+MHwxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6P0dYTAi
# GA8yMDIzMTExMzIyMTA0MVoYDzIwMjMxMTE0MjIxMDQxWjB3MD0GCisGAQQBhFkK
# BAExLzAtMAoCBQDo/R1hAgEAMAoCAQACAhV3AgH/MAcCAQACAhLEMAoCBQDo/m7h
# AgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSCh
# CjAIAgEAAgMBhqAwDQYJKoZIhvcNAQELBQADggEBAJiuhun0CnexZeo295brhGAm
# NXDrqymDR63IjMDR/vITPVTU46Ia4l6mV3H0y6xyjdIuZTE7E4YdlPwfNEgZVSWs
# w0F2QiMn7prRbuG8x4BgJlHHlkRIZGNCTDCh/XM+H01KnkdT4h68cGyDEUxj6q12
# uwxegSUiiK/gIiSKv/+s8Nwx3flAb5j2knPsW+Bj7qAaTZIIOiIqmmKTFjikn1m4
# njlIaRfZr3XrS0DKFkRhI2BhcxFKRTC12ji9EVfZ6LG3m1sg67/W1Fc1L5aiGd/E
# Bn+nJH25sJ6P1NwJJHOHRqFYMC9MlBze6LvjnAJ1/jTbADUuoaBPAqQKzQ6Kkpcx
# ggQNMIIECQIBATCBkzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
# bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
# aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAA
# AdB3CKrvoxfG3QABAAAB0DANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkD
# MQ0GCyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCCHhxoicSVDmJGCxV9a87j2
# l+I77TVRC/Ta63z8aRc+UjCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIAiV
# QAZftNP/Md1E2Yw+fBXa9w6fjmTZ5WAerrTSPwnXMIGYMIGApH4wfDELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAHQdwiq76MXxt0AAQAAAdAwIgQgFUe0
# cfcXOFPApSjiszMaap+pyARpiAJTN0r9sqCYy6QwDQYJKoZIhvcNAQELBQAEggIA
# Ks8sIZGkhIcbbMCF3SvuQjL2grarj3DEt5wgN1NsEKU38GXPl2AvsD/E1Qnum8NG
# y/9Q5AKOTA5gZPlk8Y3/928hra8D8G520TgFE0iha6mne3SXmgjOWB1QheE6EtQm
# UILCB9/XwMqgF6N3bmHs2VX6FHWkLkMMEaBjICyjnj6nCXEb02ToDeEXEREHKdxc
# CFWXgbQpwemopUIvIdy1b7N9WPpLKp3M0jO3j78646nTLH3h3BjgNSUryHjORFdE
# rwZHpbFRyhF+kqNr83cFDSCBzar4KRt2HEBdqFrVeir8U+h0d2GNOP3gZ6jImyxh
# yNHSBSyZkrwxokg8NrVK/y9BFQoTQCk60+7voyt4wShpXUreRgA+QQFF+duuqaFf
# qoKh5SOuhVuw1y/yvc1gSevRsToq/97i3HQH9P+LrecuMkImYCO38Ia48jn+gjPO
# XELLgYuFGkNB1WsZT/J4gLhTD6VoEe9DU63UgxKGk20r7WIq1pJ4tGUfb8C7e7kc
# qWNt1Kn5n//Qe7hdmwYCFrihbcarfLOag0bP/EYv5Rf2h8dkiX6gK7CqYfZxyQHP
# bN+lhe33tnX08G46nhH8nDW4qV6DxkpTWL7+FB5om5ae45XiANjiT3fCE+L3/3o/
# bgFv1xKrv0RJcp8RWtC591qFXM0qyhqVYIYYC7W2b2A=
# SIG # End signature block
