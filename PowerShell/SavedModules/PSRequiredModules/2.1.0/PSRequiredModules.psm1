<#
    .SYNOPSIS
        Get-RequiredModules

    .DESCRIPTION
        Read PSRequiredModules data from PowerShell module manifest.

    .PARAMETER  ModuleFilePath
        Module file path expect a module file ending with .psd1 or .psm1 (to retrieve automatically associated .psd1)

    .EXAMPLE
        PS C:\> Get-RequiredModules -ModuleFilePath 'C:\MyModule\MyModule.psd1'

    .INPUTS
        System.String

    .OUTPUTS
        System.Boolean

    .NOTES
        Author: JDMSFT
        Date: 17/03/21
#>
Function Get-RequiredModules
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$ModuleFilePath
    )

    Try
    {
        If ($ModuleFilePath -like '*.psm1' -or $ModuleFilePath -like '*.psd1')
        {
            $ManifestData = Import-LocalizedData -BaseDirectory (Split-Path $ModuleFilePath) -FileName (Split-Path $ModuleFilePath -Leaf)

            $ManifestData.PrivateData.PSRequiredModules
        }
        Else
        {
            Write-Warning "Please specify a valid module file path (ending with .psm1/.psd1)"
        }
    }
    Catch { Write-Error $($_) ; throw "[message] $($_)`nException: [locator] $($_.InvocationInfo.ScriptName):$($_.InvocationInfo.ScriptLineNumber) >> $($_.InvocationInfo.Line.TrimStart())" }
}

<#
    .SYNOPSIS
        Import-RequiredModules

    .DESCRIPTION
        Read PSRequiredModules data from PowerShell module manifest.

    .PARAMETER  ModuleFilePath
        Module file path expect a module file ending with .psd1 or .psm1 (to retrieve automatically associated .psd1)

    .PARAMETER  AutoInstall
        Automatically install missing module from PowerShell environments

    .PARAMETER  Details
        Return full state details isntead returning a boolean (usefull to troubleshoot)

    .EXAMPLE
        PS C:\> Import-RequiredModules -ModuleFilePath 'C:\MyModule\MyModule.psd1'
        
        Return if all required modules are imported in the PowerShell session.

    .EXAMPLE
        PS C:\> Import-RequiredModules -ModuleFilePath 'C:\MyModule\MyModule.psd1' -AutoInstall
        
        Install missing modules and return if all required modules are imported in the PowerShell session.

    .EXAMPLE
        PS C:\> Import-RequiredModules -ModuleFilePath 'C:\MyModule\MyModule.psd1' -Details
        
        Return all required modules states for the current PowerShell session instead returnin a boolean.

    .INPUTS
        System.String

    .OUTPUTS
        System.Boolean,Hastable

    .NOTES
        Author: JDMSFT
        Date: 17/03/21
