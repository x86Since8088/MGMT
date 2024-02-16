
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
The operation to create or update a logical network.
Please note some properties can be set only during logical network creation.
.Description
The operation to create or update a logical network.
Please note some properties can be set only during logical network creation.

.Outputs
Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Models.ILogicalNetworks
.Notes
COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.

SUBNET <ISubnet[]>: Subnet - list of subnets under the logical network
  [AddressPrefix <String>]: The address prefix for the subnet: Cidr for this subnet - IPv4, IPv6.
  [IPAllocationMethod <IPAllocationMethodEnum?>]: IPAllocationMethod - The IP address allocation method. Possible values include: 'Static', 'Dynamic'
  [IPConfigurationReference <ISubnetPropertiesFormatIPConfigurationReferencesItem[]>]: IPConfigurationReferences - list of IPConfigurationReferences
    [Id <String>]: IPConfigurationID
  [IPPool <IIPPool[]>]: network associated pool of IP Addresses
    [End <String>]: End of the IP address pool
    [Name <String>]: Name of the IP-Pool
    [Start <String>]: Start of the IP address pool
    [Type <IPPoolTypeEnum?>]: Type of the IP Pool [vm, vippool]
  [Name <String>]: Name - The name of the resource that is unique within a resource group. This name can be used to access the resource.
  [PropertiesAddressPrefixes <String[]>]: List of address prefixes for the subnet.
  [Route <IRoute[]>]: Collection of routes contained within a route table.
    [AddressPrefix <String>]: The destination CIDR to which the route applies.
    [Name <String>]: Name - name of the subnet
    [NextHopIPAddress <String>]: The IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance.
  [Vlan <Int32?>]: Vlan to use for the subnet
.Link
https://learn.microsoft.com/powershell/module/az.stackhcivm/new-azstackhcivmlogicalnetwork
#>

