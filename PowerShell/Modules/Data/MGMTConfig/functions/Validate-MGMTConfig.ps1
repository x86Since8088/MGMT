function Validate-MGMTConfig {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Environment
    )
    foreach($Site in $Global:MGMT_Env.config.sites.GetEnumerator()) {
        foreach($SystemType in $Site.value.GetEnumerator()) {
            foreach($System in $SystemType.value) {
                
            }
        }
    }
}