$RollUpModule = "Az"
$PSProfileMapEndpoint = "https://azureprofile.azureedge.net/powershellcore/azprofilemap.json"
$script:BootStrapRepo = "PSGallery"

# Is it Powershell Core edition?
$Script:IsCoreEdition = ($PSVersionTable.PSEdition -eq 'Core')

# Check if current user is Admin to decide on cache path
$script:IsAdmin = $false
if ((-not $Script:IsCoreEdition) -or ($IsWindows))
{
  $script:ProgramFilesPSPath = $env:ProgramFiles
  If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
  {
    $script:IsAdmin = $true
  }
}
else {
  $script:ProgramFilesPSPath = $PSHOME
  # on Linux, tests run via sudo will generally report "root" for whoami
  if ( (whoami) -match "root" ) 
  {
    $script:IsAdmin = $true
  }
}

# Get profile cache path
function Get-ProfileCachePath
{
  if ((-not $Script:IsCoreEdition) -or ($IsWindows))
  {
    $ProfileCache = Join-Path -path $env:LOCALAPPDATA -childpath "Microsoft\AzurePowerShell\ProfileCache"
    if ($script:IsAdmin)
    {
      $ProfileCache = Join-Path -path $env:ProgramData -ChildPath "Microsoft\AzurePowerShell\ProfileCache"
    }
  }
  else {
    $ProfileCache = "$HOME/.config/Microsoft/AzurePowerShell/ProfileCache" 
  }

  # If profile cache directory does not exist, create one.
  if(-Not (Test-Path $ProfileCache))
  {
    New-Item -ItemType Directory -Force -Path $ProfileCache | Out-Null
  }

  return $ProfileCache
}

# Function to find the latest profile map from cache
function Get-LatestProfileMapPath
{
  $ProfileCache = Get-ProfileCachePath
  $ProfileMapPaths = Get-ChildItem $ProfileCache
  if ($null -eq $ProfileMapPaths)
  {
    return
  }

  $LargestNumber = Get-LargestNumber -ProfileCache $ProfileCache
  if ($null -eq $LargestNumber)
  {
    return
  }

  $LatestMapPath = $ProfileMapPaths | Where-Object { $_.Name.Startswith($LargestNumber.ToString() + '-') }
  return $LatestMapPath
}

# Function to get the largest number in profile cache profile map names: This helps to find the latest map
function Get-LargestNumber
{
  param($ProfileCache)
  
  $ProfileMapPaths = Get-ChildItem $ProfileCache
  $LargestNumber = $ProfileMapPaths | ForEach-Object { if($_.Name -match "\d+-") { $matches[0] -replace '-' } } | Measure-Object -Maximum 
  if ($null -ne $LargestNumber)
  {
    return $LargestNumber.Maximum
  }
}

# Find the latest ProfileMap 
$script:LatestProfileMapPath = Get-LatestProfileMapPath

# Make Web-Call
function Get-StorageBlob
{
  $ScriptBlock = {
    Invoke-WebRequest -uri $PSProfileMapEndpoint -UseBasicParsing -TimeoutSec 120 -ErrorVariable RestError
  }

  $WebResponse = Invoke-CommandWithRetry -ScriptBlock $ScriptBlock    
  return $WebResponse
}

# Get-ProfileMap from Azure Endpoint
function Get-AzProfileMapFromEndpoint
{
  Write-Verbose "Updating profiles"
  $ProfileCache = Get-ProfileCachePath

  # Get online profile data using Web request
  $WebResponse = Get-StorageBlob  

  # Get ETag value for OnlineProfileMap
  $OnlineProfileMapETag = $WebResponse.Headers["ETag"]

  # If profilemap json exists, compare online Etag and cached Etag; if not different, don't replace cache.
  if (($null -ne $script:LatestProfileMapPath) -and ($script:LatestProfileMapPath -match "(\d+)-(.*.json)"))
  {
    [string]$ProfileMapETag = [System.IO.Path]::GetFileNameWithoutExtension($Matches[2])
    if (($ProfileMapETag -eq $OnlineProfileMapETag) -and (Test-Path $script:LatestProfileMapPath.FullName))
    {
      $scriptBlock = {
        Get-Content -Raw -Path $script:LatestProfileMapPath.FullName -ErrorAction stop | ConvertFrom-Json 
      }
      $ProfileMap = Invoke-CommandWithRetry -ScriptBlock $scriptBlock 

      if ($null -ne $ProfileMap)
      {
        return $ProfileMap
      }
    }
  }

  # If profilemap json doesn't exist, or if online ETag and cached ETag are different, cache online profile map
  $LargestNoFromCache = Get-LargestNumber -ProfileCache $ProfileCache 
  if ($null -eq $LargestNoFromCache)
  {
    $LargestNoFromCache = 0
  }
  
  $ChildPathName = ($LargestNoFromCache+1).ToString() + '-' + ($OnlineProfileMapETag) + ".json"
  $CacheFilePath = (Join-Path $ProfileCache -ChildPath $ChildPathName)
  $OnlineProfileMap = RetrieveProfileMap -WebResponse $WebResponse
  $OnlineProfileMap | ConvertTo-Json -Compress | Out-File -FilePath $CacheFilePath
   
  # Store old profile map's path before Updating
  $oldProfileMap = $script:LatestProfileMapPath

  # Update $script:LatestProfileMapPath
  $script:LatestProfileMapPath = Get-ChildItem $ProfileCache | Where-Object { $_.FullName.equals($CacheFilePath)}
  
  # Remove old profile map if it exists
  if (($null -ne $oldProfileMap) -and (Test-Path $oldProfileMap.FullName))
  {
    $ScriptBlock = {
      Remove-Item -Path $oldProfileMap.FullName -Force -ErrorAction Stop
    }
    Invoke-CommandWithRetry -ScriptBlock $ScriptBlock
  }
  
  return $OnlineProfileMap
}

# Helper to retrieve profile map from http response
function RetrieveProfileMap
{
  param($WebResponse)
  $OnlineProfileMap = $WebResponse | ConvertFrom-Json
  return $OnlineProfileMap
}

# Get ProfileMap from Cache, online or embedded source
function Get-AzProfileMap
{
  [CmdletBinding()]
  param([Switch]$Update)

  # Must use Get-Item and not [Environment]::GetEnvironmentVariable since the latter doesn't work on Unix systems.
  $azBootStrapperLocalProfile = Get-Item -Path Env:AzBootStrapperLocalProfile -ErrorAction SilentlyContinue
  if ($azBootStrapperLocalProfile)
  {
    $azBootStrapperLocalProfile = $azBootStrapperLocalProfile.Value
    $scriptBlock = {
        Get-Content -Path $azBootStrapperLocalProfile -ErrorAction stop | ConvertFrom-Json 
    }
    $ProfileMap = Invoke-CommandWithRetry -ScriptBlock $scriptBlock 
    if(!$ProfileMap)
    {
        throw [System.IO.FileNotFoundException] "Local profile ${azBootStrapperLocalProfile} doesn't exist."
    }
    return $ProfileMap
  }

  # If Update is present, download ProfileMap from online source
  if ($Update.IsPresent)
  {
    return (Get-AzProfileMapFromEndpoint)
  }

  # Check the cache
  if(($null -ne $script:LatestProfileMapPath) -and (Test-Path $script:LatestProfileMapPath.FullName))
  {
    $scriptBlock = {
      Get-Content -Raw -Path $script:LatestProfileMapPath.FullName -ErrorAction stop | ConvertFrom-Json 
    }
    $ProfileMap = Invoke-CommandWithRetry -ScriptBlock $scriptBlock 
    if ($null -ne $ProfileMap)
    {
      return $ProfileMap
    }
  }
     
  # If cache doesn't exist, Check embedded source
  $defaults = [System.IO.Path]::GetDirectoryName($PSCommandPath)
  $scriptBlock = {
    Get-Content -Raw -Path (Join-Path -Path $defaults -ChildPath "azprofilemap.json") -ErrorAction stop | ConvertFrom-Json 
  }
  $ProfileMap = Invoke-CommandWithRetry -ScriptBlock $scriptBlock 
  if($null -eq $ProfileMap)
  {
    # Cache & Embedded source empty; Return error and stop
    throw [System.IO.FileNotFoundException] "Profile meta data does not exist. Use 'Get-AzApiProfile -Update' to download from online source."
  }

  return $ProfileMap
}

