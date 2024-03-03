function Find-AssociatedProgram {
    param (
        [string]$FilePath,
        [string]$Extension
    )

    if ($env:OS -eq "Windows_NT") {
        # Windows command to find the associated program
        if ('' -eq $Extension) {
            $Extension = (Get-Item $FilePath).Extension
        }
        if ($Extension -notmatch '^\.') {$Extension = ".$Extension"}
        $registryPath = "HKCR\$Extension"
        if (Test-Path $registryPath) {
            $associatedProgram = Get-ItemProperty -Path $registryPath -Name "(Default)"
        }
    }
    else {
        # Linux command to find the associated program
        $associatedProgram = Invoke-Expression "xdg-mime query default $FilePath"
    }
    if ($null -eq $associatedProgram) {return}
    return $associatedProgram.Trim()
}