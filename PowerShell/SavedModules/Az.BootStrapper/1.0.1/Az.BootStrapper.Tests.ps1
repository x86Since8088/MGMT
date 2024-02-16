#Requires -Modules Az.BootStrapper
$global:testProfileMap = "{`"Profile1`": { `"Module1`": [`"1.0`", `"0.1`"], `"Module2`": [`"1.0`", `"0.2`"] }, `"Profile2`": { `"Module1`": [`"2.0`", `"1.0`"], `"Module2`": [`"2.0`"] }}" 

Describe "Get-ProfileCachePath" {
    InModuleScope Az.Bootstrapper {
        Mock Test-Path -Verifiable { $false }
        Mock New-Item -Verifiable {}
        Context "Windows OS Admin" {
            $IsWindows = $true
            $Script:IsAdmin = $true
            It "Should return ProgramData path" {
                $result = Get-ProfileCachePath
                $result | Should Match "(.*)ProfileCache$"
                $result.Contains("ProgramData") | Should Be $true
                Assert-VerifiableMock
            }
        }

        Context "Windows OS Non-Admin" {
            $IsWindows = $true
            $Script:IsAdmin = $false
            It "Should return LOCALAPPDATA path" {
                $result = Get-ProfileCachePath
                $result | Should Match "(.*)ProfileCache$"
                $result.Contains("AppData\Local") | Should Be $true
                Assert-VerifiableMock            
            }            
        }

        Context "Linux OS Admin" {
            $IsWindows = $false
            $Script:IsCoreEdition = $true
            It "Should return .config path" {
                $result = Get-ProfileCachePath
                $result | Should Match "(.*)ProfileCache$"
                $result.Contains(".config") | Should Be $true
                Assert-VerifiableMock
            }
        }

        # Cleanup
        $Script:IsCoreEdition = ($PSVersionTable.PSEdition -eq 'Core')
        $script:IsAdmin = $false
        if ((-not $Script:IsCoreEdition) -or ($IsWindows))
        {
            If (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
            {
                $script:IsAdmin = $true
            }
        }
        else {
            # on Linux, tests run via sudo will generally report "root" for whoami
            if ( (whoami) -match "root" ) 
            {
                $script:IsAdmin = $true
            }
        }
    }
}

Describe "Get-LatestProfileMapPath" {
    InModuleScope Az.Bootstrapper {
        Mock Get-ProfileCachePath -Verifiable { "foo\bar" }

        Context "ProfileCache is empty/no profilemaps available" {
            Mock Get-ChildItem -Verifiable { $null }
            It "Should return null" {
                Get-LatestProfileMapPath | Should be $null
                Assert-VerifiableMock
            }
        }

        context "Largest number did not exist" {
            Mock Get-LargestNumber -Verifiable { $null }
            Mock Get-ChildItem -Verifiable { "foo" }
            It "Should return null" {
                Get-LatestProfileMapPath | Should be $null
                Assert-VerifiableMock
            }
        }

        Context "Two profile maps available at profile cache" {
            $profilemap1 = New-Object -TypeName PSObject 
            $profilemap1 | Add-Member NoteProperty -Name "Name" -Value '123-pmap1.json'
            $profilemap2 = New-Object -TypeName PSObject 
            $profilemap2 | Add-Member NoteProperty -Name "Name" -Value '42-pmap2.json'
            Mock Get-ChildItem -Verifiable { @($profilemap1, $profilemap2)}
            Mock Get-LargestNumber -Verifiable { 123 }
            It "Should return Latest map" {
                Get-LatestProfileMapPath | Should Be $profilemap1
                Assert-VerifiableMock
            }
        }
    }
}

Describe "Get-LargestNumber" {
    InModuleScope Az.BootStrapper {
        Context "Profile cache is empty" {
            Mock Get-ChildItem -Verifiable { }
            It "Should return null" {
                Get-LargestNumber | Should Be $null
            }
        }

        Context "ProfileMaps weren't numbered" {
            $profilemap1 = New-Object -TypeName PSObject 
            $profilemap1 | Add-Member NoteProperty -Name "Name" -Value 'pmap1.json'
            $profilemap2 = New-Object -TypeName PSObject 
            $profilemap2 | Add-Member NoteProperty -Name "Name" -Value 'pmap2.json'
            Mock Get-ChildItem -Verifiable { @($profilemap1, $profilemap2) }
            It "Should return null" {
                Get-LargestNumber | Should Be $null
            }
        }

        Context "Two numbered Profiles were returned" {
            $profilemap1 = New-Object -TypeName PSObject 
            $profilemap1 | Add-Member NoteProperty -Name "Name" -Value '123-pmap1.json'
            $profilemap2 = New-Object -TypeName PSObject 
            $profilemap2 | Add-Member NoteProperty -Name "Name" -Value '456-pmap2.json'
            Mock Get-ChildItem -Verifiable { @($profilemap1, $profilemap2) }
            It "Should return largest number" {
                Get-LargestNumber | Should Be 456
            }
        }
    }
}

Describe "Get-StorageBlob" {
    InModuleScope Az.Bootstrapper {
        Context "Invoke-WebRequest is properly made" {
            $response = New-Object -TypeName psobject
            $response | Add-Member -MemberType NoteProperty -Name "StatusCode" -Value "200"
            $response | Add-Member -MemberType NoteProperty -Name "Content" -Value "ProfileMap json"
            Mock Invoke-CommandWithRetry -Verifiable { $response }
            It "Returns proper response" {
                $result = Get-StorageBlob
                $result.Content | Should Not Be $null
                $result.StatusCode | Should Be "200"
                Assert-VerifiableMock
            }
        }

        Context "Invoke-WebRequest threw exception at all retries" {
            Mock Invoke-CommandWithRetry -Verifiable { throw }
            It "Throws exception" {
                { Get-StorageBlob } | Should throw 
                Assert-VerifiableMock
            }
        }
    }
}

Describe "Get-AzProfileMapFromEndpoint" {
    InModuleScope Az.Bootstrapper {
        $script:LatestProfileMapPath = New-Object -TypeName PSObject
        $script:LatestProfileMapPath | Add-Member NoteProperty -Name "FullName" -Value "C:\mock\123-MockETag.json"
        Mock Get-ProfileCachePath -Verifiable { return "MockPath\ProfileCache"}
        $WebResponse = New-Object -TypeName PSObject 
        $Header = @{"Headers" = @{"ETag" = "MockETag"}}
        $WebResponse | Add-Member $Header
        Mock Get-StorageBlob -Verifiable { return $WebResponse }
        Mock Invoke-CommandWithRetry -Verifiable { ($testProfileMap | ConvertFrom-Json) }

        Context "ProfileCachePath Exists and Etags are equal" {
            Mock Test-Path -Verifiable { $true }
            It "Returns Correct ProfileMap" {
                $result = Get-AzProfileMapFromEndpoint
                $result.Profile1 | Should Not Be Empty
                $result.Profile2 | Should Not Be Empty
                Assert-VerifiableMock
            }
        }

        Context "ProfileCachePath Exists and ETags are different" {
            Mock Out-File -Verifiable {}
            $script:LatestProfileMapPath.FullName =  "123-MockedDifferentETag.json" 
            Mock RetrieveProfileMap -Verifiable {$global:testProfileMap | ConvertFrom-Json}
            Mock Get-LargestNumber -Verifiable {}
            $ProfileMapPath = New-Object -TypeName  PSObject
            $ProfileMapPath | Add-Member NoteProperty 'FullName' -Value '124-MockedDifferentETag.json'
            Mock Get-ChildItem -Verifiable { @($ProfileMapPath)}
            Mock Test-Path -Verifiable { $true }

            It "Returns Correct ProfileMap and removes old profilemap" {
                $result = Get-AzProfileMapFromEndpoint
                $result.Profile1 | Should Not Be Empty
                $result.Profile2 | Should Not Be Empty
                Assert-VerifiableMock
            }
        }

        Context "Get-StorageBlob throws exception" {
            Mock Get-StorageBlob { throw [System.Net.WebException] }
            Mock Test-Path -Verifiable { $true }
            It "Throws Web Exception" {
                { Get-AzProfileMapFromEndpoint } | Should throw 
            }
        }
    }
}

Describe "RetrieveProfileMap" {
    InModuleScope Az.Bootstrapper {
        Context "WebResponse content has extra line breaks" {
            $WebResponse = "{`n`"Profile1`":`t { `"Module1`": [`"1.0`"], `n`"Module2`": [`"1.0`"] }, `"Profile2`": `n{ `"Module1`": [`"2.0`", `"1.0`"],`n `r`"Module2`": `t[`"2.0`"] }}" 
            It "Should return proper profile map" {
                (RetrieveProfileMap -WebResponse $WebResponse) -like ($global:testProfileMap | ConvertFrom-Json) | Should Be $true
            }
        }

        Context "WebResponse content has no extra line breaks" {
            $WebResponse = $global:testProfileMap
            It "Should return proper profile map" {
                (RetrieveProfileMap -WebResponse $WebResponse) -like ($global:testProfileMap | ConvertFrom-Json) | Should Be $true
            }
            
        }
    }
}

Describe "Get-AzProfileMap" {
    InModuleScope Az.Bootstrapper {
        
        Context "Forces update from Azure Endpoint" {
            Mock Get-AzProfileMapFromEndpoint { ($testProfileMap | ConvertFrom-Json) }
            It "Should get ProfileMap from Azure Endpoint" {
                $result = Get-AzProfileMap -Update  
                $result.Profile1 | Should Not Be Empty
                $result.Profile2 | Should Not Be Empty
            }
            It "Checks Mock calls to Get-AzProfileMapFromEndpoint" {
                Assert-MockCalled Get-AzProfileMapFromEndpoint -Exactly 1
            }
        }
        
        Context "Gets Azure ProfileMap from Cache" {
            $script:LatestProfileMapPath = New-Object -TypeName PSObject
            $script:LatestProfileMapPath | Add-Member NoteProperty -Name "FullName" -Value "C:\mock\MockETag.json"
            Mock Invoke-CommandWithRetry -Verifiable { $global:testProfileMap | ConvertFrom-Json }
            Mock Test-Path -Verifiable { $true }
            It "Should get ProfileMap from Cache" {
                $result = Get-AzProfileMap
                $result.Profile1 | Should Not Be Empty
                $result.Profile2 | Should Not Be Empty
                Assert-VerifiableMock
            }
        }

        Context "ProfileMap is not available from cache" {
            Mock Test-Path -Verifiable { $false }
            Mock Invoke-CommandWithRetry -Verifiable { return $global:testProfileMap  | ConvertFrom-Json}
            It "Should get ProfileMap from Embedded source" {
                $result = Get-AzProfileMap
                $result.Profile1 | Should Not Be Empty
                $result.Profile2 | Should Not Be Empty
                Assert-VerifiableMock
            }
        }

        Context "ProfileMap is not available in cache or Embedded source" {
            Mock Test-Path -Verifiable { $false }
            Mock Invoke-CommandWithRetry -Verifiable {}

            It "Should throw FileNotFound Exception" {
                { Get-AzProfileMap } | Should Throw
                Assert-VerifiableMock
            }
        }
    }
}

Describe "Get-ProfilesInstalled" {
    InModuleScope Az.Bootstrapper {
        Context "Valid ProfileMap and Invoke with IncompleteProfiles parameter" {
            # Arrange
            $VersionObj = New-Object -TypeName System.Version -ArgumentList "1.0" 
            $moduleObj = New-Object -TypeName PSObject 
            $moduleObj | Add-Member NoteProperty Version($VersionObj)
            $Script:mockCalled = 0
            $mockTestPath = {
                $Script:mockCalled++
                if ($Script:mockCalled -le 4)
                {
                    return $moduleObj
                }
                else {
                    return $null
                }
            }   

            Mock -CommandName Get-Module -MockWith $mockTestPath

            $IncompleteProfiles = @()
            $expected = @{'Profile1'= @{'Module1' = @('1.0') ;'Module2'= @('1.0')}}
            
            # Act
            $result = (Get-ProfilesInstalled -ProfileMap ($global:testProfileMap | ConvertFrom-Json) ([REF]$IncompleteProfiles))
            
            # Assert
            It "Should return profiles installed" {
                $expected -like $result | Should Be $true
            }
            It "Should return Incomplete profiles" {
                $incompleteprofiles[0] -eq 'Profile2' | Should Be $true
            }
        }

        Context "No profiles Installed and invoke without IncompleteProfiles parameter" {
            Mock Get-Module -Verifiable {}
            It "Should return empty" {
                $result = (Get-ProfilesInstalled -ProfileMap ($global:testProfileMap | ConvertFrom-Json))
                $result.count | Should Be 0
            }
        }
        
        Context "Null ProfileMap" {
            It "Should throw exception" {
                { Get-ProfilesInstalled -ProfileMap $null } | Should Throw
            }
        }
    }    
}

Describe "Test-ProfilesInstalled" {
    InModuleScope Az.Bootstrapper {
        Context "Profile associated with Module version is installed" {
            $AllProfilesInstalled = @{'Module11.0'= @('Profile1', 'Profile2'); 'Module22.0'= @('Profile2')}
            It "Should return ProfilesAssociated" {
                $Result = (Test-ProfilesInstalled -version '1.0' -Module 'Module1' -Profile 'Profile1' -PMap ($global:testProfileMap | ConvertFrom-Json) -AllProfilesInstalled $AllProfilesInstalled)
                $Result[0] | Should Be 'Profile1'
            }
        }

        Context "Profile associated with Module version is not installed" {
                $AllProfilesInstalled = @{'Module11.0'= @('Profile1', 'Profile2')}
                It "Should return empty array" {
                $Result = (Test-ProfilesInstalled -version '1.0' -Module 'Module2' -Profile 'Profile2' -PMap ($global:testProfileMap | ConvertFrom-Json) -AllProfilesInstalled $AllProfilesInstalled)
                $Result.Count | Should Be 0

            }
        }
    }
}

Describe "Uninstall-ModuleHelper" {
    InModuleScope Az.Bootstrapper {
        Mock Remove-Module -Verifiable { }
        Mock Uninstall-Module -Verifiable { }
        Context "Modules are installed" {
            # Arrange
            $VersionObj = New-Object -TypeName System.Version -ArgumentList "1.0" 
            $moduleObj = New-Object -TypeName PSObject 
            $moduleObj | Add-Member NoteProperty Version($VersionObj)
            $Script:mockCalled = 0
            $mockTestPath = {
                $Script:mockCalled++
                if ($Script:mockCalled -eq 1)
                {
                    return $moduleObj
                }
                else {
                    return $null
                }
            }   

            Mock -CommandName Get-Module -MockWith $mockTestPath

            It "Should call Remove-Module and Uninstall-Module" {
                Uninstall-ModuleHelper -Module 'Module1' -Version '1.0' -Profile 'Profile1' -RemovePreviousVersions
                $Script:mockCalled | Should Be 2
                Assert-VerifiableMock
            } 
        }

        Context "Modules are not installed" {
            Mock Get-Module -Verifiable {}
            It "Should not call Remove-Module or Uninstall-Module" {
                Uninstall-ModuleHelper -Module 'Module1' -Version '1.0' -Profile 'Profile1'
                Assert-MockCalled Remove-Module -Exactly 0
                Assert-MockCalled Uninstall-Module -Exactly 0
            }
        }

        Context "Uninstall-Module threw error" {
            # Arrange
            $VersionObj = New-Object -TypeName System.Version -ArgumentList "1.0" 
            $moduleObj = New-Object -TypeName PSObject 
            $moduleObj | Add-Member NoteProperty -Name "Path" -Value "TestPath"
            $moduleObj | Add-Member NoteProperty Version($VersionObj)
            $Script:mockCalled = 0
            $mockTestPath = {
                $Script:mockCalled++
                if ($Script:mockCalled -eq 1)
                {
                    return $moduleObj
                }
                else {
                    return $null
                }
            }   

            Mock -CommandName Get-Module -MockWith $mockTestPath
            Mock Uninstall-Module -Verifiable { throw "No match was found for the specified search criteria and module names" }
            It "Should write error 'custom directory' to error pipeline" {
                Uninstall-ModuleHelper -Module 'Module1' -Version '1.0' -Profile 'Profile1' -RemovePreviousVersions -ErrorVariable ev -ea SilentlyContinue 
                ($null -ne ($ev -match "If you installed the module to a custom directory in your path")) | Should be $true
                $Script:mockCalled | Should Be 1
                Assert-VerifiableMock
            }
        }

        Context "Uninstall-Module threw error MSI Install" {
            # Arrange
            $VersionObj = New-Object -TypeName System.Version -ArgumentList "1.0" 
            $moduleObj = New-Object -TypeName PSObject 
            $moduleObj | Add-Member NoteProperty -Name "Path" -Value "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\PowerShell\"
            $moduleObj | Add-Member NoteProperty Version($VersionObj)
            $Script:mockCalled = 0
            $mockTestPath = {
                $Script:mockCalled++
                if ($Script:mockCalled -eq 1)
                {
                    return $moduleObj
                }
                else {
                    return $null
                }
            }   

            Mock -CommandName Get-Module -MockWith $mockTestPath
            Mock Uninstall-Module -Verifiable { throw "No match was found for the specified search criteria and module names" }
            It "Should write error 'msi' to error pipeline" {
                Uninstall-ModuleHelper -Module 'Module1' -Version '1.0' -Profile 'Profile1' -RemovePreviousVersions -ErrorVariable ev -ea SilentlyContinue 
                ($ev -match "If you installed via an MSI") | Should not be $null
                $Script:mockCalled | Should Be 1
                Assert-VerifiableMock
            } 
        }

        Context "Uninstall-Module threw error In Use" {
            # Arrange
            $VersionObj = New-Object -TypeName System.Version -ArgumentList "1.0" 
            $moduleObj = New-Object -TypeName PSObject 
            $moduleObj | Add-Member NoteProperty -Name "Path" -Value "TestPath"
            $moduleObj | Add-Member NoteProperty Version($VersionObj)
            $Script:mockCalled = 0
            $mockTestPath = {
                $Script:mockCalled++
                if ($Script:mockCalled -eq 1)
                {
                    return $moduleObj
                }
                else {
                    return $null
                }
            }   

            Mock -CommandName Get-Module -MockWith $mockTestPath
            Mock Uninstall-Module -Verifiable { throw "The module is currently in use" }
            It "Should write error 'in use' to error pipeline" {
                Uninstall-ModuleHelper -Module 'Module1' -Version '1.0' -Profile 'Profile1' -RemovePreviousVersions -ErrorVariable ev -ea SilentlyContinue 
                ($ev -match "The module is currently in use") | Should not be $null
                $Script:mockCalled | Should Be 1
                Assert-VerifiableMock
            } 
        }
    }
}

Describe "Uninstall-ProfileHelper" {
    InModuleScope Az.Bootstrapper {
        Mock Get-AllProfilesInstalled -Verifiable {}
        Mock Invoke-UninstallModule -Verifiable {}

        Context "Profile associated with the module is installed" {
            It "Should call Invoke-UninstallModule: With Force param" {
                Uninstall-ProfileHelper -Profile 'Profile1' -PMap ($global:testProfileMap | ConvertFrom-Json) -Force
                Assert-VerifiableMock
                Assert-MockCalled Invoke-UninstallModule -Exactly 4
            }
        }

         Context "Profile associated with the module is installed" {
           It "Should call Invoke-UninstallModule: Without Force param" {
                Uninstall-ProfileHelper -Profile 'Profile1' -PMap ($global:testProfileMap | ConvertFrom-Json) 
                Assert-VerifiableMock
                Assert-MockCalled Invoke-UninstallModule -Exactly 4
            }
        }
    }
}

Describe "Invoke-UninstallModule" {
    InModuleScope Az.Bootstrapper {
        Context "Module not associated with any other profile" {
            Mock Test-ProfilesInstalled -Verifiable { 'profile1'}
            Mock Uninstall-ModuleHelper -Verifiable {}
            It "Should Call Uninstall module helper" {
                Invoke-UninstallModule -PMap ($global:testProfileMap | ConvertFrom-Json) -Profile 'profile1' -module 'module1'
                Assert-VerifiableMock
            }
        }

        Context "Module associated with more than one profile" {
            Mock Test-ProfilesInstalled -Verifiable { @('Profile1', 'Profile2')}
            Mock Uninstall-ModuleHelper {}
            It "Should not invoke Uninstall module helper" {
                Invoke-UninstallModule -PMap ($global:testProfileMap | ConvertFrom-Json) -Profile 'profile1' -module 'module1'
                Assert-MockCalled Uninstall-ModuleHelper -Exactly 0
                Assert-VerifiableMock
            }
        }
    }
}

Describe "Remove-PreviousVersion" {
    InModuleScope Az.Bootstrapper {
        $AllProfilesInstalled = @{}
        Context "Previous versions are installed" {
            $VersionObj = New-Object -TypeName System.Version -ArgumentList "0.1" 
            $moduleObj = New-Object -TypeName PSObject 
            $moduleObj | Add-Member NoteProperty Version($VersionObj)
            Mock Get-Module -Verifiable { $moduleObj}
            Mock Import-Module -Verifiable {}
            Mock Invoke-UninstallModule -Verifiable {}
            It "Should call Invoke-UninstallModule" {
                Remove-PreviousVersion -Profile 'Profile1' -LatestMap ($global:testProfileMap|ConvertFrom-Json) 
                Assert-VerifiableMock
            }

            It "Invoke with Module parameter: Should call Invoke-UninstallModule" {
                Remove-PreviousVersion -Profile 'Profile1' -Module 'Module1' -LatestMap ($global:testProfileMap|ConvertFrom-Json) 
                Assert-VerifiableMock                
            }
        }

        Context "Previous versions are not installed" {
            Mock Get-Module -Verifiable {}
            Mock Import-Module -Verifiable {}
            Mock Invoke-UninstallModule {}
            It "Should not call Invoke-UninstallModule" {
                Remove-PreviousVersion -Profile 'Profile1' -LatestMap ($global:testProfileMap|ConvertFrom-Json)
                Assert-VerifiableMock
                Assert-MockCalled Invoke-UninstallModule -Exactly 0
            }
        }

        Context "No previous versions" {
            Mock Get-Module -Verifiable {}
            Mock Invoke-UninstallModule -Verifiable {}
            Mock Import-Module -Verifiable {}
            It "Should not call Invoke-UninstallModule" {
                Remove-PreviousVersion -Profile 'Profile2' -module 'Module2' -LatestMap ($global:testProfileMap|ConvertFrom-Json)
                Assert-MockCalled Get-Module -Exactly 0
                Assert-MockCalled Invoke-UninstallModule -Exactly 0
            }
        }

        Context "Previous version is same as the latest version" {
            Mock Get-Module -Verifiable {}
            Mock Invoke-UninstallModule -Verifiable {}
            Mock Import-Module -Verifiable {}
            It "Should not call Invoke-UninstallModule" {
                Remove-PreviousVersion -Profile 'Profile2' -module 'Module2' -LatestMap ($global:testProfileMap|ConvertFrom-Json)
                Assert-MockCalled Get-Module -Exactly 0
                Assert-MockCalled Invoke-UninstallModule -Exactly 0
                Assert-MockCalled Import-Module -Times 1
            }
        }
    }
}

Describe "Get-AllProfilesInstalled" {
    InModuleScope Az.Bootstrapper {
        Mock Invoke-CommandWithRetry { $global:testProfileMap | ConvertFrom-Json }
        Context "Profile Maps are available from cache" {
            Mock Get-ProfilesInstalled -Verifiable { @{'Profile1'= @{'Module1'= '1.0'}}}
            $expectedResult = @{"Module21.0"=@('Profile1'); "Module11.0"=@('Profile1')}
            It "Should return Modules & Profiles Installed" {
                (Get-AllProfilesInstalled) -like $expectedResult | Should Be $true
                Assert-MockCalled Invoke-CommandWithRetry -Exactly 1
                Assert-MockCalled Get-ProfilesInstalled -exactly 1
                Assert-VerifiableMock
            }
        }

        Context "Profiles are not installed" {
            Mock Get-ProfilesInstalled -Verifiable {}
            
            It "Should return empty" {
                $AllProfilesInstalled = @()
                $result = (Get-AllProfilesInstalled)
                $result.Count | Should Be 0
                Assert-MockCalled Invoke-CommandWithRetry -Exactly 1
                Assert-MockCalled Get-ProfilesInstalled -exactly 1
                Assert-VerifiableMock
            }      
        }
        
        Context "Cache is empty" {
            $script:LatestProfileMapPath = $null
            Mock Get-Item -Verifiable {}
            Mock Get-ProfilesInstalled {}
            It "Should return empty" {
                $result = (Get-AllProfilesInstalled)
                $result.Count | Should Be 0
                Assert-MockCalled Invoke-CommandWithRetry -Exactly 1
                Assert-MockCalled Get-ProfilesInstalled -exactly 1
                Assert-VerifiableMock
            }

            # Cleanup
            $script:LatestProfileMapPath = Get-LatestProfileMapPath
        }
    }
}

Describe "Update-ProfileHelper" {
    InModuleScope Az.Bootstrapper {
        Mock Invoke-CommandWithRetry -Verifiable { $global:testProfileMap } 
        $script:LatestProfileMapPath = New-Object -TypeName PSObject
        $script:LatestProfileMapPath | Add-Member NoteProperty -Name "FullName" -Value "C:\mock\MockETag.json"
        Mock Get-AllProfilesInstalled -Verifiable {}
        Mock Remove-PreviousVersion -Verifiable {}

        Context "Previous Versions were present" {
            It "Should invoke Remove-PreviousVersion" {
                Update-ProfileHelper -profile 'Profile1'
                Assert-VerifiableMock
            }
            
            It "Invoke with -Module param: Should invoke Remove-PreviousVerison" {
                Update-ProfileHelper -profile 'Profile1' -Module 'Module1' -RemovePreviousVersions
                Assert-VerifiableMock
            }
        }
    }
}

Describe "Find-PotentialConflict" {
    InModuleScope Az.Bootstrapper {
        Context "Modules are installed in other scope" {
            $script:IsAdmin = $true
            $moduleobj = New-Object -TypeName PSObject
            $moduleobj | Add-Member NoteProperty -Name "Path" -Value $Env:HOMEPATH
            Mock Get-Module -Verifiable { $moduleobj}
            It "Should return false, because force is present" {
                (Find-PotentialConflict -Module 'Module1' -Force) | Should Be $false
            }
        }

        Context "Modules are not installed in other scope" {
            $script:IsAdmin = $false
            $moduleobj = New-Object -TypeName PSObject
            $moduleobj | Add-Member NoteProperty -Name "Path" -Value $Env:HOMEPATH
            Mock Get-Module -Verifiable { $moduleobj}
            It "Should return false, no conflict" {
                (Find-PotentialConflict -Module 'Module1') | Should Be $false
            }
        }

        Context "Modules were not installed before" {
            Mock Get-Module -Verifiable { $null }
            It "Should return false, no conflict" {
                Find-PotentialConflict -Module 'Module1' | Should Be $false
            }
        }
    }
}

Describe "Invoke-InstallModule" {
    InModuleScope Az.Bootstrapper {
        Context "Install-Module has AllowClobber param" {
            $cmd = New-Object -TypeName PSObject 
            $cmd | Add-Member -MemberType NoteProperty -Name "Parameters" -Value @{"AllowClobber" = $true }
            Mock Get-Command -Verifiable { $cmd }
            
           <# It "Should invoke install-module with AllowClobber: No Scope" {
                Mock Install-Module -Verifiable {} 
                Invoke-InstallModule -module "Module1" -version "1.0"
                Assert-VerifiableMock
            }

            It "Should invoke install-module with AllowClobber: CurrentUser Scope" {
                Mock Install-Module -Verifiable -ParameterFilter { $Scope -eq "CurrentUser"} {}
                Invoke-InstallModule -module "Module1" -version "1.0" -scope "CurrentUser" 
                Assert-VerifiableMock
            } #>
        }

        Context "Install-Module doesn not have AllowClobber" {
            $cmd = New-Object -TypeName PSObject 
            $cmd | Add-Member -MemberType NoteProperty -Name "Parameters" -Value @{}
            Mock Get-Command -Verifiable { $cmd }
            It "Should invoke install-module with Force: No Scope" {
                Mock Install-Module -Verifiable -ParameterFilter { '$Force'} {}
                Invoke-InstallModule -module "Module1" -version "1.0"
                Assert-VerifiableMock
            }

            It "Should invoke install-module with Force: CurrentUser Scope" {
                Mock Install-Module -Verifiable -ParameterFilter { '$Force' -and ($Scope -eq "CurrentUser")} {}
                Invoke-InstallModule -module "Module1" -version "1.0" -scope "CurrentUser" 
                Assert-VerifiableMock
            }
        }
    }
}

Describe "Invoke-CommandWithRetry" {
    InModuleScope Az.Bootstrapper {
        $scriptBlock = {
           Get-ChildItem -ErrorAction Stop
        }

        Context "Executes script block successfully at first attempt" {
            Mock Get-ChildItem -Verifiable { "contents" }
            It "Should return successfully" {
                $result = Invoke-CommandWithRetry -scriptBlock $scriptBlock
                $result | Should Be "contents"
                Assert-VerifiableMock
            }
        }

        Context "Executes script successfully at one of the retries" {
            $Script:mockCalled = 0
            $mockTestPath = {
                $Script:mockCalled++
                if ($Script:mockCalled -eq 1)
                {
                    throw
                }
                else {
                    return "contents"
                }
            }   

            Mock -CommandName Get-ChildItem -MockWith $mockTestPath
            Mock Start-Sleep -Verifiable {}

            It "Should return successfully" {
                $result = Invoke-CommandWithRetry -scriptBlock $scriptBlock
                $result | Should Be "contents"
                Assert-MockCalled Get-ChildItem -Times 2
                Assert-VerifiableMock
            }
        }

        Context "Fails to execute script during all retries" {
            Mock Get-ChildItem -Verifiable { throw }
            Mock Start-Sleep -Verifiable {}
            It "Throws exception" {
                { Invoke-CommandWithRetry -scriptBlock $scriptBlock } | Should throw
            }
        }
    }   
}

Describe "Select-Profile" {
    InModuleScope Az.Bootstrapper {
        Mock Test-Path -Verifiable { $true }
        Context "Scope AllUsers with Admin rights" {
            $script:IsAdmin = $true
            It "Should return AllUsersAllHosts profile" {
                Select-Profile -scope "AllUsers" | Should Be $profile.AllUsersAllHosts 
                Assert-VerifiableMock
            }
        }

        Context "Scope CurrentUser" {
            It "Should return CurrentUserAllHosts profile" {
                Select-Profile -scope "CurrentUser" | Should Be $profile.CurrentUserAllHosts 
                Assert-VerifiableMock
            }
        }

        Context "Scope AllUsers no admin rights" {
            $script:IsAdmin = $false
            It "Should throw for admin rights" {
                { Select-Profile -scope "AllUsers" } | Should throw
            }
        }

        Context "ProfilePath does not exist" {
            $script:IsAdmin = $false
            Mock Test-Path -Verifiable { $false }
            Mock New-Item -Verifiable {}
            It "Should create a new file for profile" {
                Select-Profile -scope "CurrentUser" | Should Be $profile.CurrentUserAllHosts 
                Assert-VerifiableMock
            }
        }
    }
}

Describe "Get-LatestModuleVersion" {
    InModuleScope Az.Bootstrapper {
        Context "Returns latest version in a version array" {
            $versionarray = @("2.0", "1.5", "1.0")
            It "Should return the latest version" {
                $result = Get-LatestModuleVersion -versions $versionarray
                $result | Should Be "2.0"
            }
        }
    }
}

Describe "Get-ModuleVersion" {
    InModuleScope Az.Bootstrapper {
        Mock Get-AzProfileMap -Verifiable { $testProfileMap | ConvertFrom-Json }
        Mock Get-LatestModuleVersion -Verifiable { "2.0" }
        Context "Gets module version" {
            $RollupModule = "Azure.Module1"
            It "Should return script block" {
                Get-ModuleVersion -armProfile "Profile1" -invocationLine "ipmo ${RollupModule}" | Should Be "2.0"
                Assert-VerifiableMock
            }
        }
    }
}

Describe "Get-ScriptBlock" {
    InModuleScope Az.Bootstrapper {
        Context "Creates a script block" {
            It "Should return script block" {
                $result = Get-ScriptBlock -ProfilePath "Profilepath"
                $result[1].contains("Import-Module:RequiredVersion") | Should Be $true
                Assert-VerifiableMock
            }
        }
    }
}

Describe "Remove-ProfileSetting" {
    InModuleScope Az.Bootstrapper {
        Mock Set-Content -Verifiable {}

        Context "Profile contents had bootstrapper scripts" {
            $contents = @"
Temp Line 1
##BEGIN Az.Bootstrapper scripts
Temp Line 2
Temp Line 3
##END Az.Bootstrapper scripts
Temp Line 4
"@
            Mock Get-Content -Verifiable { $contents }
            It "Should return lines 1 and 4" {
                Remove-ProfileSetting -profilePath "testpath"
                Assert-VerifiableMock
            }
        }
    }
}

Describe "Add-ScopeParam" {
    InModuleScope Az.Bootstrapper {
        $params = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

        It "Should return Scope parameter object" {
            (Add-ScopeParam $params)
            $params.ContainsKey("Scope") | Should Be $true
        }
    }
}

Describe "Add-ProfileParam" {
    InModuleScope Az.Bootstrapper {
        $params = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
        Mock Get-AzProfileMap -Verifiable { ($global:testProfileMap | ConvertFrom-Json) }

        It "Should return Profile parameter object" {
            (Add-ProfileParam $params)
            $params.ContainsKey("Profile") | Should Be $true
            Assert-VerifiableMock
        }
    }
}

Describe "Add-ForceParam" {
    InModuleScope Az.Bootstrapper {
        $params = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
        
        It "Should return Force parameter object" {
            Add-ForceParam $params
            $params.ContainsKey("Force") | Should Be $true
        }
    }
}

Describe "Add-RemoveParam" {
    InModuleScope Az.Bootstrapper {
        $params = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary

        It "Should return RemovePreviousVersions parameter object" {
            (Add-RemoveParam $params)
            $params.ContainsKey("RemovePreviousVersions") | Should Be $true
        }
    }
}

Describe "Add-SwitchParam" {
    InModuleScope Az.Bootstrapper {
        $params = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
        
        It "Should return Switch parameter object" {
            Add-SwitchParam $params "TestParam"
            $params.ContainsKey("TestParam") | Should Be $true
        }
    }
}

Describe "Add-ModuleParam" {
    InModuleScope Az.Bootstrapper {
        
        Context "ProfileMap has more than one profile" {
            $params = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
           Mock Get-AzProfileMap -Verifiable { ($global:testProfileMap | ConvertFrom-Json) }
            It "Should return Module parameter object" {
                (Add-ModuleParam $params)
                $params.ContainsKey("Module") | Should Be $true
                Assert-VerifiableMock
            }
        }

        Context "ProfileMap has one profile" {
            $params = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
            Mock Get-AzProfileMap -Verifiable { ("{`"Profile1`": { `"Module1`": [`"1.0`", `"0.1`"], `"Module2`": [`"1.0`", `"0.2`"] }}" ) | ConvertFrom-Json }
            It "Should return Module parameter object" {
                (Add-ModuleParam $params)
                $params.ContainsKey("Module") | Should Be $true
                Assert-VerifiableMock
            }
        }
    }

}

