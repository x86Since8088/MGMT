$PSSCR = $PSScriptRoot
. "$PSSCR\Init.ps1"

$PFSense_Obj = $MGMT_Env.config.sites.values.pfsense
Function Get-PFSenseInstance {
    param (
        [string[]]$fqdn,
        [string[]]$IP
    )
    $PFSenseHT = [hashtable]::Synchronized(@{})
    foreach ($fqdnItem in $fqdn) {
        $PFSenseHT[$fqdnItem] = $MGMT_Env.config.sites.values.pfsense |
            Where-Object {$_.fqdn -eq $fqdnItem}
    }
    foreach ($fqdnItem in $fqdn) {
        $PFSenseHT[$fqdnItem] = $MGMT_Env.config.sites.values.pfsense |
            Where-Object {$_.fqdn -eq $fqdnItem}
    }
    foreach ($PfsenseObject in $MGMT_Env.config.sites.values.pfsense) {
        $PFSenseHT[$PfsenseObject.fqdn] = $PfsenseObject
        $PFSenseHT[$PfsenseObject.ip] = $PfsenseObject
    }
    $MGMT_Env.config.sites.values.pfsense | 
        Where-Object {$_.fqdn -eq $fqdn -or $_.ip -eq $IP}
    $PFSense_Creds = $MGMT_Env.Auth.($fqdn)
    return $PFSense_Creds
}
$PFSense_Creds = $PFSense_Obj$MGMT_Env.Auth.($PFSense_Obj.fqdn)