#>
Function Import-RequiredModules
{
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory = $true)] 
        [string]$ModuleFilePath,
        [switch]$AutoInstall,
        [switch]$Details
    )

    Try 
    {
        If ($ModuleFilePath -like '*.psm1' -or $ModuleFilePath -like '*.psd1')
        {
            $ModuleObject = @()
            $CallerFileName = (Split-Path $ModuleFilePath -Leaf)
            $CallerName = $CallerFileName.Substring(0, $CallerFileName.Length-5)
            $ManifestData = Import-LocalizedData -BaseDirectory (Split-Path $ModuleFilePath) -FileName $CallerFileName
            $CallerVersion = $ManifestData.ModuleVersion

            $ManifestData.PrivateData.PSRequiredModules.Keys | ForEach {

                $IsAlreadyImported = $false
                $IsRightVersionImported = $false
                $IsRightVersionInstalled = $false
                $IsDownloadable = 'Untested (locally present)'
                $Action = 'None'
                $State = $null

                # Get required version / prerelease
                $RequiredModuleName = $_
                $RequiredModuleVersionSemVer = $ManifestData.PrivateData.PSRequiredModules.$_
                If ($RequiredModuleVersionSemVer -like '*-*') 
                { 
                    $PreReleaseVersion = $true
                    $RequiredModuleVersion = ($RequiredModuleVersionSemVer -split '-')[0]
                    $RequiredModulePrerelease = ($RequiredModuleVersionSemVer -split '-')[1]
                } 
                Else 
                { 
                    $PreReleaseVersion = $false 
                    $RequiredModuleVersion = $RequiredModuleVersionSemVer
                }

                # Checking for imported module version ...
                $MatchVersion = $false
                $RequiredModuleImportedMatches = Get-Module $RequiredModuleName
                If ($RequiredModuleImportedMatches)
                {
                    If ($PreReleaseVersion)
                    {
                        Write-Verbose "Checking for imported module $RequiredModuleName v$RequiredModuleVersionSemVer... (prerelease)"
                        $RequiredModuleImportedMatches | ForEach { 
                            If ($_.Version -eq $RequiredModuleVersion -and $_.PrivateData.PSData.Prerelease -eq $RequiredModulePrerelease) 
                            { 
                                Write-Verbose "Module $RequiredModuleName v$RequiredModuleVersionSemVer already imported !"
                                $MatchVersion = $true
                                $RequiredModule = $_ 
                                $IsAlreadyImported = $true
                                $IsRightVersionImported = $true
                                $IsRightVersionInstalled = $true
                                $State = 'OK'
                            } 
                        }
                    }
                    Else
                    {
                        Write-Verbose "Checking for imported module $RequiredModuleName v$RequiredModuleVersionSemVer... (not prerelease)"
                        $RequiredModuleImportedMatches | ForEach { 
                            If ($_.Version -eq $RequiredModuleVersion) 
                            { 
                                Write-Verbose "Module $RequiredModuleName v$RequiredModuleVersionSemVer already imported !"
                                $MatchVersion = $true
                                $RequiredModule = $_ 
                                $IsAlreadyImported = $true
                                $IsRightVersionImported = $true
                                $IsRightVersionInstalled = $true
                                $State = 'OK'
                            } 
                        } 
                    }

                    If ($MatchVersion -ne $true) 
                    { 
                        Write-Warning "[PSRequiredModules] Wrong $RequiredModuleName module version already imported in the current PowerShell session (required version : $RequiredModuleVersionSemVer). You may encount some issue/bug by using this $RequiredModuleName module version. Please consider to remove $RequiredModuleName module (Remove-Module $RequiredModuleName) from your current PowerShell session prior importing $CallerName v$CallerVersion for an optimal experience."

                        $IsAlreadyImported = $true
                        $Action = "Skipped"
                        $State = 'Warning (wrong version already imported)'
                    }
                } Else {Write-Verbose "No $RequiredModuleName imported in the current PowerShell session"}

                If ($IsAlreadyImported -ne $true)
                {
                    # Checking for installed module version ...
                    $RequiredModuleInstalledMatches = Get-Module $RequiredModuleName -ListAvailable
                    If ($MatchVersion -ne $true) 
                    {
                        If ($PreReleaseVersion)
                        {
                            Write-Verbose "Checking for installed module $RequiredModuleName v$RequiredModuleVersionSemVer... (prerelease)"
                            $RequiredModuleInstalledMatches | ForEach { 
                                If ($_.Version -eq $RequiredModuleVersion -and $_.PrivateData.PSData.Prerelease -eq $RequiredModulePrerelease) 
                                { 
                                    Write-Verbose "Module $RequiredModuleName v$RequiredModuleVersionSemVer already installed !"
                                    $MatchVersion = $true
                                    $RequiredModule = $_ 
                                    $IsRightVersionInstalled = $true
                                } 
                            }
                        }
                        Else
                        {
                            Write-Verbose "Checking for installed module $RequiredModuleName v$RequiredModuleVersionSemVer... (not prerelease)"
                            $RequiredModuleInstalledMatches | ForEach { 
                                If ($_.Version -eq $RequiredModuleVersion) 
                                { 
                                    Write-Verbose "Module $RequiredModuleName v$RequiredModuleVersionSemVer already installed !"
                                    $MatchVersion = $true
                                    $RequiredModule = $_ 
                                    $IsRightVersionInstalled = $true
                                } 
                            } 
                        }

                        # Module installed, importing ...
                        If ($MatchVersion -eq $true) 
                        {
                            Write-Verbose "Importing module $RequiredModuleName v$RequiredModuleVersionSemVer..."
                            Import-Module $RequiredModule -Global
                            $Action = 'AutoImport'
                            If (Get-Module $RequiredModuleName) { $State = 'OK' } Else { $State = 'KO' }

                        }
                        # Module not installed, installing and importing ...
                        Else 
                        {
                            Write-Verbose "Module $RequiredModuleName v$RequiredModuleVersionSemVer not found."

                            If (Find-Module -Name $RequiredModuleName -RequiredVersion $RequiredModuleVersionSemVer -Repository PSGallery -AllowPrerelease -ea SilentlyContinue) { $IsDownloadable = $true } Else { $IsDownloadable = $false }

                            If ($AutoInstall)
                            {
                                If ($IsDownloadable)
                                {
                                    $Action = 'AutoInstall'
                                    Install-Module -Name $RequiredModuleName -RequiredVersion $RequiredModuleVersionSemVer -Repository PSGallery -AllowPrerelease

                                    If (Get-InstalledModule -Name $RequiredModuleName -RequiredVersion $RequiredModuleVersionSemVer -AllowPrerelease -ea SilentlyContinue) { Import-Module -Name $RequiredModuleName -RequiredVersion $RequiredModuleVersion -Global } 
                                }
                                Else { Write-Verbose "$RequiredModuleName can't be downloaded." }
                        
                                If (Get-Module $RequiredModuleName) { $State = 'OK' } Else { $State = 'KO' }
                            }
                            Else { Write-Verbose "Auto-install module disabled. Please installl required module manually prior using this module : Isntall-Module -Name $ModuleName -RequiredVersion $RequiredModuleVersionSemVer" ; $State = 'KO' }
                        } 
                    }
                    Else { Write-Verbose "" }
                }

                $ModuleObject += [PSCustomObject]@{Name = $RequiredModuleName; Version = $RequiredModuleVersionSemVer; IsPrerelease = $PreReleaseVersion ; IsAlreadyImported = $IsAlreadyImported ; IsRightVersionImported = $IsRightVersionImported ; IsRightVersionInstalled = $IsRightVersionInstalled ; IsDownloadable = $IsDownloadable ; Action = $Action ; State = $State }
            }

            If ($Details) { $ModuleObject } Else { $ModuleObject.State -notcontains 'KO' }
        }
        Else
        {
            Write-Warning "Please specify a valid module file path (ending with .psm1/.psd1)"
        }
    }
    Catch { Write-Error $($_) ; throw "[message] $($_)`nException: [locator] $($_.InvocationInfo.ScriptName):$($_.InvocationInfo.ScriptLineNumber) >> $($_.InvocationInfo.Line.TrimStart())" }
}