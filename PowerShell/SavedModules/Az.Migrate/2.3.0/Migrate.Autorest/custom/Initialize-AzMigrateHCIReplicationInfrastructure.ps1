
# ----------------------------------------------------------------------------------
#
# Copyright Microsoft Corporation
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ----------------------------------------------------------------------------------

<#
.Synopsis
Initializes the infrastructure for the migrate project.
.Description
The Initialize-AzMigrateHCIReplicationInfrastructure cmdlet initializes the infrastructure for the migrate project in AzStackHCI scenario.
.Link
https://learn.microsoft.com/powershell/module/az.migrate/initialize-azmigratehcireplicationinfrastructure
#>

function Initialize-AzMigrateHCIReplicationInfrastructure {
    [OutputType([System.Boolean], ParameterSetName = 'AzStackHCI')]
    [CmdletBinding(DefaultParameterSetName = 'AzStackHCI', PositionalBinding = $false, SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the Resource Group of the Azure Migrate Project in the current subscription.
        ${ResourceGroupName},

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the name of the Azure Migrate project to be used for server migration.
        ${ProjectName},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the Storage Account ARM Id to be used for private endpoint scenario.
        ${CacheStorageAccountId},

        [Parameter()]
        [System.String]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Runtime.DefaultInfo(Script = '(Get-AzContext).Subscription.Id')]
        # Azure Subscription ID.
        ${SubscriptionId},

        [Parameter(Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the source appliance name for the AzStackHCI scenario.
        ${SourceApplianceName},

        [Parameter(Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the target appliance name for the AzStackHCI scenario.
        ${TargetApplianceName},

        [Parameter()]
        [Alias('AzureRMContext', 'AzureCredential')]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Returns true when the command succeeds
        ${PassThru},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
    )

    process {
        Import-Module $PSScriptRoot\Helper\AzStackHCICommonSettings.ps1
        Import-Module $PSScriptRoot\Helper\CommonHelper.ps1

        CheckResourcesModuleDependency
        CheckStorageModuleDependency
        Import-Module Az.Resources
        Import-Module Az.Storage

        $context = Get-AzContext
        # Get SubscriptionId
        if ([string]::IsNullOrEmpty($SubscriptionId)) {
            Write-Host "No -SubscriptionId provided. Using the one from Get-AzContext."

            $SubscriptionId = $context.Subscription.Id
            if ([string]::IsNullOrEmpty($SubscriptionId)) {
                throw "Please login to Azure to select a subscription."
            }
        }
        Write-Host "*Selected Subscription Id: '$($SubscriptionId)'."
    
        # Get resource group
        $resourceGroup = Get-AzResourceGroup -Name $ResourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue
        if ($null -eq $resourceGroup) {
            throw "Resource group '$($ResourceGroupName)' does not exist in the subscription. Please create the resource group and try again."
        }
        Write-Host "*Selected Resource Group: '$($ResourceGroupName)'."

        # Verify user validity
        $userObject = Get-AzADUser -UserPrincipalName $context.Subscription.ExtendedProperties.Account

        if (-not $userObject) {
            $userObject = Get-AzADUser -Mail $context.Subscription.ExtendedProperties.Account
        }

        if (-not $userObject) {
            $mailNickname = "{0}#EXT#" -f $($context.Account.Id -replace '@', '_')

            $userObject = Get-AzADUser | 
            Where-Object { $_.MailNickname -eq $mailNickname }
        }

        if (-not $userObject) {
            $userObject = Get-AzADServicePrincipal -ApplicationID $context.Account.Id
        }

        if (-not $userObject) {
            throw 'User Object Id Not Found!'
        }

        # Get Migrate Project
        $migrateProject = Az.Migrate\Get-AzMigrateProject `
            -Name $ProjectName `
            -ResourceGroupName $ResourceGroupName `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($null -eq $migrateProject) {
            throw "Migrate project '$($ProjectName)' not found."
        }

        # Access Discovery Service
        $discoverySolutionName = "Servers-Discovery-ServerDiscovery"
        $discoverySolution = Az.Migrate\Get-AzMigrateSolution `
            -SubscriptionId $SubscriptionId `
            -ResourceGroupName $ResourceGroupName `
            -MigrateProjectName $ProjectName `
            -Name $discoverySolutionName `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($discoverySolution.Name -ne $discoverySolutionName) {
            throw "Server Discovery Solution not found."
        }

        # Get Appliances Mapping
        $appMap = @{}
        if ($null -ne $discoverySolution.DetailExtendedDetail["applianceNameToSiteIdMapV2"]) {
            $appMapV2 = $discoverySolution.DetailExtendedDetail["applianceNameToSiteIdMapV2"] | ConvertFrom-Json
            # Fetch all appliance from V2 map first. Then these can be updated if found again in V3 map.
            foreach ($item in $appMapV2) {
                $appMap[$item.ApplianceName.ToLower()] = $item.SiteId
            }
        }
    
        if ($null -ne $discoverySolution.DetailExtendedDetail["applianceNameToSiteIdMapV3"]) {
            $appMapV3 = $discoverySolution.DetailExtendedDetail["applianceNameToSiteIdMapV3"] | ConvertFrom-Json
            foreach ($item in $appMapV3) {
                $t = $item.psobject.properties
                $appMap[$t.Name.ToLower()] = $t.Value.SiteId
            }
        }

        if ($null -eq $discoverySolution.DetailExtendedDetail["applianceNameToSiteIdMapV2"] -And
            $null -eq $discoverySolution.DetailExtendedDetail["applianceNameToSiteIdMapV3"] ) {
            throw "Server Discovery Solution missing Appliance Details. Invalid Solution."           
        }

        $hyperVSiteTypeRegex = "(?<=/Microsoft.OffAzure/HyperVSites/).*$"
        $vmwareSiteTypeRegex = "(?<=/Microsoft.OffAzure/VMwareSites/).*$"

        # Validate SourceApplianceName & TargetApplianceName
        $sourceSiteId = $appMap[$SourceApplianceName.ToLower()]
        $targetSiteId = $appMap[$TargetApplianceName.ToLower()]
        if ($sourceSiteId -match $hyperVSiteTypeRegex -and $targetSiteId -match $hyperVSiteTypeRegex) {
            $instanceType = $AzStackHCIInstanceTypes.HyperVToAzStackHCI
        }
        elseif ($sourceSiteId -match $vmwareSiteTypeRegex -and $targetSiteId -match $hyperVSiteTypeRegex) {
            $instanceType = $AzStackHCIInstanceTypes.VMwareToAzStackHCI
        }
        else {
            throw "Error encountered in matching the given source appliance name '$SourceApplianceName' and target appliance name '$TargetApplianceName'. Please verify the VM site type to be either for HyperV or VMware for both source and target appliances, and the appliance names are correct."
        }

        # Get Data Replication Service, or the AMH solution
        $amhSolution = Az.Migrate\Get-AzMigrateSolution `
            -ResourceGroupName $ResourceGroupName `
            -MigrateProjectName $ProjectName `
            -Name "Servers-Migration-ServerMigration_DataReplication" `
            -SubscriptionId $SubscriptionId `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($null -eq $amhSolution) {
            throw "No Data Replication Service Solution found. Please verify your appliance setup."
        }

        # Get Source and Target Fabrics
        $allFabrics = Az.Migrate\Get-AzMigrateHCIReplicationFabric -ResourceGroupName $ResourceGroupName
        foreach ($fabric in $allFabrics) {
            if ($fabric.Property.CustomProperty.MigrationSolutionId -ne $amhSolution.Id) {
                continue
            }

            if (($instanceType -eq $AzStackHCIInstanceTypes.HyperVToAzStackHCI) -and
                ($fabric.Property.CustomProperty.InstanceType -ceq $FabricInstanceTypes.HyperVInstance)) {
                $sourceFabric = $fabric
            }
            elseif (($instanceType -eq $AzStackHCIInstanceTypes.VMwareToAzStackHCI) -and
                ($fabric.Property.CustomProperty.InstanceType -ceq $FabricInstanceTypes.VMwareInstance)) {
                $sourceFabric = $fabric
            }
            elseif ($fabric.Property.CustomProperty.InstanceType -ceq $FabricInstanceTypes.AzStackHCIInstance) {
                $targetFabric = $fabric
            }

            if (($null -ne $sourceFabric) -and ($null -ne $targetFabric)) {
                break
            }
        }

        if ($null -eq $sourceFabric) {
            throw "Source Fabric not found. Please verify your appliance setup."
        }
        Write-Host "*Selected Source Fabric: '$($sourceFabric.Name)'."

        if ($null -eq $targetFabric) {
            throw "Target Fabric not found. Please verify your appliance setup."
        }
        Write-Host "*Selected Target Fabric: '$($targetFabric.Name)'."

        # Get Source and Target Dras from Fabrics
        $sourceDras = Az.Migrate.Internal\Get-AzMigrateDra `
            -FabricName $sourceFabric.Name `
            -ResourceGroupName $ResourceGroupName `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($null -eq $sourceDras) {
            throw "Source Dra found. Please verify your appliance setup."
        }
        $sourceDra = $sourceDras[0]
        Write-Host "*Selected Source Dra: '$($sourceDra.Name)'."

        $targetDras = Az.Migrate.Internal\Get-AzMigrateDra `
            -FabricName $targetFabric.Name `
            -ResourceGroupName $ResourceGroupName `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($null -eq $targetDras) {
            throw "Source Dra found. Please verify your appliance setup."
        }
        $targetDra = $targetDras[0]
        Write-Host "*Selected Target Dra: '$($targetDra.Name)'."
        
        # Get Replication Vault
        $replicationVaultName = $amhSolution.DetailExtendedDetail["vaultId"].Split("/")[8]
        $replicationVault = Az.Migrate.Internal\Get-AzMigrateVault `
            -ResourceGroupName $ResourceGroupName `
            -Name $replicationVaultName
        if ($null -eq $replicationVault) {
            throw "No Replication Vault found in Resource Group '$($ResourceGroupName)'."
        }

        # Put Policy
        $policyName = $replicationVault.Name + $instanceType + "policy"
        $policy = Az.Migrate.Internal\Get-AzMigratePolicy `
            -ResourceGroupName $ResourceGroupName `
            -Name $policyName `
            -VaultName $replicationVault.Name `
            -SubscriptionId $SubscriptionId `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        
        # Default policy is found
        if ($null -ne $policy) {
            # Give time for create/update to reach a terminal state. Timeout after 10min
            if ($policy.Property.ProvisioningState -eq [ProvisioningState]::Creating -or
                $policy.Property.ProvisioningState -eq [ProvisioningState]::Updating) {
                Write-Host "Policy '$($policyName)' found in Provisioning State '$($policy.Property.ProvisioningState)'."

                for ($i = 0; $i -lt 20; $i++) {
                    Start-Sleep -Seconds 30
                    $policy = Az.Migrate.Internal\Get-AzMigratePolicy -InputObject $policy

                    if (-not (
                            $policy.Property.ProvisioningState -eq [ProvisioningState]::Creating -or
                            $policy.Property.ProvisioningState -eq [ProvisioningState]::Updating)) {
                        break
                    }
                }

                # Make sure Policy is no longer in Creating or Updating state
                if ($policy.Property.ProvisioningState -eq [ProvisioningState]::Creating -or
                    $policy.Property.ProvisioningState -eq [ProvisioningState]::Updating) {
                    throw "Policy '$($policyName)' times out with Provisioning State: '$($policy.Property.ProvisioningState)'. Please re-run this command or contact support if help needed."
                }
            }

            # Check and remove if policy is in a bad terminal state
            if ($policy.Property.ProvisioningState -eq [ProvisioningState]::Canceled -or
                $policy.Property.ProvisioningState -eq [ProvisioningState]::Failed) {
                Write-Host "Policy '$($policyName)' found but in an unusable terminal Provisioning State '$($policy.Property.ProvisioningState)'.`nRemoving policy..."
                    
                # Remove policy
                try {
                    Az.Migrate.Internal\Remove-AzMigratePolicy -InputObject $policy | Out-Null
                }
                catch {
                    if ($_.Exception.Message -notmatch "Status: OK") {
                        throw $_.Exception.Message
                    }
                }

                Start-Sleep -Seconds 30
                $policy = Az.Migrate.Internal\Get-AzMigratePolicy `
                    -InputObject $policy `
                    -ErrorVariable notPresent `
                    -ErrorAction SilentlyContinue

                # Make sure Policy is no longer in Canceled or Failed state
                if ($null -ne $policy -and
                    ($policy.Property.ProvisioningState -eq [ProvisioningState]::Canceled -or
                    $policy.Property.ProvisioningState -eq [ProvisioningState]::Failed)) {
                    throw "Failed to change the Provisioning State of policy '$($policyName)'by removing. Please re-run this command or contact support if help needed."
                }
            }

            # Give time to remove policy. Timeout after 10min
            if ($null -eq $policy -and $policy.Property.ProvisioningState -eq [ProvisioningState]::Deleting) {
                Write-Host "Policy '$($policyName)' found in Provisioning State '$($policy.Property.ProvisioningState)'."

                for ($i = 0; $i -lt 20; $i++) {
                    Start-Sleep -Seconds 30
                    $policy = Az.Migrate.Internal\Get-AzMigratePolicy `
                        -InputObject $policy `
                        -ErrorVariable notPresent `
                        -ErrorAction SilentlyContinue
                    
                    if ($null -eq $policy -or $policy.Property.ProvisioningState -eq [ProvisioningState]::Deleted) {
                        break
                    }
                    elseif ($policy.Property.ProvisioningState -eq [ProvisioningState]::Deleting) {
                        continue
                    }

                    throw "Policy '$($policyName)' has an unexpected Provisioning State of '$($policy.Property.ProvisioningState)' during removal process. Please re-run this command or contact support if help needed."
                }

                # Make sure Policy is no longer in Deleting state
                if ($null -ne $policy -and $policy.Property.ProvisioningState -eq [ProvisioningState]::Deleting) {
                    throw "Policy '$($policyName)' times out with Provisioning State: '$($policy.Property.ProvisioningState)'. Please re-run this command or contact support if help needed."
                }
            }

            # Indicate policy was removed
            if ($null -eq $policy -or $policy.Property.ProvisioningState -eq [ProvisioningState]::Deleted) {
                Write-Host "Policy '$($policyName)' was removed."
            }
        }

        # Refresh local policy object if exists
        if ($null -ne $policy) {
            $policy = Az.Migrate.Internal\Get-AzMigratePolicy -InputObject $policy
        }

        # Create policy if not found or previously deleted
        if ($null -eq $policy -or $policy.Property.ProvisioningState -eq [ProvisioningState]::Deleted) {
            Write-Host "Creating Policy..."

            $params = @{
                InstanceType                     = $instanceType;
                RecoveryPointHistoryInMinute     = $ReplicationDetails.PolicyDetails.DefaultRecoveryPointHistoryInMinutes;
                CrashConsistentFrequencyInMinute = $ReplicationDetails.PolicyDetails.DefaultCrashConsistentFrequencyInMinutes;
                AppConsistentFrequencyInMinute   = $ReplicationDetails.PolicyDetails.DefaultAppConsistentFrequencyInMinutes;
            }

            # Setup Policy deployment parameters
            $policyProperties = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api20210216Preview.PolicyModelProperties]::new()
            if ($instanceType -eq $AzStackHCIInstanceTypes.HyperVToAzStackHCI) {
                $policyCustomProperties = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api20210216Preview.HyperVToAzStackHcipolicyModelCustomProperties]::new()
            }
            elseif ($instanceType -eq $AzStackHCIInstanceTypes.VMwareToAzStackHCI) {
                $policyCustomProperties = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api20210216Preview.VMwareToAzStackHcipolicyModelCustomProperties]::new()
            }
            else {
                throw "Instance type '$($instanceType)' is not supported. Currently, for AzStackHCI scenario, only HyperV and VMware as the source is supported."
            }
            $policyCustomProperties.InstanceType = $params.InstanceType
            $policyCustomProperties.RecoveryPointHistoryInMinute = $params.RecoveryPointHistoryInMinute
            $policyCustomProperties.CrashConsistentFrequencyInMinute = $params.CrashConsistentFrequencyInMinute
            $policyCustomProperties.AppConsistentFrequencyInMinute = $params.AppConsistentFrequencyInMinute
            $policyProperties.CustomProperty = $policyCustomProperties
        
            try {
                Az.Migrate.Internal\New-AzMigratePolicy `
                    -Name $policyName `
                    -ResourceGroupName $ResourceGroupName `
                    -VaultName $replicationVaultName `
                    -Property $policyProperties `
                    -SubscriptionId $SubscriptionId `
                    -NoWait | Out-Null
            }
            catch {
                if ($_.Exception.Message -notmatch "Status: OK") {
                    throw $_.Exception.Message
                }
            }

            # Check Policy creation status every 30s. Timeout after 10min
            for ($i = 0; $i -lt 20; $i++) {
                Start-Sleep -Seconds 30
                $policy = Az.Migrate.Internal\Get-AzMigratePolicy `
                    -ResourceGroupName $ResourceGroupName `
                    -Name $policyName `
                    -VaultName $replicationVault.Name `
                    -SubscriptionId $SubscriptionId `
                    -ErrorVariable notPresent `
                    -ErrorAction SilentlyContinue
                if ($null -eq $policy) {
                    throw "Unexpected error occurred during policy creation. Please re-run this command or contact support if help needed."
                }
                
                # Stop if policy reaches a terminal state
                if ($policy.Property.ProvisioningState -eq [ProvisioningState]::Succeeded -or
                    $policy.Property.ProvisioningState -eq [ProvisioningState]::Deleted -or
                    $policy.Property.ProvisioningState -eq [ProvisioningState]::Canceled -or
                    $policy.Property.ProvisioningState -eq [ProvisioningState]::Failed) {
                    break
                }
            }

            # Make sure Policy is in a terminal state
            if (-not (
                    $policy.Property.ProvisioningState -eq [ProvisioningState]::Succeeded -or
                    $policy.Property.ProvisioningState -eq [ProvisioningState]::Deleted -or
                    $policy.Property.ProvisioningState -eq [ProvisioningState]::Canceled -or
                    $policy.Property.ProvisioningState -eq [ProvisioningState]::Failed)) {
                throw "Policy '$($policyName)' times out with Provisioning State: '$($policy.Property.ProvisioningState)' during creation process. Please re-run this command or contact support if help needed."
            }
        }
        
        if ($policy.Property.ProvisioningState -ne [ProvisioningState]::Succeeded) {
            throw "Policy '$($policyName)' has an unexpected Provisioning State of '$($policy.Property.ProvisioningState)'. Please re-run this command or contact support if help needed."
        }

        $policy = Az.Migrate.Internal\Get-AzMigratePolicy `
            -ResourceGroupName $ResourceGroupName `
            -Name $policyName `
            -VaultName $replicationVault.Name `
            -SubscriptionId $SubscriptionId `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($null -eq $policy) {
            throw "Unexpected error occurred during policy creation. Please re-run this command or contact support if help needed."
        }
        elseif ($policy.Property.ProvisioningState -ne [ProvisioningState]::Succeeded) {
            throw "Policy '$($policyName)' has an unexpected Provisioning State of '$($policy.Property.ProvisioningState)'. Please re-run this command or contact support if help needed."
        }
        else {
            Write-Host "*Selected Policy: '$($policyName)'."
        }

        # Put Cache Storage Account
        $amhSolution = Az.Migrate\Get-AzMigrateSolution `
            -ResourceGroupName $ResourceGroupName `
            -MigrateProjectName $ProjectName `
            -Name "Servers-Migration-ServerMigration_DataReplication" `
            -SubscriptionId $SubscriptionId `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($null -eq $amhSolution) {
            throw "No Data Replication Service Solution found. Please verify your appliance setup."
        }

        $amhStoredStorageAccountId = $amhSolution.DetailExtendedDetail["replicationStorageAccountId"]
        
        # Record of rsa found in AMH solution
        if (![string]::IsNullOrEmpty($amhStoredStorageAccountId)) {
            $amhStoredStorageAccountName = $amhStoredStorageAccountId.Split("/")[8]
            $amhStoredStorageAccount = Get-AzStorageAccount `
                -ResourceGroupName $ResourceGroupName `
                -Name $amhStoredStorageAccountName `
                -ErrorVariable notPresent `
                -ErrorAction SilentlyContinue

            # Wait for amhStoredStorageAccount to reach a terminal state
            if ($null -ne $amhStoredStorageAccount -and
                $null -ne $amhStoredStorageAccount.ProvisioningState -and
                $amhStoredStorageAccount.ProvisioningState -ne [StorageAccountProvisioningState]::Succeeded) {
                # Check rsa state every 30s if not Succeeded already. Timeout after 10min
                for ($i = 0; $i -lt 20; $i++) {
                    Start-Sleep -Seconds 30
                    $amhStoredStorageAccount = Get-AzStorageAccount `
                        -ResourceGroupName $ResourceGroupName `
                        -Name $amhStoredStorageAccountName `
                        -ErrorVariable notPresent `
                        -ErrorAction SilentlyContinue
                        # Stop if amhStoredStorageAccount is not found or in a terminal state
                    if ($null -eq $amhStoredStorageAccount -or
                        $null -eq $amhStoredStorageAccount.ProvisioningState -or
                        $amhStoredStorageAccount.ProvisioningState -eq [StorageAccountProvisioningState]::Succeeded) {
                        break
                    }
                }
            }
            
            # amhStoredStorageAccount exists and in Succeeded state
            if ($null -ne $amhStoredStorageAccount -and
                $amhStoredStorageAccount.ProvisioningState -eq [StorageAccountProvisioningState]::Succeeded) {
                # Use amhStoredStorageAccount and ignore user provided Cache Storage Account Id
                if (![string]::IsNullOrEmpty($CacheStorageAccountId) -and $amhStoredStorageAccount.Id -ne $CacheStorageAccountId) {
                    Write-Host "A Cache Storage Account '$($amhStoredStorageAccountName)' has been linked already. The given -CacheStorageAccountId '$($CacheStorageAccountId)' will be ignored."
                }

                $cacheStorageAccount = $amhStoredStorageAccount
            }
            elseif ($null -eq $amhStoredStorageAccount -or $null -eq $amhStoredStorageAccount.ProvisioningState) {
                # amhStoredStorageAccount is found but in a bad state, so log to ask user to remove
                if ($null -ne $amhStoredStorageAccount -and $null -eq $amhStoredStorageAccount.ProvisioningState) {
                    Write-Host "A previously linked Cache Storage Account with Id '$($amhStoredStorageAccountId)' is found but in a unusable state. Please remove it manually and re-run this command."
                }

                # amhStoredStorageAccount is not found or in a bad state but AMH has a record of it, so remove the record
                if ($amhSolution.DetailExtendedDetail.ContainsKey("replicationStorageAccountId")) {
                    $amhSolution.DetailExtendedDetail.Remove("replicationStorageAccountId") | Out-Null
                    $amhSolution.DetailExtendedDetail.Add("replicationStorageAccountId", $null) | Out-Null
                    Az.Migrate.Internal\Set-AzMigrateSolution `
                        -MigrateProjectName $ProjectName `
                        -Name $amhSolution.Name `
                        -ResourceGroupName $ResourceGroupName `
                        -DetailExtendedDetail $amhSolution.DetailExtendedDetail.AdditionalProperties | Out-Null
                }
            }
            else {
                throw "A linked Cache Storage Account with Id '$($amhStoredStorageAccountId)' times out with Provisioning State: '$($amhStoredStorageAccount.ProvisioningState)'. Please re-run this command or contact support if help needed."
            }

            $amhSolution = Az.Migrate\Get-AzMigrateSolution `
                -ResourceGroupName $ResourceGroupName `
                -MigrateProjectName $ProjectName `
                -Name "Servers-Migration-ServerMigration_DataReplication" `
                -SubscriptionId $SubscriptionId `
                -ErrorVariable notPresent `
                -ErrorAction SilentlyContinue
                # Check if AMH record is removed
            if (($null -eq $amhStoredStorageAccount -or $null -eq $amhStoredStorageAccount.ProvisioningState) -and
                ![string]::IsNullOrEmpty($amhSolution.DetailExtendedDetail["replicationStorageAccountId"])) {
                throw "Unexpected error occurred in unlinking Cache Storage Account with Id '$($amhSolution.DetailExtendedDetail["replicationStorageAccountId"])'. Please re-run this command or contact support if help needed."
            }
        }

        # No linked Cache Storage Account found in AMH solution but user provides a Cache Storage Account Id
        if ($null -eq $cacheStorageAccount -and ![string]::IsNullOrEmpty($CacheStorageAccountId)) {
            $userProvidedStorageAccountIdSegs = $CacheStorageAccountId.Split("/")
            if ($userProvidedStorageAccountIdSegs.Count -ne 9) {
                throw "Invalid Cache Storage Account Id '$($CacheStorageAccountId)' provided. Please provide a valid one."
            }

            $userProvidedStorageAccountName = ($userProvidedStorageAccountIdSegs[8]).ToLower()

            # Check if user provided Cache Storage Account exists
            $userProvidedStorageAccount = Get-AzStorageAccount `
                -ResourceGroupName $ResourceGroupName `
                -Name $userProvidedStorageAccountName `
                -ErrorVariable notPresent `
                -ErrorAction SilentlyContinue

            # Wait for userProvidedStorageAccount to reach a terminal state
            if ($null -ne $userProvidedStorageAccount -and
                $null -ne $userProvidedStorageAccount.ProvisioningState -and
                $userProvidedStorageAccount.ProvisioningState -ne [StorageAccountProvisioningState]::Succeeded) {
                # Check rsa state every 30s if not Succeeded already. Timeout after 10min
                for ($i = 0; $i -lt 20; $i++) {
                    Start-Sleep -Seconds 30
                    $userProvidedStorageAccount = Get-AzStorageAccount `
                        -ResourceGroupName $ResourceGroupName `
                        -Name $userProvidedStorageAccountName `
                        -ErrorVariable notPresent `
                        -ErrorAction SilentlyContinue
                    # Stop if userProvidedStorageAccount is not found or in a terminal state
                    if ($null -eq $userProvidedStorageAccount -or
                        $null -eq $userProvidedStorageAccount.ProvisioningState -or
                        $userProvidedStorageAccount.ProvisioningState -eq [StorageAccountProvisioningState]::Succeeded) {
                        break
                    }
                }
            }

            if ($null -ne $userProvidedStorageAccount -and
                $userProvidedStorageAccount.ProvisioningState -eq [StorageAccountProvisioningState]::Succeeded) {
                $cacheStorageAccount = $userProvidedStorageAccount
            }
            elseif ($null -eq $userProvidedStorageAccount) {
                throw "Cache Storage Account with Id '$($CacheStorageAccountId)' is not found. Please re-run this command without -CacheStorageAccountId to create one automatically or re-create the Cache Storage Account yourself and try again."
            }
            elseif ($null -eq $userProvidedStorageAccount.ProvisioningState) {
                throw "Cache Storage Account with Id '$($CacheStorageAccountId)' is found but in an unusable state. Please re-run this command without -CacheStorageAccountId to create one automatically or re-create the Cache Storage Account yourself and try again."
            }
            else {
                throw "Cache Storage Account with Id '$($CacheStorageAccountId)' is found but times out with Provisioning State: '$($userProvidedStorageAccount.ProvisioningState)'. Please re-run this command or contact support if help needed."
            }
        }

        # No Cache Storage Account found or provided, so create one
        if ($null -eq $cacheStorageAccount) {
            $suffix = (GenerateHashForArtifact -Artifact "$($sourceSiteId)/$($SourceApplianceName)").ToString()
            if ($suffixHash.Length -gt 14) {
                $suffix = $suffixHash.Substring(0, 14)
            }
            $cacheStorageAccountName = "migratersa" + $suffix
            $cacheStorageAccountId = "/subscriptions/$($SubscriptionId)/resourceGroups/$($ResourceGroupName)/providers/Microsoft.Storage/storageAccounts/$($cacheStorageAccountName)"

            # Check if default Cache Storage Account already exists, which it shoudln't
            $cacheStorageAccount = Get-AzStorageAccount `
                -ResourceGroupName $ResourceGroupName `
                -Name $cacheStorageAccountName `
                -ErrorVariable notPresent `
                -ErrorAction SilentlyContinue
            if ($null -ne $cacheStorageAccount) {
                throw "Unexpected error encountered: Cache Storage Account '$($cacheStorageAccountName)' already exists. Please re-run this command to create a different one or contact support if help needed."
            }

            Write-Host "Creating Cache Storage Account with default name '$($cacheStorageAccountName)'..."

            $params = @{
                name                                = $cacheStorageAccountName;
                location                            = $migrateProject.Location;
                migrateProjectName                  = $migrateProject.Name;
                skuName                             = "Standard_LRS";
                tags                                = @{ "Migrate Project" = $migrateProject.Name };
                kind                                = "StorageV2";
                encryption                          = @{ services = @{blob = @{ enabled = $true }; file = @{ enabled = $true } } };
            }

            # Create Cache Storage Account
            $cacheStorageAccount = New-AzStorageAccount `
                -ResourceGroupName $ResourceGroupName `
                -Name $params.name `
                -SkuName $params.skuName `
                -Location $params.location `
                -Kind $params.kind `
                -Tags $params.tags `
                -AllowBlobPublicAccess $true

            if ($null -ne $cacheStorageAccount -and
                $null -ne $cacheStorageAccount.ProvisioningState -and
                $cacheStorageAccount.ProvisioningState -ne [StorageAccountProvisioningState]::Succeeded) {
                # Check rsa state every 30s if not Succeeded already. Timeout after 10min
                for ($i = 0; $i -lt 20; $i++) {
                    Start-Sleep -Seconds 30
                    $cacheStorageAccount = Get-AzStorageAccount `
                        -ResourceGroupName $ResourceGroupName `
                        -Name $params.name `
                        -ErrorVariable notPresent `
                        -ErrorAction SilentlyContinue
                    # Stop if cacheStorageAccount is not found or in a terminal state
                    if ($null -eq $cacheStorageAccount -or
                        $null -eq $cacheStorageAccount.ProvisioningState -or
                        $cacheStorageAccount.ProvisioningState -eq [StorageAccountProvisioningState]::Succeeded) {
                        break
                    }
                }
            }

            if ($null -eq $cacheStorageAccount -or $null -eq $cacheStorageAccount.ProvisioningState) {
                throw "Unexpected error occurs during Cache Storgae Account creation process. Please re-run this command or provide -CacheStorageAccountId of the one created own your own."
            }
            elseif ($cacheStorageAccount.ProvisioningState -ne [StorageAccountProvisioningState]::Succeeded) {
                throw "Cache Storage Account with Id '$($cacheStorageAccount.Id)' times out with Provisioning State: '$($cacheStorageAccount.ProvisioningState)' during creation process. Please remove it manually and re-run this command or contact support if help needed."
            }
        }

        # Sanity check
        if ($null -eq $cacheStorageAccount -or
            $null -eq $cacheStorageAccount.ProvisioningState -or
            $cacheStorageAccount.ProvisioningState -ne [StorageAccountProvisioningState]::Succeeded) {
            throw "Unexpected error occurs during Cache Storgae Account selection process. Please re-run this command or contact support if help needed."
        }

        $params = @{
            contributorRoleDefId                = [System.Guid]::parse($RoleDefinitionIds.ContributorId);
            storageBlobDataContributorRoleDefId = [System.Guid]::parse($RoleDefinitionIds.StorageBlobDataContributorId);
            sourceAppAadId                      = $sourceDra.ResourceAccessIdentityObjectId;
            targetAppAadId                      = $targetDra.ResourceAccessIdentityObjectId;
        }

        # Grant Source Dra AAD App access to Cache Storage Account as "Contributor"
        $hasAadAppAccess = Get-AzRoleAssignment `
            -ObjectId $params.sourceAppAadId `
            -RoleDefinitionId $params.contributorRoleDefId `
            -Scope $cacheStorageAccount.Id `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($null -eq $hasAadAppAccess) {
            New-AzRoleAssignment `
                -ObjectId $params.sourceAppAadId `
                -RoleDefinitionId $params.contributorRoleDefId `
                -Scope $cacheStorageAccount.Id | Out-Null
        }

        # Grant Source Dra AAD App access to Cache Storage Account as "StorageBlobDataContributor"
        $hasAadAppAccess = Get-AzRoleAssignment `
            -ObjectId $params.sourceAppAadId `
            -RoleDefinitionId $params.storageBlobDataContributorRoleDefId `
            -Scope $cacheStorageAccount.Id `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($null -eq $hasAadAppAccess) {
            New-AzRoleAssignment `
                -ObjectId $params.sourceAppAadId `
                -RoleDefinitionId $params.storageBlobDataContributorRoleDefId `
                -Scope $cacheStorageAccount.Id | Out-Null
        }

        # Grant Target Dra AAD App access to Cache Storage Account as "Contributor"
        $hasAadAppAccess = Get-AzRoleAssignment `
            -ObjectId $params.targetAppAadId `
            -RoleDefinitionId $params.contributorRoleDefId `
            -Scope $cacheStorageAccount.Id `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($null -eq $hasAadAppAccess) {
            New-AzRoleAssignment `
                -ObjectId $params.targetAppAadId `
                -RoleDefinitionId $params.contributorRoleDefId `
                -Scope $cacheStorageAccount.Id | Out-Null
        }

        # Grant Target Dra AAD App access to Cache Storage Account as "StorageBlobDataContributor"
        $hasAadAppAccess = Get-AzRoleAssignment `
            -ObjectId $params.targetAppAadId `
            -RoleDefinitionId $params.storageBlobDataContributorRoleDefId `
            -Scope $cacheStorageAccount.Id `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($null -eq $hasAadAppAccess) {
            New-AzRoleAssignment `
                -ObjectId $params.targetAppAadId `
                -RoleDefinitionId $params.storageBlobDataContributorRoleDefId `
                -Scope $cacheStorageAccount.Id | Out-Null
        }

        # Give time for role assignments to be created. Times out after 2min
        $rsaPermissionGranted = $false
        for ($i = 0; $i -lt 4; $i++) {
            # Check Source Dra AAD App access to Cache Storage Account as "Contributor"
            $hasAadAppAccess = Get-AzRoleAssignment `
                -ObjectId $params.sourceAppAadId `
                -RoleDefinitionId $params.contributorRoleDefId `
                -Scope $cacheStorageAccount.Id `
                -ErrorVariable notPresent `
                -ErrorAction SilentlyContinue
            $rsaPermissionGranted = $null -ne $hasAadAppAccess

            # Check Source Dra AAD App access to Cache Storage Account as "StorageBlobDataContributor"
            $hasAadAppAccess = Get-AzRoleAssignment `
                -ObjectId $params.sourceAppAadId `
                -RoleDefinitionId $params.storageBlobDataContributorRoleDefId `
                -Scope $cacheStorageAccount.Id `
                -ErrorVariable notPresent `
                -ErrorAction SilentlyContinue
            $rsaPermissionGranted = $rsaPermissionGranted -and ($null -ne $hasAadAppAccess)

            # Check Target Dra AAD App access to Cache Storage Account as "Contributor"
            $hasAadAppAccess = Get-AzRoleAssignment `
                -ObjectId $params.targetAppAadId `
                -RoleDefinitionId $params.contributorRoleDefId `
                -Scope $cacheStorageAccount.Id `
                -ErrorVariable notPresent `
                -ErrorAction SilentlyContinue
            $rsaPermissionGranted = $rsaPermissionGranted -and ($null -ne $hasAadAppAccess)

            # Check Target Dra AAD App access to Cache Storage Account as "StorageBlobDataContributor"
            $hasAadAppAccess = Get-AzRoleAssignment `
                -ObjectId $params.targetAppAadId `
                -RoleDefinitionId $params.storageBlobDataContributorRoleDefId `
                -Scope $cacheStorageAccount.Id `
                -ErrorVariable notPresent `
                -ErrorAction SilentlyContinue
            $rsaPermissionGranted = $rsaPermissionGranted -and ($null -ne $hasAadAppAccess)

            if ($rsaPermissionGranted) {
                break
            }

            Start-Sleep -Seconds 30
        }

        if (!$rsaPermissionGranted) {
            throw "Failed to grant Cache Storage Account permissions. Please re-run this command or contact support if help needed."
        }

        $amhSolution = Az.Migrate\Get-AzMigrateSolution `
            -ResourceGroupName $ResourceGroupName `
            -MigrateProjectName $ProjectName `
            -Name "Servers-Migration-ServerMigration_DataReplication" `
            -SubscriptionId $SubscriptionId
        if ($amhSolution.DetailExtendedDetail.ContainsKey("replicationStorageAccountId")) {
            $amhStoredStorageAccountId = $amhSolution.DetailExtendedDetail["replicationStorageAccountId"]
            if ([string]::IsNullOrEmpty($amhStoredStorageAccountId)) {
                # Remove "replicationStorageAccountId" key
                $amhSolution.DetailExtendedDetail.Remove("replicationStorageAccountId")  | Out-Null
            }
            elseif ($amhStoredStorageAccountId -ne $cacheStorageAccount.Id) {
                # Record of rsa mismatch
                throw "Unexpected error occurred in linking Cache Storage Account with Id '$($cacheStorageAccount.Id)'. Please re-run this command or contact support if help needed."
            }
        }

        # Update AMH record with chosen Cache Storage Account
        if (!$amhSolution.DetailExtendedDetail.ContainsKey("replicationStorageAccountId")) {
            $amhSolution.DetailExtendedDetail.Add("replicationStorageAccountId", $cacheStorageAccount.Id)
            Az.Migrate.Internal\Set-AzMigrateSolution `
                -MigrateProjectName $ProjectName `
                -Name $amhSolution.Name `
                -ResourceGroupName $ResourceGroupName `
                -DetailExtendedDetail $amhSolution.DetailExtendedDetail.AdditionalProperties | Out-Null
        }

        Write-Host "*Selected Cache Storage Account: '$($cacheStorageAccount.StorageAccountName)' in Resource Group '$($ResourceGroupName)' at Location '$($cacheStorageAccount.Location)' for Migrate Project '$($migrateProject.Name)'."

        # Put replication extension
        $replicationExtensionName = ($sourceFabric.Id -split '/')[-1] + "-" + ($targetFabric.Id -split '/')[-1] + "-MigReplicationExtn"
        $replicationExtension = Az.Migrate.Internal\Get-AzMigrateReplicationExtension `
            -ResourceGroupName $ResourceGroupName `
            -Name $replicationExtensionName `
            -VaultName $replicationVaultName `
            -SubscriptionId $SubscriptionId `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue

        # Remove replication extension if does not match the selected Cache Storage Account
        if ($null -ne $replicationExtension -and $replicationExtension.Property.CustomProperty.StorageAccountId -ne $cacheStorageAccount.Id) {
            Write-Host "Replication Extension '$($replicationExtensionName)' found but linked to a different Cache Storage Account '$($replicationExtension.Property.CustomProperty.StorageAccountId)'."
        
            try {
                Az.Migrate.Internal\Remove-AzMigrateReplicationExtension -InputObject $replicationExtension | Out-Null
            }
            catch {
                if ($_.Exception.Message -notmatch "Status: OK") {
                    throw $_.Exception.Message
                }
            }

            Write-Host "Removing Replication Extension and waiting for 2 minutes..."
            Start-Sleep -Seconds 120
            $replicationExtension = Az.Migrate.Internal\Get-AzMigrateReplicationExtension `
                -InputObject $replicationExtension `
                -ErrorVariable notPresent `
                -ErrorAction SilentlyContinue

            if ($null -eq $replicationExtension) {
                Write-Host "Replication Extension '$($replicationExtensionName)' was removed."
            }
        }

        # Replication extension exists
        if ($null -ne $replicationExtension) {
            # Give time for create/update to reach a terminal state. Timeout after 10min
            if ($replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Creating -or
                $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Updating) {
                Write-Host "Replication Extension '$($replicationExtensionName)' found in Provisioning State '$($replicationExtension.Property.ProvisioningState)'."

                for ($i = 0; $i -lt 20; $i++) {
                    Start-Sleep -Seconds 30
                    $replicationExtension = Az.Migrate.Internal\Get-AzMigrateReplicationExtension `
                        -InputObject $replicationExtension `
                        -ErrorVariable notPresent `
                        -ErrorAction SilentlyContinue

                    if (-not (
                            $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Creating -or
                            $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Updating)) {
                        break
                    }
                }

                # Make sure replication extension is no longer in Creating or Updating state
                if ($replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Creating -or
                    $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Updating) {
                    throw "Replication Extension '$($replicationExtensionName)' times out with Provisioning State: '$($replicationExtension.Property.ProvisioningState)'. Please re-run this command or contact support if help needed."
                }
            }

            # Check and remove if replication extension is in a bad terminal state
            if ($replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Canceled -or
                $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Failed) {
                Write-Host "Replication Extension '$($replicationExtensionName)' found but in an unusable terminal Provisioning State '$($replicationExtension.Property.ProvisioningState)'.`nRemoving Replication Extension..."
                    
                # Remove replication extension
                try {
                    Az.Migrate.Internal\Remove-AzMigrateReplicationExtension -InputObject $replicationExtension | Out-Null
                }
                catch {
                    if ($_.Exception.Message -notmatch "Status: OK") {
                        throw $_.Exception.Message
                    }
                }

                Start-Sleep -Seconds 30
                $replicationExtension = Az.Migrate.Internal\Get-AzMigrateReplicationExtension `
                    -InputObject $replicationExtension `
                    -ErrorVariable notPresent `
                    -ErrorAction SilentlyContinue

                # Make sure replication extension is no longer in Canceled or Failed state
                if ($null -ne $replicationExtension -and
                    ($replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Canceled -or
                    $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Failed)) {
                    throw "Failed to change the Provisioning State of Replication Extension '$($replicationExtensionName)'by removing. Please re-run this command or contact support if help needed."
                }
            }

            # Give time to remove replication extension. Timeout after 10min
            if ($null -ne $replicationExtension -and
                $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Deleting) {
                Write-Host "Replication Extension '$($replicationExtensionName)' found in Provisioning State '$($replicationExtension.Property.ProvisioningState)'."

                for ($i = 0; $i -lt 20; $i++) {
                    Start-Sleep -Seconds 30
                    $replicationExtension = Az.Migrate.Internal\Get-AzMigrateReplicationExtension `
                        -InputObject $replicationExtension `
                        -ErrorVariable notPresent `
                        -ErrorAction SilentlyContinue

                    if ($null -eq $replicationExtension -or $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Deleted) {
                        break
                    }
                    elseif ($replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Deleting) {
                        continue
                    }

                    throw "Replication Extension '$($replicationExtensionName)' has an unexpected Provisioning State of '$($replicationExtension.Property.ProvisioningState)' during removal process. Please re-run this command or contact support if help needed."
                }

                # Make sure replication extension is no longer in Deleting state
                if ($null -ne $replicationExtension -and $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Deleting) {
                    throw "Replication Extension '$($replicationExtensionName)' times out with Provisioning State: '$($replicationExtension.Property.ProvisioningState)'. Please re-run this command or contact support if help needed."
                }
            }

            # Indicate replication extension was removed
            if ($null -eq $replicationExtension -or $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Deleted) {
                Write-Host "Replication Extension '$($replicationExtensionName)' was removed."
            }
        }

        # Refresh local replication extension object if exists
        if ($null -ne $replicationExtension) {
            $replicationExtension = Az.Migrate.Internal\Get-AzMigrateReplicationExtension -InputObject $replicationExtension
        }

        # Create replication extension if not found or previously deleted
        if ($null -eq $replicationExtension -or $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Deleted) {
            Write-Host "Waiting 2 minutes for permissions to sync before creating Replication Extension..."
            Start-Sleep -Seconds 120

            Write-Host "Creating Replication Extension..."
            $params = @{
                InstanceType                = $instanceType;
                SourceFabricArmId           = $sourceFabric.Id;
                TargetFabricArmId           = $targetFabric.Id;
                StorageAccountId            = $cacheStorageAccount.Id;
                StorageAccountSasSecretName = $null;
            }

            # Setup Replication Extension deployment parameters
            $replicationExtensionProperties = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api20210216Preview.ReplicationExtensionModelProperties]::new()
        
            if ($instanceType -eq $AzStackHCIInstanceTypes.HyperVToAzStackHCI) {
                $replicationExtensionCustomProperties = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api20210216Preview.HyperVToAzStackHcireplicationExtensionModelCustomProperties]::new()
                $replicationExtensionCustomProperties.HyperVFabricArmId = $params.SourceFabricArmId
                
            }
            elseif ($instanceType -eq $AzStackHCIInstanceTypes.VMwareToAzStackHCI) {
                $replicationExtensionCustomProperties = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api20210216Preview.VMwareToAzStackHcireplicationExtensionModelCustomProperties]::new()
                $replicationExtensionCustomProperties.VMwareFabricArmId = $params.SourceFabricArmId
            }
            else {
                throw "Currently, for AzStackHCI scenario, only HyperV and VMware as the source is supported."
            }
            $replicationExtensionCustomProperties.InstanceType = $params.InstanceType
            $replicationExtensionCustomProperties.AzStackHCIFabricArmId = $params.TargetFabricArmId
            $replicationExtensionCustomProperties.StorageAccountId = $params.StorageAccountId
            $replicationExtensionCustomProperties.StorageAccountSasSecretName = $params.StorageAccountSasSecretName
            $replicationExtensionProperties.CustomProperty = $replicationExtensionCustomProperties

            try {
                Az.Migrate.Internal\New-AzMigrateReplicationExtension `
                    -Name $replicationExtensionName `
                    -ResourceGroupName $ResourceGroupName `
                    -VaultName $replicationVaultName `
                    -Property $replicationExtensionProperties `
                    -SubscriptionId $SubscriptionId `
                    -NoWait | Out-Null
            }
            catch {
                if ($_.Exception.Message -notmatch "Status: OK") {
                    throw $_.Exception.Message
                }
            }

            # Check replication extension creation status every 30s. Timeout after 10min
            for ($i = 0; $i -lt 20; $i++) {
                Start-Sleep -Seconds 30
                $replicationExtension = Az.Migrate.Internal\Get-AzMigrateReplicationExtension `
                    -ResourceGroupName $ResourceGroupName `
                    -Name $replicationExtensionName `
                    -VaultName $replicationVaultName `
                    -SubscriptionId $SubscriptionId `
                    -ErrorVariable notPresent `
                    -ErrorAction SilentlyContinue
                if ($null -eq $replicationExtension) {
                    throw "Unexpected error occurred during Replication Extension creation. Please re-run this command or contact support if help needed."
                }
                
                # Stop if replication extension reaches a terminal state
                if ($replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Succeeded -or
                    $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Deleted -or
                    $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Canceled -or
                    $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Failed) {
                    break
                }
            }

            # Make sure replicationExtension is in a terminal state
            if (-not (
                    $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Succeeded -or
                    $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Deleted -or
                    $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Canceled -or
                    $replicationExtension.Property.ProvisioningState -eq [ProvisioningState]::Failed)) {
                throw "Replication Extension '$($replicationExtensionName)' times out with Provisioning State: '$($replicationExtension.Property.ProvisioningState)' during creation process. Please re-run this command or contact support if help needed."
            }
        }
        
        if ($replicationExtension.Property.ProvisioningState -ne [ProvisioningState]::Succeeded) {
            throw "Replication Extension '$($replicationExtensionName)' has an unexpected Provisioning State of '$($replicationExtension.Property.ProvisioningState)'. Please re-run this command or contact support if help needed."
        }

        $replicationExtension = Az.Migrate.Internal\Get-AzMigrateReplicationExtension `
            -ResourceGroupName $ResourceGroupName `
            -Name $replicationExtensionName `
            -VaultName $replicationVaultName `
            -SubscriptionId $SubscriptionId `
            -ErrorVariable notPresent `
            -ErrorAction SilentlyContinue
        if ($null -eq $replicationExtension) {
            throw "Unexpected error occurred during Replication Extension creation. Please re-run this command or contact support if help needed."
        }
        elseif ($replicationExtension.Property.ProvisioningState -ne [ProvisioningState]::Succeeded) {
            throw "Replication Extension '$($replicationExtensionName)' has an unexpected Provisioning State of '$($replicationExtension.Property.ProvisioningState)'. Please re-run this command or contact support if help needed."
        }
        else {
            Write-Host "*Selected Replication Extension: '$($replicationExtensionName)'."
        }

        if ($PassThru) {
            return $true
        }
    }
}
# SIG # Begin signature block
# MIInzgYJKoZIhvcNAQcCoIInvzCCJ7sCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCB0hQnApn7KPKAd
# NyeemKHvSsWLs5NSUKXQbJYWhSRC76CCDYUwggYDMIID66ADAgECAhMzAAADri01
# UchTj1UdAAAAAAOuMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMxMTE2MTkwODU5WhcNMjQxMTE0MTkwODU5WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQD0IPymNjfDEKg+YyE6SjDvJwKW1+pieqTjAY0CnOHZ1Nj5irGjNZPMlQ4HfxXG
# yAVCZcEWE4x2sZgam872R1s0+TAelOtbqFmoW4suJHAYoTHhkznNVKpscm5fZ899
# QnReZv5WtWwbD8HAFXbPPStW2JKCqPcZ54Y6wbuWV9bKtKPImqbkMcTejTgEAj82
# 6GQc6/Th66Koka8cUIvz59e/IP04DGrh9wkq2jIFvQ8EDegw1B4KyJTIs76+hmpV
# M5SwBZjRs3liOQrierkNVo11WuujB3kBf2CbPoP9MlOyyezqkMIbTRj4OHeKlamd
# WaSFhwHLJRIQpfc8sLwOSIBBAgMBAAGjggGCMIIBfjAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUhx/vdKmXhwc4WiWXbsf0I53h8T8w
# VAYDVR0RBE0wS6RJMEcxLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJh
# dGlvbnMgTGltaXRlZDEWMBQGA1UEBRMNMjMwMDEyKzUwMTgzNjAfBgNVHSMEGDAW
# gBRIbmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDEx
# XzIwMTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIB
# AGrJYDUS7s8o0yNprGXRXuAnRcHKxSjFmW4wclcUTYsQZkhnbMwthWM6cAYb/h2W
# 5GNKtlmj/y/CThe3y/o0EH2h+jwfU/9eJ0fK1ZO/2WD0xi777qU+a7l8KjMPdwjY
# 0tk9bYEGEZfYPRHy1AGPQVuZlG4i5ymJDsMrcIcqV8pxzsw/yk/O4y/nlOjHz4oV
# APU0br5t9tgD8E08GSDi3I6H57Ftod9w26h0MlQiOr10Xqhr5iPLS7SlQwj8HW37
# ybqsmjQpKhmWul6xiXSNGGm36GarHy4Q1egYlxhlUnk3ZKSr3QtWIo1GGL03hT57
# xzjL25fKiZQX/q+II8nuG5M0Qmjvl6Egltr4hZ3e3FQRzRHfLoNPq3ELpxbWdH8t
# Nuj0j/x9Crnfwbki8n57mJKI5JVWRWTSLmbTcDDLkTZlJLg9V1BIJwXGY3i2kR9i
# 5HsADL8YlW0gMWVSlKB1eiSlK6LmFi0rVH16dde+j5T/EaQtFz6qngN7d1lvO7uk
# 6rtX+MLKG4LDRsQgBTi6sIYiKntMjoYFHMPvI/OMUip5ljtLitVbkFGfagSqmbxK
# 7rJMhC8wiTzHanBg1Rrbff1niBbnFbbV4UDmYumjs1FIpFCazk6AADXxoKCo5TsO
# zSHqr9gHgGYQC2hMyX9MGLIpowYCURx3L7kUiGbOiMwaMIIHejCCBWKgAwIBAgIK
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
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGZ8wghmbAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAAOuLTVRyFOPVR0AAAAA
# A64wDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIGXW
# Z+Lm7QziNY1edRv00VEK/LttaBVdGfpWHh00MA19MEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEA0/poHHF5DvJMmQgwM7EyThjXyQJ0PaIYomGQ
# n6p8ST/K9ZHepnKByjRGmrktaAuF+Y5aASXtWN6L8qp7ocd1bcCL11LdT7KTP7dv
# vhtOsp7+MsgOCuso6TUXwvze8DUO3SvpRWY0GKYZAlpzkJvQD3j/VFF5b0qnyy3c
# +TntKoIfLYyHTX4SjEaOeIzl3CXrAV7FpmNM9tb6b/tR4GBihktaiHZyPPaSA2hh
# TTkwCU+E+gq3tzFBntr0+LiUBC6WiYbmE2n5U0U4F1Vgb2CocODvldw8FhjFQstw
# rOz127BsJ+vtUyUiltmLDSIB6yezBPxBR6lKMOWBAqFYWPdLf6GCFykwghclBgor
# BgEEAYI3AwMBMYIXFTCCFxEGCSqGSIb3DQEHAqCCFwIwghb+AgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFZBgsqhkiG9w0BCRABBKCCAUgEggFEMIIBQAIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCB+Y94Wf/4By4FIV+bjjzjUj6tyghaHrFX3
# xXJLFNBzxAIGZa6EYZYtGBMyMDI0MDEzMDA1MDQ1NS4wNjFaMASAAgH0oIHYpIHV
# MIHSMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQL
# EyRNaWNyb3NvZnQgSXJlbGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJjAkBgNVBAsT
# HVRoYWxlcyBUU1MgRVNOOjJBRDQtNEI5Mi1GQTAxMSUwIwYDVQQDExxNaWNyb3Nv
# ZnQgVGltZS1TdGFtcCBTZXJ2aWNloIIReDCCBycwggUPoAMCAQICEzMAAAHenkie
# lp8oRD0AAQAAAd4wDQYJKoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# UENBIDIwMTAwHhcNMjMxMDEyMTkwNzEyWhcNMjUwMTEwMTkwNzEyWjCB0jELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9z
# b2Z0IElyZWxhbmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMg
# VFNTIEVTTjoyQUQ0LTRCOTItRkEwMTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgU2VydmljZTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALSB
# 9ByF9UIDhA6xFrOniw/xsDl8sSi9rOCOXSSO4VMQjnNGAo5VHx0iijMEMH9LY2SU
# IBkVQS0Ml6kR+TagkUPbaEpwjhQ1mprhRgJT/jlSnic42VDAo0en4JI6xnXoAoWo
# KySY8/ROIKdpphgI7OJb4XHk1P3sX2pNZ32LDY1ktchK1/hWyPlblaXAHRu0E3yn
# vwrS8/bcorANO6DjuysyS9zUmr+w3H3AEvSgs2ReuLj2pkBcfW1UPCFudLd7IPZ2
# RC4odQcEPnY12jypYPnS6yZAs0pLpq0KRFUyB1x6x6OU73sudiHON16mE0l6LLT9
# OmGo0S94Bxg3N/3aE6fUbnVoemVc7FkFLum8KkZcbQ7cOHSAWGJxdCvo5OtUtRdS
# qf85FklCXIIkg4sm7nM9TktUVfO0kp6kx7mysgD0Qrxx6/5oaqnwOTWLNzK+BCi1
# G7nUD1pteuXvQp8fE1KpTjnG/1OJeehwKNNPjGt98V0BmogZTe3SxBkOeOQyLA++
# 5Hyg/L68pe+DrZoZPXJaGU/iBiFmL+ul/Oi3d83zLAHlHQmH/VGNBfRwP+ixvqhy
# k/EebwuXVJY+rTyfbRfuh9n0AaMhhNxxg6tGKyZS4EAEiDxrF9mAZEy8e8rf6dlK
# IX5d3aQLo9fDda1ZTOw+XAcAvj2/N3DLVGZlHnHlAgMBAAGjggFJMIIBRTAdBgNV
# HQ4EFgQUazAmbxseaapgdxzK8Os+naPQEsgwHwYDVR0jBBgwFoAUn6cVXQBeYl2D
# 9OXSZacbUzUZ6XIwXwYDVR0fBFgwVjBUoFKgUIZOaHR0cDovL3d3dy5taWNyb3Nv
# ZnQuY29tL3BraW9wcy9jcmwvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
# MDIwMTAoMSkuY3JsMGwGCCsGAQUFBwEBBGAwXjBcBggrBgEFBQcwAoZQaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNyb3NvZnQlMjBUaW1l
# LVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcnQwDAYDVR0TAQH/BAIwADAWBgNVHSUB
# Af8EDDAKBggrBgEFBQcDCDAOBgNVHQ8BAf8EBAMCB4AwDQYJKoZIhvcNAQELBQAD
# ggIBAOKUwHsXDacGOvUIgs5HDgPs0LZ1qyHS6C6wfKlLaD36tZfbWt1x+GMiazSu
# y+GsxiVHzkhMW+FqK8gruLQWN/sOCX+fGUgT9LT21cRIpcZj4/ZFIvwtkBcsCz1X
# EUsXYOSJUPitY7E8bbldmmhYZ29p+XQpIcsG/q+YjkqBW9mw0ru1MfxMTQs9MTDi
# D28gAVGrPA3NykiSChvdqS7VX+/LcEz9Ubzto/w28WA8HOCHqBTbDRHmiP7MIj+S
# QmI9VIayYsIGRjvelmNa0OvbU9CJSz/NfMEgf2NHMZUYW8KqWEjIjPfHIKxWlNMY
# huWfWRSHZCKyIANA0aJL4soHQtzzZ2MnNfjYY851wHYjGgwUj/hlLRgQO5S30Zx7
# 8GqBKfylp25aOWJ/qPhC+DXM2gXajIXbl+jpGcVANwtFFujCJRdZbeH1R+Q41Fjg
# Bg4m3OTFDGot5DSuVkQgjku7pOVPtldE46QlDg/2WhPpTQxXH64sP1GfkAwUtt6r
# rZM/PCwRG6girYmnTRLLsicBhoYLh+EEFjVviXAGTk6pnu8jx/4WPWu0jsz7yFzg
# 82/FMqCk9wK3LvyLAyDHN+FxbHAxtgwad7oLQPM0WGERdB1umPCIiYsSf/j79EqH
# doNwQYROVm+ZX10RX3n6bRmAnskeNhi0wnVaeVogLMdGD+nqMIIHcTCCBVmgAwIB
# AgITMwAAABXF52ueAptJmQAAAAAAFTANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UE
# BhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAc
# BgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0
# IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIwMTAwHhcNMjEwOTMwMTgyMjI1
# WhcNMzAwOTMwMTgzMjI1WjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDCC
# AiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAOThpkzntHIhC3miy9ckeb0O
# 1YLT/e6cBwfSqWxOdcjKNVf2AX9sSuDivbk+F2Az/1xPx2b3lVNxWuJ+Slr+uDZn
# hUYjDLWNE893MsAQGOhgfWpSg0S3po5GawcU88V29YZQ3MFEyHFcUTE3oAo4bo3t
# 1w/YJlN8OWECesSq/XJprx2rrPY2vjUmZNqYO7oaezOtgFt+jBAcnVL+tuhiJdxq
# D89d9P6OU8/W7IVWTe/dvI2k45GPsjksUZzpcGkNyjYtcI4xyDUoveO0hyTD4MmP
# frVUj9z6BVWYbWg7mka97aSueik3rMvrg0XnRm7KMtXAhjBcTyziYrLNueKNiOSW
# rAFKu75xqRdbZ2De+JKRHh09/SDPc31BmkZ1zcRfNN0Sidb9pSB9fvzZnkXftnIv
# 231fgLrbqn427DZM9ituqBJR6L8FA6PRc6ZNN3SUHDSCD/AQ8rdHGO2n6Jl8P0zb
# r17C89XYcz1DTsEzOUyOArxCaC4Q6oRRRuLRvWoYWmEBc8pnol7XKHYC4jMYcten
# IPDC+hIK12NvDMk2ZItboKaDIV1fMHSRlJTYuVD5C4lh8zYGNRiER9vcG9H9stQc
# xWv2XFJRXRLbJbqvUAV6bMURHXLvjflSxIUXk8A8FdsaN8cIFRg/eKtFtvUeh17a
# j54WcmnGrnu3tz5q4i6tAgMBAAGjggHdMIIB2TASBgkrBgEEAYI3FQEEBQIDAQAB
# MCMGCSsGAQQBgjcVAgQWBBQqp1L+ZMSavoKRPEY1Kc8Q/y8E7jAdBgNVHQ4EFgQU
# n6cVXQBeYl2D9OXSZacbUzUZ6XIwXAYDVR0gBFUwUzBRBgwrBgEEAYI3TIN9AQEw
# QTA/BggrBgEFBQcCARYzaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9E
# b2NzL1JlcG9zaXRvcnkuaHRtMBMGA1UdJQQMMAoGCCsGAQUFBwMIMBkGCSsGAQQB
# gjcUAgQMHgoAUwB1AGIAQwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/
# MB8GA1UdIwQYMBaAFNX2VsuP6KJcYmjRPZSQW9fOmhjEMFYGA1UdHwRPME0wS6BJ
# oEeGRWh0dHA6Ly9jcmwubWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01p
# Y1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYB
# BQUHMAKGPmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljUm9v
# Q2VyQXV0XzIwMTAtMDYtMjMuY3J0MA0GCSqGSIb3DQEBCwUAA4ICAQCdVX38Kq3h
# LB9nATEkW+Geckv8qW/qXBS2Pk5HZHixBpOXPTEztTnXwnE2P9pkbHzQdTltuw8x
# 5MKP+2zRoZQYIu7pZmc6U03dmLq2HnjYNi6cqYJWAAOwBb6J6Gngugnue99qb74p
# y27YP0h1AdkY3m2CDPVtI1TkeFN1JFe53Z/zjj3G82jfZfakVqr3lbYoVSfQJL1A
# oL8ZthISEV09J+BAljis9/kpicO8F7BUhUKz/AyeixmJ5/ALaoHCgRlCGVJ1ijbC
# HcNhcy4sa3tuPywJeBTpkbKpW99Jo3QMvOyRgNI95ko+ZjtPu4b6MhrZlvSP9pEB
# 9s7GdP32THJvEKt1MMU0sHrYUP4KWN1APMdUbZ1jdEgssU5HLcEUBHG/ZPkkvnNt
# yo4JvbMBV0lUZNlz138eW0QBjloZkWsNn6Qo3GcZKCS6OEuabvshVGtqRRFHqfG3
# rsjoiV5PndLQTHa1V1QJsWkBRH58oWFsc/4Ku+xBZj1p/cvBQUl+fpO+y/g75LcV
# v7TOPqUxUYS8vwLBgqJ7Fx0ViY1w/ue10CgaiQuPNtq6TPmb/wrpNPgkNWcr4A24
# 5oyZ1uEi6vAnQj0llOZ0dFtq0Z4+7X6gMTN9vMvpe784cETRkPHIqzqKOghif9lw
# Y1NNje6CbaUFEMFxBmoQtB1VM1izoXBm8qGCAtQwggI9AgEBMIIBAKGB2KSB1TCB
# 0jELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
# ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMk
# TWljcm9zb2Z0IElyZWxhbmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1U
# aGFsZXMgVFNTIEVTTjoyQUQ0LTRCOTItRkEwMTElMCMGA1UEAxMcTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgU2VydmljZaIjCgEBMAcGBSsOAwIaAxUAaKBSisy4y86pl8Xy
# 22CJZExE2vOggYMwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAN
# BgkqhkiG9w0BAQUFAAIFAOli5LkwIhgPMjAyNDAxMzAxMTAwMDlaGA8yMDI0MDEz
# MTExMDAwOVowdDA6BgorBgEEAYRZCgQBMSwwKjAKAgUA6WLkuQIBADAHAgEAAgIF
# ETAHAgEAAgIRPTAKAgUA6WQ2OQIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEE
# AYRZCgMCoAowCAIBAAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBBQUAA4GB
# AD8W4Di0WrpTByhe8Dlm7Ijp+o6zqyGx+hD4OVaYnJz6lM7t3aW1a6RZEo6bRxKP
# 4rFr4WWlQzCxAOy6w1Y+eMNKG9mI4rjsEiCK7aNhQjXMraMXv7kQNBoiD74z853W
# kFwH5opm54xV7zO9TKxBXDFc5TyIPVRaAp6046r9/7p6MYIEDTCCBAkCAQEwgZMw
# fDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
# ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMd
# TWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAHenkielp8oRD0AAQAA
# Ad4wDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRAB
# BDAvBgkqhkiG9w0BCQQxIgQgyrcEBaBwp9C02x0c+lMF8TEJsO9MEYYL5CyvGhE5
# 734wgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCCOPiOfDcFeEBBJAn/mC3Mg
# rT5w/U2z81LYD44Hc34dezCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQI
# EwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
# ZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBD
# QSAyMDEwAhMzAAAB3p5InpafKEQ9AAEAAAHeMCIEIO2aHHYEC/qVFmRZDExuq1dT
# KxcmmGTN5GI+Y3MCQUIpMA0GCSqGSIb3DQEBCwUABIICAFOeteh6tAgCYx7K9ev2
# Mt95/mBJ0DdanUAdkJ8FHd1YUICmEFVN1F1cEwjzypyhBWv3ocTuQVAdTjcki/z7
# DExsl3Bd+KtVK0UyZTQBXIaZgl5w8tD5QjqfNoHZTtIB1+Pq1XpnQzP3OM0PR4WI
# nx6VxWKre3ysdWUjRP33dJmBSmOclEDLRdTeA9nJNaAiipRgsxcFgR32JQYonSCt
# z6E/qE/qmuAPwiMOVYRSskPW3hl+GGfbXcG8ExgyLT97Qv5Y7Tiwjjwm/+Wu5GQz
# l9Ur8Ey9Jsj5xViz8rrMv+K3SgEnJEhHDUR50C8mbDjNogoZZfMBOUlNHQqydhWO
# iTYq1ho3LH6zbtTYHtaik4xCLC2+TBYdfizSrJcKI2zfQHPdrm1Iq3bsaodO9y64
# Bq1Y4x8dugzemBXjNixCm4YgurJbuTIRDIa48fIBRjq7HgYVJN+naUZbly46rrjY
# 4jzPx5//8xEWxwbEr7SR9hlxj8qu7GPF5AXjbUQ/8AWyzZexguMC87tCf91y4tkr
# oG/pySzS3MLjiIp7G8bz6J9Fk0YEslh1yeu71HQ5kGdn6Wdo4fWbs0Qq2yspg4d2
# Y28+P8//CczMTbpdWPjUO3BpcYfBzPucm2rr3zkl8+XFVt1eCDPKXlT9eu8PLxPJ
# 9ju2R/T6UeFDgTbuygLgDIG/
# SIG # End signature block