function New-AzStackHCIVMLogicalNetwork {
  [OutputType([Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Models.ILogicalNetworks])]
  [CmdletBinding( PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
  param(
      [Parameter(Mandatory)]
      [Alias('LogicalNetworkName')]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Path')]
      [System.String]
      # Name of the virtual network
      ${Name},
  
      [Parameter(Mandatory)]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Path')]
      [System.String]
      # The name of the resource group.
      # The name is case insensitive.
      ${ResourceGroupName},

      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Path')]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
      [System.String]
      # The ID of the target subscription.
      ${SubscriptionId},
  
      [Parameter(Mandatory)]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.String]
      # The geo-location where the resource lives
      ${Location},
  
      [Parameter(Mandatory)]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.String]
      # The name of the extended location.
      ${CustomLocationId},
   
      [Parameter()]
      [AllowEmptyCollection()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.String[]]
      # The list of DNS servers IP addresses.
      ${DnsServer},
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Runtime.Info(PossibleTypes=([Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Models.ITrackedResourceTags]))]
      [System.Collections.Hashtable]
      # Resource tags.
      ${Tag},
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.String]
      # Name of the network switch to be used for VMs
      ${VMSwitchName},
  
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.String[]]
      # List of address prefixes for the subnet.
      $AddressPrefix,
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.PSArgumentCompleterAttribute("Static", "Dynamic")]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.String]
      # The IP address allocation method. Possible values include: 'Static', 'Dynamic'
      $IpAllocationMethod, 
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.String]
      # End of the ip address pool
      $IpPoolEnd, 
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.String]
      # Start of the ip address pool
      $IpPoolStart, 
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.PSArgumentCompleterAttribute("vm", "vippool")]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.String]
      # Ip pool type
      $IpPoolType, 
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.Collections.Hashtable[]]
      # Network associated pool of IP Addresses
      $IpPool,
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.Collections.Hashtable[]]
      # Collection of routes contained within a route table.
      $Route, 
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.String]
      # Name of the subnet
      $SubnetName, 
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.Collections.Hashtable[]]
      # List of subnets under the virtual network
      $Subnet, 
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Body')]
      [System.Int32]
      # Vlan to use for the subnet
      $Vlan ,

      [Parameter()]
      [Alias('AzureRMContext', 'AzureCredential')]
      [ValidateNotNull()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Azure')]
      [System.Management.Automation.PSObject]
      # The credentials, account, tenant, and subscription used for communication with Azure.
      ${DefaultProfile},
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
      [System.Management.Automation.SwitchParameter]
      # Run the command as a job
      ${AsJob},
  
      [Parameter(DontShow)]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
      [System.Management.Automation.SwitchParameter]
      # Wait for .NET debugger to attach
      ${Break},
  
      [Parameter(DontShow)]
      [ValidateNotNull()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Runtime.SendAsyncStep[]]
      # SendAsync Pipeline Steps to be appended to the front of the pipeline
      ${HttpPipelineAppend},
  
      [Parameter(DontShow)]
      [ValidateNotNull()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Runtime.SendAsyncStep[]]
      # SendAsync Pipeline Steps to be prepended to the front of the pipeline
      ${HttpPipelinePrepend},
  
      [Parameter()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
      [System.Management.Automation.SwitchParameter]
      # Run the command asynchronously
      ${NoWait},
  
      [Parameter(DontShow)]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
      [System.Uri]
      # The URI for the proxy server to use
      ${Proxy},
  
      [Parameter(DontShow)]
      [ValidateNotNull()]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
      [System.Management.Automation.PSCredential]
      # Credentials for a proxy server to use for the remote call
      ${ProxyCredential},
  
      [Parameter(DontShow)]
      [Microsoft.Azure.PowerShell.Cmdlets.StackHCIVM.Category('Runtime')]
      [System.Management.Automation.SwitchParameter]
      # Use the default credentials for the proxy
      ${ProxyUseDefaultCredentials}
  
  )
  
      if ($Name -notmatch $vnetNameRegex){
        Write-Error "Invalid Name:  $Name. The name must start with an alphanumeric character, contain all alphanumeric characters or '-' or '_' or '.' and end with an alphanumeric character or '_'. The max length is 64 characters." -ErrorAction Stop
      }
  
      if ($CustomLocationId -notmatch $customLocationRegex){
        Write-Error "Invalid CustomLocationId: $CustomLocationId" -ErrorAction Stop
      } 
  
      if ($DnsServer){
        foreach ($DnsServ in $DnsServer){
          if ($DnsServ -notmatch $ipv4Regex){
              Write-Error "Invalid ipaddress provided for Dns Servers : $DnsServ." -ErrorAction Stop
          }
        }
      }
  
      if ($Subnet){
        Confirm-Subnets -Subnets $Subnet
  
      } else{
          $SubnetNew = @{}
          if ($IpAllocationMethod){
            if ($IpAllocationMethod.ToLower() -ne "dynamic" -and $IpAllocationMethod.ToLower() -ne "static"){
              Write-Error "Invalid Ip Allocation method provided: $IpAllocationMethod. Accepted values are 'dynamic' or 'static'" -ErrorAction Stop
            }
            $IpAllocationMethod = $IpAllocationMethod.ToLower()
            
            if ($IpAllocationMethod -eq "static"){
              $SubnetNew["IPAllocationMethod"] = 'Static'
              if (-Not $AddressPrefix){
                Write-Error "Invalid Configuration for Static IpAllocationMethod. AddressPrefix are required for Static IpAllocationMethod." -ErrorAction Stop
              }
            }
          } else {
            $SubnetNew["IPAllocationMethod"] = 'Dynamic'
          }
  
          if ($IpPoolStart -and $IpPoolEnd){
            if($IpPoolStart -notmatch $ipv4Regex){
              Write-Error "Invalid Ip Address provided : $IpPoolStart" -ErrorAction Stop
            }
  
            if($IpPoolEnd -notmatch $ipv4Regex){
              Write-Error "Invalid Ip Address provided : $IpPoolEnd" -ErrorAction Stop
            }
            $IpPoolNew = @{End = $IpPoolEnd; Start = $IpPoolStart}
            if ($IpPoolType){
              $IpPoolType = $IpPoolType.ToLower()
              if ($IpPoolType -ne "vm" -and $IpPoolType -ne "vippool"){
                Write-Error "Invalid IpPoolType provided: $IpPoolType. Accepted values are 'vm' and 'vippool'." -ErrorAction Stop
              }
              $IpPoolNew['Type'] = $IpPoolType
            }
            $SubnetNew["IPPool"] = @($IpPoolNew)
          } elseif ($IpPoolStart -or $IpPoolEnd){
              Write-Error "Both IpPoolStart and IpPoolEnd must be specified together." -ErrorAction Stop
          }
  
          if ($IpPool){
            Confirm-IpPools -IpPools $IpPool
            $SubnetNew["IPPool"] = $IpPool
          }
  
          if($Vlan){
            if ($Vlan -gt 4094 -or $Vlan -lt 1){
              Write-Error "Invalid value for Vlan : $Vlan. Valid range is 1-4094" -ErrorAction Stop
            }
            $SubnetNew["Vlan"] = $Vlan
          }
  
          if ($SubnetName){
            if ($SubnetName -notmatch $subnetNameRegex){
               Write-Error "Invalid SubnetName: $SubnetName. The name must start with an alphanumeric character, contain all alphanumeric characters or '-' or '_' or '.' and end with an alphanumeric character or '_'. The max length is 80 characters." -ErrorAction Stop
            }
            $SubnetNew["Name"] = $SubnetName
          }
  
          if ($AddressPrefix){
            foreach ($addPrefix in $AddressPrefix){
              if ($addPrefix -notmatch $cidrRegex){
                Write-Error "Invalid AddressPrefix: $addPrefix. Please use valid CIDR format." -ErrorAction Stop
              }
            }
  
            if ($AddressPrefix.length -eq 1){
              $SubnetNew["AddressPrefix"] = $AddressPrefix[0]
            } else {
              $SubnetNew["AddressPrefixes"] = $AddressPrefix
            }
  
          }
  
          if ($Route){
            Confirm-Routes -Routes $Route
            $SubnetNew["Route"] = $Route
  
          }
        
          $null = $PSBoundParameters.Remove("IpAllocationMethod")
          $null = $PSBoundParameters.Remove("IpPoolStart")
          $null = $PSBoundParameters.Remove("IpPoolEnd")
          $null = $PSBoundParameters.Remove("IpPoolType")
          $null = $PSBoundParameters.Remove("AddressPrefix")
          $null = $PSBoundParameters.Remove("Vlan")
          $null = $PSBoundParameters.Remove("SubnetName")
          $null = $PSBoundParameters.Remove("IpPool")
          $null = $PSBoundParameters.Remove("Route")
          $PSBoundParameters.Add("Subnet", $SubnetNew)
  
      } 
     
      return Az.StackHCIVM.internal\New-AzStackHCIVMLogicalNetwork @PSBoundParameters
  }
  
