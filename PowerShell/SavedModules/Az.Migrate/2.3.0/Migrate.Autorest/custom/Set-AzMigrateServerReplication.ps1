
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
Updates the target properties for the replicating server.
.Description
The Set-AzMigrateServerReplication cmdlet updates the target properties for the replicating server.
.Link
https://learn.microsoft.com/powershell/module/az.migrate/set-azmigrateserverreplication
#>
function Set-AzMigrateServerReplication {
    [OutputType([Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202301.IJob])]
    [CmdletBinding(DefaultParameterSetName = 'ByIDVMwareCbt', PositionalBinding = $false)]
    param(
        [Parameter(ParameterSetName = 'ByIDVMwareCbt', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the replcating server for which the properties need to be updated. The ID should be retrieved using the Get-AzMigrateServerReplication cmdlet.
        ${TargetObjectID},

        [Parameter(ParameterSetName = 'ByInputObjectVMwareCbt', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202301.IMigrationItem]
        # Specifies the replicating server for which the properties need to be updated. The server object can be retrieved using the Get-AzMigrateServerReplication cmdlet.
        ${InputObject},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the replcating server for which the properties need to be updated. The ID should be retrieved using the Get-AzMigrateServerReplication cmdlet.
        ${TargetVMName},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the name of the Azure VM to be created.
        ${TargetDiskName},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Updates the SKU of the Azure VM to be created.
        ${TargetVMSize},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Updates the Virtual Network id within the destination Azure subscription to which the server needs to be migrated.
        ${TargetNetworkId},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Updates the Virtual Network id within the destination Azure subscription to which the server needs to be test migrated.
        ${TestNetworkId},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Updates the Resource Group id within the destination Azure subscription to which the server needs to be migrated.
        ${TargetResourceGroupID},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202301.IVMwareCbtNicInput[]]
        # Updates the NIC for the Azure VM to be created.
        ${NicToUpdate},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202301.IVMwareCbtUpdateDiskInput[]]
        # Updates the disk for the Azure VM to be created.
        ${DiskToUpdate},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the Availability Set to be used for VM creation.
        ${TargetAvailabilitySet},
        
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the Availability Zone to be used for VM creation.
        ${TargetAvailabilityZone},

        [Parameter()]
        [ValidateSet("NoLicenseType" , "PAYG" , "AHUB")]
        [ArgumentCompleter( { "NoLicenseType" , "PAYG" , "AHUB" })]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies if Azure Hybrid benefit for SQL Server is applicable for the server to be migrated.
        ${SqlServerLicenseType},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.Collections.Hashtable]
        # Specifies the tag to be used for Resource creation.
        ${UpdateTag},

        [Parameter()]
        [ValidateSet("Merge" , "Replace" , "Delete")]
        [ArgumentCompleter( { "Merge" , "Replace" , "Delete" })]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies update tag operation.
        ${UpdateTagOperation},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202301.IVMwareCbtEnableMigrationInputTargetVmtags]
        # Specifies the tag to be used for VM creation.
        ${UpdateVMTag},

        [Parameter()]
        [ValidateSet("Merge" , "Replace" , "Delete")]
        [ArgumentCompleter( { "Merge" , "Replace" , "Delete" })]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies update VM tag operation.
        ${UpdateVMTagOperation},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202301.IVMwareCbtEnableMigrationInputTargetNicTags]
        # Specifies the tag to be used for NIC creation.
        ${UpdateNicTag},

        [Parameter()]
        [ValidateSet("Merge" , "Replace" , "Delete")]
        [ArgumentCompleter( { "Merge" , "Replace" , "Delete" })]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies update NIC tag operation.
        ${UpdateNicTagOperation},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202301.IVMwareCbtEnableMigrationInputTargetDiskTags]
        # Specifies the tag to be used for disk creation.
        ${UpdateDiskTag},

        [Parameter()]
        [ValidateSet("Merge" , "Replace" , "Delete")]
        [ArgumentCompleter( { "Merge" , "Replace" , "Delete" })]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies update disk tag operation.
        ${UpdateDiskTagOperation},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [System.String]
        # Specifies the storage account to be used for boot diagnostics.
        ${TargetBootDiagnosticsStorageAccount},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Runtime.DefaultInfo(Script = '(Get-AzContext).Subscription.Id')]
        [System.String]
        # The subscription Id.
        ${SubscriptionId},

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

        $HasTargetVMName = $PSBoundParameters.ContainsKey('TargetVMName')
        $HasTargetDiskName = $PSBoundParameters.ContainsKey('TargetDiskName')
        $HasTargetVmSize = $PSBoundParameters.ContainsKey('TargetVMSize')
        $HasTargetNetworkId = $PSBoundParameters.ContainsKey('TargetNetworkId')
        $HasTestNetworkId = $PSBoundParameters.ContainsKey('TestNetworkId')
        $HasTargetResourceGroupID = $PSBoundParameters.ContainsKey('TargetResourceGroupID')
        $HasNicToUpdate = $PSBoundParameters.ContainsKey('NicToUpdate')
        $HasDiskToUpdate = $PSBoundParameters.ContainsKey('DiskToUpdate')
        $HasTargetAvailabilitySet = $PSBoundParameters.ContainsKey('TargetAvailabilitySet')
        $HasTargetAvailabilityZone = $PSBoundParameters.ContainsKey('TargetAvailabilityZone')
        $HasSqlServerLicenseType = $PSBoundParameters.ContainsKey('SqlServerLicenseType')
        $HasUpdateTag = $PSBoundParameters.ContainsKey('UpdateTag')
        $HasUpdateTagOperation = $PSBoundParameters.ContainsKey('UpdateTagOperation')
        $HasUpdateVMTag = $PSBoundParameters.ContainsKey('UpdateVMTag')
        $HasUpdateVMTagOperation = $PSBoundParameters.ContainsKey('UpdateVMTagOperation')
        $HasUpdateNicTag = $PSBoundParameters.ContainsKey('UpdateNicTag')
        $HasUpdateNicTagOperation = $PSBoundParameters.ContainsKey('UpdateNicTagOperation')
        $HasUpdateDiskTag = $PSBoundParameters.ContainsKey('UpdateDiskTag')
        $HasUpdateDiskTagOperation = $PSBoundParameters.ContainsKey('UpdateDiskTagOperation')
        $HasTargetBootDignosticStorageAccount = $PSBoundParameters.ContainsKey('TargetBootDiagnosticsStorageAccount')

        $null = $PSBoundParameters.Remove('TargetObjectID')
        $null = $PSBoundParameters.Remove('TargetVMName')
        $null = $PSBoundParameters.Remove('TargetDiskName')
        $null = $PSBoundParameters.Remove('TargetVMSize')
        $null = $PSBoundParameters.Remove('TargetNetworkId')
        $null = $PSBoundParameters.Remove('TestNetworkId')
        $null = $PSBoundParameters.Remove('TargetResourceGroupID')
        $null = $PSBoundParameters.Remove('NicToUpdate')
        $null = $PSBoundParameters.Remove('DiskToUpdate')
        $null = $PSBoundParameters.Remove('TargetAvailabilitySet')
        $null = $PSBoundParameters.Remove('TargetAvailabilityZone')
        $null = $PSBoundParameters.Remove('SqlServerLicenseType')
        $null = $PSBoundParameters.Remove('UpdateTag')
        $null = $PSBoundParameters.Remove('UpdateTagOperation')
        $null = $PSBoundParameters.Remove('UpdateVMTag')
        $null = $PSBoundParameters.Remove('UpdateVMTagOperation')
        $null = $PSBoundParameters.Remove('UpdateNicTag')
        $null = $PSBoundParameters.Remove('UpdateNicTagOperation')
        $null = $PSBoundParameters.Remove('UpdateDiskTag')
        $null = $PSBoundParameters.Remove('UpdateDiskTagOperation')

        $null = $PSBoundParameters.Remove('InputObject')
        $null = $PSBoundParameters.Remove('TargetBootDiagnosticsStorageAccount')
        $parameterSet = $PSCmdlet.ParameterSetName

        if ($parameterSet -eq 'ByInputObjectVMwareCbt') {
            $TargetObjectID = $InputObject.Id
        }
        $MachineIdArray = $TargetObjectID.Split("/")
        $ResourceGroupName = $MachineIdArray[4]
        $VaultName = $MachineIdArray[8]
        $FabricName = $MachineIdArray[10]
        $ProtectionContainerName = $MachineIdArray[12]
        $MachineName = $MachineIdArray[14]
            
        $null = $PSBoundParameters.Add("ResourceGroupName", $ResourceGroupName)
        $null = $PSBoundParameters.Add("ResourceName", $VaultName)
        $null = $PSBoundParameters.Add("FabricName", $FabricName)
        $null = $PSBoundParameters.Add("MigrationItemName", $MachineName)
        $null = $PSBoundParameters.Add("ProtectionContainerName", $ProtectionContainerName)
            
        $ReplicationMigrationItem = Az.Migrate.internal\Get-AzMigrateReplicationMigrationItem @PSBoundParameters
        if ($ReplicationMigrationItem -and ($ReplicationMigrationItem.ProviderSpecificDetail.InstanceType -eq 'VMwarecbt')) {
            $ProviderSpecificDetails = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202301.VMwareCbtUpdateMigrationItemInput]::new()
                
            # Auto fill unchanged parameters
            $ProviderSpecificDetails.InstanceType = 'VMwareCbt'
            $ProviderSpecificDetails.LicenseType = $ReplicationMigrationItem.ProviderSpecificDetail.LicenseType
            $ProviderSpecificDetails.PerformAutoResync = $ReplicationMigrationItem.ProviderSpecificDetail.PerformAutoResync
                
            if ($HasTargetAvailabilitySet) {
                $ProviderSpecificDetails.TargetAvailabilitySetId = $TargetAvailabilitySet
            }
            else {
                $ProviderSpecificDetails.TargetAvailabilitySetId = $ReplicationMigrationItem.ProviderSpecificDetail.TargetAvailabilitySetId
            }

            if ($HasTargetAvailabilityZone) {
                $ProviderSpecificDetails.TargetAvailabilityZone = $TargetAvailabilityZone
            }
            else {
                $ProviderSpecificDetails.TargetAvailabilityZone = $ReplicationMigrationItem.ProviderSpecificDetail.TargetAvailabilityZone
            }

            if ($HasSqlServerLicenseType) {
                $validSqlLicenseSpellings = @{ 
                    NoLicenseType = "NoLicenseType";
                    PAYG          = "PAYG";
                    AHUB          = "AHUB"
                }
                $SqlServerLicenseType = $validSqlLicenseSpellings[$SqlServerLicenseType]
                $ProviderSpecificDetails.SqlServerLicenseType = $SqlServerLicenseType
            }
            else {
                $ProviderSpecificDetails.SqlServerLicenseType = $ReplicationMigrationItem.ProviderSpecificDetail.SqlServerLicenseType
            }

            $UserProvidedTag = $null
            if ($HasUpdateTag -And $HasUpdateTagOperation -And $UpdateTag) {
                $operation = @("UpdateTag", $UpdateTagOperation)
                $UserProvidedTag += @{$operation = $UpdateTag }
            }

            if ($HasUpdateVMTag -And $HasUpdateVMTagOperation -And $UpdateVMTag) {
                $operation = @("UpdateVMTag", $UpdateVMTagOperation)
                $UserProvidedTag += @{$operation = $UpdateVMTag }
            }
            else {
                $ProviderSpecificDetails.TargetVmTag = $ReplicationMigrationItem.ProviderSpecificDetail.TargetVmTag
            }

            if ($HasUpdateNicTag -And $HasUpdateNicTagOperation -And $UpdateNicTag) {
                $operation = @("UpdateNicTag", $UpdateNicTagOperation)
                $UserProvidedTag += @{$operation = $UpdateNicTag }
            }
            else {
                $ProviderSpecificDetails.TargetNicTag = $ReplicationMigrationItem.ProviderSpecificDetail.TargetNicTag
            }

            if ($HasUpdateDiskTag -And $HasUpdateDiskTagOperation -And $UpdateDiskTag) {
                $operation = @("UpdateDiskTag", $UpdateDiskTagOperation)
                $UserProvidedTag += @{$operation = $UpdateDiskTag }
            }
            else {
                $ProviderSpecificDetails.TargetDiskTag = $ReplicationMigrationItem.ProviderSpecificDetail.TargetDiskTag
            }

            foreach ($tag in $UserProvidedTag.Keys) {
                $IllegalCharKey = New-Object Collections.Generic.List[String]
                $ExceededLengthKey = New-Object Collections.Generic.List[String]
                $ExceededLengthValue = New-Object Collections.Generic.List[String]
                $ResourceTag = $($UserProvidedTag.Item($tag))

                foreach ($key in $ResourceTag.Keys) {
                    if ($key.length -eq 0) {
                        throw "InvalidTagName : The tag name must be non-null, non-empty and non-whitespace only. Please provide an actual value."
                    }

                    if ($key.length -gt 512) {
                        $ExceededLengthKey.add($key)
                    }

                    if ($key -match "[<>%&\?/.]") {
                        $IllegalCharKey.add($key)
                    }

                    if ($($ResourceTag.Item($key)).length -gt 256) {
                        $ExceededLengthValue.add($($ResourceTag.Item($key)))
                    }
                }

                if ($IllegalCharKey.Count -gt 0) {
                    throw "InvalidTagNameCharacters : The tag names '$($IllegalCharKey -join ', ')' have reserved characters '<,>,%,&,\,?,/' or control characters."
                }

                if ($ExceededLengthKey.Count -gt 0) {
                    throw "InvalidTagName : Tag key too large. Following tag name '$($ExceededLengthKey -join ', ')' exceeded the maximum length. Maximum allowed length for tag name - '512' characters."
                }

                if ($ExceededLengthValue.Count -gt 0) {
                    throw "InvalidTagValueLength : Tag value too large. Following tag value '$($ExceededLengthValue -join ', ')' exceeded the maximum length. Maximum allowed length for tag value - '256' characters."
                }

                if ($tag[1] -eq "Merge") {
                    foreach ($key in $ResourceTag.Keys) {
                        if ($ReplicationMigrationItem.ProviderSpecificDetail.TargetVmTag.ContainsKey($key) -And `
                            ($tag[0] -eq "UpdateVMTag" -or $tag[0] -eq "UpdateTag")) {
                            $ReplicationMigrationItem.ProviderSpecificDetail.TargetVmTag.Remove($key)
                        }

                        if ($ReplicationMigrationItem.ProviderSpecificDetail.TargetNicTag.ContainsKey($key) -And `
                            ($tag[0] -eq "UpdateNicTag" -or $tag[0] -eq "UpdateTag")) {
                            $ReplicationMigrationItem.ProviderSpecificDetail.TargetNicTag.Remove($key)
                        }

                        if ($ReplicationMigrationItem.ProviderSpecificDetail.TargetDiskTag.ContainsKey($key) -And `
                            ($tag[0] -eq "UpdateDiskTag" -or $tag[0] -eq "UpdateTag")) {
                            $ReplicationMigrationItem.ProviderSpecificDetail.TargetDiskTag.Remove($key)
                        }

                        if ($tag[0] -eq "UpdateVMTag" -or $tag[0] -eq "UpdateTag") {
                            $ReplicationMigrationItem.ProviderSpecificDetail.TargetVmTag.Add($key, $($ResourceTag.Item($key)))
                        }

                        if ($tag[0] -eq "UpdateNicTag" -or $tag[0] -eq "UpdateTag") {
                            $ReplicationMigrationItem.ProviderSpecificDetail.TargetNicTag.Add($key, $($ResourceTag.Item($key)))
                        }

                        if ($tag[0] -eq "UpdateDiskTag" -or $tag[0] -eq "UpdateTag") {
                            $ReplicationMigrationItem.ProviderSpecificDetail.TargetDiskTag.Add($key, $($ResourceTag.Item($key)))
                        }
                    }
                    
                    $ProviderSpecificDetails.TargetVmTag = $ReplicationMigrationItem.ProviderSpecificDetail.TargetVmTag
                    $ProviderSpecificDetails.TargetNicTag = $ReplicationMigrationItem.ProviderSpecificDetail.TargetNicTag
                    $ProviderSpecificDetails.TargetDiskTag = $ReplicationMigrationItem.ProviderSpecificDetail.TargetDiskTag
                }
                elseif ($tag[1] -eq "Replace") {
                    if ($tag[0] -eq "UpdateVMTag" -or $tag[0] -eq "UpdateTag") {
                        $ProviderSpecificDetails.TargetVmTag = $ResourceTag
                    }

                    if ($tag[0] -eq "UpdateNicTag" -or $tag[0] -eq "UpdateTag") {
                        $ProviderSpecificDetails.TargetNicTag = $ResourceTag
                    }

                    if ($tag[0] -eq "UpdateDiskTag" -or $tag[0] -eq "UpdateTag") {
                        $ProviderSpecificDetails.TargetDiskTag = $ResourceTag
                    }
                }
                else {
                    foreach ($key in $ResourceTag.Keys) {
                        if (($tag[0] -eq "UpdateVMTag" -or $tag[0] -eq "UpdateTag") `
                                -And $ReplicationMigrationItem.ProviderSpecificDetail.TargetVmTag.ContainsKey($key) `
                                -And ($($ReplicationMigrationItem.ProviderSpecificDetail.TargetVmTag.Item($key)) `
                                    -eq $($ResourceTag.Item($key)))) {
                            $ReplicationMigrationItem.ProviderSpecificDetail.TargetVmTag.Remove($key)
                        }

                        if (($tag[0] -eq "UpdateNicTag" -or $tag[0] -eq "UpdateTag") `
                                -And $ReplicationMigrationItem.ProviderSpecificDetail.TargetNicTag.ContainsKey($key) `
                                -And ($($ReplicationMigrationItem.ProviderSpecificDetail.TargetNicTag.Item($key)) `
                                    -eq $($ResourceTag.Item($key)))) {
                            $ReplicationMigrationItem.ProviderSpecificDetail.TargetNicTag.Remove($key)
                        }

                        if (($tag[0] -eq "UpdateDiskTag" -or $tag[0] -eq "UpdateTag") `
                                -And $ReplicationMigrationItem.ProviderSpecificDetail.TargetDiskTag.ContainsKey($key) `
                                -And ($($ReplicationMigrationItem.ProviderSpecificDetail.TargetDiskTag.Item($key)) `
                                    -eq $($ResourceTag.Item($key)))) {
                            $ReplicationMigrationItem.ProviderSpecificDetail.TargetDiskTag.Remove($key)
                        }
                    }

                    $ProviderSpecificDetails.TargetVmTag = $ReplicationMigrationItem.ProviderSpecificDetail.TargetVmTag
                    $ProviderSpecificDetails.TargetNicTag = $ReplicationMigrationItem.ProviderSpecificDetail.TargetNicTag
                    $ProviderSpecificDetails.TargetDiskTag = $ReplicationMigrationItem.ProviderSpecificDetail.TargetDiskTag
                }

                if ($ProviderSpecificDetails.TargetVmTag.Count -gt 50) {
                    throw "InvalidTags : Too many tags specified. Requested tag count - '$($ProviderSpecificDetails.TargetVmTag.Count)'. Maximum number of tags allowed - '50'."
                }

                if ($ProviderSpecificDetails.TargetNicTag.Count -gt 50) {
                    throw "InvalidTags : Too many tags specified. Requested tag count - '$($ProviderSpecificDetails.TargetNicTag.Count)'. Maximum number of tags allowed - '50'."
                }

                if ($ProviderSpecificDetails.TargetDiskTag.Count -gt 50) {
                    throw "InvalidTags : Too many tags specified. Requested tag count - '$($ProviderSpecificDetails.TargetDiskTag.Count)'. Maximum number of tags allowed - '50'."
                }
            }

            if ($HasTargetNetworkId) {
                $ProviderSpecificDetails.TargetNetworkId = $TargetNetworkId
            }
            else {
                $ProviderSpecificDetails.TargetNetworkId = $ReplicationMigrationItem.ProviderSpecificDetail.TargetNetworkId
            }

            if ($HasTestNetworkId) {
                $ProviderSpecificDetails.TestNetworkId = $TestNetworkId
            }
            else {
                $ProviderSpecificDetails.TestNetworkId = $ReplicationMigrationItem.ProviderSpecificDetail.VMNic[0].TestNetworkId
            }

            if ($HasTargetResourceGroupID) {
                $ProviderSpecificDetails.TargetResourceGroupId = $TargetResourceGroupID
            }
            else {
                $ProviderSpecificDetails.TargetResourceGroupId = $ReplicationMigrationItem.ProviderSpecificDetail.TargetResourceGroupId
            }

            if ($HasTargetVmSize) {
                $ProviderSpecificDetails.TargetVMSize = $TargetVmSize
            }
            else {
                $ProviderSpecificDetails.TargetVMSize = $ReplicationMigrationItem.ProviderSpecificDetail.TargetVmSize
            }

            if ($HasTargetBootDignosticStorageAccount) {
                $ProviderSpecificDetails.TargetBootDiagnosticsStorageAccountId = $TargetBootDiagnosticsStorageAccount
            }
            else {
                $ProviderSpecificDetails.TargetBootDiagnosticsStorageAccountId = $ReplicationMigrationItem.ProviderSpecificDetail.TargetBootDiagnosticsStorageAccountId
            }

            # Storage accounts need to be in the same subscription as that of the VM.
            if (($null -ne $ProviderSpecificDetails.TargetBootDiagnosticsStorageAccountId) -and ($ProviderSpecificDetails.TargetBootDiagnosticsStorageAccountId.length -gt 1)) {
                $TargetBDSASubscriptionId = $ProviderSpecificDetails.TargetBootDiagnosticsStorageAccountId.Split('/')[2]
                $TargetSubscriptionId = $ProviderSpecificDetails.TargetResourceGroupId.Split('/')[2]
                if ($TargetBDSASubscriptionId -ne $TargetSubscriptionId) {
                    $ProviderSpecificDetails.TargetBootDiagnosticsStorageAccountId = $null
                }
            }

            if ($HasTargetVMName) {
                if ($TargetVMName.length -gt 64 -or $TargetVMName.length -eq 0) {
                    throw "The target virtual machine name must be between 1 and 64 characters long."
                }
                $vmId = $ProviderSpecificDetails.TargetResourceGroupId + "/providers/Microsoft.Compute/virtualMachines/" + $TargetVMName
                $VMNamePresentinRg = Get-AzResource -ResourceId $vmId -ErrorVariable notPresent -ErrorAction SilentlyContinue
                if ($VMNamePresentinRg) {
                    throw "The target virtual machine name must be unique in the target resource group."
                }

                if ($TargetVMName -notmatch "^[^_\W][a-zA-Z0-9\-]{0,63}(?<![-._])$") {
                    throw "The target virtual machine name must begin with a letter or number, and can contain only letters, numbers, or hyphens(-). The names cannot contain special characters \/""[]:|<>+=;,?*@&, whitespace, or begin with '_' or end with '.' or '-'."
                }

                $ProviderSpecificDetails.TargetVMName = $TargetVMName
            }
            else {
                $ProviderSpecificDetails.TargetVMName = $ReplicationMigrationItem.ProviderSpecificDetail.TargetVMName
            }

            if ($HasDiskToUpdate) {
                $diskIdDiskTypeMap = @{}
                $originalDisks = $ReplicationMigrationItem.ProviderSpecificDetail.ProtectedDisk

                foreach($DiskObject in $originalDisks) {
                    if ($DiskObject.IsOSDisk -and $DiskObject.IsOSDisk -eq "True") {
                        $previousOsDiskId = $DiskObject.DiskId
                        Break
                    }
                }

                $diskNamePresentinRg = New-Object Collections.Generic.List[String]
                $duplicateDiskName = New-Object System.Collections.Generic.HashSet[String]
                $uniqueDiskUuids = [System.Collections.Generic.HashSet[String]]::new([StringComparer]::InvariantCultureIgnoreCase)
                $osDiskCount = 0
                foreach($DiskObject in $DiskToUpdate) {
                    if ($DiskObject.IsOSDisk -eq "True") {
                        $osDiskCount++
                        $changeOsDiskId = $DiskObject.DiskId
                        if ($osDiskCount -gt 1) {
                            throw "Multiple disks have been selected as OS Disk."
                        }
                    }

                    $matchingUserInputDisk = $null
                    $originalDisks = $ReplicationMigrationItem.ProviderSpecificDetail.ProtectedDisk
                    foreach ($orgDisk in $originalDisks) {
                        if ($orgDisk.DiskId -eq $DiskObject.DiskId)
                        {
                            $matchingUserInputDisk = $orgDisk
                            break
                        }
                    }

                    if ($matchingUserInputDisk -ne $null -and [string]::IsNullOrEmpty($DiskObject.TargetDiskName)) {
                        $DiskObject.TargetDiskName = $matchingUserInputDisk.TargetDiskName
                    }

                    if ($matchingUserInputDisk -ne $null -and [string]::IsNullOrEmpty($DiskObject.IsOSDisk)) {
                        $DiskObject.IsOSDisk = $matchingUserInputDisk.IsOSDisk
                    }

                    $diskId = $ProviderSpecificDetails.TargetResourceGroupId + "/providers/Microsoft.Compute/disks/" + $DiskObject.TargetDiskName
                    $diskNamePresent = Get-AzResource -ResourceId $diskId -ErrorVariable notPresent -ErrorAction SilentlyContinue
                    if ($diskNamePresent) {
                        $diskNamePresentinRg.Add($DiskObject.TargetDiskName)
                    }

                    if ($uniqueDiskUuids.Contains($DiskObject.DiskId)) {
                        throw "The disk uuid '$($DiskObject.DiskId)' is already taken."
                    }
                    $res = $uniqueDiskUuids.Add($DiskObject.DiskId)

                    if ($duplicateDiskName.Contains($DiskObject.TargetDiskName)) {
                        throw "The disk name '$($DiskObject.TargetDiskName)' is already taken."
                    }
                    $res = $duplicateDiskName.Add($DiskObject.TargetDiskName)
                }
                if ($diskNamePresentinRg) {
                    throw "Disks with name $($diskNamePresentinRg -join ', ')' already exists in the target resource group."
                }

                foreach($DiskObject in $DiskToUpdate) {
                    if ($DiskObject.IsOSDisk) {
                        $diskIdDiskTypeMap.Add($DiskObject.DiskId, $DiskObject.IsOSDisk)
                    }
                }

                if ($changeOsDiskId -ne $null -and $changeOsDiskId -ne $previousOsDiskId) {
                    if ($diskIdDiskTypeMap.ContainsKey($previousOsDiskId)) {
                        $rem = $diskIdDiskTypeMap.Remove($previousOsDiskId)
                        foreach($DiskObject in $DiskToUpdate) {
                            if ($DiskObject.DiskId -eq $previousOsDiskId) {
                                $DiskObject.IsOsDisk = "False"
                            }
                        }
                    }
                    else {
                        $updateDisk = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202301.VMwareCbtUpdateDiskInput]::new()
                        $updateDisk.DiskId = $previousOsDiskId
                        $updateDisk.IsOSDisk = "False"
                        $originalDisks = $ReplicationMigrationItem.ProviderSpecificDetail.ProtectedDisk
                        foreach ($orgDisk in $originalDisks) {
                           if ($orgDisk.DiskId -eq $previousOsDiskId) {
                               $updateDisk.TargetDiskName = $orgDisk.TargetDiskName
                               break
                            }
                        }
                        $DiskToUpdate += $updateDisk
                    }
                    $diskIdDiskTypeMap.Add($previousOsDiskId, "False")
                }

                $osDiskCount = 0

                foreach ($DiskObject in $originalDisks) {
                   if ($diskIdDiskTypeMap.Contains($DiskObject.DiskId)) {
                       if ($diskIdDiskTypeMap.($DiskObject.DiskId) -eq "True") {
                           $osDiskCount++
                       }
                   }
                   elseif ($DiskObject.IsOSDisk -eq "True") {
                       $osDiskCount++
                   }
                }

                if ($osDiskCount -eq 0) {
                   throw "OS disk cannot be excluded from migration."
                }
                elseif ($osDiskCount -ne 1) {
                   throw "Multiple disks have been selected as OS Disk."
                }
               $ProviderSpecificDetails.VMDisK = $DiskToUpdate
            }

            if ($HasTargetDiskName) {
                if ($TargetDiskName.length -gt 80 -or $TargetDiskName.length -eq 0) {
                    throw "The disk name must be between 1 and 80 characters long."
                }

                if ($TargetDiskName -notmatch "^[^_\W][a-zA-Z0-9_\-\.]{0,79}(?<![-.])$") {
                    throw "The disk name must begin with a letter or number, end with a letter, number or underscore, and may contain only letters, numbers, underscores, periods, or hyphens."
                }

                $diskId = $ProviderSpecificDetails.TargetResourceGroupId + "/providers/Microsoft.Compute/disks/" + $TargetDiskName
                $diskNamePresent = Get-AzResource -ResourceId $diskId -ErrorVariable notPresent -ErrorAction SilentlyContinue

                if ($diskNamePresent) {
                    throw "A disk with name $($TargetDiskName)' already exists in the target resource group."
                }

                [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202301.IVMwareCbtUpdateDiskInput[]]$updateDisksArray = @()
                $originalDisks = $ReplicationMigrationItem.ProviderSpecificDetail.ProtectedDisk
                foreach ($DiskObject in $originalDisks) {
                    if ( $DiskObject.IsOSDisk) {
                        $updateDisk = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202301.VMwareCbtUpdateDiskInput]::new()
                        $updateDisk.DiskId = $DiskObject.DiskId
                        $updateDisk.TargetDiskName = $TargetDiskName
                        $updateDisksArray += $updateDisk
                        $ProviderSpecificDetails.VMDisk = $updateDisksArray
                        break
                    }
                }
            }

            $originalNics = $ReplicationMigrationItem.ProviderSpecificDetail.VMNic
            [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202301.IVMwareCbtNicInput[]]$updateNicsArray = @()
            $nicNamePresentinRg = New-Object Collections.Generic.List[String]
            $duplicateNicName = New-Object System.Collections.Generic.HashSet[String]

            foreach ($storedNic in $originalNics) {
                $updateNic = [Microsoft.Azure.PowerShell.Cmdlets.Migrate.Models.Api202301.VMwareCbtNicInput]::new()
                $updateNic.IsPrimaryNic = $storedNic.IsPrimaryNic
                $updateNic.IsSelectedForMigration = $storedNic.IsSelectedForMigration
                $updateNic.NicId = $storedNic.NicId
                $updateNic.TargetStaticIPAddress = $storedNic.TargetIPAddress
                $updateNic.TestStaticIPAddress = $storedNic.TestIPAddress
                $updateNic.TargetSubnetName = $storedNic.TargetSubnetName
                $updateNic.TestSubnetName = $storedNic.TestSubnetName
                $updateNic.TargetNicName = $storedNic.TargetNicName

                $matchingUserInputNic = $null
                if ($HasNicToUpdate) {
                    foreach ($userInputNic in $NicToUpdate) {
                        if ($userInputNic.NicId -eq $storedNic.NicId) {
                            $matchingUserInputNic = $userInputNic
                            break
                        }
                    }
                }
                if ($null -ne $matchingUserInputNic) {
                    if ($null -ne $matchingUserInputNic.IsPrimaryNic) {
                        $updateNic.IsPrimaryNic = $matchingUserInputNic.IsPrimaryNic
                        $updateNic.IsSelectedForMigration = $matchingUserInputNic.IsSelectedForMigration
                        if ($updateNic.IsSelectedForMigration -eq "false") {
                            $updateNic.TargetSubnetName = ""
                            $updateNic.TargetStaticIPAddress = ""
                        }
                    }
                    if ($null -ne $matchingUserInputNic.TargetSubnetName) {
                        $updateNic.TargetSubnetName = $matchingUserInputNic.TargetSubnetName
                    }
                    if ($null -ne $matchingUserInputNic.TestSubnetName) {
                        $updateNic.TestSubnetName = $matchingUserInputNic.TestSubnetName
                    }
                    if ($null -ne $matchingUserInputNic.TargetNicName) {
                        $nicId = $ProviderSpecificDetails.TargetResourceGroupId + "/providers/Microsoft.Network/networkInterfaces/" + $matchingUserInputNic.TargetNicName
                        $nicNamePresent = Get-AzResource -ResourceId $nicId -ErrorVariable notPresent -ErrorAction SilentlyContinue

                        if ($nicNamePresent) {
                            $nicNamePresentinRg.Add($matchingUserInputNic.TargetNicName)
                        }
                        $updateNic.TargetNicName = $matchingUserInputNic.TargetNicName

                        if ($duplicateNicName.Contains($matchingUserInputNic.TargetNicName)) {
                            throw "The NIC name '$($matchingUserInputNic.TargetNicName)' is already taken."
                        }
                        $res = $duplicateNicName.Add($matchingUserInputNic.TargetNicName)
                    }
                    if ($null -ne $matchingUserInputNic.TargetStaticIPAddress) {
                        if ($matchingUserInputNic.TargetStaticIPAddress -eq "auto") {
                            $updateNic.TargetStaticIPAddress = $null
                        }
                        else {
                            $isValidIpAddress = [ipaddress]::TryParse($matchingUserInputNic.TargetStaticIPAddress,[ref][ipaddress]::Loopback)
                             if(!$isValidIpAddress) {
                                 throw "(InvalidPrivateIPAddressFormat) Static IP address value '$($matchingUserInputNic.TargetStaticIPAddress)' is invalid."
                             }
                             $updateNic.TargetStaticIPAddress = $matchingUserInputNic.TargetStaticIPAddress
                        }
                    }
                    if ($null -ne $matchingUserInputNic.TestStaticIPAddress) {
                        if ($matchingUserInputNic.TestStaticIPAddress -eq "auto") {
                            $updateNic.TestStaticIPAddress = $null
                        }
                        else {
                            $isValidIpAddress = [ipaddress]::TryParse($matchingUserInputNic.TestStaticIPAddress,[ref][ipaddress]::Loopback)
                             if(!$isValidIpAddress) {
                                 throw "(InvalidPrivateIPAddressFormat) Static IP address value '$($matchingUserInputNic.TestStaticIPAddress)' is invalid."
                             }
                             $updateNic.TestStaticIPAddress = $matchingUserInputNic.TestStaticIPAddress
                        }
                    }
                }
                $updateNicsArray += $updateNic
            }

            # validate there is exactly one primary nic
            $primaryNicCountInUpdate = 0
            foreach ($nic in $updateNicsArray) {
                if ($nic.IsPrimaryNic -eq "true") {
                    $primaryNicCountInUpdate += 1
                }
            }
            if ($primaryNicCountInUpdate -ne 1) {
                throw "One NIC has to be Primary."
            }

            if ($nicNamePresentinRg) {
                throw "NIC name '$($nicNamePresentinRg -join ', ')' must be unique in the target resource group."
            }

            $ProviderSpecificDetails.VMNic = $updateNicsArray
            $null = $PSBoundParameters.Add('ProviderSpecificDetail', $ProviderSpecificDetails)
            $null = $PSBoundParameters.Add('NoWait', $true)
            $output = Az.Migrate.internal\Update-AzMigrateReplicationMigrationItem @PSBoundParameters
            $JobName = $output.Target.Split("/")[12].Split("?")[0]

            $null = $PSBoundParameters.Remove('NoWait')
            $null = $PSBoundParameters.Remove('ProviderSpecificDetail')
            $null = $PSBoundParameters.Remove("ResourceGroupName")
            $null = $PSBoundParameters.Remove("ResourceName")
            $null = $PSBoundParameters.Remove("FabricName")
            $null = $PSBoundParameters.Remove("MigrationItemName")
            $null = $PSBoundParameters.Remove("ProtectionContainerName")

            $null = $PSBoundParameters.Add('JobName', $JobName)
            $null = $PSBoundParameters.Add('ResourceName', $VaultName)
            $null = $PSBoundParameters.Add('ResourceGroupName', $ResourceGroupName)

            return Az.Migrate.internal\Get-AzMigrateReplicationJob @PSBoundParameters
        }
        else {
            throw "Either machine doesn't exist or provider/action isn't supported for this machine"
        }
    }
}   
# SIG # Begin signature block
# MIIn0AYJKoZIhvcNAQcCoIInwTCCJ70CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCBsRK2yyQd0eLuC
# 2qF7rs/7N5iJQ9mF74PK5efOLfLlRqCCDYUwggYDMIID66ADAgECAhMzAAADri01
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
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGaEwghmdAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAAOuLTVRyFOPVR0AAAAA
# A64wDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIAKY
# HOivLzqzRlkPJlUgPhlbnOpUJbvsGTVPBpe6fsovMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAiSFn+9gjPXmKfmTNqkZj/9zr5nxD1A5vQpDW
# D7Tc2Ybc62xcq4zIlkb5OXp7GZ/yHeN2G037NrfuTQjtOnDgseeoeq45NFCfPltP
# I5VEMdJeAVDzugPAehibwCEDvjIiO8I2u6FCESwALGUtb3QqSFcBIDIkyi+a5d3p
# pCMqTdyYfODbN+pDbUcDB4JpYsnT5oVKdVfxKUvrI7m6Zp3ilHfGZ9PB+mbRNC7W
# lVmgSTb916aSqF98epnyR5ibYfpAmEp9KWQgx3eRb7pjhuhXANBgCMpylzCx/g6/
# uPBvZNdY3c+ivZhu+HZRQsT6UeDQ79EYvlaE2ME+PqvgFOThJ6GCFyswghcnBgor
# BgEEAYI3AwMBMYIXFzCCFxMGCSqGSIb3DQEHAqCCFwQwghcAAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFZBgsqhkiG9w0BCRABBKCCAUgEggFEMIIBQAIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCA4ddMLRQQgxTtlCLoDGoP/SuXVJd9mAZrQ
# vHiCTKHvzQIGZa7XMz5XGBMyMDI0MDEzMDA1MDQ1Ny4zOTlaMASAAgH0oIHYpIHV
# MIHSMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQL
# EyRNaWNyb3NvZnQgSXJlbGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJjAkBgNVBAsT
# HVRoYWxlcyBUU1MgRVNOOkZDNDEtNEJENC1EMjIwMSUwIwYDVQQDExxNaWNyb3Nv
# ZnQgVGltZS1TdGFtcCBTZXJ2aWNloIIRejCCBycwggUPoAMCAQICEzMAAAHimZmV
# 8dzjIOsAAQAAAeIwDQYJKoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# UENBIDIwMTAwHhcNMjMxMDEyMTkwNzI1WhcNMjUwMTEwMTkwNzI1WjCB0jELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9z
# b2Z0IElyZWxhbmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMg
# VFNTIEVTTjpGQzQxLTRCRDQtRDIyMDElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgU2VydmljZTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALVj
# tZhV+kFmb8cKQpg2mzisDlRI978Gb2amGvbAmCd04JVGeTe/QGzM8KbQrMDol7DC
# 7jS03JkcrPsWi9WpVwsIckRQ8AkX1idBG9HhyCspAavfuvz55khl7brPQx7H99UJ
# bsE3wMmpmJasPWpgF05zZlvpWQDULDcIYyl5lXI4HVZ5N6MSxWO8zwWr4r9xkMmU
# Xs7ICxDJr5a39SSePAJRIyznaIc0WzZ6MFcTRzLLNyPBE4KrVv1LFd96FNxAzwne
# tSePg88EmRezr2T3HTFElneJXyQYd6YQ7eCIc7yllWoY03CEg9ghorp9qUKcBUfF
# cS4XElf3GSERnlzJsK7s/ZGPU4daHT2jWGoYha2QCOmkgjOmBFCqQFFwFmsPrZj4
# eQszYxq4c4HqPnUu4hT4aqpvUZ3qIOXbdyU42pNL93cn0rPTTleOUsOQbgvlRdth
# FCBepxfb6nbsp3fcZaPBfTbtXVa8nLQuMCBqyfsebuqnbwj+lHQfqKpivpyd7KCW
# ACoj78XUwYqy1HyYnStTme4T9vK6u2O/KThfROeJHiSg44ymFj+34IcFEhPogaKv
# NNsTVm4QbqphCyknrwByqorBCLH6bllRtJMJwmu7GRdTQsIx2HMKqphEtpSm1z3u
# fASdPrgPhsQIRFkHZGuihL1Jjj4Lu3CbAmha0lOrAgMBAAGjggFJMIIBRTAdBgNV
# HQ4EFgQURIQOEdq+7QdslptJiCRNpXgJ2gUwHwYDVR0jBBgwFoAUn6cVXQBeYl2D
# 9OXSZacbUzUZ6XIwXwYDVR0fBFgwVjBUoFKgUIZOaHR0cDovL3d3dy5taWNyb3Nv
# ZnQuY29tL3BraW9wcy9jcmwvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
# MDIwMTAoMSkuY3JsMGwGCCsGAQUFBwEBBGAwXjBcBggrBgEFBQcwAoZQaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNyb3NvZnQlMjBUaW1l
# LVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcnQwDAYDVR0TAQH/BAIwADAWBgNVHSUB
# Af8EDDAKBggrBgEFBQcDCDAOBgNVHQ8BAf8EBAMCB4AwDQYJKoZIhvcNAQELBQAD
# ggIBAORURDGrVRTbnulfsg2cTsyyh7YXvhVU7NZMkITAQYsFEPVgvSviCylr5ap3
# ka76Yz0t/6lxuczI6w7tXq8n4WxUUgcj5wAhnNorhnD8ljYqbck37fggYK3+wEwL
# hP1PGC5tvXK0xYomU1nU+lXOy9ZRnShI/HZdFrw2srgtsbWow9OMuADS5lg7okrX
# a2daCOGnxuaD1IO+65E7qv2O0W0sGj7AWdOjNdpexPrspL2KEcOMeJVmkk/O0gan
# hFzzHAnWjtNWneU11WQ6Bxv8OpN1fY9wzQoiycgvOOJM93od55EGeXxfF8bofLVl
# UE3zIikoSed+8s61NDP+x9RMya2mwK/Ys1xdvDlZTHndIKssfmu3vu/a+BFf2uIo
# ycVTvBQpv/drRJD68eo401mkCRFkmy/+BmQlRrx2rapqAu5k0Nev+iUdBUKmX/iO
# aKZ75vuQg7hCiBA5xIm5ZIXDSlX47wwFar3/BgTwntMq9ra6QRAeS/o/uYWkmvqv
# E8Aq38QmKgTiBnWSS/uVPcaHEyArnyFh5G+qeCGmL44MfEnFEhxc3saPmXhe6MhS
# gCIGJUZDA7336nQD8fn4y6534Lel+LuT5F5bFt0mLwd+H5GxGzObZmm/c3pEWtHv
# 1ug7dS/Dfrcd1sn2E4gk4W1L1jdRBbK9xwkMmwY+CHZeMSvBMIIHcTCCBVmgAwIB
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
# Y1NNje6CbaUFEMFxBmoQtB1VM1izoXBm8qGCAtYwggI/AgEBMIIBAKGB2KSB1TCB
# 0jELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
# ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMk
# TWljcm9zb2Z0IElyZWxhbmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1U
# aGFsZXMgVFNTIEVTTjpGQzQxLTRCRDQtRDIyMDElMCMGA1UEAxMcTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgU2VydmljZaIjCgEBMAcGBSsOAwIaAxUAFpuZafp0bnpJdIhf
# iB1d8pTohm+ggYMwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAN
# BgkqhkiG9w0BAQUFAAIFAOlij/4wIhgPMjAyNDAxMzAwNDU4MzhaGA8yMDI0MDEz
# MTA0NTgzOFowdjA8BgorBgEEAYRZCgQBMS4wLDAKAgUA6WKP/gIBADAJAgEAAgFx
# AgH/MAcCAQACAhFFMAoCBQDpY+F+AgEAMDYGCisGAQQBhFkKBAIxKDAmMAwGCisG
# AQQBhFkKAwKgCjAIAgEAAgMHoSChCjAIAgEAAgMBhqAwDQYJKoZIhvcNAQEFBQAD
# gYEAwXK5ysPO/ENvxjbGeJSx6cTOmUU1xyd7TLcEKhe60Qtu1i7Dti1qo3z+IoKv
# 5XShKj/Hbmcwfd68PnalzGDFRaceUWHbB+GezKq9i8Z3VKqLy5mOErDm54HlNuIS
# OkEFvHehwvtvWcpmHbmgEwmkZ+mWT53hCnHA8ggsek/CfqoxggQNMIIECQIBATCB
# kzB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQD
# Ex1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAeKZmZXx3OMg6wAB
# AAAB4jANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJ
# EAEEMC8GCSqGSIb3DQEJBDEiBCC4sT0eIf5gJ9tu1T4d8/vvDbX3QNlYOBKyKAnp
# 4LO+TDCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EICuJKkoQ/Sa4xsFQRM4O
# gvh3ktToj9uO5whmQ4kIj3//MIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAg
# UENBIDIwMTACEzMAAAHimZmV8dzjIOsAAQAAAeIwIgQgUIv38xy3mgTiG4skuSQu
# IQjRQ5OhbSRaEkCF2AFVQPYwDQYJKoZIhvcNAQELBQAEggIACv0bpBSPcMBl76kj
# 8lYaOewoVK1pjeuaMu5vlAc3qUc6hecqyZr05k/xTGLKE6/8o1x2vXV0oTl/aEvs
# kzNett+1sruPaDSlFA3GObG0rv3psVbu9HFkmNckc9zQOOVaWyYYuKuiHLl91pvM
# ZdCXr2HxCG1S7Uiq0+mSoOEK8gRM09VsvOVvoUfjrEpxBiEborz2ISY71bA245sQ
# DrSdIgyJ77piZ1V5St6MxLZyjW23KNpC36HotmSXRvLcCxHEw7rnjp8ndvd40hT1
# 52AYANwBpADA8rucYM7QasZQOpy8kD8fYdrpMhHDyFXlvJ5+diPL39+vTuKvgKcD
# NgCB5pkPbYb1rrlSqh66bclauA26M9HPbzDgovdNbo2iNPP2aKylxwS5+WcAgklo
# WEgoObGWIBP4qvs5OpB5xoVfwVP+ZWw3s7Vos9iB8k+u61YjovQr21NR7/arC2+1
# evDESyfrnLnSTZj5/JIRdbrNUlsAlbSTgfDBbNGxRllhchF6Hsw6w/9IfIbUixnx
# ADW14Mfk7hCeMNpv5K7V8/yRaMFxy/OFa0DE4cCBQ1qqzFqyev1KqLF0ug9OZlnY
# xysVKzU2i14slBtcZhtS3k/aSHm5VL2Eh20YcqT+R4y8n1ICjASy/qtwTUf4TdC3
# ntIbO0D2SkmICLusLEpgpoleujo=
# SIG # End signature block
