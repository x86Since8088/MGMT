
# ----------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# Code generated by Microsoft (R) AutoRest Code Generator.Changes may cause incorrect behavior and will be lost if the code
# is regenerated.
# ----------------------------------------------------------------------------------

<#
.Synopsis
Creates or updates an environment.
.Description
Creates or updates an environment.
.Example
{{ Add code here }}
.Example
{{ Add code here }}

.Inputs
Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Models.Api20231001Preview.IEnvironment
.Inputs
Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Models.IDevCenterdataIdentity
.Outputs
System.Boolean
.Notes
COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.

BODY <IEnvironment>: Properties of an environment.
  CatalogName <String>: Name of the catalog.
  DefinitionName <String>: Name of the environment definition.
  Type <String>: Environment type.
  [Parameter <IAny>]: Parameters object for the environment.
  [Code <String>]: An identifier for the error. Codes are invariant and are intended to be consumed programmatically.
  [Detail <ICloudErrorBody[]>]: A list of additional details about the error.
    Code <String>: An identifier for the error. Codes are invariant and are intended to be consumed programmatically.
    Message <String>: A message describing the error, intended to be suitable for display in a user interface.
    [Detail <ICloudErrorBody[]>]: A list of additional details about the error.
    [Target <String>]: The target of the particular error. For example, the name of the property in error.
  [Message <String>]: A message describing the error, intended to be suitable for display in a user interface.
  [OperationLocation <String>]: 
  [Target <String>]: The target of the particular error. For example, the name of the property in error.

INPUTOBJECT <IDevCenterdataIdentity>: Identity Parameter
  [Name <String>]: The name of an action that will take place on a Dev Box.
  [CatalogName <String>]: The name of the catalog
  [DefinitionName <String>]: The name of the environment definition
  [DevBoxName <String>]: The name of a Dev Box.
  [EnvironmentName <String>]: The name of the environment.
  [Id <String>]: Resource identity path
  [PoolName <String>]: The name of a pool of Dev Boxes.
  [ProjectName <String>]: The DevCenter Project upon which to execute operations.
  [ScheduleName <String>]: The name of a schedule.
  [UserId <String>]: The AAD object id of the user. If value is 'me', the identity is taken from the authentication context.