Describe "Get-AzModule" {
    InModuleScope Az.Bootstrapper {
        Mock Get-AzProfileMap -Verifiable { ($global:testProfileMap | ConvertFrom-Json) }
        
        Context "Module is installed" {
           Mock Get-Module -Verifiable { @( [PSCustomObject] @{ Name='Module1'; Version='1.0'; RepositorySourceLocation='foo\bar' }, [PSCustomObject] @{ Name='Module1'; Version='2.0'}) }
           It "Should return installed version" {
                Get-AzModule -Profile 'Profile1' -Module 'Module1' | Should Be "1.0"
                Assert-VerifiableMock
            }
        }
        
        Context "Module is not installed" {
            Mock Get-Module -Verifiable {}
            It "Should return null" {
                Get-AzModule -Profile 'Profile1' -Module 'Module1' | Should be $null
                Assert-VerifiableMock
            }
        }

        Context "Module not in the list" {
            Mock Get-Module -Verifiable { @( [PSCustomObject] @{ Name='Module1'; Version='1.0'; RepositorySourceLocation='foo\bar' }, [PSCustomObject] @{ Name='Module1'; Version='2.0'}) }
            It "Should return null" {
                Get-AzModule -Profile 'Profile2' -Module 'Module2' | Should be $null
                Assert-VerifiableMock
            }
        }

        Context "Invoke with invalid parameters" {
            It "Should throw" {
                { Get-AzModule -Profile 'XYZ' -Module 'ABC' } | Should Throw
            }
        }

        Context "Invoke with null parameters" {
            It "Should throw" {
                { Get-AzModule -Profile $null -Module $null } | Should Throw
            }
        }

        Context "ProfileMap has one profile" {
            $params = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
            Mock Get-AzProfileMap -Verifiable { ("{`"Profile1`": { `"Module1`": [`"1.0`", `"0.1`"], `"Module2`": [`"1.0`", `"0.2`"] }}" ) | ConvertFrom-Json }
            Mock Get-Module -Verifiable { @( [PSCustomObject] @{ Name='Module1'; Version='1.0'; RepositorySourceLocation='foo\bar' }, [PSCustomObject] @{ Name='Module1'; Version='2.0'}) }
            It "Should return installed version" {
                Get-AzModule -Profile 'Profile1' -Module 'Module1' | Should Be "1.0"
                Assert-VerifiableMock
            }
        }
    }
}

Describe "Get-AzApiProfile" {
    InModuleScope Az.Bootstrapper {
        Mock Get-AzProfileMap -Verifiable { ($global:testProfileMap | ConvertFrom-Json) }

        Context "With ListAvailable Switch" {
            It "Should return available profiles" {
                $Result = (Get-AzApiProfile -ListAvailable)
                $Result.Count | Should be 2
                $Result.ProfileName | Should Not Be $null
                $Result.Module1 | Should Not Be $null
                Assert-VerifiableMock
            }
        }

        Context "With ListAvailable and update Switches" {
            It "Should return available profiles" {
                $Result = (Get-AzApiProfile -ListAvailable -Update)
                $Result.Count | Should be 2
                $Result.ProfileName | Should Not Be $null
                $Result.Module1 | Should Not Be $null
                Assert-VerifiableMock
            }
        }

        Context "Without ListAvailable Switch" {
            $IncompleteProfiles = @('Profile2')
            Mock Get-ProfilesInstalled -Verifiable -ParameterFilter {[REF]$IncompleteProfiles} { @{'Profile1'= @{'Module1' = @('1.0') ;'Module2'= @('1.0')}} } 
            It "Returns installed Profile" {
                $Result = (Get-AzApiProfile)
                $Result.ProfileName | Should Not Be $null
                $Result.Module1 | Should Not Be $null
                Assert-VerifiableMock
            }
        }

        Context "No profiles installed" {
            Mock Get-ProfilesInstalled -Verifiable {}
            It "Returns null" {
                (Get-AzApiProfile) | Should Be $null
                Assert-VerifiableMock
            }
        }
    }
}

Describe "Use-AzProfile" {
    InModuleScope Az.Bootstrapper {
        $RollupModule = 'Module1'
        Mock Get-AzProfileMap -Verifiable { ($global:testProfileMap | ConvertFrom-Json) }
        Mock Install-Module { "Installing module..."}
        Mock Import-Module -Verifiable { "Importing Module..."}
        Mock Find-PotentialConflict {}
        Context "Modules not installed" {
            Mock Get-AzModule -Verifiable {} -ParameterFilter {$Profile -eq "Profile1" -and $Module -eq "Module1"}
            It "Should install modules" {
                $Result = (Use-AzProfile -Profile 'Profile1' -Force)
                $Result.Length | Should Be 3 # Includes "Loading module" 
                $Result[1] | Should Be "Installing module..."
                $Result[2] | Should Be "Importing Module..."
                Assert-VerifiableMock
            }

            It "Invoke with Module param: Should install modules" {
                $Result = (Use-AzProfile -Profile 'Profile1' -Module 'Module1' -Force)
                $Result.Length | Should Be 3
                $Result[1] | Should Be "Installing module..."
                $Result[2] | Should Be "Importing Module..."
                Assert-VerifiableMock
            }
        }

        Context "Modules are installed" {
            $RollupModule = "None"
            Mock Get-AzModule -Verifiable { "1.0" } -ParameterFilter {$Profile -eq "Profile1" -and $Module -eq "Module1"}
            Mock Get-AzModule -Verifiable { "1.0" } -ParameterFilter {$Profile -eq "Profile1" -and $Module -eq "Module2"}
            Mock Import-Module { "Module1 1.0 Imported"} -ParameterFilter { $Name -eq "Module1" -and $RequiredVersion -eq "1.0"}
            Mock Import-Module { "Module2 1.0 Imported"} -ParameterFilter { $Name -eq "Module2" -and $RequiredVersion -eq "1.0"}
            It "Should skip installing modules, imports the right version module" {
                $Result = (Use-AzProfile -Profile 'Profile1' -Force) 
                $Result.length | Should Be 3
                $Result[1] | Should Be "Module1 1.0 Imported"
                Assert-MockCalled Install-Module -Exactly 0
                Assert-MockCalled Import-Module -Exactly 2
                Assert-VerifiableMock
            }

            It "Invoke with Module param: Should skip installing modules, imports the right version module" {
                $Result = (Use-AzProfile -Profile 'Profile1' -Module 'Module1', 'Module2' -Force) 
                $Result.length | Should Be 3
                $Result[1] | Should Be "Module1 1.0 Imported"
                Assert-MockCalled Install-Module -Exactly 0
                Assert-VerifiableMock
                
            }
        }
        Context "Invoke with invalid profile" {
            It "Should throw" {
                { Use-AzProfile -Profile 'WrongProfileName'} | Should Throw
            }
        }

        Context "Invoke with $null profile" {
            It "Should throw" {
                { Use-AzProfile -Profile $null} | Should Throw
            }
        }

        Context "Invoke with Scope as CurrentUser" {
            Mock Get-AzModule -Verifiable {} -ParameterFilter {$Profile -eq "Profile1" -and $Module -eq "Module1"}
            Mock Install-Module -Verifiable {} -ParameterFilter { $Scope -eq "CurrentUser"}
            It "Should invoke Install-ModuleHelper with scope currentuser" {
                (Use-AzProfile -Profile 'Profile1' -Force -scope CurrentUser)
                Assert-VerifiableMock
            }
        }
        
        Context "Invoke with Scope as AllUsers" {
            Mock Get-AzModule -Verifiable {} -ParameterFilter {$Profile -eq "Profile1" -and $Module -eq "Module1"}
            Mock Install-Module -Verifiable {} -ParameterFilter { $Scope -eq "AllUsers"}
            It "Should invoke Install-ModuleHelper with scope AllUsers" {
                (Use-AzProfile -Profile 'Profile1' -Force -scope AllUsers)
                Assert-VerifiableMock
            }
        }

        Context "Invoke with invalide module name" {
            It "Should throw" {
                { Use-AzProfile -Profile 'Profile1' -Module 'MockModule'} | Should Throw
            }            
        }

        Context "Potential Conflict found" {
            Mock Find-PotentialConflict -Verifiable { $true }
            It "Should skip installing module" {
                $Result = (Use-AzProfile -Profile 'Profile1' -Force)
                $Result.Contains("Installing module...") | Should Be $false
                Assert-VerifiableMock
            }
        }

        Context "Other versions of the same module found imported" {
            Mock Get-AzModule -Verifiable { "1.0" } 
            $VersionObj = New-Object -TypeName System.Version -ArgumentList "2.0" 
            $moduleObj = New-Object -TypeName PSObject 
            $moduleObj | Add-Member NoteProperty -Name "Name" -Value "Module1"
            $moduleObj | Add-Member NoteProperty Version($VersionObj)
            Mock Get-Module -Verifiable { $moduleObj }
            It "Should skip importing module" {
                $result = Use-AzProfile -Profile 'Profile1' -ErrorVariable useError -ErrorAction SilentlyContinue
                $useError.exception.message.contains("A different profile version of module") | Should Be $true
            }
        }

        # User tries to execute Use-AzProfile with different profiles & different modules
        Context "A different profile's module was previously imported" {
            Mock Get-AzModule -Verifiable { "1.0" } 
            $VersionObj = New-Object -TypeName System.Version -ArgumentList "2.0" 
            $moduleObj = New-Object -TypeName PSObject 
            $moduleObj | Add-Member NoteProperty -Name "Name" -Value "Module1"
            $moduleObj | Add-Member NoteProperty Version($VersionObj)
            Mock Get-Module -Verifiable { $moduleObj }
            It "Should skip importing module" {
                $result = Use-AzProfile -Profile 'Profile1' -Module 'Module1' -ErrorVariable useError -ErrorAction SilentlyContinue
                $useError.exception.message.contains("A different profile version of module") | Should Be $true
            }
        }

        # User has module2 from profile1 imported; tries to execute Use-AzProfile for profile1 with module1. Should import.
        Context "A different module from same profile was previously imported" {
            Mock Get-AzModule -Verifiable { "1.0" } 
            $VersionObj = New-Object -TypeName System.Version -ArgumentList "1.0" 
            $moduleObj = New-Object -TypeName PSObject 
            $moduleObj | Add-Member NoteProperty -Name "Name" -Value "Module2"
            $moduleObj | Add-Member NoteProperty Version($VersionObj)
            Mock Get-Module -Verifiable { $moduleObj }
            It "Should import module" {
                $result = Use-AzProfile -Profile 'Profile1' -Module 'Module1' 
                Assert-MockCalled Import-Module -Times 1
            }
        }
    }
}

Describe "Install-AzProfile" {
    InModuleScope Az.Bootstrapper {
        Mock Get-AzProfileMap -Verifiable { ($global:testProfileMap | ConvertFrom-Json) }
        Mock Get-AzModule -Verifiable {} -ParameterFilter { $Profile -eq 'Profile1' -and $Module -eq 'Module1'}
        Mock Get-AzModule -Verifiable { "1.0"} -ParameterFilter { $Profile -eq 'Profile1' -and $Module -eq 'Module2'}
        Mock Find-PotentialConflict -Verifiable { $false }
        
        Context "Invoke with valid profile name" {
            Mock Invoke-InstallModule -Verifiable { "Installing module Module1... Version 1.0"} 
            It "Should install Module1" {
                (Install-AzProfile -Profile 'Profile1') | Should be "Installing module Module1... Version 1.0"
                Assert-VerifiableMock
          }
        }

        Context "Invoke with invalid profile name" {
            It "Should throw" {
                { Install-AzProfile -Profile 'WrongProfileName'} | Should Throw
            }
        }

        Context "Invoke with null profile name" {
            It "Should throw" {
                { Install-AzProfile -Profile $null } | Should Throw
            }
        }

        Context "Invoke with Scope as CurrentUser" {
            Mock Get-AzModule -Verifiable {} -ParameterFilter {$Profile -eq "Profile1" -and $Module -eq "Module1"}
            Mock Invoke-InstallModule -Verifiable {} -ParameterFilter { $Scope -eq "CurrentUser"}
            It "Should invoke Install-ModuleHelper with scope currentuser" {
                (Install-AzProfile -Profile 'Profile1' -scope CurrentUser)
                Assert-VerifiableMock
            }
        }
        
        Context "Invoke with Scope as AllUsers" {
            Mock Get-AzModule -Verifiable {} -ParameterFilter {$Profile -eq "Profile1" -and $Module -eq "Module1"}
            Mock Invoke-InstallModule -Verifiable {} -ParameterFilter { $Scope -eq "AllUsers"}
            It "Should invoke Install-ModuleHelper with scope AllUsers" {
                (Install-AzProfile -Profile 'Profile1' -scope AllUsers)
                Assert-VerifiableMock
            }
        }

        Context "Potential Conflict found" {
            Mock Find-PotentialConflict -Verifiable { $true }
            Mock Invoke-InstallModule {}
            It "Should skip installing module" {
                Install-AzProfile -Profile 'Profile1'
                Assert-MockCalled Invoke-InstallModule -Exactly 0
                Assert-VerifiableMock
            }
        }

    }
}

Describe "Uninstall-AzProfile" {
    InModuleScope Az.Bootstrapper {
        Mock Get-AzProfileMap -Verifiable { ($global:testProfileMap | ConvertFrom-Json) }
        Mock Uninstall-ProfileHelper -Verifiable {}
        Context "Valid profile name" {
            It "Should invoke Uninstall-ProfileHelper" {
                Uninstall-AzProfile -Profile 'Profile1' -Force
                Assert-VerifiableMock
            }
        }

        Context "Invoke with invalid profile name" {
            It "Should throw" {
                { Uninstall-AzProfile -Profile 'WrongProfileName' } | Should Throw
            }
        }

        Context "Invoke with null profile name" {
            It "Should throw" {
                { Uninstall-AzProfile -Profile $null } | Should Throw
            }
        }
    }
}

Describe "Update-AzProfile" {
    InModuleScope Az.Bootstrapper {
        # Arrange
        Mock Get-AzProfileMap -Verifiable { ($global:testProfileMap | ConvertFrom-Json) }
        Mock Get-AzProfileMap -Verifiable -ParameterFilter { $Update.IsPresent } { ($global:testProfileMap | ConvertFrom-Json) }
        
        Context "Proper profile with '-RemovePreviousVersions' and '-Force' params" {
            Mock Use-AzProfile -Verifiable {} -ParameterFilter { ($Force.IsPresent)}
            Mock Update-ProfileHelper -Verifiable {}
    
            It "Imports profile modules and invokes Update-ProfileHelper" {
                Update-AzProfile -Profile 'Profile2' -RemovePreviousVersions -Force
                Assert-VerifiableMock
            }

            It "Invoke with Module param: Imports profile modules and invokes Update-ProfileHelper" {
                Update-AzProfile -Profile 'Profile2' -module 'Module1' -RemovePreviousVersions -Force
                Assert-VerifiableMock
            }
        }

        Context "Invoke with invalid profile name" {
            It "Should throw" {
                { Update-AzProfile -Profile 'WrongProfileName'} | Should Throw
            }
        }

        Context "Invoke with null profile name" {
            It "Should throw" {
                { Update-AzProfile -Profile $null } | Should Throw
            }
        }

        Context "Invoke with Scope as CurrentUser" {
            Mock Use-AzProfile -Verifiable {} -ParameterFilter { ($Force.IsPresent) -and {$Scope -like 'CurrentUser'}}
            Mock Update-ProfileHelper -Verifiable {}
            It "Should invoke Use-AzProfile with scope currentuser" {
                (Update-AzProfile -Profile 'Profile1' -scope CurrentUser -Force -r)
                Assert-VerifiableMock
            }
        }
        
        Context "Invoke with Scope as AllUsers" {
            Mock Use-AzProfile -Verifiable {} -ParameterFilter { ($Force.IsPresent) -and {$Scope -like 'CurrentUser'}}
            Mock Update-ProfileHelper -Verifiable {}
            It "Should invoke Use-AzProfile with scope AllUsers" {
                (Update-AzProfile -Profile 'Profile1' -scope AllUsers -Force -r)
                Assert-VerifiableMock
            }
        }
            
        Context "Invoke with invalid module name" {
            It "Should throw" {
                { Update-AzProfile -Profile 'Profile1' -module 'MockModule' } | Should Throw
            }
        }

        # Cleanup
        if (Test-Path '.\MockPath')
        {
            Remove-Item -Path '.\MockPath' -Force -Recurse
        }
    }
}

Describe "Set-BootstrapRepo" {
    InModuleScope Az.Bootstrapper {
        Context "Repo name is given" {
            # Arrange
            $currentBootstrapRepo = $script:BootStrapRepo
            It "Should set given repo as BootstrapRepo" {
                Set-BootstrapRepo -Repo "MockName"
                $script:BootStrapRepo | Should Be "MockName"
            }

            # Cleanup
            $script:BootStrapRepo = $currentBootstrapRepo
        }

        Context "Alias name is given" {
            # Arrange
            $currentBootstrapRepo = $script:BootStrapRepo
            It "Should set given repo alias parameter value as BootstrapRepo" {
                Set-BootstrapRepo -Name "MockName"
                $script:BootStrapRepo | Should Be "MockName"
            }

            # Cleanup
            $script:BootStrapRepo = $currentBootstrapRepo
        }
    }
}

Describe "Set-AzDefaultProfile" {
    InModuleScope Az.Bootstrapper {
        $sb = {
            if ($MyInvocation.Line.Contains("Module1")) { "1.0"}
        }
        Mock Get-ScriptBlock -Verifiable { $sb }
        Mock Invoke-CommandWithRetry -Verifiable {}
        Mock Select-Profile -verifiable {}
        Mock Remove-ProfileSetting -Verifiable {}
        Mock Get-AzProfileMap -Verifiable { ($global:testProfileMap | ConvertFrom-Json) }

        Context "New default profile value is given" {
            It "Setting default profile succeeds" {
                $Global:PSDefaultParameterValues.Remove("*-AzProfile:Profile")
                Set-AzDefaultProfile -Profile "Profile1" -Force
                $Global:PSDefaultParameterValues["*-AzProfile:Profile"] | Should Be "Profile1"
                Assert-VerifiableMock
            }
        }

        Context "User wants to update default profile value" {
            It "Should update default profile value" {
                $Global:PSDefaultParameterValues.Remove("*-AzProfile:Profile")
                Set-AzDefaultProfile -Profile "Profile2" -Force
                $Global:PSDefaultParameterValues["*-AzProfile:Profile"] | Should Be "Profile2"
                Assert-VerifiableMock
            }
        }

        Context "Removing old default profile vaule throws" {
            Mock Invoke-CommandWithRetry -Verifiable { throw }
            It "Should throw for updating default profile" {
                $Global:PSDefaultParameterValues.Remove("*-AzProfile:Profile")
                { Set-AzDefaultProfile -Profile "Profile1" -Force } | Should throw
                Assert-VerifiableMock
            }
        }

        Context "Set Default Profile with scope as AllUsers in admin shell" {
            $script:IsAdmin = $true
            Mock Select-Profile -Verifiable { "AllUsersProfile"}
            It "Should succeed setting AllUsers Profile" {
                $Global:PSDefaultParameterValues.Remove("*-AzProfile:Profile")
                Set-AzDefaultProfile -Profile "Profile1" -Scope "AllUsers" -Force
                $Global:PSDefaultParameterValues["*-AzProfile:Profile"] | Should Be "Profile1"
                Assert-VerifiableMock
            }
        }

        Context "Set Default Profile with scope as AllUsers in non-admin shell" {
            $script:IsAdmin = $false
            Mock Select-Profile -Verifiable { throw }
            It "Should throw for AllUsers Profile" {
                $Global:PSDefaultParameterValues.Remove("*-AzProfile:Profile")
                { Set-AzDefaultProfile -Profile "Profile2" -Scope "AllUsers" -Force } | Should throw
                Assert-VerifiableMock
            }
        }

        Context "Set a Default Profile twice" {
            It "Should not edit profile content twice" {
                $Global:PSDefaultParameterValues.Remove("*-AzProfile:Profile")
                Set-AzDefaultProfile -Profile "Profile1" -Force 
                Set-AzDefaultProfile -Profile "Profile1" -Force 
                Assert-MockCalled Invoke-CommandWithRetry -Exactly 1
                Assert-VerifiableMock
            }
        }
    }
}

Describe "Remove-AzDefaultProfile" {
    InModuleScope Az.Bootstrapper {
        Mock Remove-Module -Verifiable {}
        Mock Remove-ProfileSetting -Verifiable {}
        Mock Test-Path -Verifiable { $true }
        Mock Get-Module -Verifiable { "Az" }

        Context "Default profile presents in the profile file & default variable" {
            It "Should successfully remove default profile from shell & profile file" {
                Remove-AzDefaultProfile -Force
                $Global:PSDefaultParameterValues["*-AzProfile:Profile"] | Should Be $null
                Assert-VerifiableMock
            }
        }
        
        Context "Default profile is not set previously or was removed" {
            It "Should return null for default profile" {
                Remove-AzDefaultProfile -Force
                $Global:PSDefaultParameterValues["*-AzProfile:Profile"] | Should Be $null
                Assert-VerifiableMock
            }
        }

        Context "Profile files do not exist" {
            Mock Test-Path -Verifiable { $false }
            It "Should not invoke remove script" {
                Remove-AzDefaultProfile -Force
                Assert-MockCalled Remove-ProfileSetting -Exactly 0
            }
        }

        Context "Remove default profile in admin mode" {
            Mock Remove-Module -verifiable {}
            $Script:IsAdmin = $true
            It "Should remove setting in AllUsersAllHosts and CurrentUserAllHosts profiles" {
                Remove-AzDefaultProfile -Force
                # For Admin, two profile paths are tested 
                Assert-MockCalled Test-Path -Exactly 2
            }
        }

        Context "Remove default profile in non-admin mode" {
            Mock Remove-Module -verifiable {}
            $Script:IsAdmin = $false
            Mock Invoke-CommandWithRetry -Verifiable {}
            It "Should remove setting in CurrentUserAllHosts profile" {
                Remove-AzDefaultProfile -Force
                Assert-MockCalled Test-Path -Exactly 1
            }
        }
    }    
}
# SIG # Begin signature block
# MIIjigYJKoZIhvcNAQcCoIIjezCCI3cCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDntfI07p81zkiR
# OGYcqq28x1v0mcHArbjPmWv694Q9JqCCDYUwggYDMIID66ADAgECAhMzAAAB4HFz
# JMpcmPgZAAAAAAHgMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjAxMjE1MjEzMTQ2WhcNMjExMjAyMjEzMTQ2WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDRXpc9eiGRI/2BlmU7OMiQPTKpNlluodjT2rltPO/Gk47bH4gBShPMD4BX/4sg
# NvvBun6ZOG2dxUW30myWoUJJ0iRbTAv2JFzjSpVQvPE+D5vtmdu6WlOR2ahF4leF
# 5Vvk4lPg2ZFrqg5LNwT9gjwuYgmih+G2KwT8NMWusBhO649F4Ku6B6QgA+vZld5S
# G2XWIdvS0pmpmn/HFrV4eYTsl9HYgjn/bPsAlfWolLlEXYTaCljK7q7bQHDBrzlR
# ukyyryFpPOR9Wx1cxFJ6KBqg2jlJpzxjN3udNJPOqarnQIVgB8DUm3I5g2v5xTHK
# Ovz9ucN21467cYcIxjPC4UkDAgMBAAGjggGCMIIBfjAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUVBWIZHrG4UIX3uX4142l+8GsPXAw
# VAYDVR0RBE0wS6RJMEcxLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJh
# dGlvbnMgTGltaXRlZDEWMBQGA1UEBRMNMjMwMDEyKzQ2MzAxMDAfBgNVHSMEGDAW
# gBRIbmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDEx
# XzIwMTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIB
# AE5msNzmYzYbNgpnhya6YsrM+CIC8CXDu10nwzZtkgQciPOOqAYmFcWJCwD5VZzs
# qFwad8XIOrfCylWf4hzn09mD87yuazpuCstLSqfDLNd3740+254vEZqdGxOglAGU
# ih2IiF8S0GDwucpLGzt/OLXPFr/d4MWxPuX0L+HB5lA3Y/CJE673dHGQW2DELdqt
# ohtkhp+oWFn1hNDDZ3LP++HEZvA7sI/o/981Sh4kaGayOp6oEiQuGeCXyfrIC9KX
# eew0UlYX/NHVDqr4ykKkqpHtzbUbuo7qovUHPbYKcRGWrrEtBS5SPLFPumqsRtzb
# LgU9HqfRAN36bMsd2qynGyWBVFOM7NMs2lTCGM85Z/Fdzv/8tnYT36Cmbue+IM+6
# kS86j6Ztmx0VIFWbOvNsASPT6yrmYiecJiP6H0TrYXQK5B3jE8s53l+t61ab0Eul
# 7DAxNWX3lAiUlzKs3qZYQEK1LFvgbdTXtBRnHgBdABALK3RPrieIYqPln9sAmg3/
# zJZi4C/c2cWGF6WwK/w1Nzw08pj7jaaZZVBpCeDe+y7oM26QIXxracot7zJ21/TL
# 70biK36YybSUDkjhQPP/uxT0yebLNBKk7g8V98Wna2MsHWwk0sgqpkjIp02TrkVz
# 26tcF2rml2THRSDrwpBa4x9c8rM8Qomiyeh2tEJnsx2LMIIHejCCBWKgAwIBAgIK
# YQ6Q0gAAAAAAAzANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlm
# aWNhdGUgQXV0aG9yaXR5IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEw
# OTA5WjB+MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYD
# VQQDEx9NaWNyb3NvZnQgQ29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG
# 9w0BAQEFAAOCAg8AMIICCgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+la
# UKq4BjgaBEm6f8MMHt03a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc
# 6Whe0t+bU7IKLMOv2akrrnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4D
# dato88tt8zpcoRb0RrrgOGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+
# lD3v++MrWhAfTVYoonpy4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nk
# kDstrjNYxbc+/jLTswM9sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6
# A4aN91/w0FK/jJSHvMAhdCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmd
# X4jiJV3TIUs+UsS1Vz8kA/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL
# 5zmhD+kjSbwYuER8ReTBw3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zd
# sGbiwZeBe+3W7UvnSSmnEyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3
# T8HhhUSJxAlMxdSlQy90lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS
# 4NaIjAsCAwEAAaOCAe0wggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRI
# bmTlUAXTgqoXNzcitW2oynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTAL
# BgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBD
# uRQFTuHqp8cx0SOJNDBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jv
# c29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFf
# MDNfMjIuY3JsMF4GCCsGAQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFf
# MDNfMjIuY3J0MIGfBgNVHSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEF
# BQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1h
# cnljcHMuaHRtMEAGCCsGAQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkA
# YwB5AF8AcwB0AGEAdABlAG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn
# 8oalmOBUeRou09h0ZyKbC5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7
# v0epo/Np22O/IjWll11lhJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0b
# pdS1HXeUOeLpZMlEPXh6I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/
# KmtYSWMfCWluWpiW5IP0wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvy
# CInWH8MyGOLwxS3OW560STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBp
# mLJZiWhub6e3dMNABQamASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJi
# hsMdYzaXht/a8/jyFqGaJ+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYb
# BL7fQccOKO7eZS/sl/ahXJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbS
# oqKfenoi+kiVH6v7RyOA9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sL
# gOppO6/8MO0ETI7f33VtY5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtX
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCFVswghVXAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAAHgcXMkylyY+BkAAAAA
# AeAwDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIE1+
# 8o0OqZX+R0KRC9T7+CeV0gh8HF6IoxfaoGF0OLRfMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAWYMbmfV/WCWtIgj1o6GJcqyKbhbHPh1180Gx
# noMoYr3mykIZosnUJTwm8Lq254jwKTM1AmlntB+hHXt51nV1JJc7a2HLM+8j5V7B
# KFFZvjxA4dIggdxn5uVCCRQ13rfzMcThijKnd4hLm2UxcvmbBtgvuxH3yYCuGvg4
# lCp4qHgE6RObe6dkMxuagHN+8PwiZW0VqSDNTW/jzJhAxwr9kJVPWpssMlsBKVcV
# wc4A1vRudV8nnjBtnb2SWvQQ8kXRywj7vLHvM133jMxoKc2jTRpMl86v899BB4YM
# bZhsQ3ca2hlUlJbYnUdKmuY685K+EVIAUBAtsnPniklERQprLKGCEuUwghLhBgor
# BgEEAYI3AwMBMYIS0TCCEs0GCSqGSIb3DQEHAqCCEr4wghK6AgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFRBgsqhkiG9w0BCRABBKCCAUAEggE8MIIBOAIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCA8w1uu73f8zAL5946aPRXW2J8IzFtNCXIz
# CzitkYv8OgIGYNEUVI+1GBMyMDIxMDYyMjE3MTc0My4wMDVaMASAAgH0oIHQpIHN
# MIHKMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQL
# ExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMSYwJAYDVQQLEx1UaGFsZXMg
# VFNTIEVTTjo4QTgyLUUzNEYtOUREQTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgU2VydmljZaCCDjwwggTxMIID2aADAgECAhMzAAABS0+ypkjV5MJRAAAA
# AAFLMA0GCSqGSIb3DQEBCwUAMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEw
# MB4XDTIwMTExMjE4MjU1OVoXDTIyMDIxMTE4MjU1OVowgcoxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVy
# aWNhIE9wZXJhdGlvbnMxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNOOjhBODItRTM0
# Ri05RERBMSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNlMIIB
# IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAoTZ6UMd2Lia/4r6Gz6C7aUPX
# oFBZfEx3VmekgCiCXbT9y9uA9/3et6Jppo2Ywsq0Jvo/9bRwwMI0BrjsGL5+/XnD
# wkHwAfdSZxKf8D+ATBdkl8jH/JPUfOEbYSHXxhz101qs6QgnzVqJVRHFFZvAHf69
# S64pETvuCiqOrJQ0CSrICgKXwVP/Se0bnb4cNaxEMNDZNQURlo6yKe/7lqFCH0eK
# 3JelNbrTomCKJwvOzz6QCUFxkbA3Sp1RReDaVrzIsnrpLJ+bfzrcM/NrBpZ3vxzU
# KZjM4oEfHGfHlxAySTSGcaL/VgBx49vIFBNvQ/IrwE+9Ooocb07+dGWPFudbsQID
# AQABo4IBGzCCARcwHQYDVR0OBBYEFFKqan7QEpbnuity3j5U059NSuvGMB8GA1Ud
# IwQYMBaAFNVjOlyKMZDzQ3t8RhvFM2hahW1VMFYGA1UdHwRPME0wS6BJoEeGRWh0
# dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1RpbVN0
# YVBDQV8yMDEwLTA3LTAxLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUHMAKG
# Pmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljVGltU3RhUENB
# XzIwMTAtMDctMDEuY3J0MAwGA1UdEwEB/wQCMAAwEwYDVR0lBAwwCgYIKwYBBQUH
# AwgwDQYJKoZIhvcNAQELBQADggEBABbaudWXPztQHySuLRAdja/GxhFQ+akPJfIF
# yEDKzGWLXXRx/nBoqoBf+Bpr5j35eRQGIfoH//GHd6uP4g9viuC7SW7P97+pqcgZ
# dZkOL7rCuuXQMqVpok9VtxYl47JgiJI0gw7CixQWB+chhZzRThDIC/ju7uKLB+Nn
# /NJ3NlnZ2Vevjr1tN+Vz1embbVAXxVh3SG1JHThtTtp+MiZtdDn2nCLWdPH84DDK
# hPn/0k4FVjQh20dhGKk1msqxj+vYzMLVQ/QRhk1rYtV46bxOsinTvB/Z7kYty/gu
# o2J7X2hJgU250xRFfpEcdQjXKUm/aLPOggFHoWVNWkc0OgkP6Y8wggZxMIIEWaAD
# AgECAgphCYEqAAAAAAACMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBD
# ZXJ0aWZpY2F0ZSBBdXRob3JpdHkgMjAxMDAeFw0xMDA3MDEyMTM2NTVaFw0yNTA3
# MDEyMTQ2NTVaMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
# DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24x
# JjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMIIBIjANBgkq
# hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqR0NvHcRijog7PwTl/X6f2mUa3RUENWl
# CgCChfvtfGhLLF/Fw+Vhwna3PmYrW/AVUycEMR9BGxqVHc4JE458YTBZsTBED/Fg
# iIRUQwzXTbg4CLNC3ZOs1nMwVyaCo0UN0Or1R4HNvyRgMlhgRvJYR4YyhB50YWeR
# X4FUsc+TTJLBxKZd0WETbijGGvmGgLvfYfxGwScdJGcSchohiq9LZIlQYrFd/Xcf
# PfBXday9ikJNQFHRD5wGPmd/9WbAA5ZEfu/QS/1u5ZrKsajyeioKMfDaTgaRtogI
# Neh4HLDpmc085y9Euqf03GS9pAHBIAmTeM38vMDJRF1eFpwBBU8iTQIDAQABo4IB
# 5jCCAeIwEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFNVjOlyKMZDzQ3t8RhvF
# M2hahW1VMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1UdDwQEAwIBhjAP
# BgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFNX2VsuP6KJcYmjRPZSQW9fOmhjE
# MFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kv
# Y3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNybDBaBggrBgEF
# BQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9w
# a2kvY2VydHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3J0MIGgBgNVHSABAf8E
# gZUwgZIwgY8GCSsGAQQBgjcuAzCBgTA9BggrBgEFBQcCARYxaHR0cDovL3d3dy5t
# aWNyb3NvZnQuY29tL1BLSS9kb2NzL0NQUy9kZWZhdWx0Lmh0bTBABggrBgEFBQcC
# AjA0HjIgHQBMAGUAZwBhAGwAXwBQAG8AbABpAGMAeQBfAFMAdABhAHQAZQBtAGUA
# bgB0AC4gHTANBgkqhkiG9w0BAQsFAAOCAgEAB+aIUQ3ixuCYP4FxAz2do6Ehb7Pr
# psz1Mb7PBeKp/vpXbRkws8LFZslq3/Xn8Hi9x6ieJeP5vO1rVFcIK1GCRBL7uVOM
# zPRgEop2zEBAQZvcXBf/XPleFzWYJFZLdO9CEMivv3/Gf/I3fVo/HPKZeUqRUgCv
# OA8X9S95gWXZqbVr5MfO9sp6AG9LMEQkIjzP7QOllo9ZKby2/QThcJ8ySif9Va8v
# /rbljjO7Yl+a21dA6fHOmWaQjP9qYn/dxUoLkSbiOewZSnFjnXshbcOco6I8+n99
# lmqQeKZt0uGc+R38ONiU9MalCpaGpL2eGq4EQoO4tYCbIjggtSXlZOz39L9+Y1kl
# D3ouOVd2onGqBooPiRa6YacRy5rYDkeagMXQzafQ732D8OE7cQnfXXSYIghh2rBQ
# Hm+98eEA3+cxB6STOvdlR3jo+KhIq/fecn5ha293qYHLpwmsObvsxsvYgrRyzR30
# uIUBHoD7G4kqVDmyW9rIDVWZeodzOwjmmC3qjeAzLhIp9cAvVCch98isTtoouLGp
# 25ayp0Kiyc8ZQU3ghvkqmqMRZjDTu3QyS99je/WZii8bxyGvWbWu3EQ8l1Bx16HS
# xVXjad5XwdHeMMD9zOZN+w2/XU/pnR4ZOC+8z1gFLu8NoFA12u8JJxzVs341Hgi6
# 2jbb01+P3nSISRKhggLOMIICNwIBATCB+KGB0KSBzTCByjELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJp
# Y2EgT3BlcmF0aW9uczEmMCQGA1UECxMdVGhhbGVzIFRTUyBFU046OEE4Mi1FMzRG
# LTlEREExJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2WiIwoB
# ATAHBgUrDgMCGgMVAJE6M/e37Hh8TTlEkOTv2wVUhfnuoIGDMIGApH4wfDELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9z
# b2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwDQYJKoZIhvcNAQEFBQACBQDkfDuPMCIY
# DzIwMjEwNjIyMTgzNTU5WhgPMjAyMTA2MjMxODM1NTlaMHcwPQYKKwYBBAGEWQoE
# ATEvMC0wCgIFAOR8O48CAQAwCgIBAAICBxECAf8wBwIBAAICEV0wCgIFAOR9jQ8C
# AQAwNgYKKwYBBAGEWQoEAjEoMCYwDAYKKwYBBAGEWQoDAqAKMAgCAQACAwehIKEK
# MAgCAQACAwGGoDANBgkqhkiG9w0BAQUFAAOBgQCBP/sYpltdTdT3H9TSNZZTnq2b
# uQ9BCUe4RbsHRmpxFXmfmAZZ/guX/oRJJ+6hlYgwlH4AdGh8upfrPtjPEgOz7xZd
# uWV0zZkafVsP25xqG14Zoc68ADAgQIPC2491wt0iWq2U7uAJxO2MYd9srjuF8sQR
# cIQG0yfT24EIZoALUjGCAw0wggMJAgEBMIGTMHwxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFBDQSAyMDEwAhMzAAABS0+ypkjV5MJRAAAAAAFLMA0GCWCGSAFlAwQCAQUAoIIB
# SjAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQwLwYJKoZIhvcNAQkEMSIEIJP7
# AG7HuKRwSWQpZY3mnzxhS668n9F+0WoyC5s93TxmMIH6BgsqhkiG9w0BCRACLzGB
# 6jCB5zCB5DCBvQQga/buhCJ57GWBLbPxY/6yBb9GGVtcp4Vyjj9oVT1FOSMwgZgw
# gYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYD
# VQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAUtPsqZI1eTC
# UQAAAAABSzAiBCCrPkl9sZi4ukRHzaCUUS+5dbKApVoq74y323PsK5fxtDANBgkq
# hkiG9w0BAQsFAASCAQCVGXAFKU8OjLn8/B8t+HuMIJl/Wa+eWoYdKTOlnMVAVt8k
# UMapfJeFdm0tR7MMUBzjhJV7qNwLQ/OFIJkOkx+rt3RyI5rRcNlNi3JJt1G+SM3M
# 6GOuxBn/A/W2Xaz71GKM2PvoeMoEji6TQbySxCu/gnHfZttqlXnmhW4Cu5ectG1P
# NgMnjMONIMTqADiTWfJssjVZ7hM32jZj+3mO2PpB/uepVfOt3gb97OG/LaN1umXO
# L9QaaydChvlc9SOc6/s/XqngEYlDEeoPDozRDRmp0CQgNMb17ucCQb2AEzz3xTh8
# Nmk1C3l8Js6UFD0yTF7oASKyGM/hsFCMSoTmibop
# SIG # End signature block
