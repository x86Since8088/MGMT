# Import the required modules
Import-Module Az.Accounts
Import-Module Az.Compute
Import-Module Az.Network

# Connect to your Azure account


# Set your Azure subscription
[array]$azsubscription = Get-AzSubscription
Set-AzContext -SubscriptionId $azsubscription[0].SubscriptionId
$AzResourceGroup = Get-AzResourceGroup
Get-AzPublicIpAddress

# Define variables
$resourceGroupName = 'SkarkeNet_Dev'
$location = 'westus'
$vmName = 'ubuntu1'
$publicIpName = 'pub_ubuntu1'
$networkSecurityGroupName = 'your-nsg-name'
$virtualNetworkName = 'your-vnet-name'
$subnetName = 'your-subnet-name'
$adminUsername = 'your-admin-username'
$adminPassword = ConvertTo-SecureString 'your-admin-password' -AsPlainText -Force

# Create a resource group
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Create a public IP address
$publicIp = New-AzPublicIpAddress -Name $publicIpName -ResourceGroupName $resourceGroupName -Location $location -AllocationMethod Dynamic
# Create a network security group
$nsg = New-AzNetworkSecurityGroup -ResourceGroupName $resourceGroupName -Location $location -Name $networkSecurityGroupName
# Create an inbound network security group rule for port 22
Add-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg -Name 'SSH' -Description 'Allow SSH' -Access Allow -Protocol Tcp -Direction Inbound -Priority 100 -SourceAddressPrefix Internet -SourcePortRange * -DestinationAddressPrefix * -DestinationPortRange 22 | Set-AzNetworkSecurityGroup
# Create a virtual network
$vnet = New-AzVirtualNetwork -ResourceGroupName $resourceGroupName -Location $location -Name $virtualNetworkName -AddressPrefix 10.0.0.0/16
# Create a subnet
$subnet = Add-AzVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 10.0.1.0/24 -NetworkSecurityGroup $nsg -VirtualNetwork $vnet | Set-AzVirtualNetwork
# Create a network interface
$nic = New-AzNetworkInterface -Name $vmName -ResourceGroupName $resourceGroupName -Location $location -SubnetId $subnet.Id -PublicIpAddressId $publicIp.Id
# Define a credential object
$cred = New-Object System.Management.Automation.PSCredential($adminUsername, $adminPassword)

# Create a virtual machine configuration
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize 'Standard_D2s_v3' | `
Set-AzVMOperatingSystem -Linux -ComputerName $vmName -Credential $cred -DisablePasswordAuthentication:$false | `
Set-AzVMSourceImage -PublisherName 'Canonical' -Offer 'UbuntuServer' -Skus '18.04-LTS' -Version 'latest' | `
Add-AzVMNetworkInterface -Id $nic.Id

# Create a virtual machine
New-AzVM -ResourceGroupName $resourceGroupName -Location $location -VM $vmConfig

# Test SSH connection
Test-NetConnection -ComputerName $publicIp.IpAddress -Port 22
