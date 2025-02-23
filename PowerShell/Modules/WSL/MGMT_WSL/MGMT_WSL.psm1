#Requires -RunAsAdministrator

# Define helper functions for argument completers
function Get-MgmtWSLDistroTypes {
    return @("Ubuntu", "Debian", "Fedora")
}

function Get-MgmtWSLUbuntuCodenames {
    try {
        $response = Invoke-WebRequest -Uri "https://cloud-images.ubuntu.com/wsl/" -UseBasicParsing
        $codenames = [regex]::Matches($response.Content, '<a href="([a-z]+)/">').Groups[1].Value | Where-Object { $_ -ne "current" }
        return $codenames
    } catch {
        return @("jammy", "focal", "noble", "bionic")
    }
}

function Get-MgmtWSLCommonPackages {
    return @("vim", "htop", "git", "curl", "nano", "wget")
}

function Get-MgmtWSLDevTools {
    return @("docker", "nodejs", "python3", "git", "gcc")
}

# Global cache for image URLs
$script:ImageUrlCache = @{}

#region Subfunctions

function Get-MgmtWSLImageUrl {
    param (
        [string]$DistroType,
        [string]$Version
    )
    $cacheKey = "$DistroType-$Version"
    if ($script:ImageUrlCache.ContainsKey($cacheKey)) {
        return $script:ImageUrlCache[$cacheKey]
    }
    $url = "https://cloud-images.ubuntu.com/releases/$Version/release/ubuntu-$Version-server-cloudimg-amd64-wsl.rootfs.tar.gz"
    $script:ImageUrlCache[$cacheKey] = $url
    return $url
}

function Get-MgmtWSLWslImage {
    param (
        [string]$DistroType,
        [string]$Version,
        [switch]$DownloadUpdate
    )
    $downloadUrl = Get-MgmtWSLImageUrl -DistroType $DistroType -Version $Version
    $latestImage = $downloadUrl -split '/' | Select-Object -Last 1
    $downloadsDir = Join-Path $PSScriptRoot "downloads"
    if (-not (Test-Path $downloadsDir)) { New-Item -ItemType Directory -Path $downloadsDir -Force | Out-Null }
    $localFile = Join-Path $downloadsDir $latestImage

    $localFiles = Get-ChildItem $downloadsDir -Filter "*.tar.gz" | Sort-Object Name -Descending
    if ($localFiles.Count -eq 0 -or $DownloadUpdate) {
        Write-Host "Downloading $latestImage..."
        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $downloadUrl -OutFile $localFile -ErrorAction Stop
        $ProgressPreference = 'Continue'
        Write-Host "Download completed."
    } else {
        $mostRecentLocal = $localFiles[0].Name
        $localFile = Join-Path $downloadsDir $mostRecentLocal
        if ($mostRecentLocal -ne $latestImage) {
            Write-Warning "An update is available: $latestImage. Use -DownloadUpdate to fetch it."
        }
        Write-Host "Using existing image: $mostRecentLocal"
    }
    return $localFile
}

function Test-MgmtWSLWslDistro {
    param (
        [string]$Name
    )
    $wslList = (wsl --list) -replace "$([char]0)"
    return $wslList -split "`n" | Where-Object { $_ -match "^\s*$Name\s+" } | Measure-Object | Select-Object -ExpandProperty Count -gt 0
}

function Test-MgmtWSLWslDistroOperational {
    param (
        [string]$DistroName
    )
    try {
        $wslList = (wsl --list --verbose) -replace "$([char]0)"
        $distroFound = $wslList -split "`n" | Where-Object { $_ -match "^\s*\*?\s*$DistroName\s+" }
        if (-not $distroFound) { return $false }
        $testOutput = (wsl -d $DistroName echo "hi") -replace "$([char]0)"
        return $testOutput -eq "hi"
    } catch {
        return $false
    }
}

function Install-MgmtWSLWslDistro {
    param (
        [string]$DistroName,
        [string]$ImagePath
    )
    $destinationFolder = "$env:LOCALAPPDATA\$DistroName"
    if (-not (Test-Path $destinationFolder)) { New-Item -ItemType Directory -Path $destinationFolder -Force | Out-Null }
    Write-Host "Importing $DistroName to $destinationFolder..."
    wsl --import $DistroName $destinationFolder $ImagePath 2>&1 | Out-Null
    if (-not (Test-MgmtWSLWslDistroOperational -DistroName $DistroName)) {
        throw "Failed to import $DistroName."
    }
    Write-Host "Successfully imported $DistroName."
}