# Lists the profiles that are installed on the machine
function Get-ProfilesInstalled
{
  param([parameter(Mandatory = $true)] [PSCustomObject] $ProfileMap, [REF]$IncompleteProfiles)
  $result = @{} 
  $AllProfiles = ($ProfileMap | Get-Member -MemberType NoteProperty).Name
  foreach ($key in $AllProfiles)
  {
    Write-Verbose "Checking if profile $key is installed"
    foreach ($module in ($ProfileMap.$key | Get-Member -MemberType NoteProperty).Name)
    {
      $ModulesList = (Get-Module -Name $Module -ListAvailable)
      $versionList = $ProfileMap.$key.$module
      foreach ($version in $versionList)
      {
        if ($version.EndsWith("preview")) {
          $version = $version.TrimEnd("-preview")
        }
        
        if ($null -ne ($ModulesList | Where-Object { $_.Version -eq $version}))
        {
          if ($result.ContainsKey($key))
          {
            if ($result[$key].Containskey($module))
            {
              $result[$key].$module += $version
            }
            else
            {
              $result[$key] += @{$module = @($version)}
            }
          }
          else
          {
            $result.Add($key, @{$module = @($version)})
          }
        }
      }
    }

    # If not all the modules from a profile are installed, add it to $IncompleteProfiles
    if(($result.$key.Count -gt 0) -and ($result.$key.Count -ne ($ProfileMap.$key | Get-Member -MemberType NoteProperty).Count))
    {
      if ($result.$key.Contains($RollUpModule))
      {
        continue
      }
      
      $result.Remove($key)
      if ($null -ne $IncompleteProfiles) 
      {
        $IncompleteProfiles.Value += $key
      }
    }
  }
  return $result
}

# Get profiles installed associated with the module version
function Test-ProfilesInstalled
{
  param($version, [String]$Module, [String]$Profile, [PSObject]$PMap, [hashtable]$AllProfilesInstalled)

  # Profiles associated with the particular module version - installed?
  $profilesAssociated = @()
  foreach ($profileInAllProfiles in $AllProfilesInstalled[$Module + $version])
  {
    $profilesAssociated += $profileInAllProfiles
  }
  return $profilesAssociated
}

