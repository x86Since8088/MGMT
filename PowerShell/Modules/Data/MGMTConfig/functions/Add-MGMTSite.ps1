function Add-MGMTSite {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    $Site = Get-MGMTDataObject -InputObject $global:MGMT_Env -Name config,sites,$Site
    if ($null -eq $Site) {
        Set-SyncHashtable -InputObject $global:MGMT_Env.config -Name sites
        Set-SyncHashtable -InputObject $global:MGMT_Env.config.sites -Name $Site
        $global:MGMT_Env.config.sites.($site) = [hashtable]::Synchronized(@{
            Name = $Site
            domain = @{fqdn=''}
            network = @{
                DNS_Servers = @()
            }
            SystemTypes = @{
                VMware_ESXi = @()
                VMware_vCenter = @()
                PFSense = @()
                Windows = @()
                Linux = @()
                Azure = @()
                AWS = @()
                GCP = @()
                VCenter = @()
                Linode = @()
                DigitalOcean = @()
                CloudFlare = @()
                Wix = @()
                GoDaddy = @()
                NameCheap = @()
                GoogleDomains = @()
                Names_com = @()
            }
        })
    }
    $global:MGMT_Env.config.sites.$Environment = @{
        Name = $Name
        domain = @{fqdn=''}
        SystemTypes = @{}
            ESXI = $ESXI
            PFSense = $PFSense
    }
    Set-MGMTDataObject -InputObject $global:MGMT_Env -Name MGMT_Env
}
