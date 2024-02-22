function Add-MGMTSSHHostKey {
    [CmdletBinding()]
    param (
        [string]$HostName,
        [switch]$Force
    )
    process{
        [string[]]$Match = Get-Content "$env:USERPROFILE\.ssh\known_hosts" | Where-Object{$_ -like "$Hostname *"}
        if ($Force) {
            write-hoat "Overwriting the SSH host key for hostname '$HostName' in the known_hosts file"
            $NewContent = Get-Content "$env:USERPROFILE\.ssh\known_hosts" | Where-Object{$_ -notlike "$Hostname *"}
            Set-Content -Path "$env:USERPROFILE\.ssh\known_hosts" -Value $NewContent -Force -Confirm:$False
        }
        elseif ($Match.count -eq 0) {
            return (Write-host "Found SSH host key for hostname '$HostName' to the known_hosts file`n`t$($Match -join "`n`t")`nTo overwrite the existing key, run:`n`t Add-MGMTSSHHostKey -HostName $HostName -Force" -ForegroundColor Yellow)
        }
        [string]$HostKey = (ssh-keyscan -t rsa $HostName) -replace '^\s*'
        Write-Verbose -Message "Host:$Hostname`tKey:$Hostkey"
        if ('' -eq $HostKey) {
            Write-Error "Failed to retrieve the SSH host key for $HostName"
            break
        }
        [string[]]$Match = Get-Content "$env:USERPROFILE\.ssh\known_hosts" | Where-Object{$_ -eq $HostKey}
        if ($Match.count -eq 0) {
            Write-Host "Adding the SSH host key for $HostName to the known_hosts file"
            Add-Content -Path "$env:USERPROFILE\.ssh\known_hosts" -Value $HostKey
        }
        else {
            Write-host "The SSH host key for $HostName is already in the known_hosts file."
        }

    }
}