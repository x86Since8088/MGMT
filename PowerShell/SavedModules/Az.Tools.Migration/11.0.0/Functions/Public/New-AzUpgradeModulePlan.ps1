function New-AzUpgradeModulePlan
{
    <#
    .SYNOPSIS
        Generates a new upgrade plan for migrating to the Az PowerShell module.

    .DESCRIPTION
        Generates a new upgrade plan for migrating to the Az PowerShell module. The upgrade plan details the specific file/offset points that require changes when moving from AzureRM commands to Az commands.

    .PARAMETER FromAzureRmVersion
        Specifies the AzureRM module version used in your existing PowerShell scripts(s) or modules.

    .PARAMETER ToAzVersion
        Specifies the Az module version to upgrade to. Currently, only Az version 10.3 is supported.

    .PARAMETER FilePath
        Specifies the path to a single PowerShell file.

    .PARAMETER DirectoryPath
        Specifies the path to a folder where PowerShell scripts or modules reside.

    .PARAMETER AzureRmCmdReference
        Specifies the AzureRM command references output from the Find-AzUpgradeCommandReference cmdlet.

    .PARAMETER AzureRmModuleSpec
        Specifies an optional parameter to provide a pre-loaded AzureRM module spec, returned from Get-AzUpgradeCmdletSpec.

    .PARAMETER AzModuleSpec
        Specifies an optional parameter to provide a pre-loaded Az module spec, returned from Get-AzUpgradeCmdletSpec.

    .PARAMETER AzAliasMappingSpec
        Specifies an optional parameter to provide a pre-loaded Az cmdlet alias mapping table, returned from Get-AzUpgradeAliasSpec.

    .EXAMPLE
        The following example generates a new Az module upgrade plan for the script file 'C:\Scripts\my-azure-script.ps1'.

        New-AzUpgradeModulePlan -FromAzureRmVersion 6.13.1 -ToAzVersion latest -FilePath 'C:\Scripts\my-azure-script.ps1'

    .EXAMPLE
        The following example generates a new Az module upgrade plan for the script and module files located under C:\Scripts.

        New-AzUpgradeModulePlan -FromAzureRmVersion 6.13.1 -ToAzVersion latest -DirectoryPath 'C:\Scripts'

    .EXAMPLE
        The following example generates a new Az module upgrade plan for the script and module files under C:\Scripts.

        $references = Find-AzUpgradeCommandReference -DirectoryPath 'C:\Scripts' -AzureRmVersion '6.13.1'
        New-AzUpgradeModulePlan -ToAzVersion latest -AzureRmCmdReference $references

    .EXAMPLE
        The following example generates a new Az module upgrade plan for the script and module files under several directories.
        Module specs are pre-loaded here to avoid re-loading the spec each time a plan is generated.

        # pre-load specifications
        $armSpec = Get-AzUpgradeCmdletSpec -AzureRM
        $azSpec = Get-AzUpgradeCmdletSpec -Az -ModuleVersion latest
        $azAliases = Get-AzUpgradeAliasSpec -ModuleVersion latest

        # execute a batch of module upgrades
        $plan1 = New-AzUpgradeModulePlan -DirectoryPath 'C:\Scripts1' -FromAzureRmVersion '6.13.1' -ToAzVersion latest -AzureRmModuleSpec $armSpec -AzModuleSpec $azSpec -AzAliasMappingSpec $azAliases
        $plan2 = New-AzUpgradeModulePlan -DirectoryPath 'C:\Scripts2' -FromAzureRmVersion '6.13.1' -ToAzVersion latest -AzureRmModuleSpec $armSpec -AzModuleSpec $azSpec -AzAliasMappingSpec $azAliases
        $plan3 = New-AzUpgradeModulePlan -DirectoryPath 'C:\Scripts3' -FromAzureRmVersion '6.13.1' -ToAzVersion latest -AzureRmModuleSpec $armSpec -AzModuleSpec $azSpec -AzAliasMappingSpec $azAliases
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(
            Mandatory=$true,
            ParameterSetName="FromReferences",
            HelpMessage='Specify the AzureRM command references collection output from the Find-AzUpgradeCommandReference cmdlet.')]
        [CommandReference[]]
        $AzureRmCmdReference,

        [Parameter(
            Mandatory=$true,
            ParameterSetName="FromNewSearchByFile",
            HelpMessage='Specify the Az module version to upgrade to.')]
        [Parameter(
            Mandatory=$true,
            ParameterSetName="FromNewSearchByDirectory",
            HelpMessage='Specify the Az module version to upgrade to.')]
        [System.String]
        [ValidateSet('6.13.1')]
        $FromAzureRmVersion,

        [Parameter(
            Mandatory=$true,
            ParameterSetName="FromNewSearchByFile",
            HelpMessage="Specify the path to a single PowerShell file.")]
        [System.String]
        [ValidateNotNullOrEmpty()]
        $FilePath,

        [Parameter(
            Mandatory=$true,
            ParameterSetName="FromNewSearchByDirectory",
            HelpMessage="Specify the path to the folder where PowerShell scripts or modules reside.")]
        [System.String]
        [ValidateNotNullOrEmpty()]
        $DirectoryPath,

        [Parameter(
            Mandatory=$true,
            HelpMessage='Specify the Az module version to upgrade to.')]
        [System.String]
        [ValidateSet('latest')]
        $ToAzVersion,

        [Parameter(Mandatory=$false)]
        [System.Collections.Generic.Dictionary[System.String, CommandDefinition]]
        $AzureRmModuleSpec,

        [Parameter(Mandatory=$false)]
        [System.Collections.Generic.Dictionary[System.String, CommandDefinition]]
        $AzModuleSpec,

        [Parameter(Mandatory=$false)]
        [System.Collections.Generic.Dictionary[System.String, System.String]]
        $AzAliasMappingSpec
    )
    Process
    {
        $cmdStarted = Get-Date

        $versionPath = Join-Path -Path $MyInvocation.MyCommand.Module.ModuleBase -ChildPath "\Resources\ModuleSpecs\Az\$ToAzVersion"
        $version = Get-ChildItem -Path $versionPath -Name

        # if an existing set of command references was not provided
        # then call the Find cmdlet to search for those references.

        if ($PSCmdlet.ParameterSetName -eq 'FromNewSearchByFile')
        {
            $FilePath = (Resolve-Path $FilePath).Path
            if ($PSBoundParameters.ContainsKey('AzureRmModuleSpec'))
            {
                Write-Verbose -Message "Searching for commands to upgrade, by file, with pre-loaded module spec."
                $AzureRmCmdReference = Find-AzUpgradeCommandReference -FilePath $FilePath -AzureRmModuleSpec $AzureRmModuleSpec
            }
            else
            {
                Write-Verbose -Message "Searching for commands to upgrade, by file."
                $AzureRmCmdReference = Find-AzUpgradeCommandReference -FilePath $FilePath -AzureRmVersion $FromAzureRmVersion
            }
        }
        elseif ($PSCmdlet.ParameterSetName -eq 'FromNewSearchByDirectory')
        {
            $DirectoryPath = (Resolve-Path $DirectoryPath).Path
            if ($PSBoundParameters.ContainsKey('AzureRmModuleSpec'))
            {
                Write-Verbose -Message "Searching for commands to upgrade, by directory, with pre-loaded module spec."
                $AzureRmCmdReference = Find-AzUpgradeCommandReference -DirectoryPath $DirectoryPath -AzureRmModuleSpec $AzureRmModuleSpec
            }
            else
            {
                Write-Verbose -Message "Searching for commands to upgrade, by directory."
                $AzureRmCmdReference = Find-AzUpgradeCommandReference -DirectoryPath $DirectoryPath -AzureRmVersion $FromAzureRmVersion
            }
        }

        # we can't generate an upgrade plan without some cmdlet references, so quit early here if required.

        if ($AzureRmCmdReference -eq $null -or $AzureRmCmdReference.Count -eq 0)
        {
            Write-Verbose -Message "No AzureRm command references were found. No upgrade plan will be generated."
            return
        }
        else
        {
            Write-Verbose -Message "$($AzureRmCmdReference.Count) AzureRm command reference(s) were found. Upgrade plan will be generated."
        }

        if ($PSBoundParameters.ContainsKey('AzModuleSpec') -eq $false)
        {

            Write-Verbose -Message "Importing cmdlet spec for Az $version"
            $AzModuleSpec = Get-AzUpgradeCmdletSpec -Az -ModuleVersion $ToAzVersion
        }
        else
        {
            Write-Verbose -Message "Az module spec was provided at runtime, skipping module spec import."
        }

        if ($PSBoundParameters.ContainsKey('AzAliasMappingSpec') -eq $false)
        {
            Write-Verbose -Message "Importing alias mapping spec for Az $version"
            $AzAliasMappingSpec = Get-AzUpgradeAliasSpec -ModuleVersion $ToAzVersion
        }
        else
        {
            Write-Verbose -Message "Az alias mapping spec was provided at runtime, skipping alias spec import."
        }

        $defaultParamNames = @("Debug", "ErrorAction", "ErrorVariable", "InformationAction", "InformationVariable", "OutVariable", "OutBuffer", "PipelineVariable", "Verbose", "WarningAction", "WarningVariable", "WhatIf", "Confirm")

        # synchronous results output instead of async. the reason for this is that
        # we need to sort the object results before returning them to the caller.

        $planSteps = New-Object -TypeName 'System.Collections.Generic.List[UpgradePlan]'
        $planWarningSteps = New-Object -TypeName 'System.Collections.Generic.List[UpgradePlan]'
        $planErrorSteps = New-Object -TypeName 'System.Collections.Generic.List[UpgradePlan]'

        foreach ($rmCmdlet in $AzureRmCmdReference)
        {
            Write-Verbose -Message "Checking upgrade potential for instance of $($rmCmdlet.CommandName)"

            if ($AzAliasMappingSpec.ContainsKey($rmCmdlet.CommandName) -eq $false)
            {
                $errorResult = New-Object -TypeName UpgradePlan
                $errorResult.UpgradeType = [UpgradeStepType]::Cmdlet
                $errorResult.SourceCommand = $rmCmdlet
                $errorResult.FullPath = $rmCmdlet.FullPath
                $errorResult.StartOffset = $rmCmdlet.StartOffset
                $errorResult.Location = $rmCmdlet.Location
                $errorResult.Original = $rmCmdlet.CommandName
                $errorResult.PlanResultReason = "No matching upgrade alias found. Command cannot be automatically upgraded."
                $errorResult.PlanResult = [PlanResultReasonCode]::ErrorNoUpgradeAlias
                $errorResult.PlanSeverity = [DiagnosticSeverity]::Error

                $planErrorSteps.Add($errorResult)

                continue
            }

            $resolvedCommandName = $AzAliasMappingSpec[$rmCmdlet.CommandName]

            if ($AzModuleSpec.ContainsKey($resolvedCommandName) -eq $false)
            {
                $errorResult = New-Object -TypeName UpgradePlan
                $errorResult.UpgradeType = [UpgradeStepType]::Cmdlet
                $errorResult.SourceCommand = $rmCmdlet
                $errorResult.FullPath = $rmCmdlet.FullPath
                $errorResult.StartOffset = $rmCmdlet.StartOffset
                $errorResult.Location = $rmCmdlet.Location
                $errorResult.Original = $rmCmdlet.CommandName
                $errorResult.PlanResultReason = "No Az cmdlet spec found for $resolvedCommandName. Command cannot be automatically upgraded."
                $errorResult.PlanResult = [PlanResultReasonCode]::ErrorNoModuleSpecMatch
                $errorResult.PlanSeverity = [DiagnosticSeverity]::Error

                $planErrorSteps.Add($errorResult)

                continue
            }

            $cmdletUpgrade = New-Object -TypeName UpgradePlan
            $cmdletUpgrade.Original = $rmCmdlet.CommandName
            $cmdletUpgrade.Replacement = $resolvedCommandName
            $cmdletUpgrade.UpgradeType = [UpgradeStepType]::Cmdlet
            $cmdletUpgrade.SourceCommand = $rmCmdlet
            $cmdletUpgrade.FullPath = $rmCmdlet.FullPath
            $cmdletUpgrade.StartOffset = $rmCmdlet.StartOffset
            $cmdletUpgrade.Location = $rmCmdlet.Location

            $cmdletUpgrade.PlanResultReason = "Command can be automatically upgraded."
            $cmdletUpgrade.PlanResult = [PlanResultReasonCode]::ReadyToUpgrade
            $cmdletUpgrade.PlanSeverity = [DiagnosticSeverity]::Information
            $planSteps.Add($cmdletUpgrade)

            # check if parameters need to be updated

            if ($rmCmdlet.Parameters.Count -gt 0)
            {
                $resolvedAzCommand = $AzModuleSpec[$resolvedCommandName]

                foreach ($rmParam in $rmCmdlet.Parameters)
                {
                    if ($defaultParamNames -contains $rmParam.Name)
                    {
                        # direct match to a built-in default parameter
                        # no changes required.
                        continue
                    }

                    $matchedDirectName = $resolvedAzCommand.Parameters | Where-Object -FilterScript { $_.Name -eq $rmParam.Name }

                    if ($matchedDirectName -ne $null)
                    {
                        # direct match to the upgraded cmdlet's parameter name.
                        # no changes required.
                        continue
                    }

                    $matchedAliasName = $resolvedAzCommand.Parameters | Where-Object -FilterScript { $_.Aliases -contains $rmParam.Name }

                    if ($matchedAliasName -ne $null)
                    {
                        # alias match to the upgraded cmdlet's parameter name.
                        # we should add an upgrade step to swap to use the non-aliased name.

                        $paramUpgrade = New-Object -TypeName UpgradePlan
                        $paramUpgrade.Original = $rmParam.Name
                        $paramUpgrade.Replacement = $matchedAliasName.Name
                        $paramUpgrade.UpgradeType = [UpgradeStepType]::CmdletParameter
                        $paramUpgrade.SourceCommand = $rmCmdlet
                        $paramUpgrade.FullPath = $rmCmdlet.FullPath
                        $paramUpgrade.StartOffset = $rmParam.StartOffset
                        $paramUpgrade.SourceCommandParameter = $rmParam
                        $paramUpgrade.Location = $rmParam.Location
                        $paramUpgrade.PlanResultReason = "Command parameter can be automatically upgraded."
                        $paramUpgrade.PlanResult = [PlanResultReasonCode]::ReadyToUpgrade
                        $paramUpgrade.PlanSeverity = [DiagnosticSeverity]::Information

                        $planSteps.Add($paramUpgrade)

                        continue
                    }

                    # no direct match and no alias match?
                    # this could mean a breaking change that requires manual adjustments, or it could be a dynamic parameter.

                    if ($resolvedAzCommand.SupportsDynamicParameters)
                    {
                        $paramWarning = New-Object -TypeName UpgradePlan
                        $paramWarning.Original = $rmParam.Name
                        $paramWarning.UpgradeType = [UpgradeStepType]::CmdletParameter
                        $paramWarning.SourceCommand = $rmCmdlet
                        $paramWarning.FullPath = $rmCmdlet.FullPath
                        $paramWarning.StartOffset = $rmParam.StartOffset
                        $paramWarning.SourceCommandParameter = $rmParam
                        $paramWarning.Location = $rmParam.Location
                        $paramWarning.PlanResultReason = "Parameter was not found in $resolvedCommandName or its aliases, but this may not be a problem because this cmdlet also supports dynamic parameters."
                        $paramWarning.PlanResult = [PlanResultReasonCode]::WarningDynamicParameter
                        $paramWarning.PlanSeverity = [DiagnosticSeverity]::Warning

                        $planErrorSteps.Add($paramWarning)
                    }
                    else
                    {
                        $paramError = New-Object -TypeName UpgradePlan
                        $paramError.Original = $rmParam.Name
                        $paramError.UpgradeType = [UpgradeStepType]::CmdletParameter
                        $paramError.SourceCommand = $rmCmdlet
                        $paramError.FullPath = $rmCmdlet.FullPath
                        $paramError.StartOffset = $rmParam.StartOffset
                        $paramError.SourceCommandParameter = $rmParam
                        $paramError.Location = $rmParam.Location
                        $paramError.PlanResultReason = "Parameter was not found in $resolvedCommandName or its aliases. This may indicate a breaking change that requires attention."
                        $paramError.PlanResult = [PlanResultReasonCode]::ErrorParameterNotFound
                        $paramError.PlanSeverity = [DiagnosticSeverity]::Error
    
                        $planErrorSteps.Add($paramError)
                    }
                }
            }
        }

        # send metrics, if enabled (and while the collections are still seperated)

        Send-MetricsIfDataCollectionEnabled -Operation Plan `
            -ParameterSetName $PSCmdlet.ParameterSetName `
            -Duration ((Get-Date) - $cmdStarted) `
            -Properties ([PSCustomObject]@{
                ToAzureModuleName = "Az"
                ToAzureModuleVersion = $version
                UpgradeStepsCount = $planSteps.Count
                PlanWarnings = $planWarningSteps
                PlanErrors = $planErrorSteps
            })

        # join the collections into one output result.

        $planSteps.AddRange($planWarningSteps)
        $planSteps.AddRange($planErrorSteps)

        # sort the upgrade steps to by file, then offset descending.
        # the reason for this is updates must be made in descending offset order
        # otherwise file positions will change for subsequent swaps.

        $filter1 = @{ Expression = 'FullPath'; Ascending = $true }
        $filter2 = @{ Expression = 'StartOffset'; Descending = $true }

        $planSteps = $planSteps | Sort-Object -Property $filter1, $filter2

        # now that we have a sorted collection, add in the step order number
        # for extra clarity in the upgrade plan.

        for ([int]$i = 0; $i -lt $planSteps.Count; $i++)
        {
            $planSteps[$i].Order = ($i + 1)
        }

        Write-Output -InputObject $planSteps
    }
}
# SIG # Begin signature block
# MIIn0QYJKoZIhvcNAQcCoIInwjCCJ74CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAA6l5VG0CjGuww
# PeLCnMGO2hHgXF9cmYSk9hUvcvhQM6CCDYUwggYDMIID66ADAgECAhMzAAADTU6R
# phoosHiPAAAAAANNMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMwMzE2MTg0MzI4WhcNMjQwMzE0MTg0MzI4WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDUKPcKGVa6cboGQU03ONbUKyl4WpH6Q2Xo9cP3RhXTOa6C6THltd2RfnjlUQG+
# Mwoy93iGmGKEMF/jyO2XdiwMP427j90C/PMY/d5vY31sx+udtbif7GCJ7jJ1vLzd
# j28zV4r0FGG6yEv+tUNelTIsFmmSb0FUiJtU4r5sfCThvg8dI/F9Hh6xMZoVti+k
# bVla+hlG8bf4s00VTw4uAZhjGTFCYFRytKJ3/mteg2qnwvHDOgV7QSdV5dWdd0+x
# zcuG0qgd3oCCAjH8ZmjmowkHUe4dUmbcZfXsgWlOfc6DG7JS+DeJak1DvabamYqH
# g1AUeZ0+skpkwrKwXTFwBRltAgMBAAGjggGCMIIBfjAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUId2Img2Sp05U6XI04jli2KohL+8w
# VAYDVR0RBE0wS6RJMEcxLTArBgNVBAsTJE1pY3Jvc29mdCBJcmVsYW5kIE9wZXJh
# dGlvbnMgTGltaXRlZDEWMBQGA1UEBRMNMjMwMDEyKzUwMDUxNzAfBgNVHSMEGDAW
# gBRIbmTlUAXTgqoXNzcitW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIw
# MTEtMDctMDguY3JsMGEGCCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDov
# L3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDEx
# XzIwMTEtMDctMDguY3J0MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIB
# ACMET8WuzLrDwexuTUZe9v2xrW8WGUPRQVmyJ1b/BzKYBZ5aU4Qvh5LzZe9jOExD
# YUlKb/Y73lqIIfUcEO/6W3b+7t1P9m9M1xPrZv5cfnSCguooPDq4rQe/iCdNDwHT
# 6XYW6yetxTJMOo4tUDbSS0YiZr7Mab2wkjgNFa0jRFheS9daTS1oJ/z5bNlGinxq
# 2v8azSP/GcH/t8eTrHQfcax3WbPELoGHIbryrSUaOCphsnCNUqUN5FbEMlat5MuY
# 94rGMJnq1IEd6S8ngK6C8E9SWpGEO3NDa0NlAViorpGfI0NYIbdynyOB846aWAjN
# fgThIcdzdWFvAl/6ktWXLETn8u/lYQyWGmul3yz+w06puIPD9p4KPiWBkCesKDHv
# XLrT3BbLZ8dKqSOV8DtzLFAfc9qAsNiG8EoathluJBsbyFbpebadKlErFidAX8KE
# usk8htHqiSkNxydamL/tKfx3V/vDAoQE59ysv4r3pE+zdyfMairvkFNNw7cPn1kH
# Gcww9dFSY2QwAxhMzmoM0G+M+YvBnBu5wjfxNrMRilRbxM6Cj9hKFh0YTwba6M7z
# ntHHpX3d+nabjFm/TnMRROOgIXJzYbzKKaO2g1kWeyG2QtvIR147zlrbQD4X10Ab
# rRg9CpwW7xYxywezj+iNAc+QmFzR94dzJkEPUSCJPsTFMIIHejCCBWKgAwIBAgIK
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
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGaIwghmeAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAANNTpGmGiiweI8AAAAA
# A00wDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIH95
# bZRhntGZbI8gQWYAngNahprZCQ+MoNXulR6JjglUMEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAcDVjt67RZkrMbidG8kSviN6K6Eo90bh6n55Z
# dACwv+CsCSFZox20EXy+RFKOAqYTDNUhSivp+s4xuyBlYk6Ndj+UKfKtPJZmEFkM
# U2WjFxSu7IHdZHgPqhE5UtMUkH/nBQlHD7vIm3mqbtRW/pG1/7cbEMm6y3QTHk0a
# n5kyAD3uiM5O2KbKvwEgTtEM6JZt0brtdP1Xd1iYDv9L3h1PWiD+jY29/nuaS02/
# h25cKOhbU1CAwupYYtZyiZFJjWtrUaVuJtACTXNAN31Tfy9NKu4q6GOoyt8ap75Y
# FwESRnoiQyfxo7ApcBIICdy9JD0bgsID5s0FbACilHZFiLZ7laGCFywwghcoBgor
# BgEEAYI3AwMBMYIXGDCCFxQGCSqGSIb3DQEHAqCCFwUwghcBAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFZBgsqhkiG9w0BCRABBKCCAUgEggFEMIIBQAIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCDRlPkkaUj9R9S05zjCOuwVuGVgDwmLEsIN
# 7PjtJmklUwIGZULITkUBGBMyMDIzMTExNjA2MzQxNC44OTNaMASAAgH0oIHYpIHV
# MIHSMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQL
# EyRNaWNyb3NvZnQgSXJlbGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJjAkBgNVBAsT
# HVRoYWxlcyBUU1MgRVNOOkZDNDEtNEJENC1EMjIwMSUwIwYDVQQDExxNaWNyb3Nv
# ZnQgVGltZS1TdGFtcCBTZXJ2aWNloIIRezCCBycwggUPoAMCAQICEzMAAAHimZmV
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
# Y1NNje6CbaUFEMFxBmoQtB1VM1izoXBm8qGCAtcwggJAAgEBMIIBAKGB2KSB1TCB
# 0jELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1Jl
# ZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMk
# TWljcm9zb2Z0IElyZWxhbmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1U
# aGFsZXMgVFNTIEVTTjpGQzQxLTRCRDQtRDIyMDElMCMGA1UEAxMcTWljcm9zb2Z0
# IFRpbWUtU3RhbXAgU2VydmljZaIjCgEBMAcGBSsOAwIaAxUAFpuZafp0bnpJdIhf
# iB1d8pTohm+ggYMwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGlu
# Z3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBv
# cmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAN
# BgkqhkiG9w0BAQUFAAIFAOj/u5IwIhgPMjAyMzExMTYwNTUwMTBaGA8yMDIzMTEx
# NzA1NTAxMFowdzA9BgorBgEEAYRZCgQBMS8wLTAKAgUA6P+7kgIBADAKAgEAAgIR
# PwIB/zAHAgEAAgISAjAKAgUA6QENEgIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgor
# BgEEAYRZCgMCoAowCAIBAAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBBQUA
# A4GBAIGlBiAEYpCzx5T7BrHMfsShGCam+m67bEcRkrDWT5PbIPV0V/h4vaykTZeE
# dkG9D4S9AUaF2JKWjBLlYph3+bBVO0gXGl6hx7ZcWfE49L67q7TNDDeexTC4xeMm
# 9eOD5QnuYYY6utqTKitAKFRES/aX2nBXiNHtkeOKsbSwsq8BMYIEDTCCBAkCAQEw
# gZMwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
# B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UE
# AxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAHimZmV8dzjIOsA
# AQAAAeIwDQYJYIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0B
# CRABBDAvBgkqhkiG9w0BCQQxIgQgSQkok6LkBlEbRAZYt/2SQ9jvGbinX/PnxOXO
# q4tAV0gwgfoGCyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCAriSpKEP0muMbBUETO
# DoL4d5LU6I/bjucIZkOJCI9//zCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFBDQSAyMDEwAhMzAAAB4pmZlfHc4yDrAAEAAAHiMCIEIPy8+vUQdgsyterNsehA
# aSsPcsSTtHZKvrm5vvlAzm9KMA0GCSqGSIb3DQEBCwUABIICAKq6WPNrd7brTewD
# Yy3BKOYDZOAG5qJcgMrbIz8CvrkoGKJgGFl/Z6MCn2Z0Y4RyEWI6JnTj88rGjujz
# vHUS5CPpNvYCZDJLS1AVhTX9Vjs5fxKR7Gp3KcXjoyyBkf7oLR4W4y8fjybWlxGn
# e0Ehr8hjAuF8fMbAm4TU7sECQfUHSR5Csw/0jUwjV0LINkFufZK8wbDEgPm4nudB
# d75RdO5qKwv3QFzOdbRSnfSit+Vr8PIhODK3+GgrJnfDdI6zq1/gJ05bBuwiaJP0
# 9GvC/s4VcKF4ecWO6aXUoVbiBc6HT23Z1gvRYPN0TuKo4grkZ5x1duzKan5p/kSt
# T1d8mhhgWSzrFWVUlyF3RFE0g3RXBq1H5UktUdkaptJb48sGHUEYMLgrh3jguJ/c
# zd6QFNWZy+vliPdSncOAsOPUGZaDl6LRaSHnOyhOOwB0O15mqBqIf7AooN4YiWgX
# nNzyAIGKJOVzwxhEqFwk+3SGB2YWouIL9zm5SCbhtqpHGFl9mc1RNvs7SRxFa2jw
# H+QRE4Slohjxx5JdBCdCD0gxNg5Qqkj5Vw0QMe0Wei0zkPwJh8q4ndJbWIMUkHKs
# GRBdw8zCLTi3bs9babmThtf/GOjKXphx4iSmMFYxZRQRjsrRJlINWY/612kMfr/S
# 5E+8C1dZm33wBdB6dJueZbKXUprw
# SIG # End signature block
