function Connect-MGMTViserver {
    [cmdletbinding()]
    param (
        [string]$Server,
        [pscredential]$Credential
    )
    begin {
        if ($null -eq $Server) {
            Write-Error -Message "The -Server parameter is required."
            return
        }
        if ($null -eq $Credential) {
            $Credential = @(
                Get-MGMTCredential -SystemType VMware_Template -SystemName $Server
                Get-MGMTCredential -SystemType VMware_vCenter  -SystemName $Server
            ) | Select-Object -First 1
        }
        if ($null -ne $Credential) {
            $ConnectVMHostPatams['Credential'] = $Credential
            foreach ($ServerItem in $server) {
                if ($ServerItem -notin $global:DefaultVIServers.Name) {
                    Connect-VIServer @ConnectVMHostPatams 1> $null 3> $null 4> $null 5> $null 6> $null 
                }
            }
        }
    }
}