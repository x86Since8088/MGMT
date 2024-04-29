function Connect-MGMTViserver {
    [cmdletbinding()]
    param (
        [string[]]$Server,
        [pscredential]$Credential,
        [string]$UserName
    )
    begin {
        if ($null -eq $Server) {
            Write-Error -Message "The -Server parameter is required."
            return
        }
        $MGMTCredParam = @{}
        if ('' -ne $UserName) {
            $MGMTCredParam.UserName = $UserName
        }
        if ($null -eq $Credential) {
            # If credentials are not set, we need to loop through the servers and set the credentials and stay in this behavior loop.
            foreach ($ServerItem in $server) {
                if ($ServerItem -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}|^[:\da-f]{3,45}$') {
                    # 0000:0000:0000:0000:0000:ffff:192.168.100.228 is a theorhedical fully expanded IPv6 address that maps to an IPv4 address and has 45 characters.
                    $ResolvedIP = $ServerItem
                }
                else {
                    $ResolvedIP = [System.Net.Dns]::GetHostEntry($ServerItem).IPAddress
                }
                if ($ServerItem -in $global:DefaultVIServers.Name) {
                    Write-Host -Message "The server $ServerItem is already connected."
                }
                elseif ($ResolvedIP -in $global:DefaultVIServers.Name) {
                    Write-Host -Message "The server $ServerItem (Resolved IP: $ResolvedIP) is already connected."
                }
                else {
                    $SelecteVMwareServer = Get-MGMTSystem -Environment * -SystemType VMware* -SystemName *|
                    Where-Object{
                        ($_.data.ip -like $ServerItem) -or
                        ($_.data.name -like $ServerItem) -or
                        ($_.data.fqdn -like $ServerItem) 
                    } | Select-Object -First 1
                    $Credential = (Get-MGMTCredential -SystemType $SelecteVMwareServer.SystemType -SystemName $SelecteVMwareServer.SystemName @MGMTCredParam).Credential
                    if ($null -eq $Credential) {
                        Write-Error -Message "No credentials found for $ServerItem.`tUse the following command to set the credentials:`n`tSet-MGMTCredential -SystemType VMware_ESXi -SystemName $Server -Credential (Get-Credential)"
                        Write-Warning -Message "Run:`n`tSet-MGMTCredential -SystemType $($SelecteVMwareServer.SystemType) -SystemName $($SelecteVMwareServer.SystemName) -Credential (Get-Credential)"
                    }
                    elseif ($null -eq $credential.password) {
                        Write-Error -Message "The password for $ServerItem is not set.`tUse the following command to set the credentials:`n`tSet-MGMTCredential -SystemType VMware_ESXi -SystemName $Server -Credential (Get-Credential)"
                        Write-Warning -Message "Run:`n`tSet-MGMTCredential -SystemType $($SelecteVMwareServer.SystemType) -SystemName $($SelecteVMwareServer.SystemName) -Credential (Get-Credential)"
                    }
                    else {
                        Connect-VIServer -Server $ServerItem -Credential $Credential 1> $null 3> $null 4> $null 5> $null 6> $null 
                    }
                }
            }
        }
        else {
            # if the credential is set, we need to stay in this behavior loop.
            foreach ($ServerItem in $server) {
                if ($ServerItem -notin $global:DefaultVIServers.Name) {
                    if ($null -eq $credential.password) {
                        Write-Error -Message "The password for $ServerItem is not set.`tUse the following command to set the credentials:`n`tSet-MGMTCredential -SystemType VMware_ESXi -SystemName $Server -Credential (Get-Credential)"
                        Write-Warning -Message "Run:`n`tSet-MGMTCredential -SystemType [VMware_...] -SystemName [VMware...] -Credential (Get-Credential)"
                    }
                    else {
                        Connect-VIServer -Server $ServerItem -Credential $Credential 1> $null 3> $null 4> $null 5> $null 6> $null 
                    }
                }
            }
        }
    }
}