# SIG # Begin signature block
# MIIoOQYJKoZIhvcNAQcCoIIoKjCCKCYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDQVi6Kax1ljJ6F
# fysHnYbivyk2WwaPZ3UidpuHsYxhMaCCDYUwggYDMIID66ADAgECAhMzAAADri01
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
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEILmd
# 83Y6wIuM/xjrdyVC8xjTmKAaVXAaRm4B9M/R+JUpMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAByl4+cLN424kS4Ez7QdJ9z5v+B9B64KX8j54
# VUso3aQntpc0cwElHP1R3d9YQd7OxRPhWgy7/lYgzxPg3jSi17y/Xhl7dxUsEq7V
# QdStrwagVkHZ04T3hpk0XMsK9v/4O+IcGC7W4Emy+/gDHGAkiU+RUaJrPgaMsJ5y
# Dpq+khFcZnr9enw7kgx8l4U2GQRwO5Pz3IeDayRqrhhRTous++CvQHuZXp31xKrY
# oN9ZWHNdX8XNrNhMbvtUVGU6crq3eUeeOWwmYyVeYkb9nHHNgT6V7fFrA5x6ZLL3
# bIwUOEaNreN5Oj0hxOz6VhEOqUoG4qslBn4vFynTmi16qOZgYKGCF5QwgheQBgor
# BgEEAYI3AwMBMYIXgDCCF3wGCSqGSIb3DQEHAqCCF20wghdpAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFSBgsqhkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCBZ3/Wu4lipf/CbgtzE8llRu1bsZO6pdswA
# KAN02M8J6gIGZZ/gBDIeGBMyMDI0MDEzMDA1MDQ1My45MThaMASAAgH0oIHRpIHO
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
# CyqGSIb3DQEJEAEEMC8GCSqGSIb3DQEJBDEiBCC3fndM5hbhS7BFGV0TGVhWHNSj
# nFouJU+hvk3BqF2FQTCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EILPpsLqe
# NS4NuYXE2VJlMuvQeWVA80ZDFhpOPjSzhPa/MIGYMIGApH4wfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTACEzMAAAHPUja+cUvNSMoAAQAAAc8wIgQgxvq/vjpl
# ap0udZdRLjJEC8T4CoiZ1T/glkkXErMSKeEwDQYJKoZIhvcNAQELBQAEggIADbTm
# UJx2P2/Y8BJLLV0zQwQT96Yy/Zrvgd2AeVWErs/g6Fmzw0EZ/M0sRLyzmgxkMzrt
# Ii9YAJ+41T7cH8gRttqyabbW45zq/Hcd+jZWCjXba6+3LWcIX5tJOeqI6h1wTHV6
# LI0lK6AXKnhPHcj5PKV9KDilbmqF+nQUfEI/A4rYA2TGNC2RBZgRVdCVbBrl1uL5
# 2sKdmKWNDrqZkFnutpPBMELDN7rIixORHVA3HtMZiZWvHMbZDHLAQL93hCgpw65R
# xLMsZRLblszInpA1E2u8i0U3VVcyBghFzYF1a23x9YP++mPwMZ3Finc5bo0G3cgf
# ByCUCrz16buM/PnelrDZ9oOn3QEJB9bJY/47YYR6Yv1TBWwViITleWsGlblZPFQ1
# 3da4llQ7eXTK5PG8PC8hq1qK3Jc26RwueHJ5O93k116EzmklttLno+gt/1ikl0X2
# mJ469k4ZAI3xBT4UaQOAVnTC6NGd9AT7aGsCX2TkAv2rkFw72S413C253tHgeh/y
# xNxW3GjSLTJb0IkLHH+6Q5VuFSAM/Re6ILXjjfil482zur5/uuAYtnfrx6RYQS8X
# ynyP580IjOeudaOzvZRC+kT5/av0rrC0gXTDpCW3r/RJwwmlsE7sqiqrJ4H3e+iM
# bwXoWhlsvG69dB3gzQcgny4xw0piuoI3VB6gT5k=
# SIG # End signature block