# Function to uninstall module
function Uninstall-ModuleHelper
{
  [CmdletBinding(SupportsShouldProcess = $true)] 
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidShouldContinueWithoutForce", "")]
  param([String]$Profile, $Module, $version, [Switch]$RemovePreviousVersions)

  $Remove = $PSBoundParameters.RemovePreviousVersions
  Do
  {
    $moduleInstalled = Get-Module -Name $Module -ListAvailable | Where-Object { $_.Version -eq $version} 
    if ($PSCmdlet.ShouldProcess("$module version $version", "Remove module")) 
    {
      if (($null -ne $moduleInstalled) -and ($Remove.IsPresent -or $PSCmdlet.ShouldContinue("Uninstall module $Module version $version", "Uninstall Modules for profile $Profile"))) 
      {
        Write-Verbose "Removing module from session"
        Remove-Module -Name $module -Force -ErrorAction "SilentlyContinue"
        try 
        {
          Write-Verbose "Uninstalling module $module version $version"
          if ($version.EndsWith("preview")) {
            $version = $version.TrimEnd("-preview")
          }
    
          Uninstall-Module -Name $module -RequiredVersion $version -Force -ErrorAction Stop -AllowPrerelease
        }
        catch
        {
          if ($_.Exception.Message -match "No match was found")
          {
            # Check for msi installation (Install folder: C:\ProgramFiles(x86)\Microsoft SDKs\Azure\PowerShell) Only in windows
            if ((-not $Script:IsCoreEdition) -or ($IsWindows))
            {
              $sdkPath1 = (join-path ${env:ProgramFiles(x86)} -childpath "\Microsoft SDKs\Azure\PowerShell\")
              $sdkPath2 = (join-path $script:ProgramFilesPSPath -childpath "\Microsoft SDKs\Azure\PowerShell\")
              if (($null -ne $moduleInstalled.Path) -and (($moduleInstalled.Path.Contains($sdkPath1) -or $moduleInstalled.Path.Contains($sdkPath2))))
              {
                Write-Error "Unable to uninstall module $module because it was installed in a different scope than expected. If you installed via an MSI, please uninstall the MSI before proceeding." -Category InvalidOperation
                break 
              }
            }
            Write-Error "Unable to uninstall module $module because it was installed in a different scope than expected. If you installed the module to a custom directory in your path, please remove the module manually, by using Uninstall-Module, or removing the module directory." -Category InvalidOperation
          }
          else {
            Write-Error $_.Exception.Message
          }
          break
        }
      }
      else {
        break
      }
    }
    else {
      break
    }
  }
  While($null -ne $moduleInstalled);
}

# Help function to uninstall a profile
function Uninstall-ProfileHelper
{
  [CmdletBinding()]
  param([PSObject]$PMap, [String]$Profile, [Switch]$Force)
  $modules = ($PMap.$Profile | Get-Member -MemberType NoteProperty).Name

  # Get-Profiles installed across all hashes. This is to avoid uninstalling modules that are part of other installed profiles
  $AllProfilesInstalled = Get-AllProfilesInstalled

  foreach ($module in $modules)
  {
    $versionList = $PMap.$Profile.$module
    foreach ($version in $versionList)
    {
      if ($Force.IsPresent)
      {
        Invoke-UninstallModule -PMap $PMap -Profile $Profile -Module $module -version $version -AllProfilesInstalled $AllProfilesInstalled -RemovePreviousVersions
      }
      else {
        Invoke-UninstallModule -PMap $PMap -Profile $Profile -Module $module -version $version -AllProfilesInstalled $AllProfilesInstalled 
      }
    }
  }
}

# Checks if the module is part of other installed profiles. Calls Uninstall-ModuleHelper if not.
function Invoke-UninstallModule
{
  [CmdletBinding()]
  param([PSObject]$PMap, [String]$Profile, $Module, $version, [hashtable]$AllProfilesInstalled, [Switch]$RemovePreviousVersions)

  # Check if the profiles associated with the module version are installed.
  Write-Verbose "Checking module dependency to any other profile installed"
  $profilesAssociated = Test-ProfilesInstalled -version $version -Module $Module -Profile $Profile -PMap $PMap -AllProfilesInstalled $AllProfilesInstalled
      
  # If more than one profile is installed for the same version of the module, do not uninstall
  if ($profilesAssociated.Count -gt 1) 
  {
    return
  }

  $PSBoundParameters.Remove('AllProfilesInstalled') | Out-Null
  $PSBoundParameters.Remove('PMap') | Out-Null

  Uninstall-ModuleHelper @PSBoundParameters
}

# Helps to uninstall previous versions of modules in the profile
function Remove-PreviousVersion
{
  [CmdletBinding()]
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
  param([PSObject]$LatestMap, [hashtable]$AllProfilesInstalled, [String]$Profile, [Array]$Module, [Switch]$RemovePreviousVersions)

  $Remove = $PSBoundParameters.RemovePreviousVersions
  $Modules = $PSBoundParameters.Module

  Write-Verbose "Checking if previous versions of modules are installed"

  if ($null -eq $Modules)
  {
    $Modules = ($LatestMap.$Profile | Get-Member -MemberType NoteProperty).Name
  }

  foreach ($module in $Modules)
  {   
    # Skip the latest version; first element will be the latest version
    $versionList = $LatestMap.$Profile.$module
    $versionList = $versionList | Where-Object { $_ -ne $versionList[0] }
    foreach ($version in $versionList)
    {
      # Is that module version installed? If not skip; 
      if ($version.EndsWith("preview")) {
        $version = $version.TrimEnd("-preview")
      }
      if ($null -eq (Get-Module -Name $Module -ListAvailable | Where-Object { $_.Version -eq $version} ))
      {
        continue
      }

      Write-Verbose "Previous versions of modules were found. Trying to uninstall..."
      if ($Remove.IsPresent)
      {
        Invoke-UninstallModule -PMap $LatestMap -Profile $Profile -Module $module -version $version -AllProfilesInstalled $AllProfilesInstalled -RemovePreviousVersions
      }
      else {
        Invoke-UninstallModule -PMap $LatestMap -Profile $Profile -Module $module -version $version -AllProfilesInstalled $AllProfilesInstalled         
      }
    }
      
    # Uninstall removes module from session; import latest version again
    $versions = $LatestMap.$Profile.$module
    $version = Get-LatestModuleVersion -versions $versions
    if ($version.EndsWith("preview")) {
      $version = $version.TrimEnd("-preview")
    }

    Import-Module $Module -RequiredVersion $version -Global
  }
}

# Gets profiles installed as @{Module+Version = @(profile)} for checking module dependency during uninstall
function Get-AllProfilesInstalled
{
  $AllProfilesInstalled = @{}
  # If Cache is empty, use embedded source
  if ($null -eq $script:LatestProfileMapPath)
  {
    $ModulePath = [System.IO.Path]::GetDirectoryName($PSCommandPath)
    $script:LatestProfileMapPath = Get-Item -Path (Join-Path -Path $ModulePath -ChildPath "azprofilemap.json")
  }

  $scriptBlock = {
    Get-Content -Raw -Path $script:LatestProfileMapPath.FullName -ErrorAction stop | ConvertFrom-Json 
  }
  $ProfileMap = Invoke-CommandWithRetry -ScriptBlock $scriptBlock 
  $profilesInstalled = (Get-ProfilesInstalled -ProfileMap $ProfileMap)
  foreach ($Profile in $profilesInstalled.Keys)
  { 
    foreach ($module in ($profilesinstalled.$profile.Keys)) 
    {
      $versionList = $profilesinstalled.$Profile.$Module
      foreach ($version in $versionList)
      {
        if ($AllProfilesInstalled.ContainsKey(($Module + $version)))
        {
          if ($Profile -notin $AllProfilesInstalled[($Module + $version)])
          {
            $AllProfilesInstalled[($Module + $version)] += $Profile
          }
        }
        else {
          $AllProfilesInstalled.Add(($Module + $version), @($Profile))
        }
      }
    }
  }
  return $AllProfilesInstalled
}

# Helps to remove-previous versions of the update-profile and clean up cache
function Update-ProfileHelper
{
  [CmdletBinding()]
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
  param([String]$Profile, [Array]$Module, [Switch]$RemovePreviousVersions)

  Write-Verbose "Attempting to clean up previous versions"

  # Cache was updated before calling this function, so latestprofilemap will not be null. 
  $scriptBlock = {
    Get-Content -Raw -Path $script:LatestProfileMapPath.FullName -ErrorAction stop | ConvertFrom-Json 
  }
  $LatestProfileMap = Invoke-CommandWithRetry -ScriptBlock $scriptBlock 

  $AllProfilesInstalled = Get-AllProfilesInstalled
  Remove-PreviousVersion -LatestMap $LatestProfileMap -AllProfilesInstalled $AllProfilesInstalled @PSBoundParameters
}

# If cmdlets were installed at a different scope, warn users of the potential conflict
function Find-PotentialConflict
{
  [CmdletBinding(SupportsShouldProcess = $true)] 
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
  param([string]$Module, [switch]$Force)
  
  Write-Verbose "Checking if there is a potential conflict for module installation"
  $availableModules = Get-Module $Module -ListAvailable
  $IsPotentialConflict = $false

  if ($null -eq $availableModules)
  {
    return $false
  }

  Write-Information "Modules installed: $availableModules"

  # If Admin, check CurrentUser Module folder path and vice versa
  if ($script:IsAdmin)
  {
    $availableModules | ForEach-Object { if (($null -ne $_.Path) -and $_.Path.Contains($HOME)) { $IsPotentialConflict = $true } }
  }
  else { 
    $availableModules | ForEach-Object { if (($null -ne $_.Path) -and $_.Path.Contains($script:ProgramFilesPSPath)) { $IsPotentialConflict = $true } }
  }

  # If potential conflict found, confirm with user for continuing with module installation if 'force' was not used
  if ($IsPotentialConflict)
  {
    if (($Force.IsPresent) -or ($PSCmdlet.ShouldContinue(`
      "The Cmdlets from module $Module are already present on this device. Proceeding with the installation might cause conflicts. Would you like to continue?", "Detected $Module cmdlets")))
    {
      return $false
    }
    else 
    {
      return $true
    }
  }

  # False if no conflict was found
  return $false 
}

# Helper function to invoke install-module
function Invoke-InstallModule
{
  param($module, $version, $scope)
  $installCmd = Get-Command Install-Module
  if($installCmd.Parameters.ContainsKey('AllowClobber'))
  {
    if (-not $scope)
    {
      Install-Module $Module -RequiredVersion $version -AllowClobber -Repository $script:BootStrapRepo -AllowPrerelease
    }
    else {
      Install-Module $Module -RequiredVersion $version -Scope $scope -AllowClobber -Repository $script:BootStrapRepo -AllowPrerelease
    }
  }
  else {
     if (-not $scope)
    {
      Install-Module $Module -RequiredVersion $version -Force -Repository $script:BootStrapRepo -AllowPrerelease
    }
    else {
      Install-Module $Module -RequiredVersion $version -Scope $scope -Force -Repository $script:BootStrapRepo -AllowPrerelease
    }
  }
}

# Invoke any script block with a retry logic
function Invoke-CommandWithRetry
{
  [CmdletBinding()]
  [OutputType([PSObject])]
  Param
  (
    [Parameter(Mandatory=$true,
      ValueFromPipelineByPropertyName=$true,
      Position=0)]
      [System.Management.Automation.ScriptBlock]
      $ScriptBlock,

    [Parameter(Position=1)]
      [ValidateNotNullOrEmpty()]
      [int]$MaxRetries=3,

    [Parameter(Position=2)]
      [ValidateNotNullOrEmpty()]
      [int]$RetryDelay=3
  )

  Begin
  {
    $currentRetry = 1
    $Success = $False
  }

  Process
  {
    do {
      try
      {
        $result = . $ScriptBlock
        $success = $true
        return $result
      }
      catch
      {
        $currentRetry = $currentRetry + 1
        if ($currentRetry -gt $MaxRetries) {
          $PSCmdlet.ThrowTerminatingError($PSitem)
        }
        else {
          Write-verbose -Message "Waiting $RetryDelay second(s) before attempting again"
          Start-Sleep -seconds $RetryDelay
        }
      }
    } while(-not $Success)
  }
}

# Select profile according to scope & create if it doesn't exist
function Select-Profile
{ 
  param([string]$scope)
  if($scope -eq "AllUsers" -and (-not $script:IsAdmin))
  {
    Write-Error "Administrator rights are required to use AllUsers scope. Log on to the computer with an account that has Administrator rights, and then try again, or retry the operation by adding `"-Scope CurrentUser`" to your command. You can also try running the Windows PowerShell session with elevated rights (Run as Administrator). " -Category InvalidArgument -ErrorAction Stop
  }

  if($scope -eq "AllUsers")
  {
    $profilePath = $profile.AllUsersAllHosts
  }
  else {
    $profilePath = $profile.CurrentUserAllHosts
  }
  if (-not (Test-Path $ProfilePath))
  {
    new-item -path $ProfilePath -itemtype file -force | Out-Null
  }
  return $profilePath
}

# Get the latest version of a module in a profile
function Get-LatestModuleVersion
{
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
  param ([array]$versions)

  $versionEnum = $versions.GetEnumerator()
  $toss = $versionEnum.MoveNext()
  $version = $versionEnum.Current
  return $version
}

# Gets module version to be set in default parameter in $profile
function Get-ModuleVersion
{
  param ([string] $armProfile, [string] $invocationLine)

  if (-not $invocationLine.ToLower().Contains("az"))
  {
    return
  }

  $ProfileMap = (Get-AzProfileMap)
  $Modules = ($ProfileMap.$armProfile | Get-Member -MemberType NoteProperty).Name
    
  # Check for Az first 
  if ($invocationLine.ToLower().Contains($RollUpModule.ToLower()) -and (-not $invocationLine.ToLower().Contains("$($RollUpModule.ToLower())."))) 
  {
    $versions = $ProfileMap.$armProfile.$RollUpModule
    $version = Get-LatestModuleVersion -versions $versions
    return $version
  }

  foreach ($module in $Modules)
  {
    if ($module -eq $RollUpModule)
    {
      continue
    }

    if ($invocationLine.ToLower().Contains($module.ToLower())) 
    {
      $versions = $ProfileMap.$armProfile.$module
      $version = Get-LatestModuleVersion -versions $versions
      return $version
    }
  }
}

# Create a script block with function to be called to get requiredversions for use with default parameters
function Get-ScriptBlock
{
  param ($ProfilePath)
  
  $profileContent = @()

  # Write Get-ModuleVersion function to $profile path 
  $functionScript = @"
function Get-ModVersion
{
  param (`$armProfile, `$invocationLine)
  if (-not `$invocationLine.ToLower().Contains("az"))
  {
    return
  }
  try 
  {
    `$BootstrapModule = Get-Module -Name "Az.Bootstrapper" -ListAvailable
    if (`$null -ne `$BootstrapModule)
    {
      Import-Module -Name "Az.Bootstrapper" -RequiredVersion `$BootstrapModule.Version[0]
      `$version = Get-ModuleVersion -armProfile `$armProfile -invocationLine `$invocationLine
      return `$version
    }
  }
  catch
  {
    return
  }
} `r`n
"@
  
  $profileContent += $functionScript

  $defaultScript = @"
`$PSDefaultParameterValues["Import-Module:RequiredVersion"]={ Get-ModVersion -armProfile `$PSDefaultParameterValues["*-AzProfile:Profile"] -invocationLine `$MyInvocation.Line }
########## END Az.Bootstrapper scripts
"@
  $profileContent += $defaultScript
  return $profileContent
}

function Remove-ProfileSetting
{
  [CmdletBinding(SupportsShouldProcess=$true)]
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
  param ([string] $profilePath)

  $RemoveSettingScriptBlock = {
    $reqLines = @()
    Get-Content -Path $profilePath -ErrorAction Stop | 
      Foreach-Object { 
        if($_.contains("BEGIN Az.Bootstrapper scripts") -or $donotread)
        {
          $donotread = $true; 
        } 
        else 
        { 
          $reqLines += $_ 
        }
        if ($_.contains("END Az.Bootstrapper scripts"))
        { 
          $donotread = $false 
        }
      }

      if ($PSCmdlet.ShouldProcess($reqLines, "Updating `$profile conents"))
      {
        Set-Content -path $profilePath -Value $reqLines -ErrorAction Stop 
      }
  }
  
  Invoke-CommandWithRetry -ScriptBlock $RemoveSettingScriptBlock
}

# Add Scope parameter to the cmdlet
function Add-ScopeParam
{
  param([System.Management.Automation.RuntimeDefinedParameterDictionary]$params, [string]$set = "__AllParameterSets")
  $Keys = @('CurrentUser', 'AllUsers')
  $scopeValid = New-Object -Type System.Management.Automation.ValidateSetAttribute($Keys)
  $scopeAttribute = New-Object -Type System.Management.Automation.ParameterAttribute
  $scopeAttribute.ParameterSetName = 
  $scopeAttribute.Mandatory = $false
  $scopeAttribute.Position = 2
  $scopeCollection = New-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
  $scopeCollection.Add($scopeValid)
  $scopeCollection.Add($scopeAttribute)
  $scopeParam = New-Object -Type System.Management.Automation.RuntimeDefinedParameter("Scope", [string], $scopeCollection)
  $params.Add("Scope", $scopeParam)
}

# Add the profile parameter to the cmdlet
function Add-ProfileParam
{
  param([System.Management.Automation.RuntimeDefinedParameterDictionary]$params, [string]$set = "__AllParameterSets")
  # Update Profile Map cache from the blob endpoint
  $ProfileMap = (Get-AzProfileMap -Update)
  $AllProfiles = ($ProfileMap | Get-Member -MemberType NoteProperty).Name
  $profileAttribute = New-Object -Type System.Management.Automation.ParameterAttribute
  $profileAttribute.ParameterSetName = $set
  $profileAttribute.Mandatory = $true
  $profileAttribute.Position = 0
  $profileAttribute.ValueFromPipeline = $true
  $validateProfileAttribute = New-Object -Type System.Management.Automation.ValidateSetAttribute($AllProfiles)
  $profileCollection = New-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
  $profileCollection.Add($profileAttribute)
  $profileCollection.Add($validateProfileAttribute)
  $profileParam = New-Object -Type System.Management.Automation.RuntimeDefinedParameter("Profile", [string], $profileCollection)
  $params.Add("Profile", $profileParam)
}

function Add-ForceParam
{
  param([System.Management.Automation.RuntimeDefinedParameterDictionary]$params, [string]$set = "__AllParameterSets")
  Add-SwitchParam $params "Force" $set
}

function Add-RemoveParam
{
  param([System.Management.Automation.RuntimeDefinedParameterDictionary]$params, [string]$set = "__AllParameterSets")
  $name = "RemovePreviousVersions" 
  $newAttribute = New-Object -Type System.Management.Automation.ParameterAttribute
  $newAttribute.ParameterSetName = $set
  $newAttribute.Mandatory = $false
  $newCollection = New-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
  $newCollection.Add($newAttribute)
  $newParam = New-Object -Type System.Management.Automation.RuntimeDefinedParameter($name, [switch], $newCollection)
  $params.Add($name, [Alias("r")]$newParam)
}

function Add-SwitchParam
{
  param([System.Management.Automation.RuntimeDefinedParameterDictionary]$params, [string]$name, [string] $set = "__AllParameterSets")
  $newAttribute = New-Object -Type System.Management.Automation.ParameterAttribute
  $newAttribute.ParameterSetName = $set
  $newAttribute.Mandatory = $false
  $newCollection = New-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
  $newCollection.Add($newAttribute)
  $newParam = New-Object -Type System.Management.Automation.RuntimeDefinedParameter($name, [switch], $newCollection)
  $params.Add($name, $newParam)
}

function Add-ModuleParam
{
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
  param([System.Management.Automation.RuntimeDefinedParameterDictionary]$params, [string]$name, [string] $set = "__AllParameterSets")
  $ProfileMap = (Get-AzProfileMap)
  $Profiles = ($ProfileMap | Get-Member -MemberType NoteProperty).Name
  if ($Profiles.Count -gt 1)
  {
    $enum = $Profiles.GetEnumerator()
    $toss = $enum.MoveNext()
    $Current = $enum.Current
    $Keys = ($($ProfileMap.$Current) | Get-Member -MemberType NoteProperty).Name
  }
  else {
    $Keys = ($($ProfileMap.$Profiles[0]) | Get-Member -MemberType NoteProperty).Name
  }
  $moduleValid = New-Object -Type System.Management.Automation.ValidateSetAttribute($Keys)
  $AllowNullAttribute = New-Object -Type System.Management.Automation.AllowNullAttribute
  $AllowEmptyStringAttribute = New-Object System.Management.Automation.AllowEmptyStringAttribute
  $moduleAttribute = New-Object -Type System.Management.Automation.ParameterAttribute
  $moduleAttribute.ParameterSetName = 
  $moduleAttribute.Mandatory = $false
  $moduleAttribute.Position = 1
  $moduleCollection = New-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
  $moduleCollection.Add($moduleValid)
  $moduleCollection.Add($moduleAttribute)
  $moduleCollection.Add($AllowNullAttribute)
  $moduleCollection.Add($AllowEmptyStringAttribute)
  $moduleParam = New-Object -Type System.Management.Automation.RuntimeDefinedParameter("Module", [array], $moduleCollection)
  $params.Add("Module", $moduleParam)
}

<#
.ExternalHelp help\Az.Bootstrapper-help.xml 
#>
function Get-AzModule 
{
  [CmdletBinding()]
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
  param()
  DynamicParam
  {
    $params = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
    Add-ProfileParam $params
    $ProfileMap = (Get-AzProfileMap)
    $Profiles = ($ProfileMap | Get-Member -MemberType NoteProperty).Name
    if ($Profiles.Count -gt 1)
    {
      $enum = $Profiles.GetEnumerator()
      $toss = $enum.MoveNext()
      $Current = $enum.Current
      $Keys = ($($ProfileMap.$Current) | Get-Member -MemberType NoteProperty).Name
    }
    else {
      $Keys = ($($ProfileMap.$Profiles[0]) | Get-Member -MemberType NoteProperty).Name
    }
    $moduleValid = New-Object -Type System.Management.Automation.ValidateSetAttribute($Keys)
    $moduleAttribute = New-Object -Type System.Management.Automation.ParameterAttribute
    $moduleAttribute.ParameterSetName = 
    $moduleAttribute.Mandatory = $true
    $moduleAttribute.Position = 1
    $moduleCollection = New-object -Type System.Collections.ObjectModel.Collection[System.Attribute]
    $moduleCollection.Add($moduleValid)
    $moduleCollection.Add($moduleAttribute)
    $moduleParam = New-Object -Type System.Management.Automation.RuntimeDefinedParameter("Module", [string], $moduleCollection)
    $params.Add("Module", $moduleParam)
    return $params
  }
  
  PROCESS
  {
    $ProfileMap = (Get-AzProfileMap)
    $Profile = $PSBoundParameters.Profile
    $Module = $PSBoundParameters.Module
    $versionList = $ProfileMap.$Profile.$Module
    Write-Verbose "Getting the version of $module from $profile"
    $moduleList = Get-Module -Name $Module -ListAvailable | Where-Object {$null -ne $_.RepositorySourceLocation}
    foreach ($version in $versionList)
    {
      foreach ($module in $moduleList)
      {
        if ($version -eq $module.Version)
        {
          return $version
        }
      }
    }
    return $null
  }
}

<#
.ExternalHelp help\Az.Bootstrapper-help.xml 
#>
function Get-AzApiProfile
{
  [CmdletBinding(DefaultParameterSetName="ListAvailableParameterSet")]
  param()
  DynamicParam
  {
    $params = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
    Add-SwitchParam $params "ListAvailable" "ListAvailableParameterSet"
    Add-SwitchParam $params "Update"
    return $params
  }
  PROCESS
  {
    # ListAvailable helps to display all profiles available from the gallery
    [switch]$ListAvailable = $PSBoundParameters.ListAvailable
    $PSBoundParameters.Remove('ListAvailable') | Out-Null
    $ProfileMap = (Get-AzProfileMap @PSBoundParameters)
    if ($ListAvailable.IsPresent)
    {
      Write-Verbose "Getting all the profiles available for install"
      foreach ($profile in ($ProfileMap | get-member -MemberType NoteProperty).Name)
      {
        $profileObj = $ProfileMap.$profile
        $profileObj | Add-Member -MemberType NoteProperty -Name "ProfileName" -Value $profile
        $profileObj | Add-Member -TypeName ProfileMapData 
        $profileObj
      }
      return
    }
    else
    {
      # Just display profiles installed on the machine
      Write-Verbose "Getting profiles installed on the machine and available for import"
      $IncompleteProfiles = @()
      $profilesInstalled = Get-ProfilesInstalled -ProfileMap $ProfileMap ([REF]$IncompleteProfiles)
      foreach ($key in $profilesInstalled.Keys)
      {      
        $profileObj = New-Object -TypeName psobject -property $profilesinstalled.$key
        $profileObj.PSObject.TypeNames.Insert(0,'ProfileMapData')
        $profileObj | Add-Member -MemberType NoteProperty -Name "ProfileName" -Value $key
        $profileObj
      }
      if ($IncompleteProfiles.Count -gt 0)
      {
        Write-Warning "Some modules from profile(s) $(@($IncompleteProfiles) -join ', ') were not installed. Use Install-AzProfile to install missing modules."
      }
      return
    }
  }
}

<#
.ExternalHelp help\Az.Bootstrapper-help.xml 
#>
function Use-AzProfile
{
  [CmdletBinding(SupportsShouldProcess=$true)] 
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidShouldContinueWithoutForce", "")]
  param()
  DynamicParam
  {
    $params = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
    Add-ProfileParam $params
    Add-ForceParam $params
    Add-ScopeParam $params
    Add-ModuleParam $params
    return $params
  }
  PROCESS 
  {
    $Force = $PSBoundParameters.Force
    $ProfileMap = Get-AzProfileMap
    $Profile = $PSBoundParameters.Profile
    $Scope = $PSBoundParameters.Scope
    $Modules = $PSBoundParameters.Module

    # If user hasn't provided modules, use the module names from profile
    if ($null -eq $Modules)
    {
      $Modules = ($ProfileMap.$Profile | Get-Member -MemberType NoteProperty).Name
    }

    # If Az $RollUpModule is present in that profile, it will install all the dependent modules; no need to specify other modules
    if ($Modules.Contains($RollUpModule))
    {
      $Modules = @($RollUpModule)
    }
    
    $PSBoundParameters.Remove('Profile') | Out-Null
    $PSBoundParameters.Remove('Scope') | Out-Null
    $PSBoundParameters.Remove('Module') | Out-Null

    # Variable to track progress
    $ModuleCount = 0
    Write-Output "Loading Profile $Profile"
    foreach ($Module in $Modules)
    {
      $ModuleCount = $ModuleCount + 1
      $version = Get-AzModule -Profile $Profile -Module $Module
      if (($null -eq $version) -and $PSCmdlet.ShouldProcess($module, "Installing module for profile $profile in the current scope"))
      {
        Write-Verbose "$module was not found on the machine. Trying to install..."
        if (($Force.IsPresent -or $PSCmdlet.ShouldContinue("Install Module $module for Profile $Profile from the gallery?", "Installing Modules for Profile $Profile")))
        {
          if (Find-PotentialConflict -Module $Module @PSBoundParameters) 
          {
            continue
          }
          $versions = $ProfileMap.$Profile.$Module
          $version = Get-LatestModuleVersion -versions $versions
          Write-Progress -Activity "Installing Module $Module version: $version" -Status "Progress:" -PercentComplete ($ModuleCount/($Modules.Length)*100)
          Write-Verbose "Installing module $module"
          Invoke-InstallModule -module $Module -version $version -scope $scope
        }
      }

      # If a different profile's Azure Module was imported, block user
      $importedModules = Get-Module "Az*"
      foreach ($importedModule in $importedModules) 
      {
        $latestVersions = $ProfileMap.$Profile.$($importedModule.Name)
        if ($null -ne $latestVersions)
        {
          # We need the latest version in that profile to be imported. If old version was imported, block user and ask to import in a new session
          $latestVersion = Get-LatestModuleVersion -versions $latestVersions
          
          # Allow import of preview module; preview module does not end with the term 'preview' in module metadata.
          if ($latestVersion.EndsWith("preview")) {
            $latestVersion = $latestVersion.TrimEnd("-preview")
          }
      
          if ($latestVersion -ne $importedModule.Version)
          {
            Write-Error "A different profile version of module $importedModule is imported in this session. Start a new PowerShell session and retry the operation." -Category  InvalidOperation 
            return
          }
        }
      }

      if ($PSCmdlet.ShouldProcess($module, "Importing module for profile $profile in the current scope"))
      {
        Write-Verbose "Importing module $module"
        if ($version.EndsWith("preview")) {
          $version = $version.TrimEnd("-preview")
        }
        Import-Module -Name $Module -RequiredVersion $version -Global
      }
    }
  }
}

<#
.ExternalHelp help\Az.Bootstrapper-help.xml 
#>
function Install-AzProfile
{
  [CmdletBinding(SupportsShouldProcess=$true)]
  param()
  DynamicParam
  {
    $params = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
    Add-ProfileParam $params
    Add-ScopeParam $params
    Add-ForceParam $params
    return $params
  }

  PROCESS {
    $ProfileMap = Get-AzProfileMap
    $Profile = $PSBoundParameters.Profile
    $Scope = $PSBoundParameters.Scope
    $Modules = ($ProfileMap.$Profile | Get-Member -MemberType NoteProperty).Name

    # If Az $RollUpModule is present in $profile, it will install all the dependent modules; no need to specify other modules
    if ($Modules.Contains($RollUpModule))
    {
      $Modules = @($RollUpModule)
    }
      
    $PSBoundParameters.Remove('Profile') | Out-Null
    $PSBoundParameters.Remove('Scope') | Out-Null

    $ModuleCount = 0
    foreach ($Module in $Modules)
    {
      $ModuleCount = $ModuleCount + 1
      if (Find-PotentialConflict -Module $Module @PSBoundParameters) 
      {
        continue
      }

      $version = Get-AzModule -Profile $Profile -Module $Module
      if ($null -eq $version) 
      {
        $versions = $ProfileMap.$Profile.$Module
        $version = Get-LatestModuleVersion -versions $versions
        if ($PSCmdlet.ShouldProcess($Module, "Installing Module $Module version: $version"))
        {
          Write-Progress -Activity "Installing Module $Module version: $version" -Status "Progress:" -PercentComplete ($ModuleCount/($Modules.Length)*100)
          Write-Verbose "Installing module $module" 
          Invoke-InstallModule -module $Module -version $version -scope $scope
        }
      }
    }
  }
}

<#
.ExternalHelp help\Az.Bootstrapper-help.xml 
#>
function Uninstall-AzProfile
{
  [CmdletBinding(SupportsShouldProcess = $true)]
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidShouldContinueWithoutForce", "")]
  param()
  DynamicParam
  {
    $params = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
    Add-ProfileParam $params
    Add-ForceParam $params
    return $params
  }

  PROCESS {
    $ProfileMap = (Get-AzProfileMap)
    $Profile = $PSBoundParameters.Profile
    $Force = $PSBoundParameters.Force

    if ($PSCmdlet.ShouldProcess("$Profile", "Uninstall Profile")) 
    {
      if (($Force.IsPresent -or $PSCmdlet.ShouldContinue("Uninstall Profile $Profile", "Removing Modules for profile $Profile")))
      {
        Write-Verbose "Trying to uninstall profile $profile"
        Uninstall-ProfileHelper -PMap $ProfileMap @PSBoundParameters
      }
    }
  }
}

<#
.ExternalHelp help\Az.Bootstrapper-help.xml 
#>
function Update-AzProfile
{
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "")]
  [CmdletBinding(SupportsShouldProcess = $true)]
  param()
  DynamicParam
  {
    $params = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
    Add-ProfileParam $params
    Add-ForceParam $params
    Add-RemoveParam $params 
    Add-ModuleParam $params
    Add-ScopeParam $params
    return $params
  }

  PROCESS {
    # Update Profile cache, if not up-to-date
    $ProfileMap = (Get-AzProfileMap -Update)
    $profile = $PSBoundParameters.Profile
    $Remove = $PSBoundParameters.RemovePreviousVersions

    $PSBoundParameters.Remove('RemovePreviousVersions') | Out-Null

    # Install & import the required version
    Use-AzProfile @PSBoundParameters
    
    $PSBoundParameters.Remove('Force') | Out-Null
    $PSBoundParameters.Remove('Scope') | Out-Null

    # Remove previous versions of the profile?
    if ($Remove.IsPresent -and $PSCmdlet.ShouldProcess($profile, "Remove previous versions of profile")) 
    {
      # Remove-PreviousVersions and clean up cache
      Update-ProfileHelper @PSBoundParameters -RemovePreviousVersions
    }
  }
}

function Set-BootstrapRepo
{
  [CmdletBinding()]
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "")]
  param
  (
    [Alias("Name")]
    [string]$Repo
  )
  $script:BootStrapRepo = $Repo
}

<#
.ExternalHelp help\Az.Bootstrapper-help.xml 
#>
function Set-AzDefaultProfile
{
  [CmdletBinding(SupportsShouldProcess = $true)]
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidShouldContinueWithoutForce", "")]
  param()
  DynamicParam
  {
    $params = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
    Add-ProfileParam $params
    Add-ForceParam $params
    Add-ScopeParam $params
    return $params
  }
  PROCESS {
    $armProfile = $PSBoundParameters.Profile
    $Scope = $PSBoundParameters.Scope
    $Force = $PSBoundParameters.Force

    $defaultProfile = $Global:PSDefaultParameterValues["*-AzProfile:Profile"]
    if ($defaultProfile -ne $armProfile)
    {
      if ($PSCmdlet.ShouldProcess("$armProfile", "Set Default Profile")) 
      {
        if (($Force.IsPresent -or $PSCmdlet.ShouldContinue("Are you sure you would like to set $armProfile as Default Profile?", "Setting $armProfile as Default profile")))
        {
          # Check Profile existence and choose proper profile
          $profilePath = Select-Profile -Scope $Scope

          # Set DefaultProfile for this session
          $Global:PSDefaultParameterValues["*-AzProfile:Profile"]="$armProfile"
          $Global:PSDefaultParameterValues["Import-Module:RequiredVersion"]={ Get-ModuleVersion -armProfile $Global:PSDefaultParameterValues["*-AzProfile:Profile"] -invocationLine $MyInvocation.Line }

          # Edit the profile content
          $profileContent = @"
########## BEGIN Az.Bootstrapper scripts
`$PSDefaultParameterValues["*-AzProfile:Profile"]="$armProfile" `r`n
"@

          # Get Script to be added to the $profile path
          $profileContent += Get-ScriptBlock -ProfilePath $profilePath

          Write-Verbose "Updating default profile value to $armProfile"
          Write-Debug "Removing previous setting if exists"
          Remove-ProfileSetting -profilePath $profilePath

          Write-Debug "Adding new default profile value as $armProfile"
          $AddContentScriptBlock = {
            Add-Content -Value $profileContent -Path $profilePath -ErrorAction Stop
          }  
          Invoke-CommandWithRetry -ScriptBlock $AddContentScriptBlock
        }
      }
    }
  }
}

<#
.ExternalHelp help\Az.Bootstrapper-help.xml 
#>
function Remove-AzDefaultProfile
{
  [CmdletBinding(SupportsShouldProcess = $true)]
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidShouldContinueWithoutForce", "")]
  param()
  DynamicParam
  {
    $params = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
    Add-ForceParam $params
    return $params
  }
  PROCESS {
    $Force = $PSBoundParameters.Force

    if ($PSCmdlet.ShouldProcess("ARM Default Profile", "Remove Default Profile")) 
    {
      if (($Force.IsPresent -or $PSCmdlet.ShouldContinue("Are you sure you would like to remove Default Profile?", "Remove Default profile")))
      {
        Write-Verbose "Removing default profile value"
        $Global:PSDefaultParameterValues.Remove("*-AzProfile:Profile")
        $Global:PSDefaultParameterValues.Remove("Import-Module:RequiredVersion")
        
        # Remove Az modules except bootstrapper module
        $importedModules = Get-Module "Az*"
        foreach ($importedModule in $importedModules) 
        {
          if ($importedModule.Name -eq "Az.Bootstrapper")
          {
            continue
          }
          Remove-Module -Name $importedModule -Force -ErrorAction "SilentlyContinue"
        }

        # Remove content from $profile
        $profiles = @()
        if ($script:IsAdmin)
        {
          $profiles += $profile.AllUsersAllHosts
        }
        
        $profiles += $profile.CurrentUserAllHosts
        
        foreach ($profilePath in $profiles)
        {
          if (-not (Test-Path -path $profilePath))
          {
            continue
          }

          Remove-ProfileSetting -profilePath $profilePath
        }
      }
    }
  }
}
# SIG # Begin signature block
# MIIjkgYJKoZIhvcNAQcCoIIjgzCCI38CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCKp6E5b9JqfHZI
# rgwZqVflb01zsIVHT3bE/qEuC+PMAaCCDYEwggX/MIID56ADAgECAhMzAAAB32vw
# LpKnSrTQAAAAAAHfMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjAxMjE1MjEzMTQ1WhcNMjExMjAyMjEzMTQ1WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQC2uxlZEACjqfHkuFyoCwfL25ofI9DZWKt4wEj3JBQ48GPt1UsDv834CcoUUPMn
# s/6CtPoaQ4Thy/kbOOg/zJAnrJeiMQqRe2Lsdb/NSI2gXXX9lad1/yPUDOXo4GNw
# PjXq1JZi+HZV91bUr6ZjzePj1g+bepsqd/HC1XScj0fT3aAxLRykJSzExEBmU9eS
# yuOwUuq+CriudQtWGMdJU650v/KmzfM46Y6lo/MCnnpvz3zEL7PMdUdwqj/nYhGG
# 3UVILxX7tAdMbz7LN+6WOIpT1A41rwaoOVnv+8Ua94HwhjZmu1S73yeV7RZZNxoh
# EegJi9YYssXa7UZUUkCCA+KnAgMBAAGjggF+MIIBejAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUOPbML8IdkNGtCfMmVPtvI6VZ8+Mw
# UAYDVR0RBEkwR6RFMEMxKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1
# ZXJ0byBSaWNvMRYwFAYDVQQFEw0yMzAwMTIrNDYzMDA5MB8GA1UdIwQYMBaAFEhu
# ZOVQBdOCqhc3NyK1bajKdQKVMFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY0NvZFNpZ1BDQTIwMTFfMjAxMS0w
# Ny0wOC5jcmwwYQYIKwYBBQUHAQEEVTBTMFEGCCsGAQUFBzAChkVodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRzL01pY0NvZFNpZ1BDQTIwMTFfMjAx
# MS0wNy0wOC5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAgEAnnqH
# tDyYUFaVAkvAK0eqq6nhoL95SZQu3RnpZ7tdQ89QR3++7A+4hrr7V4xxmkB5BObS
# 0YK+MALE02atjwWgPdpYQ68WdLGroJZHkbZdgERG+7tETFl3aKF4KpoSaGOskZXp
# TPnCaMo2PXoAMVMGpsQEQswimZq3IQ3nRQfBlJ0PoMMcN/+Pks8ZTL1BoPYsJpok
# t6cql59q6CypZYIwgyJ892HpttybHKg1ZtQLUlSXccRMlugPgEcNZJagPEgPYni4
# b11snjRAgf0dyQ0zI9aLXqTxWUU5pCIFiPT0b2wsxzRqCtyGqpkGM8P9GazO8eao
# mVItCYBcJSByBx/pS0cSYwBBHAZxJODUqxSXoSGDvmTfqUJXntnWkL4okok1FiCD
# Z4jpyXOQunb6egIXvkgQ7jb2uO26Ow0m8RwleDvhOMrnHsupiOPbozKroSa6paFt
# VSh89abUSooR8QdZciemmoFhcWkEwFg4spzvYNP4nIs193261WyTaRMZoceGun7G
# CT2Rl653uUj+F+g94c63AhzSq4khdL4HlFIP2ePv29smfUnHtGq6yYFDLnT0q/Y+
# Di3jwloF8EWkkHRtSuXlFUbTmwr/lDDgbpZiKhLS7CBTDj32I0L5i532+uHczw82
# oZDmYmYmIUSMbZOgS65h797rj5JJ6OkeEUJoAVwwggd6MIIFYqADAgECAgphDpDS
# AAAAAAADMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0
# ZSBBdXRob3JpdHkgMjAxMTAeFw0xMTA3MDgyMDU5MDlaFw0yNjA3MDgyMTA5MDla
# MH4xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMT
# H01pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTEwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQCr8PpyEBwurdhuqoIQTTS68rZYIZ9CGypr6VpQqrgG
# OBoESbp/wwwe3TdrxhLYC/A4wpkGsMg51QEUMULTiQ15ZId+lGAkbK+eSZzpaF7S
# 35tTsgosw6/ZqSuuegmv15ZZymAaBelmdugyUiYSL+erCFDPs0S3XdjELgN1q2jz
# y23zOlyhFvRGuuA4ZKxuZDV4pqBjDy3TQJP4494HDdVceaVJKecNvqATd76UPe/7
# 4ytaEB9NViiienLgEjq3SV7Y7e1DkYPZe7J7hhvZPrGMXeiJT4Qa8qEvWeSQOy2u
# M1jFtz7+MtOzAz2xsq+SOH7SnYAs9U5WkSE1JcM5bmR/U7qcD60ZI4TL9LoDho33
# X/DQUr+MlIe8wCF0JV8YKLbMJyg4JZg5SjbPfLGSrhwjp6lm7GEfauEoSZ1fiOIl
# XdMhSz5SxLVXPyQD8NF6Wy/VI+NwXQ9RRnez+ADhvKwCgl/bwBWzvRvUVUvnOaEP
# 6SNJvBi4RHxF5MHDcnrgcuck379GmcXvwhxX24ON7E1JMKerjt/sW5+v/N2wZuLB
# l4F77dbtS+dJKacTKKanfWeA5opieF+yL4TXV5xcv3coKPHtbcMojyyPQDdPweGF
# RInECUzF1KVDL3SV9274eCBYLBNdYJWaPk8zhNqwiBfenk70lrC8RqBsmNLg1oiM
# CwIDAQABo4IB7TCCAekwEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFEhuZOVQ
# BdOCqhc3NyK1bajKdQKVMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1Ud
# DwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFHItOgIxkEO5FAVO
# 4eqnxzHRI4k0MFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwubWljcm9zb2Z0
# LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcmwwXgYIKwYBBQUHAQEEUjBQME4GCCsGAQUFBzAChkJodHRwOi8vd3d3Lm1p
# Y3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcnQwgZ8GA1UdIASBlzCBlDCBkQYJKwYBBAGCNy4DMIGDMD8GCCsGAQUFBwIB
# FjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2RvY3MvcHJpbWFyeWNw
# cy5odG0wQAYIKwYBBQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AcABvAGwAaQBjAHkA
# XwBzAHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAGfyhqWY
# 4FR5Gi7T2HRnIpsLlhHhY5KZQpZ90nkMkMFlXy4sPvjDctFtg/6+P+gKyju/R6mj
# 82nbY78iNaWXXWWEkH2LRlBV2AySfNIaSxzzPEKLUtCw/WvjPgcuKZvmPRul1LUd
# d5Q54ulkyUQ9eHoj8xN9ppB0g430yyYCRirCihC7pKkFDJvtaPpoLpWgKj8qa1hJ
# Yx8JaW5amJbkg/TAj/NGK978O9C9Ne9uJa7lryft0N3zDq+ZKJeYTQ49C/IIidYf
# wzIY4vDFLc5bnrRJOQrGCsLGra7lstnbFYhRRVg4MnEnGn+x9Cf43iw6IGmYslmJ
# aG5vp7d0w0AFBqYBKig+gj8TTWYLwLNN9eGPfxxvFX1Fp3blQCplo8NdUmKGwx1j
# NpeG39rz+PIWoZon4c2ll9DuXWNB41sHnIc+BncG0QaxdR8UvmFhtfDcxhsEvt9B
# xw4o7t5lL+yX9qFcltgA1qFGvVnzl6UJS0gQmYAf0AApxbGbpT9Fdx41xtKiop96
# eiL6SJUfq/tHI4D1nvi/a7dLl+LrdXga7Oo3mXkYS//WsyNodeav+vyL6wuA6mk7
# r/ww7QRMjt/fdW1jkT3RnVZOT7+AVyKheBEyIXrvQQqxP/uozKRdwaGIm1dxVk5I
# RcBCyZt2WwqASGv9eZ/BvW1taslScxMNelDNMYIVZzCCFWMCAQEwgZUwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMQITMwAAAd9r8C6Sp0q00AAAAAAB3zAN
# BglghkgBZQMEAgEFAKCBrjAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgKdhmp3Z8
# +mZ1gfHTmYfauiWwc8lm90XaFyJ8tw0snO4wQgYKKwYBBAGCNwIBDDE0MDKgFIAS
# AE0AaQBjAHIAbwBzAG8AZgB0oRqAGGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbTAN
# BgkqhkiG9w0BAQEFAASCAQCiICdZOj7wZ5z0brkm4dxNL+Ixl4lF8ROHMau46Rg5
# VOeFFu3npNpinhl/gcbNrv3j1mn0KZTTHjTH9b6Si3EopCUeO3BiUIzmufWXcKUz
# soV4evgKCOUp0o4dNNrqV/jBiuv0hcZCcoKACtLYjA0Q9ZNcdIc0DolXS/nNnlLa
# Wj4w8mq6L4i5niFqKt52A8f7CcOZRjZTpBLNrStdTC0ztGBiEF3G0HO7Ilr4KlGO
# Rjy0OoFXN8SgDg2DhTXIAwXgWK40xSHSmigdDQ2/LUr8aMYjkQXtF7Kh0HXwjLma
# sfeo233iNjgu95l+kv3Hk1G9juG5ltfQh/pA0O2KLrQ5oYIS8TCCEu0GCisGAQQB
# gjcDAwExghLdMIIS2QYJKoZIhvcNAQcCoIISyjCCEsYCAQMxDzANBglghkgBZQME
# AgEFADCCAVUGCyqGSIb3DQEJEAEEoIIBRASCAUAwggE8AgEBBgorBgEEAYRZCgMB
# MDEwDQYJYIZIAWUDBAIBBQAEINrQIeMFDkUE8umkfwrpY579oR7ZEdM4Xi+Hu/bU
# dxG+AgZgr759380YEzIwMjEwNjIyMTcxNzQyLjAwNFowBIACAfSggdSkgdEwgc4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKTAnBgNVBAsTIE1p
# Y3Jvc29mdCBPcGVyYXRpb25zIFB1ZXJ0byBSaWNvMSYwJAYDVQQLEx1UaGFsZXMg
# VFNTIEVTTjo3ODgwLUUzOTAtODAxNDElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgU2VydmljZaCCDkQwggT1MIID3aADAgECAhMzAAABXIbS4+w59os4AAAA
# AAFcMA0GCSqGSIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEw
# MB4XDTIxMDExNDE5MDIxN1oXDTIyMDQxMTE5MDIxN1owgc4xCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVy
# YXRpb25zIFB1ZXJ0byBSaWNvMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjo3ODgw
# LUUzOTAtODAxNDElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2Vydmlj
# ZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANAqKz6vKh9iQLJoEvJc
# CUwd5fnatwQXmIZMlJ84v4nsMufnfJbG623f/U8OBu1syOXOZ7VzHOeC/+rIZrzc
# JQaQ8r5lCQjn9fiG3jk+pqPSFRl3w9YGFjouy/FxuSA6s/Mv7b0GS0baHTlJFgRu
# DKBgBsTagGR4SRmHnFdrShT3tk1T3WASLTGISeGGx4i0DyDuz8zQVmppL8+BUyiP
# ir0W/XZOsuA6FExj3gTvyTLfiDVhmNcwzPv5LQlrIVir0m2+7UDTY8inzHl/2ClH
# 4N42uqbWk9H2I4rpCCcUWSBw1m8De4hTsTGQET7qiR+FfI7PQlJQ+9ef7ANAflPS
# NhsCAwEAAaOCARswggEXMB0GA1UdDgQWBBRf8xSsOShygJAFf7iaey1jGMG6PjAf
# BgNVHSMEGDAWgBTVYzpcijGQ80N7fEYbxTNoWoVtVTBWBgNVHR8ETzBNMEugSaBH
# hkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNU
# aW1TdGFQQ0FfMjAxMC0wNy0wMS5jcmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUF
# BzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1RpbVN0
# YVBDQV8yMDEwLTA3LTAxLmNydDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsG
# AQUFBwMIMA0GCSqGSIb3DQEBCwUAA4IBAQB4eUz2134gcw4cI/Uy2e2jkO7tepK7
# T5WXt76a/Az/pdNCN6B1D6QYRRHL90JmGlZMdUtwG/A6E9RqNqDv9aHQ8/2FLFcr
# rNOTgDQ0cjZ/9Mx8sto17k4rW22QvTYOQBB14ouNAsDloZ9aqc/Qtmi8JFHd6Mc7
# vE5oDgeVGm3y8er7UgLn4gkTIYn8leTPY9H2yuoLfXbQ8Xrl0WWFBbmZm6t3DEG+
# r6raImNJ7PrBQHnpdXxCjjF5WNPMYNeKEWA+RkyA5FD5YA0uKXtlNd5HgvwcWo/A
# CGyuPluxwYBcDCZQFFatov0uNjOsQxEMRgAzpA5vqEOOx/TUEYFkcRBJMIIGcTCC
# BFmgAwIBAgIKYQmBKgAAAAAAAjANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJv
# b3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIwMTAwHhcNMTAwNzAxMjEzNjU1WhcN
# MjUwNzAxMjE0NjU1WjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
# bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
# aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDCCASIw
# DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKkdDbx3EYo6IOz8E5f1+n9plGt0
# VBDVpQoAgoX77XxoSyxfxcPlYcJ2tz5mK1vwFVMnBDEfQRsalR3OCROOfGEwWbEw
# RA/xYIiEVEMM1024OAizQt2TrNZzMFcmgqNFDdDq9UeBzb8kYDJYYEbyWEeGMoQe
# dGFnkV+BVLHPk0ySwcSmXdFhE24oxhr5hoC732H8RsEnHSRnEnIaIYqvS2SJUGKx
# Xf13Hz3wV3WsvYpCTUBR0Q+cBj5nf/VmwAOWRH7v0Ev9buWayrGo8noqCjHw2k4G
# kbaICDXoeByw6ZnNPOcvRLqn9NxkvaQBwSAJk3jN/LzAyURdXhacAQVPIk0CAwEA
# AaOCAeYwggHiMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBTVYzpcijGQ80N7
# fEYbxTNoWoVtVTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMC
# AYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvX
# zpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20v
# cGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYI
# KwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNydDCBoAYDVR0g
# AQH/BIGVMIGSMIGPBgkrBgEEAYI3LgMwgYEwPQYIKwYBBQUHAgEWMWh0dHA6Ly93
# d3cubWljcm9zb2Z0LmNvbS9QS0kvZG9jcy9DUFMvZGVmYXVsdC5odG0wQAYIKwYB
# BQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AUABvAGwAaQBjAHkAXwBTAHQAYQB0AGUA
# bQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAAfmiFEN4sbgmD+BcQM9naOh
# IW+z66bM9TG+zwXiqf76V20ZMLPCxWbJat/15/B4vceoniXj+bzta1RXCCtRgkQS
# +7lTjMz0YBKKdsxAQEGb3FwX/1z5Xhc1mCRWS3TvQhDIr79/xn/yN31aPxzymXlK
# kVIArzgPF/UveYFl2am1a+THzvbKegBvSzBEJCI8z+0DpZaPWSm8tv0E4XCfMkon
# /VWvL/625Y4zu2JfmttXQOnxzplmkIz/amJ/3cVKC5Em4jnsGUpxY517IW3DnKOi
# PPp/fZZqkHimbdLhnPkd/DjYlPTGpQqWhqS9nhquBEKDuLWAmyI4ILUl5WTs9/S/
# fmNZJQ96LjlXdqJxqgaKD4kWumGnEcua2A5HmoDF0M2n0O99g/DhO3EJ3110mCII
# YdqwUB5vvfHhAN/nMQekkzr3ZUd46PioSKv33nJ+YWtvd6mBy6cJrDm77MbL2IK0
# cs0d9LiFAR6A+xuJKlQ5slvayA1VmXqHczsI5pgt6o3gMy4SKfXAL1QnIffIrE7a
# KLixqduWsqdCosnPGUFN4Ib5KpqjEWYw07t0MkvfY3v1mYovG8chr1m1rtxEPJdQ
# cdeh0sVV42neV8HR3jDA/czmTfsNv11P6Z0eGTgvvM9YBS7vDaBQNdrvCScc1bN+
# NR4Iuto229Nfj950iEkSoYIC0jCCAjsCAQEwgfyhgdSkgdEwgc4xCzAJBgNVBAYT
# AlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYD
# VQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKTAnBgNVBAsTIE1pY3Jvc29mdCBP
# cGVyYXRpb25zIFB1ZXJ0byBSaWNvMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjo3
# ODgwLUUzOTAtODAxNDElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2Vy
# dmljZaIjCgEBMAcGBSsOAwIaAxUAnuKlo8afKEeVnH5d6yP4nk5p8EyggYMwgYCk
# fjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQD
# Ex1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQUFAAIF
# AOR8gvUwIhgPMjAyMTA2MjIxOTQwMzdaGA8yMDIxMDYyMzE5NDAzN1owdzA9Bgor
# BgEEAYRZCgQBMS8wLTAKAgUA5HyC9QIBADAKAgEAAgIMQgIB/zAHAgEAAgIRqTAK
# AgUA5H3UdQIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMCoAowCAIB
# AAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBBQUAA4GBAJHPqeyb0ClNU5tb
# +kPAB+8VgMJriFLBMRUwSSR0v2bONVh9qb5kmMez6Lldbn3OjIdpUg357PuZSF+K
# D4GNnAuLMPJ8+7Th1J6mt6HVRyo3E3oeYLgB8MCR3FtCGnrgF6zBz5NCWF67dtxN
# L+4Hq3zkFVf9zuD98UWDHL5oTQHUMYIDDTCCAwkCAQEwgZMwfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTACEzMAAAFchtLj7Dn2izgAAAAAAVwwDQYJYIZIAWUD
# BAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0B
# CQQxIgQgBKv96vUid9mWOHnuz8AQ+8WPfFSjiRtkoYDK0ff7SqUwgfoGCyqGSIb3
# DQEJEAIvMYHqMIHnMIHkMIG9BCBPLWRXwiBPbAAwScykICtQPfQuIIhGbxXvtFyP
# DBnmtTCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
# MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
# b24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB
# XIbS4+w59os4AAAAAAFcMCIEIBRHjFM/PWvyx92DtpHTmh5U8NjXVqhApD0RvEXk
# H1XWMA0GCSqGSIb3DQEBCwUABIIBAF7TX1qsa4/SRzKonTMa9jOwlAJ92V9pOP/R
# /XgeNsf7sSzK+9f5k8vebK9uhZpaC3/CDilfmXKW0SqZ233+wiUxkCzyARq9GbSy
# Ug7xbnDEoN5mS4uOrhL84+j3WeQHi7qrGuN5aesI0ze0VwGgrz0HuuHOdafl747U
# PWhJEkA66iIq5C2iNmb9EIrbgNXykYghePlZaSiRjvMF7L//ZbnIw/enw0H8nUqb
# 0akbzzXCJhYQ9cdtrgnpEore8nQgpjQaR6iKulTwqW5OxeN2uNhJooAVvV24YZoV
# tMGfNRkl5RcOnKvmj/qRG/19OqryKpuja88ra0gYo0lie8WHeAM=
# SIG # End signature block
