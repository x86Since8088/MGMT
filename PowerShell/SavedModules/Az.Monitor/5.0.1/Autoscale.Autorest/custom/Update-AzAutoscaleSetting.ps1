
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
Updates an existing AutoscaleSettingsResource.
To update other fields use the CreateOrUpdate method.
.Description
Updates an existing AutoscaleSettingsResource.
To update other fields use the CreateOrUpdate method.
.Example
{{ Add code here }}
.Example
{{ Add code here }}

.Inputs
Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Models.IAutoscaleIdentity
.Outputs
Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Models.Api20221001.IAutoscaleSettingResource
.Notes
COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.

INPUTOBJECT <IAutoscaleIdentity>: Identity Parameter
  [AutoscaleSettingName <String>]: The autoscale setting name.
  [Id <String>]: Resource identity path
  [ResourceGroupName <String>]: The name of the resource group. The name is case insensitive.
  [SubscriptionId <String>]: The ID of the target subscription.

NOTIFICATION <IAutoscaleNotification[]>: the collection of notifications.
  [EmailCustomEmail <String[]>]: the custom e-mails list. This value can be null or empty, in which case this attribute will be ignored.
  [EmailSendToSubscriptionAdministrator <Boolean?>]: a value indicating whether to send email to subscription administrator.
  [EmailSendToSubscriptionCoAdministrator <Boolean?>]: a value indicating whether to send email to subscription co-administrators.
  [Webhook <IWebhookNotification[]>]: the collection of webhook notifications.
    [Property <IWebhookNotificationProperties>]: a property bag of settings. This value can be empty.
      [(Any) <String>]: This indicates any property can be added to this object.
    [ServiceUri <String>]: the service address to receive the notification.

