
# ----------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.
# Code generated by Microsoft (R) AutoRest Code Generator.
# Changes may cause incorrect behavior and will be lost if the code is regenerated.
# ----------------------------------------------------------------------------------

<#
.Synopsis
Deletes member from group
Users, contacts, and groups that are members of this group.
HTTP Methods: GET (supported for all groups), POST (supported for security groups and mail-enabled security groups), DELETE (supported only for security groups) Read-only.
Nullable.
Supports $expand.
.Description
Deletes member from group
Users, contacts, and groups that are members of this group.
HTTP Methods: GET (supported for all groups), POST (supported for security groups and mail-enabled security groups), DELETE (supported only for security groups) Read-only.
Nullable.
Supports $expand.
.Link
https://learn.microsoft.com/powershell/module/az.resources/remove-azadgroupmember
#>
function Remove-AzADGroupMember {
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Runtime.PreviewMessageAttribute("This cmdlet is using a preview API version and is subject to breaking change in a future release.")]
    [OutputType([System.Boolean])]
    [CmdletBinding(DefaultParameterSetName = 'ExplicitParameterSet ', PositionalBinding = $false, SupportsShouldProcess, ConfirmImpact = 'Medium')]
    param(
        [Parameter(ParameterSetName='MemberObjectIdWithGroupObjectId', Mandatory, HelpMessage = "The object Id of target group.")]
        [Parameter(ParameterSetName='MemberUPNWithGroupObjectIdParameterSet', Mandatory, HelpMessage = "The object Id of target group.")]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Path')]
        [System.String]
        # key: id of group
        ${GroupObjectId},

        [Parameter(ParameterSetName='MemberObjectIdWithGroupDisplayName', Mandatory, HelpMessage = "The display name of target group.")]
        [Parameter(ParameterSetName='MemberUPNWithGroupDisplayNameParameterSet', Mandatory, HelpMessage = "The display name of target group.")]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Path')]
        [System.String]
        ${GroupDisplayName},

        [Parameter(ParameterSetName='MemberObjectIdWithGroupObject', Mandatory, ValueFromPipeline, HelpMessage = "The target group object, could be used as pipeline input.")]
        [Parameter(ParameterSetName='MemberUPNWithGroupObjectParameterSet', Mandatory, ValueFromPipeline, HelpMessage = "The target group object, could be used as pipeline input.")]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Path')]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.MicrosoftGraphGroup]
        ${GroupObject},
    
        [Parameter(ParameterSetName='MemberObjectIdWithGroupObjectId', Mandatory, HelpMessage = "The object Id of member to be removed from target group.")]
        [Parameter(ParameterSetName='MemberObjectIdWithGroupDisplayName', Mandatory, HelpMessage = "The object Id of member to be removed from target group.")]
        [Parameter(ParameterSetName='MemberObjectIdWithGroupObject', Mandatory, HelpMessage = "The object Id of member to be removed from target group.")]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Path')]
        [System.String[]]
        ${MemberObjectId},

        [Parameter(ParameterSetName='MemberUPNWithGroupObjectIdParameterSet', Mandatory, HelpMessage = "The user principal name of member to be removed from target group.")]
        [Parameter(ParameterSetName='MemberUPNWithGroupDisplayNameParameterSet', Mandatory, HelpMessage = "The user principal name of member to be removed from target group.")]
        [Parameter(ParameterSetName='MemberUPNWithGroupObjectParameterSet', Mandatory, HelpMessage = "The user principal name of member to be removed from target group.")]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Path')]
        [System.String[]]
        ${MemberUserPrincipalName},
    
        [Parameter()]
        [Alias("AzContext", "AzureRmContext", "AzureCredential")]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Azure')]
        [System.Management.Automation.PSObject]
        # The credentials, account, tenant, and subscription used for communication with Azure.
        ${DefaultProfile},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Wait for .NET debugger to attach
        ${Break},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be appended to the front of the pipeline
        ${HttpPipelineAppend},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Runtime')]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Runtime.SendAsyncStep[]]
        # SendAsync Pipeline Steps to be prepended to the front of the pipeline
        ${HttpPipelinePrepend},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Returns true when the command succeeds
        ${PassThru},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Runtime')]
        [System.Uri]
        # The URI for the proxy server to use
        ${Proxy},
    
        [Parameter(DontShow)]
        [ValidateNotNull()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Runtime')]
        [System.Management.Automation.PSCredential]
        # Credentials for a proxy server to use for the remote call
        ${ProxyCredential},
    
        [Parameter(DontShow)]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Runtime')]
        [System.Management.Automation.SwitchParameter]
        # Use the default credentials for the proxy
        ${ProxyUseDefaultCredentials}
    )
    
    process {
        if ($PSBoundParameters['PassThru']) {
            $shouldPassThru = $PSBoundParameters['PassThru']
            $null = $PSBoundParameters.Remove('PassThru')
        }

        if ($PSBoundParameters['GroupDisplayName']) {
            $param = @{'DisplayName' = $PSBoundParameters['GroupDisplayName']}
            if ($PSBoundParameters['Debug']) {
                $param['Debug'] = $PSBoundParameters['Debug']
            }
            $PSBoundParameters['GroupId'] = (Get-AzADGroup @param).Id
            $null = $PSBoundParameters.Remove('GroupDisplayName')
        } elseif ($PSBoundParameters['GroupObject']) {
            $PSBoundParameters['GroupId'] = $PSBoundParameters['GroupObject'].Id
            $null = $PSBoundParameters.Remove('GroupObject')
        } else {
            $PSBoundParameters['GroupId'] = $PSBoundParameters['GroupObjectId']
            $null = $PSBoundParameters.Remove('GroupObjectId')
        }

        $members = @()
        if ($PSBoundParameters['MemberUserPrincipalName']) {
            foreach ($name in $PSBoundParameters['MemberUserPrincipalName']) {
                $members += (Get-AzADUser -UserPrincipalName $name).Id
            }
            $null = $PSBoundParameters.Remove('MemberUserPrincipalName')
        } else {
            $members += $PSBoundParameters['MemberObjectId']
            $null = $PSBoundParameters.Remove('MemberObjectId')
        }

        foreach ($member in $members) {
            $PSBoundParameters['MemberId'] = $member
            Az.MSGraph.internal\Remove-AzADGroupRefMember @PSBoundParameters
        }

        if ($shouldPassThru) {
            $PSCmdlet.WriteObject($true)
        }
    }
}
    