function Uninstall-MgmtWSLWslDistro {
    param (
        [string]$DistroName
    )
    if (Test-MgmtWSLWslDistro -Name $DistroName) {
        Write-Host "Uninstalling $DistroName..."
        wsl --terminate $DistroName 2>$null
        wsl --unregister $DistroName 2>$null
        $destinationFolder = "$env:LOCALAPPDATA\$DistroName"
        if (Test-Path $destinationFolder) { Remove-Item $destinationFolder -Recurse -Force }
        Write-Host "Successfully uninstalled $DistroName."
    } else {
        Write-Host "$DistroName is not installed."
    }
}

function Backup-MgmtWSLWslDistro {
    param (
        [string]$DistroName,
        [string]$BackupPath
    )
    Write-Host "Backing up $DistroName to $BackupPath..."
    wsl --export $DistroName $BackupPath
    if ($LASTEXITCODE -ne 0) { throw "Backup failed with exit code $LASTEXITCODE." }
    Write-Host "Backup completed successfully."
}

function Restore-MgmtWSLWslDistro {
    param (
        [string]$DistroName,
        [string]$RestoreFrom
    )
    $destinationFolder = "$env:LOCALAPPDATA\$DistroName"
    if (-not (Test-Path $destinationFolder)) { New-Item -ItemType Directory -Path $destinationFolder -Force | Out-Null }
    Write-Host "Restoring $DistroName from $RestoreFrom..."
    wsl --import $DistroName $destinationFolder $RestoreFrom
    if ($LASTEXITCODE -ne 0) { throw "Restore failed with exit code $LASTEXITCODE." }
    Write-Host "Restore completed successfully."
}

function Get-MgmtWSLWslDistroReport {
    param (
        [string]$DistroName,
        [string[]]$Sections = @("basics", "system", "packages")
    )
    $report = @{}
    if ("basics" -in $Sections) { $report["basics"] = (wsl --list --verbose) -replace "$([char]0)" }
    if ("system" -in $Sections) {
        $report["system"] = @{}
        $report["system"]["uname"] = (wsl -d $DistroName uname -a) -replace "$([char]0)"
    }
    if ("packages" -in $Sections) { $report["packages"] = (wsl -d $DistroName dpkg -l) -replace "$([char]0)" }
    $reportPath = "$PSScriptRoot\$DistroName_report.json"
    $report | ConvertTo-Json -Depth 5 | Set-Content -Path $reportPath
    Write-Host "Report saved to $reportPath"
}

function Set-MgmtWSLWslPerformanceLimits {
    param (
        [int]$MemoryLimit,
        [int]$CpuLimit
    )
    $wslConfigPath = "$env:USERPROFILE\.wslconfig"
    $config = "[wsl2]`n"
    if ($MemoryLimit) { $config += "memory=${MemoryLimit}MB`n" }
    if ($CpuLimit) { $config += "processors=$CpuLimit`n" }
    Set-Content -Path $wslConfigPath -Value $config
    Write-Host "Performance limits set. Restart WSL with 'wsl --shutdown' to apply."
}

function Schedule-MgmtWSLWslMaintenance {
    param (
        [string]$DistroName
    )
    $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -Command `"Import-Module '$PSScriptRoot\WSLMgmt.psm1'; Invoke-MgmtWSL -DistroName '$DistroName' -DownloadUpdate`""
    $trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At "2AM"
    Register-ScheduledTask -TaskName "WSL_Update_$DistroName" -Action $action -Trigger $trigger -User "SYSTEM" -RunLevel Highest -Force
    Write-Host "Maintenance scheduled successfully."
}

function Get-MgmtWSLWslVhdxPath {
    param (
        [string]$DistroName
    )
    return "$env:LOCALAPPDATA\$DistroName\ext4.vhdx"
}

function New-MgmtWSLWslVhdxSnapshot {
    param (
        [string]$DistroName
    )
    $vhdxPath = Get-MgmtWSLWslVhdxPath -DistroName $DistroName
    $snapshotPath = "$PSScriptRoot\${DistroName}_snapshot_$(Get-Date -Format 'yyyyMMdd_HHmmss').vhdx"
    if (-not (Test-Path $vhdxPath)) { Write-Error "VHDX file not found at $vhdxPath."; return }
    Write-Host "Creating VHDX snapshot for '$DistroName'..."
    wsl --terminate $DistroName 2>$null
    Start-Sleep -Seconds 2
    Copy-Item -Path $vhdxPath -Destination $snapshotPath -Force
    Write-Host "Snapshot created: $snapshotPath"
}