PROFILE <IAutoscaleProfile[]>: the collection of automatic scaling profiles that specify different scaling parameters for different time periods. A maximum of 20 profiles can be specified.
  CapacityDefault <String>: the number of instances that will be set if metrics are not available for evaluation. The default is only used if the current instance count is lower than the default.
  CapacityMaximum <String>: the maximum number of instances for the resource. The actual maximum number of instances is limited by the cores that are available in the subscription.
  CapacityMinimum <String>: the minimum number of instances for the resource.
  Name <String>: the name of the profile.
  Rule <IScaleRule[]>: the collection of rules that provide the triggers and parameters for the scaling action. A maximum of 10 rules can be specified.
    MetricTriggerMetricName <String>: the name of the metric that defines what the rule monitors.
    MetricTriggerMetricResourceUri <String>: the resource identifier of the resource the rule monitors.
    MetricTriggerOperator <ComparisonOperationType>: the operator that is used to compare the metric data and the threshold.
    MetricTriggerStatistic <MetricStatisticType>: the metric statistic type. How the metrics from multiple instances are combined.
    MetricTriggerThreshold <Double>: the threshold of the metric that triggers the scale action.
    MetricTriggerTimeAggregation <TimeAggregationType>: time aggregation type. How the data that is collected should be combined over time. The default value is Average.
    MetricTriggerTimeGrain <TimeSpan>: the granularity of metrics the rule monitors. Must be one of the predefined values returned from metric definitions for the metric. Must be between 12 hours and 1 minute.
    MetricTriggerTimeWindow <TimeSpan>: the range of time in which instance data is collected. This value must be greater than the delay in metric collection, which can vary from resource-to-resource. Must be between 12 hours and 5 minutes.
    ScaleActionCooldown <TimeSpan>: the amount of time to wait since the last scaling action before this action occurs. It must be between 1 week and 1 minute in ISO 8601 format.
    ScaleActionDirection <ScaleDirection>: the scale direction. Whether the scaling action increases or decreases the number of instances.
    ScaleActionType <ScaleType>: the type of action that should occur when the scale rule fires.
    [MetricTriggerDimension <IScaleRuleMetricDimension[]>]: List of dimension conditions. For example: [{"DimensionName":"AppName","Operator":"Equals","Values":["App1"]},{"DimensionName":"Deployment","Operator":"Equals","Values":["default"]}].
      DimensionName <String>: Name of the dimension.
      Operator <ScaleRuleMetricDimensionOperationType>: the dimension operator. Only 'Equals' and 'NotEquals' are supported. 'Equals' being equal to any of the values. 'NotEquals' being not equal to all of the values
      Value <String[]>: list of dimension values. For example: ["App1","App2"].
    [MetricTriggerDividePerInstance <Boolean?>]: a value indicating whether metric should divide per instance.
    [MetricTriggerMetricNamespace <String>]: the namespace of the metric that defines what the rule monitors.
    [MetricTriggerMetricResourceLocation <String>]: the location of the resource the rule monitors.
    [ScaleActionValue <String>]: the number of instances that are involved in the scaling action. This value must be 1 or greater. The default value is 1.
  [FixedDateEnd <DateTime?>]: the end time for the profile in ISO 8601 format.
  [FixedDateStart <DateTime?>]: the start time for the profile in ISO 8601 format.
  [FixedDateTimeZone <String>]: the timezone of the start and end times for the profile. Some examples of valid time zones are: Dateline Standard Time, UTC-11, Hawaiian Standard Time, Alaskan Standard Time, Pacific Standard Time (Mexico), Pacific Standard Time, US Mountain Standard Time, Mountain Standard Time (Mexico), Mountain Standard Time, Central America Standard Time, Central Standard Time, Central Standard Time (Mexico), Canada Central Standard Time, SA Pacific Standard Time, Eastern Standard Time, US Eastern Standard Time, Venezuela Standard Time, Paraguay Standard Time, Atlantic Standard Time, Central Brazilian Standard Time, SA Western Standard Time, Pacific SA Standard Time, Newfoundland Standard Time, E. South America Standard Time, Argentina Standard Time, SA Eastern Standard Time, Greenland Standard Time, Montevideo Standard Time, Bahia Standard Time, UTC-02, Mid-Atlantic Standard Time, Azores Standard Time, Cape Verde Standard Time, Morocco Standard Time, UTC, GMT Standard Time, Greenwich Standard Time, W. Europe Standard Time, Central Europe Standard Time, Romance Standard Time, Central European Standard Time, W. Central Africa Standard Time, Namibia Standard Time, Jordan Standard Time, GTB Standard Time, Middle East Standard Time, Egypt Standard Time, Syria Standard Time, E. Europe Standard Time, South Africa Standard Time, FLE Standard Time, Turkey Standard Time, Israel Standard Time, Kaliningrad Standard Time, Libya Standard Time, Arabic Standard Time, Arab Standard Time, Belarus Standard Time, Russian Standard Time, E. Africa Standard Time, Iran Standard Time, Arabian Standard Time, Azerbaijan Standard Time, Russia Time Zone 3, Mauritius Standard Time, Georgian Standard Time, Caucasus Standard Time, Afghanistan Standard Time, West Asia Standard Time, Ekaterinburg Standard Time, Pakistan Standard Time, India Standard Time, Sri Lanka Standard Time, Nepal Standard Time, Central Asia Standard Time, Bangladesh Standard Time, N. Central Asia Standard Time, Myanmar Standard Time, SE Asia Standard Time, North Asia Standard Time, China Standard Time, North Asia East Standard Time, Singapore Standard Time, W. Australia Standard Time, Taipei Standard Time, Ulaanbaatar Standard Time, Tokyo Standard Time, Korea Standard Time, Yakutsk Standard Time, Cen. Australia Standard Time, AUS Central Standard Time, E. Australia Standard Time, AUS Eastern Standard Time, West Pacific Standard Time, Tasmania Standard Time, Magadan Standard Time, Vladivostok Standard Time, Russia Time Zone 10, Central Pacific Standard Time, Russia Time Zone 11, New Zealand Standard Time, UTC+12, Fiji Standard Time, Kamchatka Standard Time, Tonga Standard Time, Samoa Standard Time, Line Islands Standard Time
  [RecurrenceFrequency <RecurrenceFrequency?>]: the recurrence frequency. How often the schedule profile should take effect. This value must be Week, meaning each week will have the same set of profiles. For example, to set a daily schedule, set **schedule** to every day of the week. The frequency property specifies that the schedule is repeated weekly.
  [ScheduleDay <String[]>]: the collection of days that the profile takes effect on. Possible values are Sunday through Saturday.
  [ScheduleHour <Int32[]>]: A collection of hours that the profile takes effect on. Values supported are 0 to 23 on the 24-hour clock (AM/PM times are not supported).
  [ScheduleMinute <Int32[]>]: A collection of minutes at which the profile takes effect at.
  [ScheduleTimeZone <String>]: the timezone for the hours of the profile. Some examples of valid time zones are: Dateline Standard Time, UTC-11, Hawaiian Standard Time, Alaskan Standard Time, Pacific Standard Time (Mexico), Pacific Standard Time, US Mountain Standard Time, Mountain Standard Time (Mexico), Mountain Standard Time, Central America Standard Time, Central Standard Time, Central Standard Time (Mexico), Canada Central Standard Time, SA Pacific Standard Time, Eastern Standard Time, US Eastern Standard Time, Venezuela Standard Time, Paraguay Standard Time, Atlantic Standard Time, Central Brazilian Standard Time, SA Western Standard Time, Pacific SA Standard Time, Newfoundland Standard Time, E. South America Standard Time, Argentina Standard Time, SA Eastern Standard Time, Greenland Standard Time, Montevideo Standard Time, Bahia Standard Time, UTC-02, Mid-Atlantic Standard Time, Azores Standard Time, Cape Verde Standard Time, Morocco Standard Time, UTC, GMT Standard Time, Greenwich Standard Time, W. Europe Standard Time, Central Europe Standard Time, Romance Standard Time, Central European Standard Time, W. Central Africa Standard Time, Namibia Standard Time, Jordan Standard Time, GTB Standard Time, Middle East Standard Time, Egypt Standard Time, Syria Standard Time, E. Europe Standard Time, South Africa Standard Time, FLE Standard Time, Turkey Standard Time, Israel Standard Time, Kaliningrad Standard Time, Libya Standard Time, Arabic Standard Time, Arab Standard Time, Belarus Standard Time, Russian Standard Time, E. Africa Standard Time, Iran Standard Time, Arabian Standard Time, Azerbaijan Standard Time, Russia Time Zone 3, Mauritius Standard Time, Georgian Standard Time, Caucasus Standard Time, Afghanistan Standard Time, West Asia Standard Time, Ekaterinburg Standard Time, Pakistan Standard Time, India Standard Time, Sri Lanka Standard Time, Nepal Standard Time, Central Asia Standard Time, Bangladesh Standard Time, N. Central Asia Standard Time, Myanmar Standard Time, SE Asia Standard Time, North Asia Standard Time, China Standard Time, North Asia East Standard Time, Singapore Standard Time, W. Australia Standard Time, Taipei Standard Time, Ulaanbaatar Standard Time, Tokyo Standard Time, Korea Standard Time, Yakutsk Standard Time, Cen. Australia Standard Time, AUS Central Standard Time, E. Australia Standard Time, AUS Eastern Standard Time, West Pacific Standard Time, Tasmania Standard Time, Magadan Standard Time, Vladivostok Standard Time, Russia Time Zone 10, Central Pacific Standard Time, Russia Time Zone 11, New Zealand Standard Time, UTC+12, Fiji Standard Time, Kamchatka Standard Time, Tonga Standard Time, Samoa Standard Time, Line Islands Standard Time