.Link
https://learn.microsoft.com/powershell/module/az.devcenter/new-azdevcenteruserenvironment
#>
function New-AzDevCenterUserEnvironment {
  [OutputType([System.Boolean])]
  [CmdletBinding(DefaultParameterSetName = 'CreateExpanded', PositionalBinding = $false, SupportsShouldProcess, ConfirmImpact = 'Medium')]
  param(
    [Parameter(ParameterSetName = 'CreateExpanded', Mandatory)]
    [Parameter(ParameterSetName = 'CreateViaIdentityExpanded', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Uri')]
    [System.String]
    # The DevCenter-specific URI to operate on.
    ${Endpoint},
  
    [Parameter(ParameterSetName = 'CreateViaIdentityExpandedByDevCenter', Mandatory)]
    [Parameter(ParameterSetName = 'CreateExpandedByDevCenter', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Uri')]
    [Alias('DevCenter')]
    [System.String]
    # The DevCenter upon which to execute operations.
    ${DevCenterName},
  
    [Parameter(ParameterSetName = 'CreateExpanded', Mandatory)]
    [Parameter(ParameterSetName = 'CreateExpandedByDevCenter', Mandatory)]
    [Alias('EnvironmentName')]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Path')]
    [System.String]
    # The name of the environment.
    ${Name},
  
    [Parameter(ParameterSetName = 'CreateExpanded', Mandatory)]
    [Parameter(ParameterSetName = 'CreateExpandedByDevCenter', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Path')]
    [System.String]
    # The DevCenter Project upon which to execute operations.
    ${ProjectName},
  
    [Parameter(ParameterSetName = 'CreateExpanded')]
    [Parameter(ParameterSetName = 'CreateExpandedByDevCenter')]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Path')]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Runtime.DefaultInfo(Script = '"me"')]
    [System.String]
    # The AAD object id of the user.
    # If value is 'me', the identity is taken from the authentication context.
    ${UserId},
  
    [Parameter(ParameterSetName = 'CreateViaIdentityExpanded', Mandatory, ValueFromPipeline)]
    [Parameter(ParameterSetName = 'CreateViaIdentityExpandedByDevCenter', Mandatory, ValueFromPipeline)]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Path')]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Models.IDevCenterdataIdentity]
    # Identity Parameter
    # To construct, see NOTES section for INPUTOBJECT properties and create a hash table.
    ${InputObject},
  
    [Parameter(ParameterSetName = 'CreateExpanded', Mandatory)]
    [Parameter(ParameterSetName = 'CreateViaIdentityExpanded', Mandatory)]
    [Parameter(ParameterSetName = 'CreateViaIdentityExpandedByDevCenter', Mandatory)]
    [Parameter(ParameterSetName = 'CreateExpandedByDevCenter', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Body')]
    [System.String]
    # Name of the catalog.
    ${CatalogName},
  
    [Parameter(ParameterSetName = 'CreateExpanded', Mandatory)]
    [Parameter(ParameterSetName = 'CreateViaIdentityExpanded', Mandatory)]
    [Parameter(ParameterSetName = 'CreateViaIdentityExpandedByDevCenter', Mandatory)]
    [Parameter(ParameterSetName = 'CreateExpandedByDevCenter', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Body')]
    [System.String]
    # Name of the environment definition.
    ${EnvironmentDefinitionName},
  
    [Parameter(ParameterSetName = 'CreateExpanded', Mandatory)]
    [Parameter(ParameterSetName = 'CreateViaIdentityExpanded', Mandatory)]
    [Parameter(ParameterSetName = 'CreateViaIdentityExpandedByDevCenter', Mandatory)]
    [Parameter(ParameterSetName = 'CreateExpandedByDevCenter', Mandatory)]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Body')]
    [System.String]
    # Environment type.
    ${EnvironmentType},
  
    [Parameter(ParameterSetName = 'CreateExpanded')]
    [Parameter(ParameterSetName = 'CreateViaIdentityExpanded')]
    [Parameter(ParameterSetName = 'CreateViaIdentityExpandedByDevCenter')]
    [Parameter(ParameterSetName = 'CreateExpandedByDevCenter')]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Runtime.Info(PossibleTypes=([Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Models.Api20231001Preview.IEnvironmentUpdatePropertiesParameters]))]
    [System.Collections.Hashtable]
    # Parameters object for the environment.
    ${Parameter},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Body')]
    [System.DateTime]
    # The time the expiration date will be triggered (UTC), after which the environment and associated resources will be deleted.
    ${ExpirationDate},
  
    [Parameter()]
    [Alias('AzureRMContext', 'AzureCredential')]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Azure')]
    [System.Management.Automation.PSObject]
    # The DefaultProfile parameter is not functional.
    # Use the SubscriptionId parameter when available if executing the cmdlet against a different subscription.
    ${DefaultProfile},
  
    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Run the command as a job
    ${AsJob},
  
    [Parameter(DontShow)]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Wait for .NET debugger to attach
    ${Break},
  
    [Parameter(DontShow)]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Runtime')]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Runtime.SendAsyncStep[]]
    # SendAsync Pipeline Steps to be appended to the front of the pipeline
    ${HttpPipelineAppend},
  
    [Parameter(DontShow)]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Runtime')]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Runtime.SendAsyncStep[]]
    # SendAsync Pipeline Steps to be prepended to the front of the pipeline
    ${HttpPipelinePrepend},
  
    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Run the command asynchronously
    ${NoWait},
  
    [Parameter(DontShow)]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Runtime')]
    [System.Uri]
    # The URI for the proxy server to use
    ${Proxy},
  
    [Parameter(DontShow)]
    [ValidateNotNull()]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Runtime')]
    [System.Management.Automation.PSCredential]
    # Credentials for a proxy server to use for the remote call
    ${ProxyCredential},
  
    [Parameter(DontShow)]
    [Microsoft.Azure.PowerShell.Cmdlets.DevCenterdata.Category('Runtime')]
    [System.Management.Automation.SwitchParameter]
    # Use the default credentials for the proxy
    ${ProxyUseDefaultCredentials}
  )

  process {
    if (-not $PSBoundParameters.ContainsKey('Endpoint')) {
      $Endpoint = GetEndpointFromResourceGraph -DevCenterName $DevCenterName -Project $ProjectName
      $null = $PSBoundParameters.Add("Endpoint", $Endpoint)
      $null = $PSBoundParameters.Remove("DevCenterName")

    }
    else {
      $Endpoint = ValidateAndProcessEndpoint -Endpoint $Endpoint
      $PSBoundParameters["Endpoint"] = $Endpoint
    }

    Az.DevCenterdata.internal\New-AzDevCenterUserEnvironment @PSBoundParameters
  }
}

# SIG # Begin signature block
# MIIoOQYJKoZIhvcNAQcCoIIoKjCCKCYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDPhWsEYC6op7tD
# Ox0jo47BRJrLWoyORDMBpxLnO+nykKCCDYUwggYDMIID66ADAgECAhMzAAADri01
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
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIGi+
# APWTzbS7wuOaAyWoA+KqewZaLPz6l36tlda/vpqzMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAfyuhVf3pFtzhtRXNaOCGeOPA6aD9g9jcktuY
# Z9DPJwTbfkS4H7D68nZEQXVDv0/KUlpkq6Le6kZGupLIy63PcO1ChAhgzTEGL9QG
# h4MFIxj8guHTIUqYjft24QI7dITVZTNwgOclywugbUcNtO6a2V16MNdTZKSYNU7f
# 7xojtBT+jpVw3pds8jJdLtrh0S9T53lt/NiNUGFyu93av+dDzeD5Mm/MElWDExca
# Gz+xSfM3/fgweBD34+xqEKxQL8ZKGWZQtgpMiFaHGEa1W5yQQCc0OUO6kI6+t1AR
# c4fxTBtX5emIJvpxy+gsAmZ0KzlGiOxuvwK8Vg5gJHAgXKV+qKGCF5QwgheQBgor
# BgEEAYI3AwMBMYIXgDCCF3wGCSqGSIb3DQEHAqCCF20wghdpAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFSBgsqhkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCAGdre21ue4+vjNbnVSmxbGJlEvp5Ns6xz0
# YxIjY2nkYAIGZXsVlvTAGBMyMDIzMTIyNzA1NTU0NC41NzNaMASAAgH0oIHRpIHO
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
# CyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCC5Bf9VoGwRCRIu3XSeurPzjcU+
# iVBWWw4RXK6VZLgkJjCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIMzqh/rY
# FKXOlzvWS5xCtPi9aU+fBUkxIriXp2WTPWI3MIGYMIGApH4wfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTACEzMAAAHU5OkDL8CsaawAAQAAAdQwIgQgBYEYWujQ
# pUcyoe5r15nRgVWWzS28zu99C6hRCEFVjbUwDQYJKoZIhvcNAQELBQAEggIAQJjV
# UqENrCWciDkepSbVUDp1SeaxZWcZdHobcAMVmnz24YxYcaH8+QfEz46gq34AULqN
# v2JzjmT/X8PuP19okDrVC6Xim12djZoVLs9TLeMkapDq86rNhxMipSHxZ9xiNfTg
# QYNtsm98A4e8Fyo5ezlQ0kiYP8RtgIGsjMg9J20go4OmWF1EOdxguu7yAbj4IE24
# A8O3LFrx618Q8bfW0uQkU6VTuN+wNwn2aDjXQBijYFf73q3Pg7waJdwf5pogNNbG
# X98OfKhuKcTzruWfuQvf/lFO+NR8fH2yx+3UhYqY+AdxxFT/frHMLxlOBp3jcWWR
# itqWoe9UK9c+PkNXFB9p7/DSLfpX/8XIiCMQmPdqjGMsP+GBVklA35m+J+JWak/T
# B7t/Rwefkii61eGNV3t9SRZ2Bo8PFnJ/jdFqxS/0CCKPtnNPzJKzARm7Vsrb6SM+
# zSxUr5resb62GQ/phWm1geexvvavVNhX2e+d4UTCeBYuScAMt+RgvkSaFT/MQnfW
# AiULCkoQ7wx1/JvJu9vhj5PoDKeii+iA/QvRHXj/MrFDupyMzNROreeDD8OHD2ma
# K3aK2by8FxXmQLw8hHmCdnC+13yjStZJpSMdcvM0380MyOXUK/nbSfaB9qQwdjIu
# 2cXN9ssa9QvHZJvtvmA+fihwwA2Bk8j3DZoKyJU=
# SIG # End signature block
