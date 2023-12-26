$folder = "$PSData\proxmox"
$Remotepaths = @{
    pve=@{
        Path='/etc/pve'
        PathType='Directory'
    }
    network=@{
        Path='/etc/pve'
        PathType='Directory'
    }
    passwd=@{
        Path='/etc/passwd'
        PathType='File'
    }
    group=@{
        Path='/etc/group'
        PathType='File'
    }
    shadow=@{
        Path='/etc/shadow'
        PathType='File'
    }
}
foreach ($remotepath in $Remotepaths.values) {
    $Dest = "$Folder\$($Remotepath.path)" -split '\\|/' -match '\w' -join '\'
    if ($remotepath.PathType -eq 'File') {
        $Dest| ?{Test-Path $_}|%{Remove-Item -Force $_}
        $dest = Split-Path $Dest
        $Dest| ?{!(Test-Path $_)}|%{mkdir $_}
    }
    if ($remotepath.PathType -eq 'Directory') {
        RD -Recurse -Force $Dest
        md $Dest
    }
    Get-SCPItem -ComputerName ($URL_proxmox -split '/|:')[3] -Destination (split-path $Dest) -Path $remotepath.path -Credential ($Cred_proxmox) -AcceptKey -Force -PathType $Remotepath.PathType -Verbose
    #Get-ChildItem $dest -Recurse
}