.Link
https://learn.microsoft.com/powershell/module/az.monitor/update-azAutoscaleSetting
#>
function Update-AzAutoscaleSetting {
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Models.Api20221001.IAutoscaleSettingResource])]
    [CmdletBinding(DefaultParameterSetName='UpdateExpanded', PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(ParameterSetName='UpdateExpanded', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Path')]
        [System.String]
        [Alias("AutoscaleSettingName")]
        # The autoscale setting name.
        ${Name},
    
        [Parameter(ParameterSetName='UpdateExpanded', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Path')]
        [System.String]
        # The name of the resource group.
        # The name is case insensitive.
        ${ResourceGroupName},
    
        [Parameter(ParameterSetName='UpdateExpanded')]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
        [System.String]
        # The ID of the target subscription.
        ${SubscriptionId},
    
        [Parameter(ParameterSetName='UpdateViaIdentityExpanded', Mandatory, ValueFromPipeline)]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Models.IAutoscaleIdentity]
        # Identity Parameter
        # To construct, see NOTES section for INPUTOBJECT properties and create a hash table.
        ${InputObject},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Body')]
        [System.Boolean]
        # the enabled flag.
        # Specifies whether automatic scaling is enabled for the resource.
        # The default value is 'false'.
        ${Enabled},
    
        [Parameter()]
        [AllowEmptyCollection()]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Models.Api20221001.IAutoscaleNotification[]]
        # the collection of notifications.
        # To construct, see NOTES section for NOTIFICATION properties and create a hash table.
        ${Notification},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Body')]
        [System.TimeSpan]
        # the amount of time to specify by which instances are launched in advance.
        # It must be between 1 minute and 60 minutes in ISO 8601 format.
        ${PredictiveAutoscalePolicyScaleLookAheadTime},
    
        [Parameter()]
        [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Support.PredictiveAutoscalePolicyScaleMode])]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Support.PredictiveAutoscalePolicyScaleMode]
        # the predictive autoscale mode
        ${PredictiveAutoscalePolicyScaleMode},
    
        [Parameter()]
        [AllowEmptyCollection()]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Models.Api20221001.IAutoscaleProfile[]]
        # the collection of automatic scaling profiles that specify different scaling parameters for different time periods.
        # A maximum of 20 profiles can be specified.
        # To construct, see NOTES section for PROFILE properties and create a hash table.
        ${Profile},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Runtime.Info(PossibleTypes=([Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Models.Api20221001.IAutoscaleSettingResourcePatchTags]))]
        [System.Collections.Hashtable]
        # Resource tags
        ${Tag},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Body')]
        [System.String]
        # the location of the resource that the autoscale setting should be added to.
        ${TargetResourceLocation},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Body')]
        [System.String]
        # the resource identifier of the resource that the autoscale setting should be added to.
        ${TargetResourceUri},
    
        [Parameter()]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Monitor.Autoscale.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
    )
    process {
      try {        
        $hasEnabled = $PSBoundParameters.Remove("Enabled")
        $hasNotification = $PSBoundParameters.Remove("Notification")
        $hasPredictiveAutoscalePolicyScaleLookAheadTime = $PSBoundParameters.Remove("PredictiveAutoscalePolicyScaleLookAheadTime")
        $hasPredictiveAutoscalePolicyScaleMode = $PSBoundParameters.Remove("PredictiveAutoscalePolicyScaleMode")
        $hasProfile = $PSBoundParameters.Remove("Profile")
        $hasTag = $PSBoundParameters.Remove("Tag")
        $hasTargetResourceLocation = $PSBoundParameters.Remove("TargetResourceLocation")
        $hasTargetResourceUri = $PSBoundParameters.Remove("TargetResourceUri")
        $hasAsJob = $PSBoundParameters.Remove('AsJob')
        $null = $PSBoundParameters.Remove('WhatIf')
        $null = $PSBoundParameters.Remove('Confirm')
        
        $AutoscaleSetting = Get-AzAutoscaleSetting @PSBoundParameters

        $null = $PSBoundParameters.Remove("InputObject")
        $null = $PSBoundParameters.Remove('ResourceGroupName')
        $null = $PSBoundParameters.Remove('Name')
        $null = $PSBoundParameters.Remove('SubscriptionId')

        if ($hasEnabled) {
          $AutoscaleSetting.Enabled = $Enabled
        }
        if ($hasNotification) {
          $AutoscaleSetting.Notification = $Notification
        }
        if ($hasPredictiveAutoscalePolicyScaleLookAheadTime) {
          $AutoscaleSetting.PredictiveAutoscalePolicyScaleLookAheadTime = $PredictiveAutoscalePolicyScaleLookAheadTime
        }
        if ($hasPredictiveAutoscalePolicyScaleMode) {
          $AutoscaleSetting.PredictiveAutoscalePolicyScaleMode = $PredictiveAutoscalePolicyScaleMode
        }
        if ($hasProfile) {
          $AutoscaleSetting.Profile = $Profile
        }
        if ($hasTag) {
          $AutoscaleSetting.Tag = $Tag
        }
        if ($hasTargetResourceLocation) {
          $AutoscaleSetting.TargetResourceLocation = $TargetResourceLocation
        }
        if ($hasTargetResourceUri) {
          $AutoscaleSetting.TargetResourceUri = $TargetResourceUri
        }
        if ($hasAsJob) {
          $PSBoundParameters.Add("AsJob", $AsJob)
        }

        if ($PSCmdlet.ShouldProcess("AutoscaleSetting $($AutoscaleSetting.Name)", "Create or update")) {
          Az.Autoscale.private\New-AzAutoscaleSetting_CreateViaIdentity @PSBoundParameters -InputObject $AutoscaleSetting -Parameter $AutoscaleSetting
        }
      } catch {

      }
    }
}
# SIG # Begin signature block
# MIIoLQYJKoZIhvcNAQcCoIIoHjCCKBoCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAk8c+NRX7K3Mk1
# HNC52dG+9aCGCLYgm6yqECDl/qVCgKCCDXYwggX0MIID3KADAgECAhMzAAADrzBA
# DkyjTQVBAAAAAAOvMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMxMTE2MTkwOTAwWhcNMjQxMTE0MTkwOTAwWjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDOS8s1ra6f0YGtg0OhEaQa/t3Q+q1MEHhWJhqQVuO5amYXQpy8MDPNoJYk+FWA
# hePP5LxwcSge5aen+f5Q6WNPd6EDxGzotvVpNi5ve0H97S3F7C/axDfKxyNh21MG
# 0W8Sb0vxi/vorcLHOL9i+t2D6yvvDzLlEefUCbQV/zGCBjXGlYJcUj6RAzXyeNAN
# xSpKXAGd7Fh+ocGHPPphcD9LQTOJgG7Y7aYztHqBLJiQQ4eAgZNU4ac6+8LnEGAL
# go1ydC5BJEuJQjYKbNTy959HrKSu7LO3Ws0w8jw6pYdC1IMpdTkk2puTgY2PDNzB
# tLM4evG7FYer3WX+8t1UMYNTAgMBAAGjggFzMIIBbzAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQURxxxNPIEPGSO8kqz+bgCAQWGXsEw
# RQYDVR0RBD4wPKQ6MDgxHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEW
# MBQGA1UEBRMNMjMwMDEyKzUwMTgyNjAfBgNVHSMEGDAWgBRIbmTlUAXTgqoXNzci
# tW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3JsMGEG
# CCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3J0
# MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIBAISxFt/zR2frTFPB45Yd
# mhZpB2nNJoOoi+qlgcTlnO4QwlYN1w/vYwbDy/oFJolD5r6FMJd0RGcgEM8q9TgQ
# 2OC7gQEmhweVJ7yuKJlQBH7P7Pg5RiqgV3cSonJ+OM4kFHbP3gPLiyzssSQdRuPY
# 1mIWoGg9i7Y4ZC8ST7WhpSyc0pns2XsUe1XsIjaUcGu7zd7gg97eCUiLRdVklPmp
# XobH9CEAWakRUGNICYN2AgjhRTC4j3KJfqMkU04R6Toyh4/Toswm1uoDcGr5laYn
# TfcX3u5WnJqJLhuPe8Uj9kGAOcyo0O1mNwDa+LhFEzB6CB32+wfJMumfr6degvLT
# e8x55urQLeTjimBQgS49BSUkhFN7ois3cZyNpnrMca5AZaC7pLI72vuqSsSlLalG
# OcZmPHZGYJqZ0BacN274OZ80Q8B11iNokns9Od348bMb5Z4fihxaBWebl8kWEi2O
# PvQImOAeq3nt7UWJBzJYLAGEpfasaA3ZQgIcEXdD+uwo6ymMzDY6UamFOfYqYWXk
# ntxDGu7ngD2ugKUuccYKJJRiiz+LAUcj90BVcSHRLQop9N8zoALr/1sJuwPrVAtx
# HNEgSW+AKBqIxYWM4Ev32l6agSUAezLMbq5f3d8x9qzT031jMDT+sUAoCw0M5wVt
# CUQcqINPuYjbS1WgJyZIiEkBMIIHejCCBWKgAwIBAgIKYQ6Q0gAAAAAAAzANBgkq
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGg0wghoJAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAOvMEAOTKNNBUEAAAAAA68wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIEtZVs1VRs1qbKnyLbQUZDqN
# O2B2M/TtskmWLWK+QAFUMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAWJR5Qzi7IQsNuWNbQjDPiL4RoQMUbpOk1szeJUB2M/6MeLjc+vyLfWRP
# mHxH37JkHl8xQ/66wEkdopPEUcMkHPHZuQQk2PslUJDMxVHdVGFTz/HIMHwSQ8Oj
# L53YZNeFneEL9r1h1c6EbpLtEBkv/FyvG8LFhqP0UbgslGMHD1iiXXzc1qCQKl1T
# jtvZolJTarhQiH6w5djvAYH8O+CN7QDg5gxrG1OuwGp45ItLhaO9E2oB6611Bzk7
# libANDTa/1+Os0+XM5sRaz5mEksn0VmJAKtr8PtaVYXvf9mVsQ7k4NaoBtUWSidg
# 8tHXs4iHOPe6/rGgDP1x0lztVtq+FaGCF5cwgheTBgorBgEEAYI3AwMBMYIXgzCC
# F38GCSqGSIb3DQEHAqCCF3AwghdsAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFSBgsq
# hkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCCIHbjJSoUpu/R8y/3nN5FEJBIkuuWEmt+fZoYarxQPBQIGZaAIL/A5
# GBMyMDI0MDEzMDA1MDQ1Ni4zMTRaMASAAgH0oIHRpIHOMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046N0YwMC0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Wg
# ghHtMIIHIDCCBQigAwIBAgITMwAAAdWpAs/Fp8npWgABAAAB1TANBgkqhkiG9w0B
# AQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYD
# VQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAeFw0yMzA1MjUxOTEy
# MzBaFw0yNDAyMDExOTEyMzBaMIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25z
# MScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046N0YwMC0wNUUwLUQ5NDcxJTAjBgNV
# BAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2UwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQDFfak57Oph9vuxtloABiLc6enT+yKH619b+OhGdkyh
# gNzkX80KUGI/jEqOVMV4Sqt/UPFFidx2t7v2SETj2tAzuVKtDfq2HBpu80vZ0vyQ
# DydVt4MDL4tJSKqgYofCxDIBrWzJJjgBolKdOJx1ut2TyOc+UOm7e92tVPHpjdg+
# Omf31TLUf/oouyAOJ/Inn2ih3ASP0QYm+AFQjhYDNDu8uzMdwHF5QdwsscNa9PVS
# GedLdDLo9jL6DoPF4NYo06lvvEQuSJ9ImwZfBGLy/8hpE7RD4ewvJKmM1+t6eQuE
# sTXjrGM2WjkW18SgUZ8n+VpL2uk6AhDkCa355I531p0Jkqpoon7dHuLUdZSQO40q
# mVIQ6qQCanvImTqmNgE/rPJ0rgr0hMPI/uR1T/iaL0mEq4bqak+3sa8I+FAYOI/P
# C7V+zEek+sdyWtaX+ndbGlv/RJb5mQaGn8NunbkfvHD1Qt5D0rmtMOekYMq7QjYq
# E3FEP/wAY4TDuJxstjsa2HXi2yUDEg4MJL6/JvsQXToOZ+IxR6KT5t5fB5FpZYBp
# VLMma3pm5z6VXvkXrYs33NXJqVWLwiswa7NUFV87Es2sou9Idw3yAZmHIYWgOQ+D
# IY1nY3aG5DODiwN1rJyEb+mbWDagrdVxcncr6UKKO49eoNTXEW+scUf6GwXG0KEy
# mQIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFK/QXKNO35bBMOz3R5giX7Ala2OaMB8G
# A1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8GA1UdHwRYMFYwVKBSoFCG
# Tmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29mdCUy
# MFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBsBggrBgEFBQcBAQRgMF4w
# XAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2Vy
# dHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3J0MAwG
# A1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwDgYDVR0PAQH/BAQD
# AgeAMA0GCSqGSIb3DQEBCwUAA4ICAQBmRddqvQuyjRpx0HGxvOqffFrbgFAg0j82
# v0v7R+/8a70S2V4t7yKYKSsQGI6pvt1A8JGmuZyjmIXmw23AkI5bZkxvSgws8rrB
# tJw9vakEckcWFQb7JG6b618x0s9Q3DL0dRq46QZRnm7U6234lecvjstAow30dP0T
# nIacPWKpPc3QgB+WDnglN2fdT1ruQ6WIVBenmpjpG9ypRANKUx5NRcpdJAQW2FqE
# HTS3Ntb+0tCqIkNHJ5aFsF6ehRovWZp0MYIz9bpJHix0VrjdLVMOpe7wv62t90E3
# UrE2KmVwpQ5wsMD6YUscoCsSRQZrA5AbwTOCZJpeG2z3vDo/huvPK8TeTJ2Ltu/I
# tXgxIlIOQp/tbHAiN8Xptw/JmIZg9edQ/FiDaIIwG5YHsfm2u7TwOFyd6OqLw18Z
# 5j/IvDPzlkwWJxk6RHJF5dS4s3fnyLw3DHBe5Dav6KYB4n8x/cEmD/R44/8gS5Pf
# uG1srjLdyyGtyh0KiRDSmjw+fa7i1VPoemidDWNZ7ksNadMad4ZoDvgkqOV4A6a+
# N8HIc/P6g0irrezLWUgbKXSN8iH9RP+WJFx5fBHE4AFxrbAUQ2Zn5jDmHAI3wYcQ
# DnnEYP51A75WFwPsvBrfrb1+6a1fuTEH1AYdOOMy8fX8xKo0E0Ys+7bxIvFPsUpS
# zfFjBolmhzCCB3EwggVZoAMCAQICEzMAAAAVxedrngKbSZkAAAAAABUwDQYJKoZI
# hvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
# DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24x
# MjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0eSAy
# MDEwMB4XDTIxMDkzMDE4MjIyNVoXDTMwMDkzMDE4MzIyNVowfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTAwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoIC
# AQDk4aZM57RyIQt5osvXJHm9DtWC0/3unAcH0qlsTnXIyjVX9gF/bErg4r25Phdg
# M/9cT8dm95VTcVrifkpa/rg2Z4VGIwy1jRPPdzLAEBjoYH1qUoNEt6aORmsHFPPF
# dvWGUNzBRMhxXFExN6AKOG6N7dcP2CZTfDlhAnrEqv1yaa8dq6z2Nr41JmTamDu6
# GnszrYBbfowQHJ1S/rboYiXcag/PXfT+jlPP1uyFVk3v3byNpOORj7I5LFGc6XBp
# Dco2LXCOMcg1KL3jtIckw+DJj361VI/c+gVVmG1oO5pGve2krnopN6zL64NF50Zu
# yjLVwIYwXE8s4mKyzbnijYjklqwBSru+cakXW2dg3viSkR4dPf0gz3N9QZpGdc3E
# XzTdEonW/aUgfX782Z5F37ZyL9t9X4C626p+Nuw2TPYrbqgSUei/BQOj0XOmTTd0
# lBw0gg/wEPK3Rxjtp+iZfD9M269ewvPV2HM9Q07BMzlMjgK8QmguEOqEUUbi0b1q
# GFphAXPKZ6Je1yh2AuIzGHLXpyDwwvoSCtdjbwzJNmSLW6CmgyFdXzB0kZSU2LlQ
# +QuJYfM2BjUYhEfb3BvR/bLUHMVr9lxSUV0S2yW6r1AFemzFER1y7435UsSFF5PA
# PBXbGjfHCBUYP3irRbb1Hode2o+eFnJpxq57t7c+auIurQIDAQABo4IB3TCCAdkw
# EgYJKwYBBAGCNxUBBAUCAwEAATAjBgkrBgEEAYI3FQIEFgQUKqdS/mTEmr6CkTxG
# NSnPEP8vBO4wHQYDVR0OBBYEFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMFwGA1UdIARV
# MFMwUQYMKwYBBAGCN0yDfQEBMEEwPwYIKwYBBQUHAgEWM2h0dHA6Ly93d3cubWlj
# cm9zb2Z0LmNvbS9wa2lvcHMvRG9jcy9SZXBvc2l0b3J5Lmh0bTATBgNVHSUEDDAK
# BggrBgEFBQcDCDAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMC
# AYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvX
# zpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20v
# cGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYI
# KwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNydDANBgkqhkiG
# 9w0BAQsFAAOCAgEAnVV9/Cqt4SwfZwExJFvhnnJL/Klv6lwUtj5OR2R4sQaTlz0x
# M7U518JxNj/aZGx80HU5bbsPMeTCj/ts0aGUGCLu6WZnOlNN3Zi6th542DYunKmC
# VgADsAW+iehp4LoJ7nvfam++Kctu2D9IdQHZGN5tggz1bSNU5HhTdSRXud2f8449
# xvNo32X2pFaq95W2KFUn0CS9QKC/GbYSEhFdPSfgQJY4rPf5KYnDvBewVIVCs/wM
# nosZiefwC2qBwoEZQhlSdYo2wh3DYXMuLGt7bj8sCXgU6ZGyqVvfSaN0DLzskYDS
# PeZKPmY7T7uG+jIa2Zb0j/aRAfbOxnT99kxybxCrdTDFNLB62FD+CljdQDzHVG2d
# Y3RILLFORy3BFARxv2T5JL5zbcqOCb2zAVdJVGTZc9d/HltEAY5aGZFrDZ+kKNxn
# GSgkujhLmm77IVRrakURR6nxt67I6IleT53S0Ex2tVdUCbFpAUR+fKFhbHP+Crvs
# QWY9af3LwUFJfn6Tvsv4O+S3Fb+0zj6lMVGEvL8CwYKiexcdFYmNcP7ntdAoGokL
# jzbaukz5m/8K6TT4JDVnK+ANuOaMmdbhIurwJ0I9JZTmdHRbatGePu1+oDEzfbzL
# 6Xu/OHBE0ZDxyKs6ijoIYn/ZcGNTTY3ugm2lBRDBcQZqELQdVTNYs6FwZvKhggNQ
# MIICOAIBATCB+aGB0aSBzjCByzELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEn
# MCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjdGMDAtMDVFMC1EOTQ3MSUwIwYDVQQD
# ExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQBO
# Ei+S/ZVFe6w1Id31m6Kge26lNKCBgzCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6WLp+jAiGA8yMDI0MDEzMDAzMjIz
# NFoYDzIwMjQwMTMxMDMyMjM0WjB3MD0GCisGAQQBhFkKBAExLzAtMAoCBQDpYun6
# AgEAMAoCAQACAiJsAgH/MAcCAQACAhNYMAoCBQDpZDt6AgEAMDYGCisGAQQBhFkK
# BAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAIAgEAAgMBhqAwDQYJ
# KoZIhvcNAQELBQADggEBAKCPFKz+ugJJcpPKOCDEVGAJ5UOawc4iezWCKhFKZXrX
# r+KIR/P9iL6sfAA9pDbYgjxHSO1LtOa3zeubZECHiLp07FGyGgrpFT5T5YgQ+Tux
# SKQD4+IGKEI+UJxAfMxl6vAM/S7G7qYzeOO3xb1HQr9jB1nrXDVHB9aUu3cIt1SS
# Yw8fMYvJLkf8zTtpC2OPxQXzjPhWgZZd0WkmFbPHgtKtFTrryPQX1IrZPk0GzavK
# /LBfXzzu2P9LoNNWAfqWZLwb1kSAB1ykKSDMQI24eWgl7tVNbxGtFk6UMgcDx4MA
# 8lPFgGNsYvk5t6pZi0YNiTRqAmiIACHttkbjele7beExggQNMIIECQIBATCBkzB8
# MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVk
# bW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1N
# aWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAdWpAs/Fp8npWgABAAAB
# 1TANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEE
# MC8GCSqGSIb3DQEJBDEiBCCSco8Bnzb1iDV6DcpVLrDfiLwNnBmLd8QMxLq/gi2n
# 9jCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EINm/I4YM166JMM7EKIcYvlcb
# r2CHjKC0LUOmpZIbBsH/MIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
# dCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENB
# IDIwMTACEzMAAAHVqQLPxafJ6VoAAQAAAdUwIgQg/o1eNIo3fgZ5CrKcbo1OoiYz
# ZsCRTMvQ0GEm+yhSzG0wDQYJKoZIhvcNAQELBQAEggIAONJV0mwDVS1BiBN7V55V
# KFH9tBs1yrxsDfDXFSMyfp10+gktmNL1uNOyn+iftK+5cDImOsXsFsY4NbojdxoW
# Z+C++7m/S3zLxE9eVtnObHbGhjxk5xfkUk5gaUEQEeUWapR+wjY3RDKPXwRBx4Qd
# DtU47R8jDQ2O645GIC3QbDAebPcU0aT4C+RzQiITjRBikKLg4DVAv/JxnSoeB4p8
# LVFvzWO5Oe/RAYndiZdAWvMl3XYRBbfDAv6zVlkaylSI6NLy7i0bTU6CVVbD4cbV
# N0Od1aad25RWStpSCYw6OjxLDWyGPIi6giOQM3ccJoCqOSQai8z8QAUCiZCkQJMU
# TFi6OpfTLlBFN2DhJ7/vaKilmiAu5/5N5fnm3fHO31BlZui4rU5wz741Co3lPbZs
# 0gNGpPIGbWOgpRs1xLeqbTplRXCWdAZCfZM+7O46kOO73art0VpzAlq4DnuJZTSj
# Xik9y6XQCmI4avPfdltPJn2aqfQyACT23vRRJS3Gnpkv4C7Pm3oJ3wrC3uukZVfU
# +kj7RWYzKuZbSy8Mozm4WJsbpuSI+s7pWzvlfIe9oT0diYFAgUwbfko/3xMXSU5N
# 09jn2rlbJ4iQnW8bNhJ0gIohE8ZjzfxWJzVWSVvlx4DGR+nC+VNKAKKySWDVreO6
# cZrWx9sGdmqwEmyOGD32Nac=
# SIG # End signature block