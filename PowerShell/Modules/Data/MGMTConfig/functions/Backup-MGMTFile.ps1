function Backup-MGMTFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [string]$BackupPath = (Join-Path -Path (Split-Path -Path $Path) -ChildPath "Backup")
    )
    begin{
        $WarningPreference = 'Continue'
        if (!(Test-Path -Path $BackupPath)) {
            mkdir $BackupPath |Out-Null
        }
        $FileObject = Get-Item -Path $Path
        if ($FileObject.length -eq 0) {
            Write-Warning -Message "The file '$Path' is empty."
            return
        }
        elseif ($FileObject.Length -le 9) {
            Write-Warning -Message "The file '$Path' is corrupt."
        }
        $BackupFileName = $FileObject.BaseName + "_BACKUP_$($FileObject.LastWriteTime.ToString('yyyMMdd_HHmmss'))" + $FileObject.Extension
        $BackupFile = Join-Path -Path $BackupPath -ChildPath $BackupFileName
        if ($FileObject.Extension -match '^\.ya{0,1}ml$') {
            $FileData = Import-MGMTYAML -LiteralPath $Path
            $FileData.Remove('LastWriteTime') | Out-Null
            if ($FileData -eq $null) {
                Write-Warning -Message "The file '$Path' is empty."
                return
            }
            if($FileData.count -eq 0) {
                Write-Warning -Message "The file '$Path' is empty or corrupt."
                return
            }
        }
        if (!(Test-Path -Path $BackupFile)) {
            Write-Verbose -Message "starting backup of '$Path' to `n`t'$BackupFile'."
            Copy-Item -Path $Path -Destination $BackupFile -Force
            Write-Verbose -Message "Completed backup of '$Path' `n`t to '$BackupFile'."
            return
        }

        $BackupFileTimeFromName = $BackupFileName -replace '.*_BACKUP_(\d{8}_\d{6})\..*','$1'
        $BackupFileTime = [datetime]::ParseExact($BackupFileTimeFromName,'yyyyMMdd_HHmmss',$null)
        $BackupFileObj = Get-Item -Path $BackupFile
        if ($FileObject.Length -ne $BackupFileObj.Length) {
            Write-Warning -Message "The file '$Path' is different from '$BackupFile'."
            Write-Verbose -Message "starting backup of '$Path' to `n`t'$BackupFile'."
            Copy-Item -Path $Path -Destination $BackupFile
            Write-Verbose -Message "Completed backup of '$Path' `n`t to '$BackupFile'."
            return
        }
        else {
            $SourceContent = Get-Content -Path $Path
            $BackupContent = Get-Content -Path $BackupFile
            if ($Null -eq $BackupPath) {
                Write-Warning -Message "The backup file '$BackupFile' is empty."
                Write-Verbose -Message "starting backup of '$Path' to `n`t'$BackupFile'."
                Copy-Item -Path $Path -Destination $BackupFile
                Write-Verbose -Message "Completed backup of '$Path' `n`t to '$BackupFile'."
                return
            }
            $Diff = Compare-Object -ReferenceObject $SourceContent -DifferenceObject $BackupContent -PassThru
            if ($Diff) {
                Write-Warning -Message "The file '$Path' is different from '$BackupFile'."
                Backup-MGMTFile -Path $BackupFile -BackupPath $BackupPath
                Remove-Item -Path $BackupFile
                Write-Verbose -Message "starting backup of '$Path' to `n`t'$BackupFile'."
                Copy-Item -Path $Path -Destination $BackupFile
                Write-Verbose -Message "Completed backup of '$Path' `n`t to '$BackupFile'."
                return
            }
            else {
                return Write-Verbose -Message "The file '$Path' matches its backup."
            }
        }
    }
}