function New-MGMTSite {
    [CmdletBinding()]
    param (
        # Unique name of the site
        [Parameter(Mandatory = $true)]
        [string]$SiteName,
        # FQDN of the domain name that hosts in this site will use.
        [Parameter(Mandatory = $true)]
        [string]$DomainFQDN,
        # The IP address of the DNS servers for the site.
        [Parameter(Mandatory = $true)]
        [string[]]$dnsServers,
        # The IP address of the gateway for the site.
        [Parameter(Mandatory = $true)]
        [string[]]$gateway,
        # Name of the network to be attached to the data interface of VMs in this environment.
        [Parameter(Mandatory = $true)]
        [string]$virtual_Network,
        # VLAN ID for this environment
        [Parameter(Mandatory = $true)]
        [int]$VLAN,
        # Network in IP/CIDR notation
        [Parameter(Mandatory = $true)]
        [string]$Subnet
    )
    begin{
        $nullValues = $PSBoundParameters.GetEnumerator() | Where-Object { $null -eq $_.Value }
        $nullValues | ForEach-Object {
            Write-Error -Message "The parameter $($_.Key) cannot be null."
        }
        
        Set-MGMTDataObject -InputObject $Global:MGMT_Env -Name Config,Sites,$Name -Value @{
            Path = $Path
            Host = $Host
        }
    }
}