
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

<#
.Synopsis
Returns a BotService specified by the parameters.
.Description
Returns a BotService specified by the parameters.
.Link
https://learn.microsoft.com/powershell/module/az.botservice/export-azbotserviceapp
#>
function Export-AzBotServiceApp {
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.BotService.Models.Api20220615Preview.IBot])]
    [CmdletBinding(PositionalBinding=$false)]
    param(
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.BotService.Category('Path')]
        [System.String]
        # The name of the Bot resource group in the user subscription.
        ${ResourceGroupName},
    
        [Alias('BotName')]
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.BotService.Category('Path')]
        [System.String]
        # The name of the Bot resource.
        ${Name},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.BotService.Category('Path')]
        [System.String]
        ${SavePath},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.BotService.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.BotService.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
        [System.String[]]
        # Azure Subscription ID.
        ${SubscriptionId},
    
        [Parameter()]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.BotService.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.BotService.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.BotService.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.BotService.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.BotService.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.BotService.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.BotService.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.BotService.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.BotService.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
    )
    
    process {
        try {
            $EnvPSBoundParameters = @{}
            if ($PSBoundParameters.ContainsKey('Debug')) {
                $EnvPSBoundParameters['Debug'] = $Debug
            }
            if ($PSBoundParameters.ContainsKey('HttpPipelineAppend')) {
                $EnvPSBoundParameters['HttpPipelineAppend'] = $HttpPipelineAppend
            }
            if ($PSBoundParameters.ContainsKey('HttpPipelinePrepend')) {
                $EnvPSBoundParameters['HttpPipelinePrepend'] = $HttpPipelinePrepend
            }
            if ($PSBoundParameters.ContainsKey('Proxy')) {
                $EnvPSBoundParameters['Proxy'] = $Proxy
            }
            if ($PSBoundParameters.ContainsKey('ProxyCredential')) {
                $EnvPSBoundParameters['ProxyCredential'] = $ProxyCredential
            }
            if ($PSBoundParameters.ContainsKey('ProxyUseDefaultCredentials')) {
                $EnvPSBoundParameters['ProxyUseDefaultCredentials'] = $ProxyUseDefaultCredentials
            }
            $BotService = Get-AzBotService -ResourceGroupName $ResourceGroupName -Name $Name @EnvPSBoundParameters
            if ('bot' -eq $BotService.Kind)
            {
                throw "Source download is not supported for registration only bots."
            }
            if (-not $PSBoundParameters.ContainsKey('SavePath'))
            {
                $SavePath = '.'
                Write-Host 'Parameter $SavePath not provided, defaulting to current working directory.'
            }
            $SavePath = Resolve-Path -Path $SavePath
            if (-not (Get-Item $SavePath) -is [System.IO.DirectoryInfo])
            {
                throw "SavePath is not a valid directory."
            }
            DownloadBotZip -ResourceGroupName $ResourceGroupName -Name $Name -SavePath $SavePath -EnvParameters $EnvPSBoundParameters

        } catch {
            throw
        }
    }
}

