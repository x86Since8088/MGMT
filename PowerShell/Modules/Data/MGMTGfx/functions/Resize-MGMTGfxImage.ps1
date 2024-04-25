function Resize-MGMTGfxImage {
    param (
        [string[]]$ImagePath,
        [string]$FileNameFilter,
        [int]$Width,
        [int]$Height,
        [switch]$MaintainRatio,
        [string]$OutputPath,
        [string]$Prefix,
        [switch]$force
    )
    if (!(Test-Path $ImagePath)) {
        return Write-Error -Message "-ImagePath is required."
    }
    $ImagePaths = Get-ChildItem $ImagePath |
        Where-Object{$_.Name -match $FileNameFilter}
    foreach ($ImagePath in $ImagePaths.fullname) {
        $newOutputPath = $OutputPath
        $newWidth = $Width
        $newHeight = $Height
        $image = [System.Drawing.Image]::FromFile($ImagePath)
        if (
            $MaintainRatio -or
            (0 -eq $Width) -or
            (0 -eq $Height)
        ) {
            $aspectRatio = $image.Width / $image.Height
            if ((0 -ne $newHeight) -and (0 -ne $newWidth)) {
                Write-Warning -Message "You have provided -MaintainRatio, -Height, and -Width at the same time.  Ignoring -MaintainRatio."
            }
            elseif ((0 -ne $newHeight) -and (0 -eq $newWidth)) {
                $newWidth = [math]::Round($Height * $aspectRatio)
            }
            elseif((0 -ne $newWidth) -and (0 -eq $newHeight)) {
                $newHeight = [math]::Round($Width / $aspectRatio)
            }
        }
        if ('' -eq $newOutputPath) {
            $newOutputPath = $ImagePath -replace '\.\w+$', "_resized_$($newWidth)x$($newHeight)_$($image.RawFormat.ToString().ToLower())" -replace '(^.*[[/\\]])(.*)',"`$1$Prefix`$2"
        }
        if ((Test-Path $newOutputPath) -and !$force) {
            Write-Warning -Message "Resize-MGMTGfxImage: Skipping existing output file '$newOutputPath'"
        }
        else {
            $resizedImage = $image.GetThumbnailImage($newWidth, $newHeight, $null, [System.IntPtr]::Zero)
            $resizedImage.Save($newOutputPath, $image.RawFormat)
            $resizedImage.Dispose()
            $image.Dispose()
            Get-Item $newOutputPath
        }
    }
}