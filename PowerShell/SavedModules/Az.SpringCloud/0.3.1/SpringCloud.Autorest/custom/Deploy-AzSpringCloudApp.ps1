
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
Deploy the build file to an existing deployment.
.Description
Deploy the build file to an existing deployment.
.Example
PS C:\> {{ Add code here }}

{{ Add output here }}
.Example
PS C:\> {{ Add code here }}

{{ Add output here }}

.Outputs
Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Models.Api20220401.IAppResource
.Link
https://learn.microsoft.com/powershell/module/az.SpringCloud/deploy-azSpringCloudapp
#>
function Deploy-AzSpringCloudApp {
[OutputType([Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Models.Api20220401.IAppResource])]
[CmdletBinding(DefaultParameterSetName='DeployAppForStandard', PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
param(
    [Parameter(Mandatory)]
    [Alias('AppName')]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Category('Path')]
    [System.String]
    # The name of the App resource.
    ${Name},

    [Parameter(Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Category('Path')]
    [System.String]
    # The name of the resource group that contains the resource.
    # You can obtain this value from the Azure Resource Manager API or the portal.
    ${ResourceGroupName},

    [Parameter(Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Category('Path')]
    [System.String]
    # The name of the Service resource.
    ${ServiceName},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Category('Path')]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
    [System.String]
    # Gets subscription ID which uniquely identify the Microsoft Azure subscription.
    # The subscription ID forms part of the URI for every service call.
    ${SubscriptionId},


    [Parameter(Mandatory, HelpMessage='The path of the file need to be deploied. The file supports Jar, NetcoreZip and Source.')]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Category('Path')]
    [System.String]
    # The path of the file need to be deploied. The file supports Jar, NetcoreZip and Source.
    ${FilePath},

    [Parameter(Mandatory, ParameterSetName = "DeployAppForEnterprise", HelpMessage='The resource id of builder to build the source code.')]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Category('Path')]
    [System.String]
    # The path of the file need to be deploied. The file supports Jar, NetcoreZip and Source.
    ${BuilderId},

    [Parameter(Mandatory, ParameterSetName = "DeployAppForEnterprise", HelpMessage='The resource id of agent pool.')]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Category('Path')]
    [System.String]
    # The path of the file need to be deploied. The file supports Jar, NetcoreZip and Source.
    ${AgentPoolId},

    [Parameter()]
    [Alias('AzureRMContext', 'AzureCredential')]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Category('Azure')]
    [System.Management.Automation.PSObject]
    # The credentials, account, tenant, and subscription used for communication with Azure.
    ${DefaultProfile},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Run the command as a job
    ${AsJob},

    [Parameter(DontShow)]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Wait for .NET debugger to attach
    ${Break},

    [Parameter(DontShow)]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Category('Runtime')]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Runtime.SendAsyncStep[]]
    # SendAsync Pipeline Steps to be appended to the front of the pipeline
    ${HttpPipelineAppend},

    [Parameter(DontShow)]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Category('Runtime')]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Runtime.SendAsyncStep[]]
    # SendAsync Pipeline Steps to be prepended to the front of the pipeline
    ${HttpPipelinePrepend},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Run the command asynchronously
    ${NoWait},

    [Parameter(DontShow)]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Category('Runtime')]
    [System.Uri]
    # The URI for the proxy server to use
    ${Proxy},

    [Parameter(DontShow)]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Category('Runtime')]
    [System.Management.Automation.PSCredential]
    # Credentials for a proxy server to use for the remote call
    ${ProxyCredential},

    [Parameter(DontShow)]
    [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Use the default credentials for the proxy
    ${ProxyUseDefaultCredentials}
)


    process {
        <# IMPORTANT
            1. deployment.source.type with value Jar/NetCoreZip is not supported when service instance;sku.tier is Enterprise
        #>
        $DeployPSBoundParameters = @{}
        if ($PSBoundParameters.ContainsKey('HttpPipelineAppend')) {
            $DeployPSBoundParameters['HttpPipelineAppend'] = $HttpPipelineAppend
        }
        if ($PSBoundParameters.ContainsKey('HttpPipelinePrepend')) {
            $DeployPSBoundParameters['HttpPipelinePrepend'] = $HttpPipelinePrepend
        }
        $DeployPSBoundParameters['SubscriptionId'] = $SubscriptionId
        
        # Get spring cloud service sku tier
        $service = Get-AzSpringCloud -ResourceGroupName $ResourceGroupName -Name $ServiceName @DeployPSBoundParameters
        # Get active deployment of the spring cloud app
        $activeDeployment = (Get-AzSpringCloudAppDeployment -ResourceGroupName $ResourceGroupName -ServiceName $ServiceName -AppName $Name @DeployPSBoundParameters | Where-Object {$_.Active}).Name
        # Uploading package to blob
        $relativePath = UploadFileToSpringCloud -ResourceGroupName $ResourceGroupName -ServiceName $ServiceName -AppName $Name -ServiceType $service.SkuTier -FilePath $FilePath -DeployPSBoundParameters $DeployPSBoundParameters
        Write-Host "[3/3] Updating deployment in app $Name (this operation can take a while to complete)" -ForegroundColor Yellow
        if ($service.SkuTier -eq 'Enterprise')
        {
            DeployEnterpriseSpringCloudApp -ResourceGroupName $ResourceGroupName -ServiceName $ServiceName -AppName $Name -DeploymentName $activeDeployment `
            -BuilderId $BuilderId -AgentPoolId $AgentPoolId -RelativePath $relativePath -DeployPSBoundParameters $DeployPSBoundParameters
        }
        DeployStandardSpringCloudApp -ResourceGroupName $ResourceGroupName -ServiceName $ServiceName -AppName $Name -DeploymentName $activeDeployment -RelativePath $relativePath -DeployPSBoundParameters $DeployPSBoundParameters
    }
}

function UploadFileToSpringCloud {
    param (                
        [string]
        $ResourceGroupName,

        [string]
        $ServiceName,

        [string]
        $AppName,

        [string]
        $ServiceType,

        [string]
        $FilePath,

        [hashtable]
        $DeployPSBoundParameters
    )
    Write-Host '[1/3] Requesting for upload URL' -ForegroundColor Yellow
    if ($ServiceType -eq 'Enterprise')
    {
        $uploadInfo = Az.SpringCloud.internal\Get-AzSpringCloudBuildServiceResourceUploadUrl -ResourceGroupName $ResourceGroupName -ServiceName $ServiceName -Name default @DeployPSBoundParameters
    }
    else {
        $uploadInfo = Az.SpringCloud.internal\Get-AzSpringCloudAppResourceUploadUrl -ResourceGroupName $ResourceGroupName -serviceName $ServiceName -Name $AppName @DeployPSBoundParameters
    }
    Write-Host '[2/3] Uploading package to blob' -ForegroundColor Yellow
    $uploadUrl = $uploadInfo.UploadUrl
    $uri = [System.Uri]::New($uploadUrl.Split('?')[0])
    $sasToken = $uploadUrl.Split('?')[-1]
    $storageCredentials = [Microsoft.WindowsAzure.Storage.Auth.StorageCredentials]::New($sasToken)
    $cloudFile = [Microsoft.WindowsAzure.Storage.File.CloudFile]::New($uri, $storageCredentials)
    $uploadTask = $cloudFile.UploadFromFileAsync($filePath)
    try {
        $null = $uploadTask.GetAwaiter().GetResult()
    }
    catch {
        throw $_.Exception
    }
    return $uploadInfo.RelativePath
}

function DeployStandardSpringCloudApp {
    param (
        [string]
        $ResourceGroupName,

        [string]
        $ServiceName,

        [string]
        $AppName,

        [string]
        $DeploymentName,

        [string]
        $RelativePath,

        [hashtable]
        $DeployPSBoundParameters
    )
    $deployment = Get-AzSpringCloudAppDeployment -ResourceGroupName $ResourceGroupName -ServiceName $ServiceName -AppName $AppName -Name $DeploymentName @DeployPSBoundParameters
    if ($deployment.Source.Type -eq 'Jar')
    {
        $source = [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Models.Api20220401.JarUploadedUserSourceInfo]::New()
        $source.RelativePath = $RelativePath
        $source.Type = $deployment.Source.Type
    }
    if ($deployment.Source.Type -eq 'NetCoreZip')
    {
        $source = [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Models.Api20220401.NetCoreZipUploadedUserSourceInfo]::New()
        $source.RelativePath = $RelativePath
        $source.Type = $deployment.Source.Type
    }
    if ($deployment.Source.Type -eq 'Source')
    {
        $source = [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Models.Api20220401.SourceUploadedUserSourceInfo]::New()
        $source.RelativePath = $RelativePath
        $source.Type = $deployment.Source.Type
    }
    Update-AzSpringCloudAppDeployment -ResourceGroupName $ResourceGroupName -ServiceName $ServiceName -AppName $AppName -Name $DeploymentName -Source $source @DeployPSBoundParameters
    Start-AzSpringCloudAppDeployment -ResourceGroupName $ResourceGroupName -ServiceName $ServiceName -AppName $AppName -Name $DeploymentName @DeployPSBoundParameters
}

function DeployEnterpriseSpringCloudApp {
    param (
        [string]
        $ResourceGroupName,

        [string]
        $ServiceName,

        [string]
        $AppName,

        [string]
        $DeploymentName,

        [string]
        $BuilderId,

        [string]
        $AgentPoolId,

        [string]
        $RelativePath,

        [hashtable]
        $DeployPSBoundParameters
    )
    $buildName = 'default' + (Get-Random)
    $null = Az.SpringCloud.internal\New-AzSpringCloudBuildServiceBuild -ResourceGroupName $ResourceGroupName -ServiceName $ServiceName -BuildServiceName 'default' -Name $buildName -AgentPoolId $AgentPoolId -BuilderId $BuilderId -RelativePath $RelativePath @DeployPSBoundParameters
    do {
        Start-Sleep 30
        $result = Az.SpringCloud.internal\Get-AzSpringCloudBuildServiceBuildResult -ResourceGroupName $ResourceGroupName -ServiceName $ServiceName -BuildServiceName 'default' -BuildName $buildName -Name 1
        if ($result.ProvisioningState -eq 'Failed')
        {
            $resultFailedLog = Az.SpringCloud.internal\Get-AzSpringCloudBuildServiceBuildResultLog -ResourceGroupName $ResourceGroupName -ServiceName $ServiceName -BuildServiceName 'default' -BuildName $buildName -Name 1
            throw "Service build failed, Log file url: $resultFailedLog"
        }
    } until ($result.ProvisioningState -eq 'Succeeded')
    $buildResult = [Microsoft.Azure.PowerShell.Cmdlets.SpringCloud.Models.Api20220401.BuildResultUserSourceInfo]::New()
    $buildResult.Type = "BuildResult"
    $buildResult.BuildResultId = $result.Id
    $null  = Update-AzSpringCloudAppDeployment -ResourceGroupName $ResourceGroupName -ServiceName $ServiceName -AppName $AppName -Name $DeploymentName -Source $buildResult @DeployPSBoundParameters
    Start-AzSpringCloudAppDeployment -ResourceGroupName $ResourceGroupName -ServiceName $ServiceName -AppName $AppName -Name $DeploymentName @DeployPSBoundParameters
}
# SIG # Begin signature block
# MIIoOQYJKoZIhvcNAQcCoIIoKjCCKCYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBQF8ggNy34UvHp
# suuPssvwjo5ixF4dfBGl/mAFgt2MVqCCDYUwggYDMIID66ADAgECAhMzAAADri01
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
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIEp9
# Z6UF8L4HOQtBsBO9ff9fKRv5TekGXQ4y6nXHEyRMMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAkmT0iDYre2iokSgr6PHMlxGqwlxyZFoxNG+b
# ziM1n3r+mencK7GRzkoaZmXfWEX1iHqzjJbNFE4wRiHp9Vw6TZsGCyvDR5Fsyjfo
# rw1/y+xbaSambdIyyJ/MZFKHLXPTxhVN/GRL5AYHFPaDSTddi0izvjmL8/DXNiou
# +RU+KjdrCI51vpVDDvAk0tkb8sPeCFGY+lChmDoTCY5HczyG03Y6Ed5ekhXvqEXh
# n/nkygee9AZi8Yp9KIpDWFxabwi21uVZntRCP0Gg6cFsV6wa7rmJ5VlsIDeck58u
# 12tW1CFuKUKXzSWNPmUCN6CTEQiYT7EQrALNi1Rw9rlJjsrJnqGCF5QwgheQBgor
# BgEEAYI3AwMBMYIXgDCCF3wGCSqGSIb3DQEHAqCCF20wghdpAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFSBgsqhkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCD6fHiL0pht2G5DVD9LUKA4T/wZrEEhhHJU
# +qaCXrcN5AIGZZ/gBDLXGBMyMDI0MDEzMDA1MDQ1Ni4xOTdaMASAAgH0oIHRpIHO
# MIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQL
# ExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxk
# IFRTUyBFU046OTIwMC0wNUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1l
# LVN0YW1wIFNlcnZpY2WgghHqMIIHIDCCBQigAwIBAgITMwAAAc9SNr5xS81IygAB
# AAABzzANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MDAeFw0yMzA1MjUxOTEyMTFaFw0yNDAyMDExOTEyMTFaMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046OTIwMC0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Uw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC4Pct+15TYyrUje553lzBQ
# odgmd5Bz7WuH8SdHpAoWz+01TrHExBSuaMKnxvVMsyYtas5h6aopUGAS5WKVLZAv
# UtH62TKmAE0JK+i1hafiCSXLZPcRexxeRkOqeZefLBzXp0nudMOXUUab333Ss8Lk
# oK4l3LYxm1Ebsr3b2OTo2ebsAoNJ4kSxmVuPM7C+RDhGtVKR/EmHsQ9GcwGmluu5
# 4bqiVFd0oAFBbw4txTU1mruIGWP/i+sgiNqvdV/wah/QcrKiGlpWiOr9a5aGrJaP
# SQD2xgEDdPbrSflYxsRMdZCJI8vzvOv6BluPcPPGGVLEaU7OszdYjK5f4Z5Su/lP
# K1eST5PC4RFsVcOiS4L0sI4IFZywIdDJHoKgdqWRp6Q5vEDk8kvZz6HWFnYLOlHu
# qMEYvQLr6OgooYU9z0A5cMLHEIHYV1xiaBzx2ERiRY9MUPWohh+TpZWEUZlUm/q9
# anXVRN0ujejm6OsUVFDssIMszRNCqEotJGwtHHm5xrCKuJkFr8GfwNelFl+XDoHX
# rQYL9zY7Np+frsTXQpKRNnmI1ashcn5EC+wxUt/EZIskWzewEft0/+/0g3+8YtMk
# UdaQE5+8e7C8UMiXOHkMK25jNNQqLCedlJwFIf9ir9SpMc72NR+1j6Uebiz/ZPV7
# 4do3jdVvq7DiPFlTb92UKwIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFDaeKPtp0eTS
# VdG+gZc5BDkabTg4MB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8G
# A1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMv
# Y3JsL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBs
# BggrBgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0
# LmNvbS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
# MDIwMTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUH
# AwgwDgYDVR0PAQH/BAQDAgeAMA0GCSqGSIb3DQEBCwUAA4ICAQBQgm4pnA0xkd/9
# uKXJMzdMYyxUfUm/ZusUBa32MEZXQuMGp20pSuX2VW9/tpTMo5bkaJdBVoUyd2Db
# DsNb1kjr/36ntT0jvL3AoWStAFhZBypmpPbx+BPK49ZlejlM4d5epX668tRRGfFi
# p9Til9yKRfXBrXnM/q64IinN7zXEQ3FFQhdJMzt8ibXClO7eFA+1HiwZPWysYWPb
# /ZOFobPEMvXie+GmEbTKbhE5tze6RrA9aejjP+v1ouFoD5bMj5Qg+wfZXqe+hfYK
# pMd8QOnQyez+Nlj1itynOZWfwHVR7dVwV0yLSlPT+yHIO8g+3fWiAwpoO17bDcnt
# SZ7YOBljXrIgad4W4gX+4tp1eBsc6XWIITPBNzxQDZZRxD4rXzOB6XRlEVJdYZQ8
# gbXOirg/dNvS2GxcR50QdOXDAumdEHaGNHb6y2InJadCPp2iT5QLC4MnzR+YZno1
# b8mWpCdOdRs9g21QbbrI06iLk9KD61nx7K5ReSucuS5Z9nbkIBaLUxDesFhr1wmd
# 1ynf0HQ51Swryh7YI7TXT0jr81mbvvI9xtoqjFvIhNBsICdCfTR91ylJTH8WtUlp
# DhEgSqWt3gzNLPTSvXAxXTpIM583sZdd+/2YGADMeWmt8PuMce6GsIcLCOF2NiYZ
# 10SXHZS5HRrLrChuzedDRisWpIu5uTCCB3EwggVZoAMCAQICEzMAAAAVxedrngKb
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
# Y2EgT3BlcmF0aW9uczEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjkyMDAtMDVF
# MC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMK
# AQEwBwYFKw4DAhoDFQDq8xzVXwLguauAQj1rrJ4/TyEMm6CBgzCBgKR+MHwxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6WK/tjAi
# GA8yMDI0MDEzMDAwMjIxNFoYDzIwMjQwMTMxMDAyMjE0WjB0MDoGCisGAQQBhFkK
# BAExLDAqMAoCBQDpYr+2AgEAMAcCAQACAiJOMAcCAQACAha7MAoCBQDpZBE2AgEA
# MDYGCisGAQQBhFkKBAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAI
# AgEAAgMBhqAwDQYJKoZIhvcNAQELBQADggEBAFhREGxGsKjKY5IveZ/9E/bp6Jhq
# G+fNpMKZTpV8P3nrH6cpq+vuU8az57fdhHOj1mz+VaTymFZdVyyQBTq98guepAQ4
# n+uU3SSDxS52gWUZvdzCtyDbwoCzIAdvsYEyF9VglTDtNuUe0oIfMT/6LoGju+aZ
# V3j7OGfVv+SU5qIAfArxrbt00IxC4WVC0DcABoUo4ilZZEnyK+KyI4Ohrn0YEP6i
# 0eQHYb2Sf0YsHRePocBm0Oz/1iHwdPAKFfWJMezCsHUiuIBvrmKdCtkY3z5kmlb2
# KwcMnGM7QpLralHKjd0Y1vwpsXdAeBISxgOkP56gCHewg4m/pdu9ASYJPEkxggQN
# MIIECQIBATCBkzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQ
# MA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9u
# MSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAc9S
# Nr5xS81IygABAAABzzANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0G
# CyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCBlLutPM3+mCgL8fFfoOFqw7GnG
# b+BtHbkJz2IXQVz/vzCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EILPpsLqe
# NS4NuYXE2VJlMuvQeWVA80ZDFhpOPjSzhPa/MIGYMIGApH4wfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTACEzMAAAHPUja+cUvNSMoAAQAAAc8wIgQgxvq/vjpl
# ap0udZdRLjJEC8T4CoiZ1T/glkkXErMSKeEwDQYJKoZIhvcNAQELBQAEggIAcDRd
# Dg/UcExOkf6SUoWgahVtXsu8GtDDYFri24uR1uTJunFl135uZRZ8K4yIlSDwOaHf
# u1TSytzjrm7mjft56z8ZVr69CYo5rlKnpz4b4rvX6fpSQhPqooNawie8FF5SVrUV
# MMzO2Ap7awFnPBTZU6tqUOfDS4V0TMcVPLqPulNwe+jfEr+d4UVGYM+i6WEcCB1g
# bHN3YlJy2VsIRKwcN5Qy7LbOUxRJDknQuMp6imWuhshR0uD76pIC7JUGvKbwCpyq
# qjHO4FSNnlheRG7/CtrenJ/u2T56cQsNhLplMphiYN0cvK/uuUsAdhkw2YfdINvD
# 9/+B19HQQfmWMS//Ic5h/x3zu3uzB6xAkVVAps0RHzQeyZ5kZ/Fwx99lEhlVwdrg
# o4vFhUzgigmhK1QrcBXyZqhEvWT64xXPxvOLS2bjcIjQzgmzkU80kFw9T+Wj4OpB
# Im4vumLWfHVRKD42ZHZGR/uXtupMH6xPdYUSEshyO0cy0YjhvtHvP4egnOziprZU
# ti+yoIh3po0jTdoCJg5mJMxRfQOsomOj+OmrCFiLzFVKLp4l1j3IZrJ0cpbRv63g
# WO5F0XiD6z0saEv42YtCW1lJZpc7wU3mmgx40000GA+fDrIlOamGxG/pflKv1iaS
# Ox3KH7GGYvXUJuRyqfOPIlXvdhiK2YREf0Ab7mk=
# SIG # End signature block