function DownloadBotZip
{
    [Microsoft.Azure.PowerShell.Cmdlets.BotService.DoNotExportAttribute()]
    param(
        [Parameter()]
        [System.String]
        # The name of the Bot resource group in the user subscription.
        ${ResourceGroupName},
        [Parameter()]
        [System.String]
        # The name of the Bot resource.
        ${Name},
        [Parameter()]
        [System.String]
        # The path to save your bot.
        ${SavePath},
        [Parameter()]
        [hashtable]
        ${EnvParameters}
    )
    process {
        $WebApp = Get-AzWebApp -ResourceGroupName $ResourceGroupName -Name $Name @EnvParameters
        foreach ($HostNameSslState in $WebApp.HostNameSslStates)
        {
            if ('Repository' -eq $HostNameSslState.HostType)
            {
                $HostName = $HostNameSslState.Name
                $ScmUrl = "https://$HostName"
                $PublishingProfileInfo = [xml](Get-AzWebAppPublishingProfile -ResourceGroupName $ResourceGroupName -Name $Name @EnvParameters)
                foreach ($publishProfile in $PublishingProfileInfo.publishData.publishProfile)
                {
                    if ('MSDeploy' -eq $publishProfile.publishMethod)
                    {
                        $Username = $publishProfile.userName
                        $UserPWD = $publishProfile.userPWD
                        $JWT = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${Username}:${UserPWD}"))
                        $OctetHeader = @{'content-type' = 'application/octet-stream'; 'authorization' = "Basic $JWT"}
                        $NeedToPackSourceCode = $False
                        try {
                            $Response = Invoke-WebRequest -Method Get -Headers $OctetHeader -Uri "$ScmUrl/api/zip/site/clirepo/"
                            
                            if (200 -ne $Response.StatusCode)
                            {
                                $NeedToPackSourceCode = $True
                            }
                        }
                        catch {
                            $NeedToPackSourceCode = $True
                        }
                        if ($NeedToPackSourceCode)
                        {
                            $Payload = @{
                                "command" = "PostDeployScripts\\prepareSrc.cmd $userPWD";
                                "dir" = "site\wwwroot"
                            }
                            $Body = ConvertTo-Json $Payload
                            $JsonHeader = @{'content-type' = 'application/json'; 'authorization' = "Basic $JWT"}
                            $PrepareSrcResponse = Invoke-WebRequest -Method Post -Headers $JsonHeader -Uri "$ScmUrl/api/command" -Body $Body
                            if (200 -ne $PrepareSrcResponse.StatusCode)
                            {
                                throw "Fail to pack the source code into bot-src.zip."
                            }
                        }
                        $DownloadPath = [System.IO.Path]::Combine($SavePath, $Name)
                        if (Test-Path -Path $DownloadPath)
                        {
                            throw "The path $DownloadPath already exists. Please delete this folder or specify an alternate path."
                        }
                        New-Item -Path $DownloadPath -ItemType Directory
                        $ZipPath = [System.IO.Path]::Combine($SavePath, 'download.zip')
                        $Response = Invoke-WebRequest -Method Get -Headers $OctetHeader -Uri "$ScmUrl/api/vfs/site/bot-src.zip" -OutFile $ZipPath
                        Expand-Archive -Path $ZipPath -DestinationPath $DownloadPath
                        Remove-Item -Path $ZipPath
                        return
                    }
                }
                throw "Cannot find web deploy profile for $Name."
            }
        }
        throw 'Failed to retrieve Scm Uri'
    }
}
# SIG # Begin signature block
# MIInoQYJKoZIhvcNAQcCoIInkjCCJ44CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCc++lBlJTbLtq+
# f5JNdxlKLKgXx6Itof/pXxAuKxJkOaCCDYEwggX/MIID56ADAgECAhMzAAACzI61
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
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgaHUvKeqj
# Hq8YjKe2Txr3TwaR1nKsGdOMbd5Fiqe7nj0wQgYKKwYBBAGCNwIBDDE0MDKgFIAS
# AE0AaQBjAHIAbwBzAG8AZgB0oRqAGGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbTAN
# BgkqhkiG9w0BAQEFAASCAQCE0ueKyHAY3PBZorBhx2e/pELMLpCHwD9KmWEg3scZ
# tNLnCHa1ddvzkY0C3ZMO+JcFl3Ts5D7eMH0Fu4nVbJDhE4WS9NuOYDSII/98vwLQ
# q++dkWqJdBxnuPMEdXBB/Enkap+Fr1Cd+BS7hPpbslVkmBN+sv2fnV5SEful1mbK
# 0tk+GRXZMMXvnc6MaSRknDIC5wt7D7o4F/BDmsbwDPz/cVd2okuhK2v00vnQfv3X
# dUV58ZqXD7+prIYVLmbzPJn47dYi+YXjK3dZW5o4lTGkOkBI9Yd4rPK0wNrrtFWL
# 51wbwwVJo0NUL5DaAS9GgGkMyVPB0cXRgZeR709X6ANkoYIXADCCFvwGCisGAQQB
# gjcDAwExghbsMIIW6AYJKoZIhvcNAQcCoIIW2TCCFtUCAQMxDzANBglghkgBZQME
# AgEFADCCAVEGCyqGSIb3DQEJEAEEoIIBQASCATwwggE4AgEBBgorBgEEAYRZCgMB
# MDEwDQYJYIZIAWUDBAIBBQAEID8cMQ9/Lty5KVAOZG27w3E/DG3G7TRXil1oR7ij
# AGZ5AgZjbSXVhiMYEzIwMjIxMjAxMTAxNTI3LjUxOVowBIACAfSggdCkgc0wgcox
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
# BgkqhkiG9w0BAQUFAAIFAOcyqpwwIhgPMjAyMjEyMDExMjIyNTJaGA8yMDIyMTIw
# MjEyMjI1MlowdzA9BgorBgEEAYRZCgQBMS8wLTAKAgUA5zKqnAIBADAKAgEAAgIO
# TwIB/zAHAgEAAgIRpDAKAgUA5zP8HAIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgor
# BgEEAYRZCgMCoAowCAIBAAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBBQUA
# A4GBABVgoWCJGl+EAx3zBOrY6Alo1BQGX9fIiCoDnj8Rd5Vlm13sym3a13A7/Ze+
# VLyFEm9+8W4R+ZiXnRSfEEtvJ2Lf8Cf2MY7EcBOdT9PugZ+cz11sn/hBzE4FO4tY
# +56IMJg0UPEIOSbu2VuftzIZJXEr4fEEiHwh25rvE8H4b7+/MYIEDTCCBAkCAQEw
# gZMwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
# B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UE
# AxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAG+9CCi7pbWINYA
# AQAAAb4wDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0B
# CRABBDAvBgkqhkiG9w0BCQQxIgQgz3AO52gJvw1tOGuqLeopcrqOpXI5L9mgpBoK
# OqcbPYAwgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCCU7oqvrfb87L1ltc+u
# EQ+J00CD8V5/srdJmD4PGOEMLzCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFBDQSAyMDEwAhMzAAABvvQgou6W1iDWAAEAAAG+MCIEICvzzYrn51d8YXGkRsa2
# BmTD0jxsUAOnz7kyfIiY7d62MA0GCSqGSIb3DQEBCwUABIICAJWlO22DQl/ixXOK
# GKgcbdkZsu57MndduVsYvLf8iTP75LSAiESuzoTeb067j0ErNAOog1Y/S8PYEyin
# 9k2uEXEqaFZikgILL1r/kgaTwiUP3X1ytHHAzUDp+xv5vcmm+h2AGMxs4vn2XvXz
# 2NgFm/CUmAZ/cr3q7/aWoHUxzcDvJmK2D9OGRYKWSaSF4VRmkDAt8RFBhCGUX4+Y
# 6x4ggz8/DnDUbZ+0PQ5Q0+qSI4GjQXm8zASLHPLhkGJ1ikDyGrAiQOyY8WSLB5js
# IWsaDWIXicSud62sf8EfB+d9OUXwC0I8rc6+65XgLKiraUrIcZy4ZiRYaR1zTqva
# 3E1AoCLH7DovdEIq2G7M/T8fKAPVHwdMbeUAn/nL4NF/owt4EEbowmIXZXdELfuI
# rL/i0eP31wtLH+dXWmH/rvuiSctgbczIf5EhEgEfKoHLl7AwnJn2HbFusJu74Pd1
# 2ZyAzoytbXIHm0XhSvTd0NKzcP07MXxm+wE3tvtFvs/5PBJIZgRO+0ecQImtJLWV
# felzqVSd2RVSvSKJbVWXxGOI5PVWYyUISvsi0iGXCFAkt6ABqTNTM9jgOKjBsegv
# 7qRP+i7YbyhFhj7g35X1Wvu4B+KcZcPH2XYK4wcAsEPaSFE+vEMw+AFLxssSpeVO
# ydPQn9YXcQWDox5MgBzPSBjikiK6
# SIG # End signature block
