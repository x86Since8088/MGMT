function Add-MGMTSite {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    $Site = Get-MGMTDataObject -InputObject $MGMT_Env -Name config,sites,$Site
    if ($null -eq $Site) {
        Set-SyncHashtable -InputObject $MGMT_Env.config.sites -Name $Site
        $MGMT_Env.config.sites.($site) = [hashtable]::Synchronized(@{
            Name = $Site
            domain = ''
            DNS_Servers = @()
            APIS = @()
            Type = ''
            SystemType = @{
                ESXI = @()
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
    $MGMT_Env.config.sites.$Environment = @{
        Name = $Name
        ESXI = $ESXI
        PFSense = $PFSense
    }
    Set-MGMTDataObject -InputObject $MGMT_Env -Name MGMT_Env
}