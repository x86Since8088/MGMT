[cmdletbinding()]
param (
    # Set the Proxmox server details
    [Parameter(Mandatory = $true)]
        $ProxmoxServer,
    [Parameter(Mandatory = $true)]
        [pscredential]$ProxmoxCredential,
    [Parameter(Mandatory = $true)]
        $ProxmoxNode,
    # Set the VM details
    [Parameter(Mandatory = $true)]
        $VmName,
    [Parameter(Mandatory = $true)]
        $VmMacAddress
)
begin {
# Import the Proxmox PowerShell module
Import-Module Proxmox

# Connect to the Proxmox server
Connect-ProxmoxServer -Server $ProxmoxServer -User $ProxmoxUser -Password $ProxmoxPassword -Node $ProxmoxNode


# Create a new VM with a specific MAC address
New-ProxmoxVM -Name $VmName -OS "l26" -Memory 4096 -DiskSize 32 -NetModel "virtio" -MacAddress $VmMacAddress

# Load the Alma Linux ISO into the VM
Add-ProxmoxCdrom -VMName $VmName -ISOUrl "https://url.to.alma.linux.iso"

# Start the VM
Start-ProxmoxVM -Name $VmName

}