function Remove-MgmtWSLWslVhdxSnapshot {
    param (
        [string]$SnapshotFile
    )
    $snapshotPath = "$PSScriptRoot\$SnapshotFile"
    if (-not (Test-Path $snapshotPath)) { Write-Error "Snapshot file '$snapshotPath' not found."; return }
    Write-Host "Removing snapshot '$SnapshotFile'..."
    Remove-Item -Path $snapshotPath -Force
    Write-Host "Snapshot removed."
}

function Restore-MgmtWSLWslVhdxSnapshot {
    param (
        [string]$DistroName,
        [string]$SnapshotFile
    )
    $vhdxPath = Get-MgmtWSLWslVhdxPath -DistroName $DistroName
    $snapshotPath = "$PSScriptRoot\$SnapshotFile"
    if (-not (Test-Path $snapshotPath)) { Write-Error "Snapshot file '$snapshotPath' not found."; return }
    Write-Host "Restoring '$DistroName' from snapshot '$SnapshotFile'..."
    wsl --terminate $DistroName 2>$null
    if (Test-MgmtWSLWslDistro -Name $DistroName) { wsl --unregister $DistroName 2>$null }
    Start-Sleep -Seconds 2
    if (Test-Path $vhdxPath) { Remove-Item -Path $vhdxPath -Force }
    Copy-Item -Path $snapshotPath -Destination $vhdxPath -Force
    Write-Host "Snapshot restored. Restarting '$DistroName'..."
    wsl -d $DistroName 2>$null
}

function Initialize-MgmtWSLWslDistro {
    param (
        [string]$DistroName,
        [string[]]$Packages,
        [string[]]$AdditionalUsers,
        [string[]]$DevTools
    )
    $initScriptContent = @"
#!/bin/bash
echo "Updating package sources..."
cat > /etc/apt/sources.list << EOL
deb http://archive.ubuntu.com/ubuntu jammy main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu jammy-updates main restricted universe multiverse
deb http://archive.ubuntu.com/ubuntu jammy-security main restricted universe multiverse
EOL
apt-get update -y
apt-get install -y python3-pip python3-venv git curl $($Packages -join ' ')
$(foreach ($user in $AdditionalUsers) { "useradd -m -G sudo -s /bin/bash $user; echo '$user ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/$user" })
$(if ($DevTools) { "apt-get install -y $($DevTools -join ' ')" })
useradd -m -s /bin/bash clouduser
echo "[user]" > /etc/wsl.conf
echo "default=clouduser" >> /etc/wsl.conf
"@
    $initScriptContent.Replace("`r`n", "`n") | wsl -d $DistroName -u root bash -c "cat > /root/init.sh; chmod +x /root/init.sh; /root/init.sh; rm /root/init.sh"
}

#endregion

function Stop-MgmtWSLTranscript {
    param(
        $TranscriptStarted=$TranscriptStarted
    )
    if ($TranscriptStarted) {
        Stop-Transcript;$TranscriptStarted=$false
    }
}