# SIG # Begin signature block
# MIIoKQYJKoZIhvcNAQcCoIIoGjCCKBYCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCyAexlSFcU974i
# iv3nCgYUZ4LVVs+bvO641vLMkV5roaCCDXYwggX0MIID3KADAgECAhMzAAADTrU8
# esGEb+srAAAAAANOMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMwMzE2MTg0MzI5WhcNMjQwMzE0MTg0MzI5WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDdCKiNI6IBFWuvJUmf6WdOJqZmIwYs5G7AJD5UbcL6tsC+EBPDbr36pFGo1bsU
# p53nRyFYnncoMg8FK0d8jLlw0lgexDDr7gicf2zOBFWqfv/nSLwzJFNP5W03DF/1
# 1oZ12rSFqGlm+O46cRjTDFBpMRCZZGddZlRBjivby0eI1VgTD1TvAdfBYQe82fhm
# WQkYR/lWmAK+vW/1+bO7jHaxXTNCxLIBW07F8PBjUcwFxxyfbe2mHB4h1L4U0Ofa
# +HX/aREQ7SqYZz59sXM2ySOfvYyIjnqSO80NGBaz5DvzIG88J0+BNhOu2jl6Dfcq
# jYQs1H/PMSQIK6E7lXDXSpXzAgMBAAGjggFzMIIBbzAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUnMc7Zn/ukKBsBiWkwdNfsN5pdwAw
# RQYDVR0RBD4wPKQ6MDgxHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEW
# MBQGA1UEBRMNMjMwMDEyKzUwMDUxNjAfBgNVHSMEGDAWgBRIbmTlUAXTgqoXNzci
# tW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3JsMGEG
# CCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3J0
# MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIBAD21v9pHoLdBSNlFAjmk
# mx4XxOZAPsVxxXbDyQv1+kGDe9XpgBnT1lXnx7JDpFMKBwAyIwdInmvhK9pGBa31
# TyeL3p7R2s0L8SABPPRJHAEk4NHpBXxHjm4TKjezAbSqqbgsy10Y7KApy+9UrKa2
# kGmsuASsk95PVm5vem7OmTs42vm0BJUU+JPQLg8Y/sdj3TtSfLYYZAaJwTAIgi7d
# hzn5hatLo7Dhz+4T+MrFd+6LUa2U3zr97QwzDthx+RP9/RZnur4inzSQsG5DCVIM
# pA1l2NWEA3KAca0tI2l6hQNYsaKL1kefdfHCrPxEry8onJjyGGv9YKoLv6AOO7Oh
# JEmbQlz/xksYG2N/JSOJ+QqYpGTEuYFYVWain7He6jgb41JbpOGKDdE/b+V2q/gX
# UgFe2gdwTpCDsvh8SMRoq1/BNXcr7iTAU38Vgr83iVtPYmFhZOVM0ULp/kKTVoir
# IpP2KCxT4OekOctt8grYnhJ16QMjmMv5o53hjNFXOxigkQWYzUO+6w50g0FAeFa8
# 5ugCCB6lXEk21FFB1FdIHpjSQf+LP/W2OV/HfhC3uTPgKbRtXo83TZYEudooyZ/A
# Vu08sibZ3MkGOJORLERNwKm2G7oqdOv4Qj8Z0JrGgMzj46NFKAxkLSpE5oHQYP1H
# tPx1lPfD7iNSbJsP6LiUHXH1MIIHejCCBWKgAwIBAgIKYQ6Q0gAAAAAAAzANBgkq
# hkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5
# IDIwMTEwHhcNMTEwNzA4MjA1OTA5WhcNMjYwNzA4MjEwOTA5WjB+MQswCQYDVQQG
# EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwG
# A1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSgwJgYDVQQDEx9NaWNyb3NvZnQg
# Q29kZSBTaWduaW5nIFBDQSAyMDExMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIIC
# CgKCAgEAq/D6chAcLq3YbqqCEE00uvK2WCGfQhsqa+laUKq4BjgaBEm6f8MMHt03
# a8YS2AvwOMKZBrDIOdUBFDFC04kNeWSHfpRgJGyvnkmc6Whe0t+bU7IKLMOv2akr
# rnoJr9eWWcpgGgXpZnboMlImEi/nqwhQz7NEt13YxC4Ddato88tt8zpcoRb0Rrrg
# OGSsbmQ1eKagYw8t00CT+OPeBw3VXHmlSSnnDb6gE3e+lD3v++MrWhAfTVYoonpy
# 4BI6t0le2O3tQ5GD2Xuye4Yb2T6xjF3oiU+EGvKhL1nkkDstrjNYxbc+/jLTswM9
# sbKvkjh+0p2ALPVOVpEhNSXDOW5kf1O6nA+tGSOEy/S6A4aN91/w0FK/jJSHvMAh
# dCVfGCi2zCcoOCWYOUo2z3yxkq4cI6epZuxhH2rhKEmdX4jiJV3TIUs+UsS1Vz8k
# A/DRelsv1SPjcF0PUUZ3s/gA4bysAoJf28AVs70b1FVL5zmhD+kjSbwYuER8ReTB
# w3J64HLnJN+/RpnF78IcV9uDjexNSTCnq47f7Fufr/zdsGbiwZeBe+3W7UvnSSmn
# Eyimp31ngOaKYnhfsi+E11ecXL93KCjx7W3DKI8sj0A3T8HhhUSJxAlMxdSlQy90
# lfdu+HggWCwTXWCVmj5PM4TasIgX3p5O9JawvEagbJjS4NaIjAsCAwEAAaOCAe0w
# ggHpMBAGCSsGAQQBgjcVAQQDAgEAMB0GA1UdDgQWBBRIbmTlUAXTgqoXNzcitW2o
# ynUClTAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYD
# VR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBRyLToCMZBDuRQFTuHqp8cx0SOJNDBa
# BgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2Ny
# bC9wcm9kdWN0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNfMjIuY3JsMF4GCCsG
# AQUFBwEBBFIwUDBOBggrBgEFBQcwAoZCaHR0cDovL3d3dy5taWNyb3NvZnQuY29t
# L3BraS9jZXJ0cy9NaWNSb29DZXJBdXQyMDExXzIwMTFfMDNfMjIuY3J0MIGfBgNV
# HSAEgZcwgZQwgZEGCSsGAQQBgjcuAzCBgzA/BggrBgEFBQcCARYzaHR0cDovL3d3
# dy5taWNyb3NvZnQuY29tL3BraW9wcy9kb2NzL3ByaW1hcnljcHMuaHRtMEAGCCsG
# AQUFBwICMDQeMiAdAEwAZQBnAGEAbABfAHAAbwBsAGkAYwB5AF8AcwB0AGEAdABl
# AG0AZQBuAHQALiAdMA0GCSqGSIb3DQEBCwUAA4ICAQBn8oalmOBUeRou09h0ZyKb
# C5YR4WOSmUKWfdJ5DJDBZV8uLD74w3LRbYP+vj/oCso7v0epo/Np22O/IjWll11l
# hJB9i0ZQVdgMknzSGksc8zxCi1LQsP1r4z4HLimb5j0bpdS1HXeUOeLpZMlEPXh6
# I/MTfaaQdION9MsmAkYqwooQu6SpBQyb7Wj6aC6VoCo/KmtYSWMfCWluWpiW5IP0
# wI/zRive/DvQvTXvbiWu5a8n7dDd8w6vmSiXmE0OPQvyCInWH8MyGOLwxS3OW560
# STkKxgrCxq2u5bLZ2xWIUUVYODJxJxp/sfQn+N4sOiBpmLJZiWhub6e3dMNABQam
# ASooPoI/E01mC8CzTfXhj38cbxV9Rad25UAqZaPDXVJihsMdYzaXht/a8/jyFqGa
# J+HNpZfQ7l1jQeNbB5yHPgZ3BtEGsXUfFL5hYbXw3MYbBL7fQccOKO7eZS/sl/ah
# XJbYANahRr1Z85elCUtIEJmAH9AAKcWxm6U/RXceNcbSoqKfenoi+kiVH6v7RyOA
# 9Z74v2u3S5fi63V4GuzqN5l5GEv/1rMjaHXmr/r8i+sLgOppO6/8MO0ETI7f33Vt
# Y5E90Z1WTk+/gFcioXgRMiF670EKsT/7qMykXcGhiJtXcVZOSEXAQsmbdlsKgEhr
# /Xmfwb1tbWrJUnMTDXpQzTGCGgkwghoFAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAANOtTx6wYRv6ysAAAAAA04wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIMmImRJHXlb9kdwERlqGGnAA
# OEUljcMpdX/jI/t0wKmxMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAsgcVsGdEffC7KbUsxfVkx4/HuM445Kvgh7JP4KXfcnhP5TEHzWHJwyjV
# 2W/0LnTfHWcr0eXkp4cQTU0Kz4AbOt/n/HKaV0cpwEfVyR6vDzf8oiFiJvDJzj+j
# /RrbFSMCYyGSOkYb0XanP91g4JSmWYtUZgJvQB/IutobwQdQs9hJgWIQTMq8wvux
# J461kB9b3Hkgfa4qh83CK1fNi1UmMTvOZ8uxkHzCejjj9v9qRi4r5dzVQVK8gg1R
# xJGR4nSIExkibun2bzIkhjfyIbQqtufi0Z7udLFzEW4J3i8+DgO2lK4GjclKS7Vp
# +1eV2EFwaeKui7+R0TXk/EAsC45PIaGCF5MwghePBgorBgEEAYI3AwMBMYIXfzCC
# F3sGCSqGSIb3DQEHAqCCF2wwghdoAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFSBgsq
# hkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCBtLL8O8MFJ/KqNXw5VXpnwGrNRH4IfSiUDkChjx34/iwIGZMvn1wdL
# GBMyMDIzMDgwNDAzMTA0OC4wMjNaMASAAgH0oIHRpIHOMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046MzcwMy0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Wg
# ghHpMIIHIDCCBQigAwIBAgITMwAAAdTk6QMvwKxprAABAAAB1DANBgkqhkiG9w0B
# AQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UE
# BxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYD
# VQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDAeFw0yMzA1MjUxOTEy
# MjdaFw0yNDAyMDExOTEyMjdaMIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25z
# MScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046MzcwMy0wNUUwLUQ5NDcxJTAjBgNV
# BAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2UwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQCYU94tmwIkl353SWej1ybWcSAbu8FLwTEtOvw3uXMp
# a1DnDXDwbtkLc+oT8BNti8t+38TwktfgoAM9N/BOHyT4CpXB1Hwn1YYovuYujoQV
# 9kmyU6D6QttTIKN7fZTjoNtIhI5CBkwS+MkwCwdaNyySvjwPvZuxH8RNcOOB8ABD
# hJH+vw/jev+G20HE0Gwad323x4uA4tLkE0e9yaD7x/s1F3lt7Ni47pJMGMLqZQCK
# 7UCUeWauWF9wZINQ459tSPIe/xK6ttLyYHzd3DeRRLxQP/7c7oPJPDFgpbGB2HRJ
# aE0puRRDoiDP7JJxYr+TBExhI2ulZWbgL4CfWawwb1LsJmFWJHbqGr6o0irW7IqD
# kf2qEbMRT1WUM15F5oBc5Lg18lb3sUW7kRPvKwmfaRBkrmil0H/tv3HYyE6A490Z
# FEcPk6dzYAKfCe3vKpRVE4dPoDKVnCLUTLkq1f/pnuD/ZGHJ2cbuIer9umQYu/Fz
# 1DBreC8CRs3zJm48HIS3rbeLUYu/C93jVIJOlrKAv/qmYRymjDmpfzZvfvGBGUbO
# px+4ofwqBTLuhAfO7FZz338NtsjDzq3siR0cP74p9UuNX1Tpz4KZLM8GlzZLje3a
# HfD3mulrPIMipnVqBkkY12a2slsbIlje3uq8BSrj725/wHCt4HyXW4WgTGPizyEx
# TQIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFDzajMdwtAZ6EoB5Hedcsru0DHZJMB8G
# A1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8GA1UdHwRYMFYwVKBSoFCG
# Tmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY3Jvc29mdCUy
# MFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBsBggrBgEFBQcBAQRgMF4w
# XAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvY2Vy
# dHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3J0MAwG
# A1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwDgYDVR0PAQH/BAQD
# AgeAMA0GCSqGSIb3DQEBCwUAA4ICAQC0xUPP+ytwktdRhYlZ9Bk4/bLzLOzq+wcC
# 7VAaRQHGRS+IPyU/8OLiVoXcoyKKKiRQ7K9c90OdM+qL4PizKnStLDBsWT+ds1ha
# yNkTwnhVcZeA1EGKlNZvdlTsCUxJ5C7yoZQmA+2lpk04PGjcFhH1gGRphz+tcDNK
# /CtKJ+PrEuNj7sgmBop/JFQcYymiP/vr+dudrKQeStcTV9W13cm2FD5F/XWO37Ti
# +G4Tg1BkU25RA+t8RCWy/IHug3rrYzqUcdVRq7UgRl40YIkTNnuco6ny7vEBmWFj
# cr7Skvo/QWueO8NAvP2ZKf3QMfidmH1xvxx9h9wVU6rvEQ/PUJi3popYsrQKuogp
# hdPqHZ5j9OoQ+EjACUfgJlHnn8GVbPW3xGplCkXbyEHheQNd/a3X/2zpSwEROOcy
# 1YaeQquflGilAf0y40AFKqW2Q1yTb19cRXBpRzbZVO+RXUB4A6UL1E1Xjtzr/b9q
# z9U4UNV8wy8Yv/07bp3hAFfxB4mn0c+PO+YFv2YsVvYATVI2lwL9QDSEt8F0RW6L
# ekxPfvbkmVSRwP6pf5AUfkqooKa6pfqTCndpGT71HyiltelaMhRUsNVkaKzAJrUo
# ESSj7sTP1ZGiS9JgI+p3AO5fnMht3mLHMg68GszSH4Wy3vUDJpjUTYLtaTWkQtz6
# UqZPN7WXhjCCB3EwggVZoAMCAQICEzMAAAAVxedrngKbSZkAAAAAABUwDQYJKoZI
# hvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
# DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24x
# MjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmljYXRlIEF1dGhvcml0eSAy
# MDEwMB4XDTIxMDkzMDE4MjIyNVoXDTMwMDkzMDE4MzIyNVowfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTAwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoIC
# AQDk4aZM57RyIQt5osvXJHm9DtWC0/3unAcH0qlsTnXIyjVX9gF/bErg4r25Phdg
# M/9cT8dm95VTcVrifkpa/rg2Z4VGIwy1jRPPdzLAEBjoYH1qUoNEt6aORmsHFPPF
# dvWGUNzBRMhxXFExN6AKOG6N7dcP2CZTfDlhAnrEqv1yaa8dq6z2Nr41JmTamDu6
# GnszrYBbfowQHJ1S/rboYiXcag/PXfT+jlPP1uyFVk3v3byNpOORj7I5LFGc6XBp
# Dco2LXCOMcg1KL3jtIckw+DJj361VI/c+gVVmG1oO5pGve2krnopN6zL64NF50Zu
# yjLVwIYwXE8s4mKyzbnijYjklqwBSru+cakXW2dg3viSkR4dPf0gz3N9QZpGdc3E
# XzTdEonW/aUgfX782Z5F37ZyL9t9X4C626p+Nuw2TPYrbqgSUei/BQOj0XOmTTd0
# lBw0gg/wEPK3Rxjtp+iZfD9M269ewvPV2HM9Q07BMzlMjgK8QmguEOqEUUbi0b1q
# GFphAXPKZ6Je1yh2AuIzGHLXpyDwwvoSCtdjbwzJNmSLW6CmgyFdXzB0kZSU2LlQ
# +QuJYfM2BjUYhEfb3BvR/bLUHMVr9lxSUV0S2yW6r1AFemzFER1y7435UsSFF5PA
# PBXbGjfHCBUYP3irRbb1Hode2o+eFnJpxq57t7c+auIurQIDAQABo4IB3TCCAdkw
# EgYJKwYBBAGCNxUBBAUCAwEAATAjBgkrBgEEAYI3FQIEFgQUKqdS/mTEmr6CkTxG
# NSnPEP8vBO4wHQYDVR0OBBYEFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMFwGA1UdIARV
# MFMwUQYMKwYBBAGCN0yDfQEBMEEwPwYIKwYBBQUHAgEWM2h0dHA6Ly93d3cubWlj
# cm9zb2Z0LmNvbS9wa2lvcHMvRG9jcy9SZXBvc2l0b3J5Lmh0bTATBgNVHSUEDDAK
# BggrBgEFBQcDCDAZBgkrBgEEAYI3FAIEDB4KAFMAdQBiAEMAQTALBgNVHQ8EBAMC
# AYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV9lbLj+iiXGJo0T2UkFvX
# zpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20v
# cGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcmwwWgYI
# KwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2LTIzLmNydDANBgkqhkiG
# 9w0BAQsFAAOCAgEAnVV9/Cqt4SwfZwExJFvhnnJL/Klv6lwUtj5OR2R4sQaTlz0x
# M7U518JxNj/aZGx80HU5bbsPMeTCj/ts0aGUGCLu6WZnOlNN3Zi6th542DYunKmC
# VgADsAW+iehp4LoJ7nvfam++Kctu2D9IdQHZGN5tggz1bSNU5HhTdSRXud2f8449
# xvNo32X2pFaq95W2KFUn0CS9QKC/GbYSEhFdPSfgQJY4rPf5KYnDvBewVIVCs/wM
# nosZiefwC2qBwoEZQhlSdYo2wh3DYXMuLGt7bj8sCXgU6ZGyqVvfSaN0DLzskYDS
# PeZKPmY7T7uG+jIa2Zb0j/aRAfbOxnT99kxybxCrdTDFNLB62FD+CljdQDzHVG2d
# Y3RILLFORy3BFARxv2T5JL5zbcqOCb2zAVdJVGTZc9d/HltEAY5aGZFrDZ+kKNxn
# GSgkujhLmm77IVRrakURR6nxt67I6IleT53S0Ex2tVdUCbFpAUR+fKFhbHP+Crvs
# QWY9af3LwUFJfn6Tvsv4O+S3Fb+0zj6lMVGEvL8CwYKiexcdFYmNcP7ntdAoGokL
# jzbaukz5m/8K6TT4JDVnK+ANuOaMmdbhIurwJ0I9JZTmdHRbatGePu1+oDEzfbzL
# 6Xu/OHBE0ZDxyKs6ijoIYn/ZcGNTTY3ugm2lBRDBcQZqELQdVTNYs6FwZvKhggNM
# MIICNAIBATCB+aGB0aSBzjCByzELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEn
# MCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjM3MDMtMDVFMC1EOTQ3MSUwIwYDVQQD
# ExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQAt
# M12Wjo2xxA5sduzB/3HdzZmiSKCBgzCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6HZmVzAiGA8yMDIzMDgwMzE3NDU1
# OVoYDzIwMjMwODA0MTc0NTU5WjBzMDkGCisGAQQBhFkKBAExKzApMAoCBQDodmZX
# AgEAMAYCAQACATEwBwIBAAICEwMwCgIFAOh3t9cCAQAwNgYKKwYBBAGEWQoEAjEo
# MCYwDAYKKwYBBAGEWQoDAqAKMAgCAQACAwehIKEKMAgCAQACAwGGoDANBgkqhkiG
# 9w0BAQsFAAOCAQEAgm55tvg7kvtis96q3ayUdoLwNE0dRdWZ2+fEO0vQaGrzaHE8
# 2bJ6/l+ZyMPhvD4L7q3OcMsMEUaLjnzLNEUUn9EOjSBzMGHyEemSmGaPM/qjUPFt
# zdzI82aSeaFZ+TQnAalFv7XnMZQuU26gD2PjPPxaxOQmsAcELonptm5i0hCjHXia
# 7/CD/sZKS7srnHMIi9ZoAf8B8sYWutj9RdJVv1ydj/ue4X4DPnkySuFF2U6cieww
# ADMIN8GIjHEFvQU184vAYqdwHnRWMxzZ118hXzHCDYhy2Wo4bYoPja70tav1Pbxw
# /Tz9K0ezmPi00DATPNY536BNmYe5eXpgjutS3jGCBA0wggQJAgEBMIGTMHwxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB1OTpAy/ArGmsAAEAAAHUMA0G
# CWCGSAFlAwQCAQUAoIIBSjAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQwLwYJ
# KoZIhvcNAQkEMSIEIN6vrm2JF9gfQ1+fT28zyt+z3LYRDZrX+ObMNuqkZKcWMIH6
# BgsqhkiG9w0BCRACLzGB6jCB5zCB5DCBvQQgzOqH+tgUpc6XO9ZLnEK0+L1pT58F
# STEiuJenZZM9YjcwgZgwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MAITMwAAAdTk6QMvwKxprAABAAAB1DAiBCD7KfoTl/Tw1W3lF9r1CDKTaFI5IOvZ
# MUmx6HQtuw96bzANBgkqhkiG9w0BAQsFAASCAgBiawdts1dKsnRHxIFvFFL3A2vp
# zIvt2+GK+72a4PfoNL/VPcuMUKDhfcD3O1Qnd/EQ85fMpNw82V6Jnv+tiN6fkiR7
# owbJFmE3RZMDMfOAV3SAdSaaOUqQhbYBtU34uWdwhqsEUvSm3U9EBtHA4t1ppFkq
# 6SXm3W1cVqqyrb1X8TeT0ZFbvEwvt6oV1hhog0NLjGfE2s9Zcs0cxdgev+8BVeSU
# +fC/HmQS1r1BAvj25itaEYxIvkM4Zfqmm3HmpyrYxwioGkyoXQTSGVJABZ4vhlMs
# xI29+uyloPY3URn1DyOC3izjyrLuUhXOEyC9wplo1G46iVroiHbFFBnVGaIZbtiE
# x4RHkY6URusGYVqBOYKPYx3lPmGt+Jc7Woidym7yoFq6B5SrvalhPImpHRAZn9BG
# TcjLlU2kgTHXMCSwrMQjjq/OpvFbefaT2DmBLri7JuhB+w05EnFKeS/RqwxOW6Ge
# 04ph4HbdoJQzAM3Obq4p7jb5b2d50x5r+nYpwSdUlXDv1zuQTjNGYtygs6LWrfTf
# twYzcdlqoGW4KF/rAIQqr3IdjPjPcR8yrbFFXdadp3ihBW20ulZcZ9hRpeMkZKO4
# I9gmmnHFdYudeQa/6F0hV6pUPWf0sgIACPyPNoxIBwrhETEooQS55Nsp9IoarZQC
# 7yCYhtLN8M4pUJjHIw==
# SIG # End signature block
