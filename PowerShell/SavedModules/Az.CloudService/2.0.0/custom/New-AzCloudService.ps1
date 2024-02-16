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
Create a CloudService Resource
.Description
Create a CloudService Resource 
#>

function New-AzCloudService {
    [OutputType('Microsoft.Azure.PowerShell.Cmdlets.CloudService.Models.Api20220904.ICloudService')]
    [CmdletBinding(PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
    param(
        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage', Mandatory)]
        [Parameter(ParameterSetName='quickCreateParameterSetWithStorage', Mandatory)]
        [Alias('CloudServiceName')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Path')]
        [System.String]
        # Name of the cloud service.
        ${Name},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage', Mandatory)]
        [Parameter(ParameterSetName='quickCreateParameterSetWithStorage', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Path')]
        [System.String]
        # Name of the resource group.
        ${ResourceGroupName},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage')]
        [Parameter(ParameterSetName='quickCreateParameterSetWithStorage')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Runtime.DefaultInfo(Script='(Get-AzContext).Subscription.Id')]
        [System.String]
        # Subscription credentials which uniquely identify Microsoft Azure subscription.
        # The subscription ID forms part of the URI for every service call.
        ${SubscriptionId},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage', Mandatory)]
        [Parameter(ParameterSetName='quickCreateParameterSetWithStorage', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Body')]
        [System.String]
        # Resource location.
        ${Location},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage', Mandatory)]
        [Parameter(ParameterSetName='quickCreateParameterSetWithStorage', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Body')]
        [System.String]
        # Specifies the XML service configuration (.cscfg) for the cloud service.
        ${ConfigurationFile},
        
        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage', Mandatory, HelpMessage="Path to .csdef file.")]
        [Parameter(ParameterSetName='quickCreateParameterSetWithStorage', Mandatory, HelpMessage="Path to .csdef file.")]
        [System.String]
        # Specifies the XML service definitions (.csdef) for the cloud service. 
        ${DefinitionFile},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage', Mandatory, HelpMessage='URL that refers to the location of the service package in the Blob service.')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Body')]
        [System.String]
        # Specifies a URL that refers to the location of the service package in the Blob service.
        # The service package URL can be Shared Access Signature (SAS) URI from any storage account.This is a write-only property and is not returned in GET calls.
        ${PackageUrl},

        [Parameter(ParameterSetName='quickCreateParameterSetWithStorage', Mandatory, HelpMessage='Path to .cspkg file. It will be uploaded to a blob')]
        [System.String]
        ${PackageFile},

        [Parameter(ParameterSetName='quickCreateParameterSetWithStorage', Mandatory, HelpMessage='Name of the storage account that will store the Package file.')]
        [System.String]
        ${StorageAccount},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage', HelpMessage="Describes a cloud service extension profile.")]
        [Parameter(ParameterSetName='quickCreateParameterSetWithStorage', HelpMessage="Describes a cloud service extension profile.")]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Models.Api20220904.ICloudServiceExtensionProfile]
        # Describes a cloud service extension profile.
        # To construct, see NOTES section for EXTENSIONPROFILE properties and create a hash table.
        ${ExtensionProfile},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage', HelpMessage="Indicates whether to start the cloud service immediately after it is created.")]
        [Parameter(ParameterSetName='quickCreateParameterSetWithStorage', HelpMessage="Indicates whether to start the cloud service immediately after it is created.")]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        # (Optional) Indicates whether to start the cloud service immediately after it is created.
        # The default value is `true`.If false, the service model is still deployed, but the code is not run immediately.
        # Instead, the service is PoweredOff until you call Start, at which time the service will be started.
        # A deployed service still incurs charges, even if it is poweredoff.
        ${StartCloudService},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage')]
        [Parameter(ParameterSetName='quickCreateParameterSetWithStorage')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Runtime.Info(PossibleTypes=([Microsoft.Azure.PowerShell.Cmdlets.CloudService.Models.Api20220904.ICloudServiceTags]))]
        [System.Collections.Hashtable]
        # Resource tags.
        ${Tag},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage', HelpMessage="Update mode for the cloud service.")]
        [Parameter(ParameterSetName='quickCreateParameterSetWithStorage', HelpMessage="Update mode for the cloud service.")]
        [ArgumentCompleter([Microsoft.Azure.PowerShell.Cmdlets.CloudService.Support.CloudServiceUpgradeMode])]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.CloudService.Support.CloudServiceUpgradeMode]
        # Update mode for the cloud service.
        # Role instances are allocated to update domains when the service is deployed.
        # Updates can be initiated manually in each update domain or initiated automatically in all update domains.Possible Values are <br /><br />**Auto**<br /><br />**Manual** <br /><br />**Simultaneous**<br /><br />If not specified, the default value is Auto.
        # If set to Manual, PUT UpdateDomain must be called to apply the update.
        # If set to Auto, the update is automatically applied to each update domain in sequence.
        ${UpgradeMode},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage', HelpMessage= "Name of Dns to be used for the CloudService resource.")]
        [Parameter(ParameterSetName='quickCreateParameterSetWithStorage', HelpMessage= "Name of Dns to be used for the CloudService resource.")]
        [System.String]
        # Name of Dns to be used for the CloudService resource
        ${DnsName},

        [Parameter(ParameterSetName='quickCreateParameterSetWithoutStorage', HelpMessage= "Name of the KeyVault to be used for the CloudService resource.")]
        [Parameter(ParameterSetName='quickCreateParameterSetWithStorage', HelpMessage= "Name of the KeyVault to be used for the CloudService resource.")]
        [System.String]
        # Name of the KeyVault to be used for the CloudService resource
        ${KeyVaultName}
    )

    process {
        Import-Module Az.Network
        Import-Module Az.KeyVault
        Import-Module Az.Storage

        # extract csdef/cscfg 

        try {
            $getCS = Get-azcloudservice -resourcegroupname $ResourceGroupName -name $name -ErrorAction Stop
        }
        catch {
            # CloudService does not exist in that name/resource group
        }
        finally {
            if ($null -ne $getCS){
                throw "A Cloud Service resource with name: '" +$name + "' already exists in Resource Group: '" + $ResourceGroupName + "'. Please try another name."
            }
        }

        if (-not (Test-Path $ConfigurationFile))  
        {
            throw "Cannot find file: " + $ConfigurationFile 
        }
        if (-not (Test-Path $DefinitionFile))
        {
            throw "Cannot find file: " + $DefinitionFile
        }
        if ($PSBoundParameters.ContainsKey("PackageFile")){
            if (-not (Test-Path $PackageFile))
            {
                throw "Cannot find file: " + $PackageFile
            }
            $extn = [IO.Path]::GetExtension($PackageFile)
            if ($extn -ne ".cspkg" )
            {
                throw "The Definition File must have the file extension '.cspkg'"
            }
        }

        [xml]$csdef = Get-Content -Path $DefinitionFile
        [xml]$cscfg = Get-Content -Path $ConfigurationFile
        $Configuration = Get-Content -Path $ConfigurationFile | Out-String

        # do validation 
        $passMemory = @{}
        validation $cscfg $csdef $PSBoundParameters ([ref]$passMemory)

        # create resources
        If ($passMemory.ipFound -eq $false){
            Write-Host("Creating ReservedIP")
            $null = New-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name $passMemory.ipName -location $location -Sku Basic -AllocationMethod Static -WarningAction SilentlyContinue 
        }
        If ($passMemory.vNetFound -eq $False){
            # create subnets first 
            $subnetsList = @()
            $subnetCount = 0
            If ($True -eq $passMemory.CreateInternalLoadBalancer){
                $aSubnet = New-AzVirtualNetworkSubnetConfig -Name $cscfg.ServiceConfiguration.NetworkConfiguration.loadBalancers.Loadbalancer.FrontendIPConfiguration.subnet -AddressPrefix "10.0.0.0/24" -WarningAction SilentlyContinue 
                $subnetsList = $subnetsList + @($aSubnet)
                $subnetCount = $subnetCount + 1
                $passMemory.Add("theSubnet", $aSubnet)
            }

            foreach ($instaceAddress in $cscfg.ServiceConfiguration.NetworkConfiguration.AddressAssignments.InstanceAddress) {
                if ( ($subnetsList.count -eq 0) -or (-not ($subnetsList.name.tolower()).contains($instaceAddress.subnets.subnet.Name.tolower())) ){
                    $addressPrefix = "10.0." + $subnetCount + ".0/24"
                    $aSubnet = New-AzVirtualNetworkSubnetConfig -Name $instaceAddress.subnets.subnet.Name -AddressPrefix $addressPrefix -WarningAction SilentlyContinue 
                    $subnetsList = $subnetsList + @($aSubnet)
                    $subnetCount = $subnetCount + 1
                }
            }

            # vnet
            Write-Host("Creating Virtual Network")
            $null = New-AzVirtualNetwork -name $passMemory.vnetName -resourcegroupname $resourcegroupname -location $location -AddressPrefix 10.0.0.0/16 -Subnet $subnetsList 
        }

        # if -storageaccount is given, upload to packageUrl to blob 
        if ($PSBoundParameters.ContainsKey("StorageAccount")) 
        {
            Write-Host("Uploading the csdef to a blob in the Storage Account.")
            $storageAccountObjs = Get-AzStorageAccount
            foreach ($storageAccountObj in $storageAccountObjs) {
                if ($storageAccountObj.StorageAccountName.tolower() -eq $storageAccount.tolower()){
                    break
                }
            }
            $containerName = "cloudservicecontainer"
            # check if container exists
            try {
                $container = get-azstorageContainer -context $storageAccountObj.context -name $containerName -ErrorAction Stop
            }
            catch {
                # does not exist
                $container = New-AzStorageContainer -Name $containerName -Context $storageAccountObj.Context -Permission Blob
            }
            
            # Upload your Cloud Service package (cspkg) to the storage account.
            $tokenStartTime = Get-Date 
            $tokenEndTime = $tokenStartTime.AddYears(1) 
            $cspkgBlob = Set-AzStorageBlobContent -File $PackageFile -Container $container.name -Blob ($name + ".cspkg") -Context $storageAccountObj.Context 
            $cspkgToken = New-AzStorageBlobSASToken -Container $container.name -Blob $cspkgBlob.Name -Permission rwd -StartTime $tokenStartTime -ExpiryTime $tokenEndTime -Context $storageAccountObj.Context 
            $cspkgUrl = $cspkgBlob.ICloudBlob.Uri.AbsoluteUri + $cspkgToken 
            
            $null = $PSBoundParameters.Remove("StorageAccount")
            $null = $PSBoundParameters.Remove("PackageFile")
            $null = $PSBoundParameters.Add("packageURL", $cspkgURL)
        }

        # network profile
        if ( $null -eq $cscfg.ServiceConfiguration.NetworkConfiguration.AddressAssignments.ReservedIPs.ReservedIP ){
            # Create a public IP address and (optionally) set the DNS label property of the public IP address. If you are using a static IP, it needs to referenced as a Reserved IP in Service Configuration file.
            $publicIpName = $name + "Ip"
            if ($PSBoundParameters.ContainsKey("DnsName")) 
            {
                $publicIp = New-AzPublicIpAddress -Name $publicIPName -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Dynamic -IpAddressVersion IPv4 -DomainNameLabel $DnsName -Sku Basic -WarningAction SilentlyContinue 
                $null = $PSBoundParameters.Remove("DnsName")
            }
            else {
                $publicIp = New-AzPublicIpAddress -Name $publicIpName -ResourceGroupName $ResourceGroupName -Location $Location -AllocationMethod Dynamic -IpAddressVersion IPv4 -Sku Basic -WarningAction SilentlyContinue 
            } 
        }
        else {
            $publicIpName = $cscfg.ServiceConfiguration.NetworkConfiguration.AddressAssignments.ReservedIPs.ReservedIP.Name
        }
        
            # Create Network Profile Object and associate public IP address to the frontend of the platform created load balancer.
        $publicIP = Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Name $publicIpName  
        $feIpConfig = New-AzCloudServiceLoadBalancerFrontendIPConfigurationObject -Name ($name+'LbFe') -PublicIPAddressId $publicIP.Id 
        $loadBalancerConfig = New-AzCloudServiceLoadBalancerConfigurationObject -Name ($name + 'LB') -FrontendIPConfiguration $feIpConfig 
        $networkProfile = @{loadBalancerConfiguration = $loadBalancerConfig}
        
        If ( $null -ne $cscfg.ServiceConfiguration.NetworkConfiguration.loadBalancers.loadBalancer){
            $privateLB = $cscfg.ServiceConfiguration.NetworkConfiguration.loadBalancers.loadBalancer
            $feIpConfig2 = New-AzCloudServiceLoadBalancerFrontendIPConfigurationObject -Name ($privateLB.name + 'Fe') -privateIPAddress $privateLB.FrontendIPConfiguration.staticVirtualNetworkIPAddress -subnetId $passMemory.theSubnet.Id
            $loadBalancerConfig2 = New-AzCloudServiceLoadBalancerConfigurationObject -Name $privateLB.name -FrontendIPConfiguration $feIpConfig2
            $networkProfile = @{loadBalancerConfiguration = @($loadBalancerConfig, $loadBalancerConfig2)}
        }

        $null = $PSBoundParameters.Add("NetworkProfile", $networkProfile)

    
        # OS Profile
        if ($PSBoundParameters.ContainsKey("KeyVaultName")) {
            $keyVault = $passMemory.KeyVault 
            $certSecretList = $passMemory.certSecretList

            $secretGroup = New-AzCloudServiceVaultSecretGroupObject -Id $keyVault.ResourceId -CertificateUrl $certSecretList 
            $osProfile = @{secret = @($secretGroup)}

            $null = $PSBoundParameters.Remove("keyvaultname")
            $null = $PSBoundParameters.Add("OSProfile", $osProfile)
        }

        # Role Profile 
        $roleProfileList = @()

        foreach ($role in $cscfg.ServiceConfiguration.Role) {
            # find in csdef
            $RoleFoundinCsDef = $false
            foreach ($webRole in $csdef.ServiceDefinition.WebRole) {
                if ($role.name -eq $webRole.name){
                    $RoleFoundinCsDef = $true
                    $defRole = $webRole
                    break
                }
            }
            if (-not $RoleFoundinCsDef){
                foreach ($workerRole in $csdef.ServiceDefinition.WorkerRole) {
                    if($role.name -eq $workerRole.name){
                        $RoleFoundinCsDef = $true
                        $defRole = $workerRole
                        break
                    }
                }
            }

            $newRole = New-AzCloudServiceRoleProfilePropertiesObject -Name $defRole.Name -SkuName $defRole.vmsize -SkuTier 'Standard' -SkuCapacity $role.Instances.count 
            $roleProfileList = $roleProfileList + @($newRole)
        }

        $roleProfile = @{role = $roleProfileList} 
        $null = $PSBoundParameters.Add("roleProfile", $RoleProfile)

        
        $null = $PSBoundParameters.Remove("DefinitionFile")
        $null = $PSBoundParameters.Remove("ConfigurationFile")
        $null = $PSBoundParameters.Add("Configuration", $Configuration)

        

        # Perform action
        Write-Host("Creating the Cloud Service resource.")
        Az.CloudService\New-AzCloudService @PSBoundParameters
    }

}

function validation
{
    [Microsoft.Azure.PowerShell.Cmdlets.CloudService.DoNotExportAttribute()]
    param(
        [Parameter()]
        [object]
        ${cscfg},
        [Parameter()]
        [object]
        ${csdef},
        [Parameter()]
        [Hashtable]
        $params,
        [Parameter()]
        [Hashtable]
        [ref]$passMemory
    )

    Write-Host("Checking validations on the .cscfg and .csdef files.")

    # Network configuration missing in configuration
    If ( ($null -eq $cscfg.ServiceConfiguration.NetworkConfiguration) -or (($cscfg.ServiceConfiguration.NetworkConfiguration.VirtualNetworkSite | Measure-Object | Select-Object -expandproperty count) -eq 0) -or (($cscfg.ServiceConfiguration.NetworkConfiguration.AddressAssignments.InstanceAddress.Subnets | Measure-Object | Select-Object -ExpandProperty count) -eq 0) )
    {
        throw "The network configuration is missing from the configuration file. Please add the network configuration to the configuration file."
    }

    # CS definition and configuration match
    if (($cscfg.ServiceConfiguration.Role | Measure-Object | Select-Object -ExpandProperty count) -eq 1){
        $csCfgRoleNames = @($cscfg.ServiceConfiguration.Role.name.tolower())
    }elseif(($cscfg.ServiceConfiguration.Role | Measure-Object | Select-Object -ExpandProperty count) -gt 1){
        $csCfgRoleNames = $cscfg.ServiceConfiguration.Role.name.tolower()
    }

    $csDefRoleNames = @()
    if (($csdef.ServiceDefinition.WebRole | Measure-Object | select-object -expandproperty count) -eq 1){
        $csDefRoleNames = @($csdef.ServiceDefinition.WebRole.name.tolower())
    }elseif (($csdef.ServiceDefinition.WebRole | Measure-Object | select-object -expandproperty count) -gt 1) {
        $csDefRoleNames = $csdef.ServiceDefinition.WebRole.name.tolower()
    }
    if (($csdef.ServiceDefinition.WorkerRole | Measure-Object | select-object -expandproperty count) -eq 1){
        $csDefRoleNames = $csDefRoleNames + @($csdef.ServiceDefinition.WorkerRole.name.tolower())
    }elseif (($csdef.ServiceDefinition.WorkerRole | Measure-Object | select-object -expandproperty count) -gt 1) {
        $csDefRoleNames = $csDefRoleNames + $csdef.ServiceDefinition.WorkerRole.name.tolower()
    }

    foreach ($aRoleName in $csCfgRoleNames){
        if (-not $csDefRoleNames.contains($aRoleName)){
            throw "The CSCFG did not match the CSDEF. More details: No role named '" + $aRoleName + "' found in the service definition file. For more details please refer to : https://aka.ms/cses-cscfg-csdef"
        }
    }
    foreach ($aRoleName in $csDefRoleNames){
        if (-not $csCfgRoleNames.contains($aRoleName)){
            throw "The CSCFG did not match the CSDEF. More details: No role named '" + $aRoleName + "' found in the service configuration file. For more details please refer to : https://aka.ms/cses-cscfg-csdef"
        }
    }

    $certList = @()
    foreach ($role in $cscfg.ServiceConfiguration.Role){
        $defCerts = ($csdef.ServiceDefinition.childnodes | where-object {$_.name.tolower() -eq $role.name.tolower()}).Certificates.Certificate
        If ( 1 -eq $defCerts.count ){
            $defCerts = @($defCerts)
        }
        foreach ($cert in $role.Certificates.Certificate){
            if ( "Microsoft.WindowsAzure.Plugins.RemoteAccess.PasswordEncryption" -ne $cert.Name){
                # CS definition and configuration match
                if ( -not $defCerts.name.tolower().Contains($cert.Name.tolower())){
                    throw "The service definition file does not provide a certificate definition for certificate '" + $cert.name + "' for role '"+ $role.name +"'. For more details please refer to : https://aka.ms/cses-cscfg-csdef"
                }
                if ($certList.Count -eq 0 -or -not $certList.thumbprint.Contains($cert.thumbprint))
                {
                    $certList = $certList + $cert
                }
            }
        }
    }

    # Existing Virtual Network Location Mismatch
    # check if vnet exists
    $vnetNameSplitCount = ($cscfg.ServiceConfiguration.NetworkConfiguration.VirtualNetworkSite.name).split().count
    if (3 -eq $vnetNameSplitCount){
        
        $vnetNameFormat = ($cscfg.ServiceConfiguration.NetworkConfiguration.VirtualNetworkSite.name).split()
        if ("group" -ne $vnetNameFormat[0].tolower()){
            throw "VirtualNetworkSite name should be formated either ""{Name}"" or ""Group {ResourceGroupName} {Name}""."
        }
        
        $passMemory.Add("vnetName", $vnetNameFormat[2])

        # look for the vnet
        try {
            $thevnet = Get-AzVirtualNetwork -ResourceGroupName $vnetNameFormat[1] -Name $vnetNameFormat[2] -ErrorAction Stop
            if ($thevnet.location.replace(" ","").tolower() -eq $Location.replace(" ","").tolower()){
                $vnetFound = $true
            }else {
                $vnetLocationMatch = $false
            }
        }
        catch {
            $vnetFound = $false
        }

    } elseif (1 -eq $vnetNameSplitCount) {
        $passMemory.Add("vnetName", $cscfg.ServiceConfiguration.NetworkConfiguration.VirtualNetworkSite.name)
        try {
            $thevnet = Get-AzVirtualNetwork -name $cscfg.ServiceConfiguration.NetworkConfiguration.VirtualNetworkSite.name -ResourceGroupName $ResourceGroupName -ErrorAction Stop
            if ($thevnet.location.replace(" ","").tolower() -eq $Location.replace(" ","").tolower()){
                $vnetFound = $true
            }
            else {
                $vnetLocationMatch = $false
            }
        }
        catch {
            $vnetFound = $false
        }
    }else {
        throw "VirtualNetworkSite name should be formated either ""{Name}"" or ""Group {ResourceGroupName} {Name}""."
    }

    If($false -eq $vnetLocationMatch){
        throw "The location for the cloud service (" + $location + ") and virtual network ("+ $thevnet.location +") are different. The location of the cloud service needs to match the location of the virtual network. Change the location of the cloud service to match the virtual network or change the resource group of the cloud service to try to resolve this issue."
    }

    $passMemory.Add("vnetFound", $vnetFound)

    If ($vnetFound){
        If (1 -eq $theVNet.subnets.count){
            $vnetSubnets = @($theVnet.Subnets)
        }
        else {
            $vnetSubnets = $theVnet.subnets
        }
    
        # Existing Virtual Network Missing Subnets  
        foreach ($instaceAddress in $cscfg.ServiceConfiguration.NetworkConfiguration.AddressAssignments.InstanceAddress) {
            if (-not ($vnetSubnets.name.tolower()).contains($instaceAddress.subnets.subnet.Name.tolower())){
                throw "Subnet defined in the CSCFG file: '" + $instaceAddress.subnets.subnet.Name + "' could not be found in the Virtual Network: '" + $theVNet.name + "'. Please add the subnet to the virtual network."
            }
        }
    }


    # Internal load balancer private ip contained in subnet 
    If ( $null -ne $cscfg.ServiceConfiguration.NetworkConfiguration.loadBalancers.loadBalancer){
        $InternalLBFEConfig = $cscfg.ServiceConfiguration.NetworkConfiguration.loadBalancers.Loadbalancer.FrontendIPConfiguration 
        If ($vnetFound){
            $theSubnet = $thevnet.Subnets | where-object {$_.Name.tolower() -eq $InternalLBFEConfig.subnet.tolower()}
            If ($null -eq $theSubnet){
                throw "Subnet defined in the CSCFG file: '" + $InternalLBFEConfig.subnet + "' could not be found in the Virtual Network: '" + $theVNet.name + "'. Please add the subnet to the virtual network."
            }
            $passMemory.Add("theSubnet", $theSubnet)
            $addressPrefix = $theSubnet.AddressPrefix
        }
        else{
            $passMemory.Add("CreateInternalLoadBalancer", $true)
            $addressPrefix = "10.0.0.0/24" 
        }

        $maskNumber = $addressPrefix.split("/")[1]

        $subnetAddress = $addressPrefix.split("/")[0]
        $subnetBinary = -join ($subnetAddress -split '\.' | ForEach-Object {
            [System.Convert]::ToString($_,2).PadLeft(8,'0')
        })

        $LBIP = $InternalLBFEConfig.staticVirtualNetworkIPAddress
        $LBIPBinary = -join ($LBIP -split '\.' | ForEach-Object {
            [System.Convert]::ToString($_,2).PadLeft(8,'0')
        })

        If ($subnetBinary.substring(0,$maskNumber)  -ne $LBIPbinary.substring(0,$maskNumber)){
            If ($vnetFound){
                throw "The internal load balancer subnet '" + $InternalLBFEConfig.subnet + "' does not contain the private IP " + $LBIP + ". Update the subnet within the Virtual Network to include the Private IP."
            }else{
                throw "The default internal load balancer subnet which will be created: '"+ $addressPrefix +"' does not contain the private IP " + $LBIP + ". Either update private IP or provided an already created virtual network and subnet."
            }
        }
    }
    
    if ( $null -ne $cscfg.ServiceConfiguration.NetworkConfiguration.AddressAssignments.ReservedIPs.ReservedIP ){
        
        $IpNameSplitCount = ($cscfg.ServiceConfiguration.NetworkConfiguration.AddressAssignments.ReservedIPs.ReservedIP.Name).split().count
        if (3 -eq $IpNameSplitCount){
            
            $IpNameFormat = ($cscfg.ServiceConfiguration.NetworkConfiguration.AddressAssignments.ReservedIPs.ReservedIP.Name).split()
            if ("group" -ne $IpNameFormat[0].tolower()){
                throw "ReservedIP name should be formated either ""{Name}"" or ""Group {ResourceGroupName} {Name}""."
            }
            $passMemory.Add("ipName", $IpNameFormat[2])

            # look for the Ip
            try {
                $theIpObj = Get-AzPublicIpAddress -ResourceGroupName $IpNameFormat[1] -Name $IpNameFormat[2] -ErrorAction Stop
                if ($theIpObj.location.replace(" ","").tolower() -eq $Location.replace(" ","").tolower()){
                    $ipFound = $true
                }else {
                    $ipLocationMatch = $false
                }
            }
            catch {
                $ipFound = $false
            }

        }elseif (1 -eq $IpNameSplitCount) {
            $passMemory.Add("ipName", $cscfg.ServiceConfiguration.NetworkConfiguration.AddressAssignments.ReservedIPs.ReservedIP.Name)
            try {
                $theIpObj = Get-AzPublicIpAddress -name $cscfg.ServiceConfiguration.NetworkConfiguration.AddressAssignments.ReservedIPs.ReservedIP.Name -ResourceGroupName $ResourceGroupName -ErrorAction Stop
                # Existing Reserved (Static) IP Location Mismatch
                if ($theIpObj.Location.replace(" ","").tolower() -eq $location.replace(" ","").tolower()) {
                    $ipFound = $true
                } else {
                    $ipLocationMatch = $false
                }
            }
            catch {
                $ipFound = $false
            }
        } else {
            throw "ReservedIP name should be formated either ""{Name}"" or ""Group {ResourceGroupName} {Name}""."
        }

        If ($false -eq $IpLocationMatch){
            throw "The location for the Cloud Service (" + $location + ") and the Public IP Address (" + $theIPObj.location + ") are different. The location of the Cloud Service needs to match the location of the Public IP Address. Change the location of the Cloud Service to match the Public IP Address or change the resource group of the Cloud Service to try to resolve the issue."
        }
        
        $passMemory.Add("ipFound", $ipFound)

        If ($ipFound){
            
            # Existing Reserved (Static) IP In Use
            if ($null -ne $theIPObj.IPConfiguration){
                throw "The Public IP provided in the CSCFG: '" + $theIPObj.name + "' is currently in use by another resource."
            }

            # Existing Reserved (Static) IP Incorrect Sku
            if ("Basic" -ne $theIPObj.Sku.Name){
                throw "The Public IP provided in the CSCFG: '" + $theIPObj.name + "' must have a 'Basic' SKU."
            }

            # Existing Reserved (Static) IP Address Incorrect Version
            if ("IPv4" -ne $theIPObj.PublicIPAddressVersion){
                throw "The Public IP provided in the CSCFG: '" + $theIPObj.name + "' uses IPv6 and an IPv4 public IP address is needed."
            }

            # Existing Reserved (Static) IP Incorrect Allocation
            if ("Static" -ne $theIPObj.PublicIPAllocationMethod){
                throw "The Public IP provided in the CSCFG: '" + $theIPObj.name + "' uses a dynamic allocation and a static allocation is needed."
            }
        }
    }

    if ($params.ContainsKey("KeyVaultName")) {
        # Keyvault in same location 
        $keyVaultsWithName = Get-AzKeyVault -vaultName $keyvaultname 
        $keyvaultFound = $false
        foreach ($kv in $keyVaultsWithName) {
            if ($kv.location.replace(" ","").tolower() -eq $location.replace(" ","").tolower()) {
                $keyvaultFound = $true
                $theKV = Get-AzKeyVault -vaultName $keyvaultname -resourceGroupName $kv.resourcegroupname
                $passMemory.Add("KeyVault", $theKV)
            }
        }
        If (-not $keyvaultFound){
            throw "No KeyVault named '" + $keyvaultname + "' was found in " + $Location
        }

        # Keyvault has virtual machine deployment permission and user has list and get permissions
        If (-not $theKV.EnabledForDeployment){
            throw "The Key vault is not enabled for deployment. The Key Vault must have 'Azure Virtual Machines for deployment' access enabled. Please run the following cmdlets to enable access: Set-AzKeyVaultAccessPolicy -VaultName " + $keyvaultname + " -ResourceGroupName " +$resourcegroupname +" -EnabledForDeployment"
        }

        try {
            $certsInKV = Get-AzKeyVaultCertificate -VaultName $keyvaultname -ErrorAction Stop
        }
        catch [Microsoft.Azure.KeyVault.Models.KeyVaultErrorException]{
            $KVnoPolicy = $true
        }
        finally {
            If ($KVnoPolicy){
              throw "The certificates must have 'Get' and 'List' permissions enabled on the Key Vault. Please run the following cmdlets to enable access: Set-AzKeyVaultAccessPolicy -VaultName " + $keyvaultname +" -ResourceGroupName " + $theKV.resourcegroupname + " -UserPrincipalName 'user@domain.com' -PermissionsToCertificates create,get,list,delete "  
            }
        }

        # All certificates are found in the keyvault
        $certsObjsFromKeyvault = @()
        $certSecretList = @()
        foreach ($cert in $CertsInKV) {
            $certsObjsFromKeyvault = $certsObjsFromKeyvault + (Get-AzKeyVaultCertificate -VaultName $keyvaultname -name $cert.name)
        }
        foreach ($certFromFiles in $certList){
            $thumbprintFound = $false
            foreach ($certFromKV in $certsObjsFromKeyvault){
                if ($certFromFiles.thumbprint -eq $certFromKV.thumbprint){
                    $thumbprintFound = $true
                    $certSecretList = $certSecretList + $certFromKV.SecretId
                }
            }
            if (-not $thumbprintFound){
                throw "The thumbprints specified in the CSCFG could not be found in the Key Vault. Add the missing certificates in Key Vault: '" + $keyvaultName + "'. Missing thumbprint: '" + $certFromFiles.name + " " + $certFromFiles.thumbprint +"'. To understand more about how to use KeyVault for certificates, please follow the documentation at https://aka.ms/cses-kv"
            }
        }
        $passMemory.Add("certSecretList", $certSecretList)
    }

    if ($params.ContainsKey("StorageAccount")) {
        $storAccs = Get-AzStorageAccount
        if (-not ($storAccs.StorageAccountName.tolower()).contains($storageAccount.tolower())){
            throw "The provided Storage Account: '" + $storageAccount + "' does not exist."
        }
    }
}

# SIG # Begin signature block
# MIIoLQYJKoZIhvcNAQcCoIIoHjCCKBoCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAfPirPvtMF5zi8
# 5oJELwraCEdDm6A2vbFGZgFId1GN06CCDXYwggX0MIID3KADAgECAhMzAAADTrU8
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGg0wghoJAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAANOtTx6wYRv6ysAAAAAA04wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIMJneZTTighYEmPdc/AdBjpS
# dJMkMwxmf+sb4CD4s09XMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAaxd66FUHrK78uxowUD9pPN1BD7DIMbPm8D/w+6Kyit7NDQIVJG+yXXku
# Nm0NiHC7F2O6Bjkj/WVqvP2PxNUjO/pAbFPSRo/n5Lt4BVCHnYb5ozvUdoy/HOJv
# OGI7zaVTehRGn/QTOA2zSv5zfUGczp9//wdCk6YpSYuEhqaq2vFuwYhDVSnLW27l
# Tuso+MyvDVVq88q4nGcQFFGa1HqOaESz0WJsa7zt4pnZStp61OiW3v1/LwLd3VIw
# xFl2+d1T8FHo95ptsE3Hv2zhmCPoEjGJtvX98CMS1FSObOL2GshwJ/6BZ5LPPQeN
# 21MsrCcoFruniyV2Xz8linScHVsUDKGCF5cwgheTBgorBgEEAYI3AwMBMYIXgzCC
# F38GCSqGSIb3DQEHAqCCF3AwghdsAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFSBgsq
# hkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCBNt0EJsrXorM1FvHbwACvXO4F6FiHURs9/hQR7YT6T9AIGZShwuO+G
# GBMyMDIzMTExMDA0MjUzMi41OThaMASAAgH0oIHRpIHOMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046QTAwMC0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Wg
# ghHtMIIHIDCCBQigAwIBAgITMwAAAdB3CKrvoxfG3QABAAAB0DANBgkqhkiG9w0B
# AQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYD
# VQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAeFw0yMzA1MjUxOTEy
# MTRaFw0yNDAyMDExOTEyMTRaMIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25z
# MScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046QTAwMC0wNUUwLUQ5NDcxJTAjBgNV
# BAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2UwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQDfMlfn35fvM0XAUSmI5qiG0UxPi25HkSyBgzk3zpYO
# 311d1OEEFz0QpAK23s1dJFrjB5gD+SMw5z6EwxC4CrXU9KaQ4WNHqHrhWftpgo3M
# kJex9frmO9MldUfjUG56sIW6YVF6YjX+9rT1JDdCDHbo5nZiasMigGKawGb2HqD7
# /kjRR67RvVh7Q4natAVu46Zf5MLviR0xN5cNG20xwBwgttaYEk5XlULaBH5OnXz2
# eWoIx+SjDO7Bt5BuABWY8SvmRQfByT2cppEzTjt/fs0xp4B1cAHVDwlGwZuv9Rfc
# 3nddxgFrKA8MWHbJF0+aWUUYIBR8Fy2guFVHoHeOze7IsbyvRrax//83gYqo8c5Z
# /1/u7kjLcTgipiyZ8XERsLEECJ5ox1BBLY6AjmbgAzDdNl2Leej+qIbdBr/SUvKE
# C+Xw4xjFMOTUVWKWemt2khwndUfBNR7Nzu1z9L0Wv7TAY/v+v6pNhAeohPMCFJc+
# ak6uMD8TKSzWFjw5aADkmD9mGuC86yvSKkII4MayzoUdseT0nfk8Y0fPjtdw2Wne
# jl6zLHuYXwcDau2O1DMuoiedNVjTF37UEmYT+oxC/OFXUGPDEQt9tzgbR9g8HLtU
# fEeWOsOED5xgb5rwyfvIss7H/cdHFcIiIczzQgYnsLyEGepoZDkKhSMR5eCB6Kcv
# /QIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFDPhAYWS0oA+lOtITfjJtyl0knRRMB8G
# A1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8GA1UdHwRYMFYwVKBSoFCG
# Tmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29mdCUy
# MFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBsBggrBgEFBQcBAQRgMF4w
# XAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2Vy
# dHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3J0MAwG
# A1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwDgYDVR0PAQH/BAQD
# AgeAMA0GCSqGSIb3DQEBCwUAA4ICAQCXh+ckCkZaA06SNW+qxtS9gHQp4x7G+gdi
# kngKItEr8otkXIrmWPYrarRWBlY91lqGiilHyIlZ3iNBUbaNEmaKAGMZ5YcS7IZU
# KPaq1jU0msyl+8og0t9C/Z26+atx3vshHrFQuSgwTHZVpzv7k8CYnBYoxdhI1uGh
# qH595mqLvtMsxEN/1so7U+b3U6LCry5uwwcz5+j8Oj0GUX3b+iZg+As0xTN6T0Qa
# 8BNec/LwcyqYNEaMkW2VAKrmhvWH8OCDTcXgONnnABQHBfXK/fLAbHFGS1XNOtr6
# 2/iaHBGAkrCGl6Bi8Pfws6fs+w+sE9r3hX9Vg0gsRMoHRuMaiXsrGmGsuYnLn3Aw
# TguMatw9R8U5vJtWSlu1CFO5P0LEvQQiMZ12sQSsQAkNDTs9rTjVNjjIUgoZ6XPM
# xlcPIDcjxw8bfeb4y4wAxM2RRoWcxpkx+6IIf2L+b7gLHtBxXCWJ5bMW7WwUC2Ll
# tburUwBv0SgjpDtbEqw/uDgWBerCT+Zty3Nc967iGaQjyYQH6H/h9Xc8smm2n6Vj
# ySRx2swnW3hr6Qx63U/xY9HL6FNhrGiFED7ZRKrnwvvXvMVQUIEkB7GUEeN6heY8
# gHLt0jLV3yzDiQA8R8p5YGgGAVt9MEwgAJNY1iHvH/8vzhJSZFNkH8svRztO/i3T
# vKrjb8ZxwjCCB3EwggVZoAMCAQICEzMAAAAVxedrngKbSZkAAAAAABUwDQYJKoZI
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
# MCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOkEwMDAtMDVFMC1EOTQ3MSUwIwYDVQQD
# ExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQC8
# t8hT8KKUX91lU5FqRP9Cfu9MiaCBgzCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6PfXYTAiGA8yMDIzMTEwOTIyMTA0
# MVoYDzIwMjMxMTEwMjIxMDQxWjB3MD0GCisGAQQBhFkKBAExLzAtMAoCBQDo99dh
# AgEAMAoCAQACAg5cAgH/MAcCAQACAhOCMAoCBQDo+SjhAgEAMDYGCisGAQQBhFkK
# BAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAIAgEAAgMBhqAwDQYJ
# KoZIhvcNAQELBQADggEBAAv+2WzmCaElzvq6im0JAcJt2cSRTjy5s68ivJ496Hfr
# LNhj8xyeV1ZTO49Jgh7+vYqk9JlQjXwu6GM1JGjSbLU1Pymg1pdiqz4gUvabgNiB
# iVZ9/qw/XfDWOF8v/Hx/vufrdfr7iNdC55RdWbyz7sLvFp3Dvk6GO0PQOw0bajda
# cvlRrSqMRwdZpgosM8bq3kFIy1qrxTD5rF5D7TtqjdShkqL5DjOHFtZPlF4sXNwp
# C4ic24/vaHRS3tA28relapuUMht0JqQhBQKOSRkcwXe/jfkPsbE02bmPXYzzV60X
# O3bf+D1WEcHQWqcTNnms7TATxUY9sxmF8KFgJM3/KuAxggQNMIIECQIBATCBkzB8
# MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVk
# bW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1N
# aWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAdB3CKrvoxfG3QABAAAB
# 0DANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEE
# MC8GCSqGSIb3DQEJBDEiBCDQ0c+BccSTY7YFzHdECRVIZ22lMOTRIuMdQn8giy5Y
# cjCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIAiVQAZftNP/Md1E2Yw+fBXa
# 9w6fjmTZ5WAerrTSPwnXMIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
# dCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENB
# IDIwMTACEzMAAAHQdwiq76MXxt0AAQAAAdAwIgQg4LYBUmVf4UhqpYE8XU17N+GS
# hkBiJDzd34jN930z91cwDQYJKoZIhvcNAQELBQAEggIANy8u54DXMXRXrlHt4fCQ
# VIW2bh/0hOQo5EDyj/IBN7i3kBgzYFHW3n4/BwC1K3cfqB07Jd747pTZ4G7q71a9
# +Omj/xkwyTZ8Po9GfcpOwH2M+ol0IXWCDEE7pl78/gjYxDsGQzFU3iKIWIQIKsau
# +itILhec6B4luR8U7oP7DQjoEEDCR5ruwHl0immPGff9/stojiYQ1S8jYAQVoDLZ
# 0w3qLMttgMQez9HU3kVF9LFikdueoMmH5pgSd+pvG/gO5V9WP4nYkZhAa7mI1aoc
# brP2I0arUUCvi7UgWvQ5PhQcyUC/9St8HVBPLret2oE4O1grzvSZIR/75DXmKNvg
# BAeNV2zwa/lWpeiXSsW6rYqfbf1cMoMw9UwVyagy/kZ2gAXhQOck0Q4m8MKlRvfg
# Mve5iys/rGODsKFY13l8H+uKamV0OOtxB3hB5q7+uozvTfguV//TVnBBEqVquaG8
# 5XdZJrbxDGz7JgvNcYwrSUBqCVUIIsg5+HvC1gUCLV04aFVQZ8257g7+VDgtOtSJ
# eHUOckRUB58bEfJSNTrRUZDeIJSdV+1tdRzvsgLnWniTv/7qri4kSmOKNIiaW6VT
# h3vTgSRNtTlwwkhzH3728jxcH5LPMDh1gfP9TpLMaoF2xVhzZC3SlwQ4dJQTXCMB
# sQU5z1VIdfSRQ0B2cYC0dGA=
# SIG # End signature block