# Main function to invoke the script logic
function Invoke-MgmtWSL {
    [CmdletBinding()]
    param (
        [string]$DistroName = "CloudPortal",
        [Parameter(Mandatory = $false)]
        [ArgumentCompleter({
            param ($commandName, $parameterName, $wordToComplete)
            Get-MgmtWSLDistroTypes | Where-Object { $_ -like "$wordToComplete*" }
        })]
        [string]$DistroType = "Ubuntu",
        [Parameter(Mandatory = $false)]
        [ArgumentCompleter({
            param ($commandName, $parameterName, $wordToComplete)
            if ($fakeBoundParameters.DistroType -eq "Ubuntu") {
                Get-MgmtWSLUbuntuCodenames | Where-Object { $_ -like "$wordToComplete*" }
            } else {
                @("defaultVersion")
            }
        })]
        [string]$Version = "jammy",
        [switch]$DownloadUpdate,
        [switch]$Reinstall,
        [switch]$Uninstall,
        [switch]$Backup,
        [switch]$Restore,
        [string]$RestoreFrom,
        [Parameter(Mandatory = $false)]
        [ArgumentCompleter({
            param ($commandName, $parameterName, $wordToComplete)
            Get-MgmtWSLCommonPackages | Where-Object { $_ -like "$wordToComplete*" }
        })]
        [string[]]$Packages,
        [string[]]$AdditionalUsers,
        [Parameter(Mandatory = $false)]
        [ArgumentCompleter({
            param ($commandName, $parameterName, $wordToComplete)
            Get-MgmtWSLDevTools | Where-Object { $_ -like "$wordToComplete*" }
        })]
        [string[]]$DevTools,
        [switch]$Report,
        [string[]]$Sections,
        [int]$MemoryLimit,
        [int]$CpuLimit,
        [switch]$Schedule,
        [switch]$Snapshot,
        [switch]$RemoveSnapshot,
        [switch]$RestoreSnapshot,
        [string]$SnapshotFile,
        [string]$TranscriptFile
    )
    if ('' -ne $TranscriptFile) {
        if (Test-Path $TranscriptFile) {
            $timestamp = (Get-Item $TranscriptFile).LastWriteTime.ToString('yyyyMMdd_HHmmss')
            $baseName = [System.IO.Path]::GetFileNameWithoutExtension($TranscriptFile)
            $extension = [System.IO.Path]::GetExtension($TranscriptFile)
            $newName = "${baseName}_$timestamp$extension"
            Rename-Item $TranscriptFile -NewName $newName
        }
        [bool]$TranscriptStarted = $true
        Start-Transcript -Path $TranscriptFile
    }
    else {
        [bool]$TranscriptStarted = $false
    }

    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Warning "This script requires administrative privileges. Please run as Administrator."
        Stop-MgmtWSLTranscript
        return
    }

    if ($Snapshot) {
        New-MgmtWSLWslVhdxSnapshot -DistroName $DistroName
        return
    }
    if ($RemoveSnapshot -and $SnapshotFile) {
        Remove-MgmtWSLWslVhdxSnapshot -SnapshotFile $SnapshotFile
        Stop-MgmtWSLTranscript
        return
    }
    if ($RestoreSnapshot -and $SnapshotFile) {
        Restore-MgmtWSLWslVhdxSnapshot -DistroName $DistroName -SnapshotFile $SnapshotFile
        Stop-MgmtWSLTranscript
        return
    }

    if ($Restore -and $RestoreFrom) {
        Restore-MgmtWSLWslDistro -DistroName $DistroName -RestoreFrom $RestoreFrom
        Stop-MgmtWSLTranscript
        return
    }

    if ($Uninstall) {
        if ($Backup) {
            Backup-MgmtWSLWslDistro -DistroName $DistroName -BackupPath "$PSScriptRoot\$DistroName_backup.tar"
        }
        Uninstall-MgmtWSLWslDistro -DistroName $DistroName
        Stop-MgmtWSLTranscript
        return
    }

    if ($Report) {
        Get-MgmtWSLWslDistroReport -DistroName $DistroName -Sections $Sections
        Stop-MgmtWSLTranscript
        return
    }

    $imagePath = Get-MgmtWSLWslImage -DistroType $DistroType -Version $Version -DownloadUpdate $DownloadUpdate
    if (Test-MgmtWSLWslDistro -Name $DistroName) {
        if ($Reinstall) {
            if ($Backup) {
                Backup-MgmtWSLWslDistro -DistroName $DistroName -BackupPath "$PSScriptRoot\$DistroName_backup.tar"
            }
            Uninstall-MgmtWSLWslDistro -DistroName $DistroName
        } else {
            Write-Host "'$DistroName' already exists. Use -Reinstall to modify."
            Stop-MgmtWSLTranscript
            return
        }
    }
    Install-MgmtWSLWslDistro -DistroName $DistroName -ImagePath $imagePath
    Initialize-MgmtWSLWslDistro -DistroName $DistroName -Packages $Packages -AdditionalUsers $AdditionalUsers -DevTools $DevTools
    if ($MemoryLimit -or $CpuLimit) {
        Set-MgmtWSLWslPerformanceLimits -MemoryLimit $MemoryLimit -CpuLimit $CpuLimit
    }
    if ($Schedule) {
        Schedule-MgmtWSLWslMaintenance -DistroName $DistroName
    }

    Stop-MgmtWSLTranscript
}

# Export module members
Export-ModuleMember -Function Invoke-MgmtWSL, Get-MgmtWSLDistroTypes, Get-MgmtWSLUbuntuCodenames, Get-MgmtWSLCommonPackages, Get-MgmtWSLDevTools, Get-MgmtWSLImageUrl, Get-MgmtWSLWslImage, Test-MgmtWSLWslDistro, Test-MgmtWSLWslDistroOperational, Install-MgmtWSLWslDistro, Uninstall-MgmtWSLWslDistro, Backup-MgmtWSLWslDistro, Restore-MgmtWSLWslDistro, Get-MgmtWSLWslDistroReport, Set-MgmtWSLWslPerformanceLimits, Schedule-MgmtWSLWslMaintenance, Get-MgmtWSLWslVhdxPath, New-MgmtWSLWslVhdxSnapshot, Remove-MgmtWSLWslVhdxSnapshot, Restore-MgmtWSLWslVhdxSnapshot, Initialize-MgmtWSLWslDistro