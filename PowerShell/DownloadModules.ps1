$WorkingFolder        = $PSScriptRoot
$DataFile             = "$WorkingFolder\DownloadModules.yaml"
$ModuleFolder         = "$WorkingFolder\SavedModules"
                        if (!(Test-Path $ModuleFolder)) {mkdir $ModuleFolder|out-null} 
$PackageFolder        = "$WorkingFolder\SavedPackages"
                        if (!(Test-Path $PackageFolder)) {mkdir $PackageFolder|out-null} 
$Global:SavedModules  = Get-Content $DataFile|ConvertFrom-YAML
$FoundModuleArr = @()
foreach ($EntryData in $Global:SavedModules)
{
    if ($EntryData.version -replace '\s' -match '^\d\.\d[\d\.]*$') {
        [version]$Version = $EntryData.version
    }
    else{
        [string]$Version = "$($EntryData.version)"
    }
    if ('' -eq $Version) {[string]$Version='Latest'}
    if ('Package' -ne $EntryData.type) {
        $FoundModules = Find-Module -Name $EntryData.name -Verbose -AllVersions
        $FoundModuleArr+=$FoundModules
        
        if ('Latest' -eq $EntryData.Version) {
            $SelectedModules = $FoundModules|
                Sort-Object Version -Descending|
                Select-Object -First 1
        }
        elseif($Version -is [version]) {
            $SelectedModules = $FoundModules|
                Sort-Object Version -Descending|
                Where-Object{$Version -eq $_.Version}
        }
        foreach($SelectedModuleItem in $SelectedModules) {
            $SelectedModulePath = $ModuleFolder + '\' + $SelectedModuleItem.Name + '\' + $SelectedModuleItem.Version.ToString()
            if (!(test-path $SelectedModulePath)) {
                Save-Module -Name $SelectedModuleItem.name -Path $ModuleFolder -Force -Confirm:$False
            }
        }
    }
    else {
        $FoundPackages = Find-Package -Name $EntryData.name -Verbose -AllVersions | 
            Select-Object @{Name='Version';Expression={[version]$_.Version}},* -ErrorAction Ignore
        $FoundPackageArr+=$FoundPackages
        if ('Latest' -eq $Version) {
            $SelectedPackages = $FoundPackages|
                Sort-Object Version -Descending|
                Select-Object -First 1
        }
        elseif($Version -is [version]) {
            $SelectedPackages = $FoundPackages|
                Sort-Object Version -Descending|
                Where-Object{$Version -eq $_.Version}
        }
        foreach($SelectedPackageItem in $SelectedPackages) {
            $SelectedPackagePath = $PackageFolder + '\' + $SelectedPackageItem.Name + '\' + $SelectedPackageItem.Version.ToString()
            Start-ThreadJob -ThrottleLimit 5 -Name "Save_Module_$($SelectedPackageItem.Name)" -ScriptBlock {
                $SelectedPackageItem = $using:SelectedPackageItem
                $SelectedPackagePath = $using:SelectedPackagePath
                $PackageFolder = $using:PackageFolder
                if (!(test-path $SelectedPackagePath)) {
                    Save-Package -Name $SelectedPackageItem.name -Path $PackageFolder -Force -Confirm:$False -ProviderName $SelectedPackageItem.ProviderName -RequiredVersion $SelectedPackageItem.Version -Verbose 
                }
            }
        }
    }
}