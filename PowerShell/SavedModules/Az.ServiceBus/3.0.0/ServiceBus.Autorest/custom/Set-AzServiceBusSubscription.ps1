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
Updates a ServiceBus Subscription
.Description
Updates a ServiceBus Subscription
#>

function Set-AzServiceBusSubscription{
	[OutputType([Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Models.Api20221001Preview.ISbSubscription])]
    [CmdletBinding(DefaultParameterSetName = 'SetExpanded', PositionalBinding = $false, SupportsShouldProcess, ConfirmImpact = 'Medium')]
	param(
		[Parameter(ParameterSetName = 'SetExpanded', Mandatory, HelpMessage = "The name of the Subscription.")]
        [Alias('SubscriptionName')]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Path')]
        [System.String]
        # The name of the Subscription.
        ${Name},

        [Parameter(ParameterSetName = 'SetExpanded', Mandatory, HelpMessage = "The name of the Topic.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Path')]
        [System.String]
        # The name of the Topic.
        ${TopicName},

        [Parameter(ParameterSetName = 'SetExpanded', Mandatory, HelpMessage = "The name of ServiceBus namespace")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Path')]
        [System.String]
        # The name of ServiceBus namespace
        ${NamespaceName},

        [Parameter(ParameterSetName = 'SetExpanded', Mandatory, HelpMessage = "The name of the resource group. The name is case insensitive.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Path')]
        [System.String]
        # The name of the resource group.
        # The name is case insensitive.
        ${ResourceGroupName},

        [Parameter(ParameterSetName = 'SetExpanded', HelpMessage = "The ID of the target subscription.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Runtime.DefaultInfo(Script = '(Get-AzContext).Subscription.Id')]
        [System.String]
        # The ID of the target subscription.
        ${SubscriptionId},

        [Parameter(ParameterSetName = 'SetViaIdentityExpanded', Mandatory, ValueFromPipeline, HelpMessage = "Identity parameter. To construct, see NOTES section for INPUTOBJECT properties and create a hash table.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Models.IServiceBusIdentity]
        # Identity Parameter
        # To construct, see NOTES section for INPUTOBJECT properties and create a hash table.
        ${InputObject},

        [Parameter(HelpMessage = "ISO 8061 timeSpan idle interval after which the subscription is automatically deleted. The minimum duration is 5 minutes.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
        [System.TimeSpan]
        # timeSpan.
        ${AutoDeleteOnIdle},

        [Parameter(HelpMessage = "ISO 8601 default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
        [System.TimeSpan]
        # timeSpan.
        ${DefaultMessageTimeToLive},

        [Parameter(HelpMessage = "ISO 8601 timeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
        [System.TimeSpan]
        # timeSpan.
        ${DuplicateDetectionHistoryTimeWindow},

        [Parameter(HelpMessage = "ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
        [System.TimeSpan]
        # timeSpan.
        ${LockDuration},

        [Parameter(HelpMessage = "Value that indicates whether server-side batched operations are enabled.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        # Value that indicates whether server-side batched operations are enabled.
        ${EnableBatchedOperations},

        [Parameter(HelpMessage = "Enumerates the possible values for the status of a messaging entity.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Support.EntityStatus]
        # Enumerates the possible values for the status of a messaging entity.
        ${Status},

        [Parameter(HelpMessage = "Queue/Topic name to forward the messages")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
        [System.String]
        # Queue/Topic name to forward the messages
        ${ForwardTo},

        [Parameter(HelpMessage = "Queue/Topic name to forward the Dead Letter message")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
        [System.String]
        # Queue/Topic name to forward the Dead Letter message
        ${ForwardDeadLetteredMessagesTo},

        [Parameter(HelpMessage = "The maximum delivery count. A message is automatically deadlettered after this number of deliveries. default value is 10.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
        [System.Int32]
        # The maximum delivery count. A message is automatically deadlettered after this number of deliveries. default value is 10.
        ${MaxDeliveryCount},

        [Parameter(HelpMessage = "Value that indicates whether a subscription has dead letter support on filter evaluation exceptions.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        # Value that indicates whether a subscription has dead letter support on filter evaluation exceptions.
        ${DeadLetteringOnFilterEvaluationException},

        [Parameter(HelpMessage = "Value that indicates whether a subscription has dead letter support when a message expires.")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        # Value that indicates whether a subscription has dead letter support on filter evaluation exceptions.
        ${DeadLetteringOnMessageExpiration},
        
        [Parameter(HelpMessage = "The credentials, account, tenant, and subscription used for communication with Azure.")]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},

        [Parameter(HelpMessage = "Run the command as a job")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Run the command as a job
        ${AsJob},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},

        [Parameter(HelpMessage = "Run the command asynchronously")]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Run the command asynchronously
        ${NoWait},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},

        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},

        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.ServiceBus.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
	)

    process{
        try{
            $hasAutoDeleteOnIdle = $PSBoundParameters.Remove('AutoDeleteOnIdle')
            $hasDefaultMessageTimeToLive = $PSBoundParameters.Remove('DefaultMessageTimeToLive')
            $hasLockDuration = $PSBoundParameters.Remove('LockDuration')
            $hasDuplicateDetectionHistoryTimeWindow = $PSBoundParameters.Remove('DuplicateDetectionHistoryTimeWindow')
            $hasEnableBatchedOperations = $PSBoundParameters.Remove('EnableBatchedOperations')
            $hasDeadLetteringOnFilterEvaluationException = $PSBoundParameters.Remove('DeadLetteringOnFilterEvaluationException')
            $hasMaxDeliveryCount = $PSBoundParameters.Remove('MaxDeliveryCount')
            $hasForwardTo = $PSBoundParameters.Remove('ForwardTo')
            $hasForwardDeadLetteredMessagesTo = $PSBoundParameters.Remove('ForwardDeadLetteredMessagesTo')
            $hasStatus = $PSBoundParameters.Remove('Status')
            $hasDeadLetteringOnMessageExpiration = $PSBoundParameters.Remove('DeadLetteringOnMessageExpiration')
            $hasAsJob = $PSBoundParameters.Remove('AsJob')
            $null = $PSBoundParameters.Remove('WhatIf')
            $null = $PSBoundParameters.Remove('Confirm')

            $subscription = Get-AzServiceBusSubscription @PSBoundParameters

            # 2. PUT
            $null = $PSBoundParameters.Remove('InputObject')
            $null = $PSBoundParameters.Remove('ResourceGroupName')
            $null = $PSBoundParameters.Remove('NamespaceName')
            $null = $PSBoundParameters.Remove('TopicName')
            $null = $PSBoundParameters.Remove('Name')
            $null = $PSBoundParameters.Remove('SubscriptionId')

            $hasProperty = $false

            if ($hasAutoDeleteOnIdle) {
                $subscription.AutoDeleteOnIdle = $AutoDeleteOnIdle
                $hasProperty = $true
            }
            if ($hasDefaultMessageTimeToLive) {
                $subscription.DefaultMessageTimeToLive = $DefaultMessageTimeToLive
                $hasProperty = $true
            }
            if($hasLockDuration){
	            $subscription.LockDuration = $LockDuration
                $hasProperty = $true
            }
            if ($hasDuplicateDetectionHistoryTimeWindow) {
                $subscription.DuplicateDetectionHistoryTimeWindow = $DuplicateDetectionHistoryTimeWindow
                $hasProperty = $true
            }
            if ($hasEnableBatchedOperations) {
                $subscription.EnableBatchedOperations = $EnableBatchedOperations
                $hasProperty = $true
            }
            if ($hasStatus) {
                $subscription.Status = $Status
                $hasProperty = $true
            }
            if ($hasDeadLetteringOnMessageExpiration) {
                $subscription.DeadLetteringOnMessageExpiration = $DeadLetteringOnMessageExpiration
                $hasProperty = $true
            }
            if ($hasDeadLetteringOnFilterEvaluationException) {
                $subscription.DeadLetteringOnFilterEvaluationException = $DeadLetteringOnFilterEvaluationException
                $hasProperty = $true
            }
            if ($hasMaxDeliveryCount) {
                $subscription.MaxDeliveryCount = $MaxDeliveryCount
                $hasProperty = $true
            }
            if ($hasForwardDeadLetteredMessagesTo) {
                $subscription.ForwardDeadLetteredMessagesTo = $ForwardDeadLetteredMessagesTo
                $hasProperty = $true
            }
            if ($hasForwardTo) {
                $subscription.ForwardTo = $ForwardTo
                $hasProperty = $true
            }

            if (($hasProperty -eq $false) -and ($PSCmdlet.ParameterSetName -eq 'SetViaIdentityExpanded')){
                throw 'Please specify the property you want to update on the -InputObject. Refer https://go.microsoft.com/fwlink/?linkid=2204584#behavior-of--inputobject for example.'
            }

            if ($hasAsJob) {
                $PSBoundParameters.Add('AsJob', $true)
            }

            if ($PSCmdlet.ShouldProcess("ServiceBus Subscription $($subscription.Name)", "Create or update")) {
                Az.ServiceBus.private\New-AzServiceBusSubscription_CreateViaIdentity -InputObject $subscription -Parameter $subscription @PSBoundParameters
            }
        }
        catch{
            throw
        }
    }
}

# SIG # Begin signature block
# MIInkwYJKoZIhvcNAQcCoIInhDCCJ4ACAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBtTtwDbgjQpb5j
# PS6YCCtVukXzNthuLb+Z+FVYGztIlaCCDXYwggX0MIID3KADAgECAhMzAAADTrU8
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGXMwghlvAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAANOtTx6wYRv6ysAAAAAA04wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIK0nwLqEnLYVFxxrfON8Xzg/
# ebMDiX4DBvOtFdjCNB1QMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAuB+qBnyvEOUMvY4alu5X98wSBzyhyA8ykmKWItoX6W04FRu6Xd+rGXuK
# FX6hlKuWc2q8YVJ/w2t7lemJlC0bUQDIqe667P/H+IPqy8CTVOZAPjBRBPShh2zn
# cEL+n6UejRs0//Kp1W7+DARLDxIIMp52p+IZ6Kj0LelCvTbr+n/CMD1SPRHtP+EB
# 34YhgDzs6kPDYn085tRIO3jK9WWg/3Gj7weOrdJ2uTwmB7qT0uAEtebwPtYhaoRs
# xVt6bbJWAzGemuVyZV+EE60VN6tmVxib0asEwYii9xPKlg1rnalBWqp/uu5ZEx8T
# BXSgUr8X6KB4NpmvXacZnwUOPqSqBKGCFv0wghb5BgorBgEEAYI3AwMBMYIW6TCC
# FuUGCSqGSIb3DQEHAqCCFtYwghbSAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFRBgsq
# hkiG9w0BCRABBKCCAUAEggE8MIIBOAIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCA2CeT4TotJ1aRwfN8c1v7Kxezw/1vujnVJSATdlujc/QIGZF0DwGW2
# GBMyMDIzMDUyMjExNDU0My45NDdaMASAAgH0oIHQpIHNMIHKMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjoxMkJDLUUz
# QUUtNzRFQjElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZaCC
# EVQwggcMMIIE9KADAgECAhMzAAAByk/Cs+0DDRhsAAEAAAHKMA0GCSqGSIb3DQEB
# CwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQH
# EwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNV
# BAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMB4XDTIyMTEwNDE5MDE0
# MFoXDTI0MDIwMjE5MDE0MFowgcoxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVyaWNhIE9wZXJhdGlvbnMx
# JjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNOOjEyQkMtRTNBRS03NEVCMSUwIwYDVQQD
# ExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNlMIICIjANBgkqhkiG9w0BAQEF
# AAOCAg8AMIICCgKCAgEAwwGcq9j50rWEkcLSlGZLweUVfxXRaUjiPsyaNVxPdMRs
# 3CVe58siu/EkaVt7t7PNTPko/s8lNtusAeLEnzki44yxk2c9ekm8E1SQ2YV9b8/L
# OxfKapZ8tVlPyxw6DmFzNFQjifVm8EiZ7lFRoY448vpcbBD18qjYNF/2Z3SQchcs
# dV1N9Y6V2WGl55VmLqFRX5+dptdjreBXzi3WW9TsoCEWcYCBK5wYgS9tT2SSSTza
# e3jmdw40g+LOIyrVPF2DozkStv6JBDPvwahXWpKGpO7rHrKF+o7ECN/ViQFMZyp/
# vxePiUABDNqzEUI8s7klYmeHXvjeQOq/CM3C/Y8bj3fJObnZH7eAXvRDnxT8R6W/
# uD1mGUJvv9M9BMu3nhKpKmSxzzO5LtcMEh2tMXxhMGGNMUP3DOEK3X+2/LD1Z03u
# sJTk5pHNoH/gDIvbp787Cw40tsApiAvtrHYwub0TqIv8Zy62l8n8s/Mv/P764CTq
# rxcXzalBHh+Xy4XPjmadnPkZJycp3Kczbkg9QbvJp0H/0FswHS+efFofpDNJwLh1
# hs/aMi1K/ozEv7/WLIPsDgK16fU/axybqMKk0NOxgelUjAYKl4wU0Y6Q4q9N/9Pw
# AS0csifQhY1ooQfAI0iDCCSEATslD8bTO0tRtqdcIdavOReqzoPdvAv3Dr1XXQ8C
# AwEAAaOCATYwggEyMB0GA1UdDgQWBBT6x/6lS4ESQ8KZhd0RgU7RYXM8fzAfBgNV
# HSMEGDAWgBSfpxVdAF5iXYP05dJlpxtTNRnpcjBfBgNVHR8EWDBWMFSgUqBQhk5o
# dHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNyb3NvZnQlMjBU
# aW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcmwwbAYIKwYBBQUHAQEEYDBeMFwG
# CCsGAQUFBzAChlBodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRz
# L01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNydDAMBgNV
# HRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMIMA0GCSqGSIb3DQEBCwUAA4IC
# AQDY0HkqCS3KuKefFX8/rm/dtD9066dKEleNqriwZqsM4Ym8Ew4QiqOqO7mWoYYY
# 4K5y8eXSOHKNXOfpO6RbaYj8jCOcJAB5tqLl5hiMgaMbAVLrl1hlix9sloO45LON
# 0JphKva3D6AVKA7P78mA9iRHZYUVrRiyfvQjWxmUnxhis8fom92+/RHcEZ1Dh5+p
# 4gzeeL84Yl00Wyq9EcgBKKfgq0lCjWNSq1AUG1sELlgXOSvKZ4/lXXH+MfhcHe91
# WLIaZkS/Hu9wdTT6I14BC97yhDsZWXAl0IJ801I6UtEFpCsTeOyZBJ7CF0rf5lxJ
# 8tE9ojNsyqXJKuwVn0ewCMkZqz/cEwv9FEx8QmsZ0ZNodTtsl+V9dZm+eUrMKZk6
# PKsKArtQ+jHkfVsHgKODloelpOmHqgX7UbO0NVnIlpP55gQTqV76vU7wRXpUfz7K
# hE3BZXNgwG05dRnCXDwrhhYz+Itbzs1K1R8I4YMDJjW90ASCg9Jf+xygRKZGKHjo
# 2Bs2XyaKuN1P6FFCIVXN7KgHl/bZiakGq7k5TQ4OXK5xkhCHhjdgHuxj3hK5AaOy
# +GXxO/jbyqGRqeSxf+TTPuWhDWurIo33RMDGe5DbImjcbcj6dVhQevqHClR1OHSf
# r+8m1hWRJGlC1atcOWKajArwOURqJSVlThwVgIyzGNmjzjCCB3EwggVZoAMCAQIC
# EzMAAAAVxedrngKbSZkAAAAAABUwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNVBAYT
# AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYD
# VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29mdCBS
# b290IENlcnRpZmljYXRlIEF1dGhvcml0eSAyMDEwMB4XDTIxMDkzMDE4MjIyNVoX
# DTMwMDkzMDE4MzIyNVowfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0
# b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3Jh
# dGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwggIi
# MA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDk4aZM57RyIQt5osvXJHm9DtWC
# 0/3unAcH0qlsTnXIyjVX9gF/bErg4r25PhdgM/9cT8dm95VTcVrifkpa/rg2Z4VG
# Iwy1jRPPdzLAEBjoYH1qUoNEt6aORmsHFPPFdvWGUNzBRMhxXFExN6AKOG6N7dcP
# 2CZTfDlhAnrEqv1yaa8dq6z2Nr41JmTamDu6GnszrYBbfowQHJ1S/rboYiXcag/P
# XfT+jlPP1uyFVk3v3byNpOORj7I5LFGc6XBpDco2LXCOMcg1KL3jtIckw+DJj361
# VI/c+gVVmG1oO5pGve2krnopN6zL64NF50ZuyjLVwIYwXE8s4mKyzbnijYjklqwB
# Sru+cakXW2dg3viSkR4dPf0gz3N9QZpGdc3EXzTdEonW/aUgfX782Z5F37ZyL9t9
# X4C626p+Nuw2TPYrbqgSUei/BQOj0XOmTTd0lBw0gg/wEPK3Rxjtp+iZfD9M269e
# wvPV2HM9Q07BMzlMjgK8QmguEOqEUUbi0b1qGFphAXPKZ6Je1yh2AuIzGHLXpyDw
# wvoSCtdjbwzJNmSLW6CmgyFdXzB0kZSU2LlQ+QuJYfM2BjUYhEfb3BvR/bLUHMVr
# 9lxSUV0S2yW6r1AFemzFER1y7435UsSFF5PAPBXbGjfHCBUYP3irRbb1Hode2o+e
# FnJpxq57t7c+auIurQIDAQABo4IB3TCCAdkwEgYJKwYBBAGCNxUBBAUCAwEAATAj
# BgkrBgEEAYI3FQIEFgQUKqdS/mTEmr6CkTxGNSnPEP8vBO4wHQYDVR0OBBYEFJ+n
# FV0AXmJdg/Tl0mWnG1M1GelyMFwGA1UdIARVMFMwUQYMKwYBBAGCN0yDfQEBMEEw
# PwYIKwYBBQUHAgEWM2h0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvRG9j
# cy9SZXBvc2l0b3J5Lmh0bTATBgNVHSUEDDAKBggrBgEFBQcDCDAZBgkrBgEEAYI3
# FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAf
# BgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvXzpoYxDBWBgNVHR8ETzBNMEugSaBH
# hkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNS
# b29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUF
# BzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0Nl
# ckF1dF8yMDEwLTA2LTIzLmNydDANBgkqhkiG9w0BAQsFAAOCAgEAnVV9/Cqt4Swf
# ZwExJFvhnnJL/Klv6lwUtj5OR2R4sQaTlz0xM7U518JxNj/aZGx80HU5bbsPMeTC
# j/ts0aGUGCLu6WZnOlNN3Zi6th542DYunKmCVgADsAW+iehp4LoJ7nvfam++Kctu
# 2D9IdQHZGN5tggz1bSNU5HhTdSRXud2f8449xvNo32X2pFaq95W2KFUn0CS9QKC/
# GbYSEhFdPSfgQJY4rPf5KYnDvBewVIVCs/wMnosZiefwC2qBwoEZQhlSdYo2wh3D
# YXMuLGt7bj8sCXgU6ZGyqVvfSaN0DLzskYDSPeZKPmY7T7uG+jIa2Zb0j/aRAfbO
# xnT99kxybxCrdTDFNLB62FD+CljdQDzHVG2dY3RILLFORy3BFARxv2T5JL5zbcqO
# Cb2zAVdJVGTZc9d/HltEAY5aGZFrDZ+kKNxnGSgkujhLmm77IVRrakURR6nxt67I
# 6IleT53S0Ex2tVdUCbFpAUR+fKFhbHP+CrvsQWY9af3LwUFJfn6Tvsv4O+S3Fb+0
# zj6lMVGEvL8CwYKiexcdFYmNcP7ntdAoGokLjzbaukz5m/8K6TT4JDVnK+ANuOaM
# mdbhIurwJ0I9JZTmdHRbatGePu1+oDEzfbzL6Xu/OHBE0ZDxyKs6ijoIYn/ZcGNT
# TY3ugm2lBRDBcQZqELQdVTNYs6FwZvKhggLLMIICNAIBATCB+KGB0KSBzTCByjEL
# MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
# bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWlj
# cm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEmMCQGA1UECxMdVGhhbGVzIFRTUyBF
# U046MTJCQy1FM0FFLTc0RUIxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFNlcnZpY2WiIwoBATAHBgUrDgMCGgMVAKOO55cMT4syPP6nClg2IWfajMqkoIGD
# MIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNV
# BAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQG
# A1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwDQYJKoZIhvcNAQEF
# BQACBQDoFVibMCIYDzIwMjMwNTIyMTA1NzMxWhgPMjAyMzA1MjMxMDU3MzFaMHQw
# OgYKKwYBBAGEWQoEATEsMCowCgIFAOgVWJsCAQAwBwIBAAICKoAwBwIBAAICEbQw
# CgIFAOgWqhsCAQAwNgYKKwYBBAGEWQoEAjEoMCYwDAYKKwYBBAGEWQoDAqAKMAgC
# AQACAwehIKEKMAgCAQACAwGGoDANBgkqhkiG9w0BAQUFAAOBgQBMmIOHSyq81JIP
# eL28x8qqr5dMUoV4fK1ejvDycMNoDy98FH8zJ+qJMdDGKsK6I3sjH15lXD97gVsh
# 3Hn3lYwqE9TfjB5aw/eJMoFGRJV6+wRwvhhs5c9C4Ce5F6GuSOmt8FQYPLG9aOtM
# XQF3IwZ3snNDHWJeNmMHee+i/nKcuDGCBA0wggQJAgEBMIGTMHwxCzAJBgNVBAYT
# AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYD
# VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBU
# aW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAByk/Cs+0DDRhsAAEAAAHKMA0GCWCGSAFl
# AwQCAQUAoIIBSjAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQwLwYJKoZIhvcN
# AQkEMSIEILGZYhBxFSDxMxqT3eHcKbkKhqgxDBqYZ2yg1KA5bLBVMIH6BgsqhkiG
# 9w0BCRACLzGB6jCB5zCB5DCBvQQgEz0b85vrVU2slZAk4jt1SDEk6IzZAwVCoWwF
# 3KzcGuAwgZgwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
# bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
# aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAA
# AcpPwrPtAw0YbAABAAAByjAiBCAb3uJOxBWLOdby6cIitU+x1+7k/e54onHzEk2m
# AmSvpDANBgkqhkiG9w0BAQsFAASCAgAtkvgTdzRCAd9FVAhkUW24Cf38XlTUuMUW
# Pnm5bqOI6xlRZ5SInwzHH6061pE1ZTEVwukEQwm+JmX11zb69LqneoobFQbGuPAs
# zk54WLUKJdqk5BrhPUbHf7hxlulhyyrmC4vdZL6A8hCpxchVQbjdmAeqIrfo97Pf
# 6V98KMB2vBDWHPMAy2A8pvEL4xeAkV1IsD7s7Gqfzc3Gv/ceecObOsvoFkDPEJHq
# Qhbl6UHoN1z8w21EjDPGRWJFolB5VIQv6rkFQde1VFJRRVzn8sSvozImvlaFH5yt
# SI+QFt4KrdaHp9yQoCvvgBaPtLf41/+YABRhyg8CQdT/gMebrrsCZxGWAMImtRfT
# JzQ7ZO2Eh6Qj+DdTNhP2fexjiD+DfoSbQIT4AGvi/mlfhXKJab4HH+QlcQwrmCDf
# RRuAs+p7dCkRF9N69uZoCnc2p0Ec2uaUX27gq1JMupWFdXVj/ZiBssYj0s/WYDlc
# OG8CqSknf4Ynm2EOTJOSJZLutPoC0dIust8upfa2hDgcA6qMprZ1VXVpmy8yPgQo
# AKV8VsdDsG5FN6S5tfZ7TnGV+njjb0LVvDqPOzp8SisZCbgi983uZldv8Wj+MnFq
# BSJHFaXaJCfGXWFnN4g1CH3FEVYsYXQFB+IuPvn+cFjNxFlrXj1dyzAuA0xbJG9v
# o6FcosNTmg==
# SIG # End signature block
