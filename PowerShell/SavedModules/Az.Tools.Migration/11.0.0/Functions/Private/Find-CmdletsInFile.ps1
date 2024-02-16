function Find-CmdletsInFile
{
    <#
    .SYNOPSIS
        Finds any cmdlets used in the specified PowerShell file.

    .DESCRIPTION
        Finds any cmdlets used in the specified PowerShell file.

    .PARAMETER FilePath
        Specify the path to the file that should be searched.

    .EXAMPLE
        PS C:\> Find-CmdletsInFile -FilePath "C:\scripts\file.ps1"
        Finds cmdlets used in the specified file.
    #>
    [CmdletBinding()]
    Param
    (
        [Parameter(
            Mandatory=$true,
            HelpMessage="Specify the path to the file that should be searched.")]
        [System.String]
        [ValidateNotNullOrEmpty()]
        $FilePath
    )
    Process
    {
        # constants
        $matchPattern = "(\b[a-zA-z]+-[a-zA-z]+\b)"
        $doubleQuoteCharacter = '"'
        $singleQuoteCharacter = ''''
        $orderedTypeName = 'ordered'

        # ref output vars
        $parserErrors = $null
        $parsedTokens = $null

        $rootAstNode = [System.Management.Automation.Language.Parser]::ParseFile($FilePath, [ref]$parsedTokens, [ref]$parserErrors)

        if ($parserErrors.Count -gt 0)
        {
            if ($parserErrors[0].ErrorID -eq "FileReadError")
            {
                throw "The PowerShell file provided [$FilePath] was not found or not accessible."
            }
            else
            {
                throw "The PowerShell file provided [$FilePath] has $($parserErrors.Count) syntax error(s). Please correct the syntax errors then try again."
            }
        }

        # search for variable assignment statements
        # the goal here is to build a table with the hastable variable sets (if any are present), to support splatted parameter names.
        $recurse = $true
        $assignmentPredicate = { param($astObject) $astObject -is [System.Management.Automation.Language.AssignmentStatementAst] }
        $assignmentAstNodes = $rootAstNode.FindAll($assignmentPredicate, $recurse)
        $hashtableVariables = New-Object -TypeName 'System.Collections.Generic.Dictionary[System.String, System.Collections.Generic.List[System.Management.Automation.Language.StringConstantExpressionAst]]'

        for ([int]$i = 0; $i -lt $assignmentAstNodes.Count; $i++)
        {
            $currentVarAstNode = $assignmentAstNodes[$i]

            # is the left hand side of the expression a variable expression? (ex: $var = 1)
            # or is it a member expression? (ex: $var.Property = 1)
            # only variable expressions are supported at this time.

            if ($currentVarAstNode.Left -is [System.Management.Automation.Language.VariableExpressionAst])
            {
                # is the right hand side of the expression statement a hashtable node?
                if ($currentVarAstNode.Right.Expression -is [System.Management.Automation.Language.HashtableAst])
                {
                    # capture the hashtable variable name
                    $htVariableName = $currentVarAstNode.Left.VariablePath.UserPath
                    $hashtableVariables[$htVariableName] = New-Object -TypeName 'System.Collections.Generic.List[System.Management.Automation.Language.StringConstantExpressionAst]'

                    # capture the hashtable key name extents. 
                    # -- the tuple's .Item1 contains the key name AST (which may represent a splatted parameter name).
                    # -- the tuple's .Item2 contains the key value AST (we dont need to capture this)
                    # -- also make sure to only grab hashtable key names that come from ConstantExpressionAst (to avoid unsupported subexpression keyname scenarios).
                    foreach ($expressionAst in $currentVarAstNode.Right.Expression.KeyValuePairs)
                    {
                        if ($expressionAst.Item1 -is [System.Management.Automation.Language.StringConstantExpressionAst])
                        {
                            $hashtableVariables[$htVariableName].Add($expressionAst.Item1)
                        }
                    }
                }
                elseif ($currentVarAstNode.Right.Expression -is [System.Management.Automation.Language.ConvertExpressionAst] `
                    -and $currentVarAstNode.Right.Expression.Type.TypeName.FullName -eq $orderedTypeName `
                    -and $currentVarAstNode.Right.Expression.Child -is [System.Management.Automation.Language.HashtableAst])
                {
                    # same as the above 'if' condition case, but special handling for [ordered] hashtable objects.
                    # we have to check the .Child [HashtableAst] of the ConvertExpressionAst.

                    $htVariableName = $currentVarAstNode.Left.VariablePath.UserPath
                    $hashtableVariables[$htVariableName] = New-Object -TypeName 'System.Collections.Generic.List[System.Management.Automation.Language.StringConstantExpressionAst]'
                    
                    foreach ($expressionAst in $currentVarAstNode.Right.Expression.Child.KeyValuePairs)
                    {
                        if ($expressionAst.Item1 -is [System.Management.Automation.Language.StringConstantExpressionAst])
                        {
                            $hashtableVariables[$htVariableName].Add($expressionAst.Item1)
                        }
                    }
                }
            }
        }

        # search for command statements
        $commandPredicate = { param($astObject) $astObject -is [System.Management.Automation.Language.CommandAst] }
        $commandAstNodes = $rootAstNode.FindAll($commandPredicate, $recurse)
        $cmdletRegex = New-Object System.Text.RegularExpressions.Regex($matchPattern)

        for ([int]$i = 0; $i -lt $commandAstNodes.Count; $i++)
        {
            $currentAstNode = $commandAstNodes[$i]

            # is the first command element a cmdlet?
            # then we have the start of a cmdlet expression

            if ($currentAstNode.CommandElements[0] -is [System.Management.Automation.Language.StringConstantExpressionAst] `
                    -and $cmdletRegex.IsMatch($currentAstNode.CommandElements[0].Extent.Text))
            {
                $cmdletRef = New-Object -TypeName CommandReference
                $cmdletRef.FullPath = $currentAstNode.CommandElements[0].Extent.File
                $cmdletRef.FileName = Split-Path -Path $currentAstNode.CommandElements[0].Extent.File -Leaf
                $cmdletRef.StartLine = $currentAstNode.CommandElements[0].Extent.StartLineNumber
                $cmdletRef.StartColumn = $currentAstNode.CommandElements[0].Extent.StartColumnNumber
                $cmdletRef.EndLine = $currentAstNode.CommandElements[0].Extent.EndLineNumber
                $cmdletRef.EndPosition = $currentAstNode.CommandElements[0].Extent.EndColumnNumber
                $cmdletRef.CommandName = $currentAstNode.CommandElements[0].Extent.Text
                $cmdletRef.StartOffset = $currentAstNode.CommandElements[0].Extent.StartOffset
                $cmdletRef.EndOffset = $currentAstNode.CommandElements[0].Extent.EndOffset
                $cmdletRef.Location = "{0}:{1}:{2}" -f $cmdletRef.FileName, $cmdletRef.StartLine, $cmdletRef.StartColumn

                if ($currentAstNode.CommandElements.Count -gt 1)
                {
                    # this cmdlet likely has parameters supplied to it.

                    for ([int]$j = 1; $j -lt $currentAstNode.CommandElements.Count; $j++)
                    {
                        $currentAstNodeCmdElement = $currentAstNode.CommandElements[$j]

                        if ($currentAstNodeCmdElement -is [System.Management.Automation.Language.CommandParameterAst])
                        {
                            $paramRef = New-Object -TypeName CommandReferenceParameter

                            # grab the parameter name with no dash value
                            # the extent offsets here include the dash, so add +1 to the starting values
                            # construct the parameter object with location details
                            $paramRef.Name = $currentAstNodeCmdElement.ParameterName
                            $paramRef.FullPath = $cmdletRef.FullPath
                            $paramRef.FileName = $cmdletRef.FileName
                            $paramRef.StartLine = $currentAstNodeCmdElement.Extent.StartLineNumber
                            $paramRef.StartColumn = ($currentAstNodeCmdElement.Extent.StartColumnNumber + 1)
                            $paramRef.EndLine = $currentAstNodeCmdElement.Extent.EndLineNumber
                            $paramRef.EndPosition = $currentAstNodeCmdElement.Extent.EndColumnNumber
                            $paramRef.StartOffset = ($currentAstNodeCmdElement.Extent.StartOffset + 1)
                            $paramRef.EndOffset = $currentAstNodeCmdElement.Extent.EndOffset
                            $paramRef.Location = "{0}:{1}:{2}" -f $paramRef.FileName, $paramRef.StartLine, $paramRef.StartColumn

                            $cmdletRef.Parameters.Add($paramRef)
                        }
                        elseif ($currentAstNodeCmdElement -is [System.Management.Automation.Language.VariableExpressionAst] `
                                -and $currentAstNodeCmdElement.Splatted -eq $true)
                        {
                            $cmdletRef.HasSplattedArguments = $true

                            # grab the splatted parameter name without the '@' character prefix.
                            # we can then look this up in our known hashtable variables table.
                            $hashtableVariableName = $currentAstNodeCmdElement.VariablePath.UserPath

                            if ($hashtableVariables.ContainsKey($hashtableVariableName))
                            {
                                foreach ($splattedParameter in $hashtableVariables[$hashtableVariableName])
                                {
                                    $paramRef = New-Object -TypeName CommandReferenceParameter

                                    # add new parameter, similar to above, however a hashtable key name is the parameter name.
                                    $paramRef.Name = $splattedParameter.Value
                                    $paramRef.FullPath = $cmdletRef.FullPath
                                    $paramRef.FileName = $cmdletRef.FileName

                                    if ($splattedParameter.Extent.Text[0] -ne $doubleQuoteCharacter -and $splattedParameter.Extent.Text[0] -ne $singleQuoteCharacter)
                                    {
                                        # normal hash table key (not wrapped in quote characters)
                                        $paramRef.StartLine = $splattedParameter.Extent.StartLineNumber
                                        $paramRef.StartColumn = $splattedParameter.Extent.StartColumnNumber
                                        $paramRef.EndLine = $splattedParameter.Extent.EndLineNumber
                                        $paramRef.EndPosition = $splattedParameter.Extent.EndColumnNumber
                                        $paramRef.StartOffset = $splattedParameter.Extent.StartOffset
                                        $paramRef.EndOffset = $splattedParameter.Extent.EndOffset
                                    }
                                    else
                                    {
                                        # hash table key wrapped in quotes
                                        # use special offset handling to account for quote wrapper characters.
                                        $paramRef.StartLine = $splattedParameter.Extent.StartLineNumber
                                        $paramRef.StartColumn = ($splattedParameter.Extent.StartColumnNumber + 1)
                                        $paramRef.EndLine = $splattedParameter.Extent.EndLineNumber
                                        $paramRef.EndPosition = ($splattedParameter.Extent.EndColumnNumber - 1)
                                        $paramRef.StartOffset = ($splattedParameter.Extent.StartOffset + 1)
                                        $paramRef.EndOffset = ($splattedParameter.Extent.EndOffset - 1)
                                    }

                                    $paramRef.Location = "{0}:{1}:{2}" -f $paramRef.FileName, $paramRef.StartLine, $paramRef.StartColumn

                                    $cmdletRef.Parameters.Add($paramRef)
                                }
                            }
                        }
                    }
                }

                Write-Output -InputObject $cmdletRef
            }
        }
    }
}
# SIG # Begin signature block
# MIInwgYJKoZIhvcNAQcCoIInszCCJ68CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCANhsPjEB4+9yA7
# UW+Z/q41Ts4dHRGTzaoaXPX2wpc/YKCCDXYwggX0MIID3KADAgECAhMzAAADTrU8
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGaIwghmeAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAANOtTx6wYRv6ysAAAAAA04wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIP0VVErJCFT1wT8HWS9BIgOA
# 6awUXsFvzkxGeMGYmkF2MEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEA2UcQtFokMtt6EcLkbDpblj7WiF2knOo5xeKYTSYegJhHRYuj57xRK99/
# bEdGFUeviRU2Lz8gOu1nXEDiQDynToD5/cWjCUOB7567PxBphxJgTqstZL8iVn+G
# yiQQqxaf1Rx2/73Mx4rW1QS7nwP3AC42wWwRyqPvIWKC5VG4upPkBbl1ZoMkqf/y
# WlqYWD0ZOG2kv6dwtfxSqMCtRMNe+BnshQrbgNj1gcDHuNR2IaMqp+5FroGelWS7
# Y1FSyGBK0782Zi2PKz8+f6sNFgH77ALuExg3FUB6eYu1tsaDwy3WxGRLGj/rNNj5
# bcLwptVQ9TUCLCFlfb5cUt2yAluvB6GCFywwghcoBgorBgEEAYI3AwMBMYIXGDCC
# FxQGCSqGSIb3DQEHAqCCFwUwghcBAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFZBgsq
# hkiG9w0BCRABBKCCAUgEggFEMIIBQAIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCCshxgBIkXap5BcYNL3R1jSYDppBRjPlMyfy6jdDynMHgIGZULFs2Jq
# GBMyMDIzMTExNjA2MzQxNi4wNzFaMASAAgH0oIHYpIHVMIHSMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMS0wKwYDVQQLEyRNaWNyb3NvZnQgSXJl
# bGFuZCBPcGVyYXRpb25zIExpbWl0ZWQxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNO
# Ojg2REYtNEJCQy05MzM1MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBT
# ZXJ2aWNloIIRezCCBycwggUPoAMCAQICEzMAAAHdXVcdldStqhsAAQAAAd0wDQYJ
# KoZIhvcNAQELBQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24x
# EDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlv
# bjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcNMjMx
# MDEyMTkwNzA5WhcNMjUwMTEwMTkwNzA5WjCB0jELMAkGA1UEBhMCVVMxEzARBgNV
# BAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jv
# c29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9zb2Z0IElyZWxhbmQgT3Bl
# cmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjo4NkRGLTRC
# QkMtOTMzNTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZTCC
# AiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAKhOA5RE6i53nHURH4lnfKLp
# +9JvipuTtctairCxMUSrPSy5CWK2DtriQP+T52HXbN2g7AktQ1pQZbTDGFzK6d03
# vYYNrCPuJK+PRsP2FPVDjBXy5mrLRFzIHHLaiAaobE5vFJuoxZ0ZWdKMCs8acjhH
# UmfaY+79/CR7uN+B4+xjJqwvdpU/mp0mAq3earyH+AKmv6lkrQN8zgrcbCgHwsqv
# vqT6lEFqYpi7uKn7MAYbSeLe0pMdatV5EW6NVnXMYOTRKuGPfyfBKdShualLo88k
# G7qa2mbA5l77+X06JAesMkoyYr4/9CgDFjHUpcHSODujlFBKMi168zRdLerdpW0b
# BX9EDux2zBMMaEK8NyxawCEuAq7++7ktFAbl3hUKtuzYC1FUZuUl2Bq6U17S4CKs
# qR3itLT9qNcb2pAJ4jrIDdll5Tgoqef5gpv+YcvBM834bXFNwytd3ujDD24P9Dd8
# xfVJvumjsBQQkK5T/qy3HrQJ8ud1nHSvtFVi5Sa/ubGuYEpS8gF6GDWN5/KbveFk
# dsoTVIPo8pkWhjPs0Q7nA5+uBxQB4zljEjKz5WW7BA4wpmFm24fhBmRjV4Nbp+n7
# 8cgAjvDSfTlA6DYBcv2kx1JH2dIhaRnSeOXePT6hMF0Il598LMu0rw35ViUWcAQk
# UNUTxRnqGFxz5w+ZusMDAgMBAAGjggFJMIIBRTAdBgNVHQ4EFgQUbqL1toyPUdpF
# yyHSDKWj0I4lw/EwHwYDVR0jBBgwFoAUn6cVXQBeYl2D9OXSZacbUzUZ6XIwXwYD
# VR0fBFgwVjBUoFKgUIZOaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9j
# cmwvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUyMDIwMTAoMSkuY3JsMGwG
# CCsGAQUFBwEBBGAwXjBcBggrBgEFBQcwAoZQaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNyb3NvZnQlMjBUaW1lLVN0YW1wJTIwUENBJTIw
# MjAxMCgxKS5jcnQwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcD
# CDAOBgNVHQ8BAf8EBAMCB4AwDQYJKoZIhvcNAQELBQADggIBAC5U2bINLgXIHWbM
# cqVuf9jkUT/K8zyLBvu5h8JrqYR2z/eaO2yo1Ooc9Shyvxbe9GZDu7kkUzxSyJ1I
# ZksZZw6FDq6yZNT3PEjAEnREpRBL8S+mbXg+O4VLS0LSmb8XIZiLsaqZ0fDEcv3H
# eA+/y/qKnCQWkXghpaEMwGMQzRkhGwcGdXr1zGpQ7HTxvfu57xFxZX1MkKnWFENJ
# 6urd+4teUgXj0ngIOx//l3XMK3Ht8T2+zvGJNAF+5/5qBk7nr079zICbFXvxtidN
# N5eoXdW+9rAIkS+UGD19AZdBrtt6dZ+OdAquBiDkYQ5kVfUMKS31yHQOGgmFxuCO
# zTpWHalrqpdIllsy8KNsj5U9sONiWAd9PNlyEHHbQZDmi9/BNlOYyTt0YehLbDov
# mZUNazk79Od/A917mqCdTqrExwBGUPbMP+/vdYUqaJspupBnUtjOf/76DAhVy8e/
# e6zR98PkplmliO2brL3Q3rD6+ZCVdrGM9Rm6hUDBBkvYh+YjmGdcQ5HB6WT9Rec8
# +qDHmbhLhX4Zdaard5/OXeLbgx2f7L4QQQj3KgqjqDOWInVhNE1gYtTWLHe4882d
# /k7Lui0K1g8EZrKD7maOrsJLKPKlegceJ9FCqY1sDUKUhRa0EHUW+ZkKLlohKrS7
# FwjdrINWkPBgbQznCjdE2m47QjTbMIIHcTCCBVmgAwIBAgITMwAAABXF52ueAptJ
# mQAAAAAAFTANBgkqhkiG9w0BAQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
# dCBDb3Jwb3JhdGlvbjEyMDAGA1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNh
# dGUgQXV0aG9yaXR5IDIwMTAwHhcNMjEwOTMwMTgyMjI1WhcNMzAwOTMwMTgzMjI1
# WjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQD
# Ex1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDCCAiIwDQYJKoZIhvcNAQEB
# BQADggIPADCCAgoCggIBAOThpkzntHIhC3miy9ckeb0O1YLT/e6cBwfSqWxOdcjK
# NVf2AX9sSuDivbk+F2Az/1xPx2b3lVNxWuJ+Slr+uDZnhUYjDLWNE893MsAQGOhg
# fWpSg0S3po5GawcU88V29YZQ3MFEyHFcUTE3oAo4bo3t1w/YJlN8OWECesSq/XJp
# rx2rrPY2vjUmZNqYO7oaezOtgFt+jBAcnVL+tuhiJdxqD89d9P6OU8/W7IVWTe/d
# vI2k45GPsjksUZzpcGkNyjYtcI4xyDUoveO0hyTD4MmPfrVUj9z6BVWYbWg7mka9
# 7aSueik3rMvrg0XnRm7KMtXAhjBcTyziYrLNueKNiOSWrAFKu75xqRdbZ2De+JKR
# Hh09/SDPc31BmkZ1zcRfNN0Sidb9pSB9fvzZnkXftnIv231fgLrbqn427DZM9itu
# qBJR6L8FA6PRc6ZNN3SUHDSCD/AQ8rdHGO2n6Jl8P0zbr17C89XYcz1DTsEzOUyO
# ArxCaC4Q6oRRRuLRvWoYWmEBc8pnol7XKHYC4jMYctenIPDC+hIK12NvDMk2ZItb
# oKaDIV1fMHSRlJTYuVD5C4lh8zYGNRiER9vcG9H9stQcxWv2XFJRXRLbJbqvUAV6
# bMURHXLvjflSxIUXk8A8FdsaN8cIFRg/eKtFtvUeh17aj54WcmnGrnu3tz5q4i6t
# AgMBAAGjggHdMIIB2TASBgkrBgEEAYI3FQEEBQIDAQABMCMGCSsGAQQBgjcVAgQW
# BBQqp1L+ZMSavoKRPEY1Kc8Q/y8E7jAdBgNVHQ4EFgQUn6cVXQBeYl2D9OXSZacb
# UzUZ6XIwXAYDVR0gBFUwUzBRBgwrBgEEAYI3TIN9AQEwQTA/BggrBgEFBQcCARYz
# aHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3BraW9wcy9Eb2NzL1JlcG9zaXRvcnku
# aHRtMBMGA1UdJQQMMAoGCCsGAQUFBwMIMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIA
# QwBBMAsGA1UdDwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFNX2
# VsuP6KJcYmjRPZSQW9fOmhjEMFYGA1UdHwRPME0wS6BJoEeGRWh0dHA6Ly9jcmwu
# bWljcm9zb2Z0LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dF8yMDEw
# LTA2LTIzLmNybDBaBggrBgEFBQcBAQROMEwwSgYIKwYBBQUHMAKGPmh0dHA6Ly93
# d3cubWljcm9zb2Z0LmNvbS9wa2kvY2VydHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYt
# MjMuY3J0MA0GCSqGSIb3DQEBCwUAA4ICAQCdVX38Kq3hLB9nATEkW+Geckv8qW/q
# XBS2Pk5HZHixBpOXPTEztTnXwnE2P9pkbHzQdTltuw8x5MKP+2zRoZQYIu7pZmc6
# U03dmLq2HnjYNi6cqYJWAAOwBb6J6Gngugnue99qb74py27YP0h1AdkY3m2CDPVt
# I1TkeFN1JFe53Z/zjj3G82jfZfakVqr3lbYoVSfQJL1AoL8ZthISEV09J+BAljis
# 9/kpicO8F7BUhUKz/AyeixmJ5/ALaoHCgRlCGVJ1ijbCHcNhcy4sa3tuPywJeBTp
# kbKpW99Jo3QMvOyRgNI95ko+ZjtPu4b6MhrZlvSP9pEB9s7GdP32THJvEKt1MMU0
# sHrYUP4KWN1APMdUbZ1jdEgssU5HLcEUBHG/ZPkkvnNtyo4JvbMBV0lUZNlz138e
# W0QBjloZkWsNn6Qo3GcZKCS6OEuabvshVGtqRRFHqfG3rsjoiV5PndLQTHa1V1QJ
# sWkBRH58oWFsc/4Ku+xBZj1p/cvBQUl+fpO+y/g75LcVv7TOPqUxUYS8vwLBgqJ7
# Fx0ViY1w/ue10CgaiQuPNtq6TPmb/wrpNPgkNWcr4A245oyZ1uEi6vAnQj0llOZ0
# dFtq0Z4+7X6gMTN9vMvpe784cETRkPHIqzqKOghif9lwY1NNje6CbaUFEMFxBmoQ
# tB1VM1izoXBm8qGCAtcwggJAAgEBMIIBAKGB2KSB1TCB0jELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEtMCsGA1UECxMkTWljcm9zb2Z0IElyZWxh
# bmQgT3BlcmF0aW9ucyBMaW1pdGVkMSYwJAYDVQQLEx1UaGFsZXMgVFNTIEVTTjo4
# NkRGLTRCQkMtOTMzNTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUtU3RhbXAgU2Vy
# dmljZaIjCgEBMAcGBSsOAwIaAxUANiNHGWXbNaDPxnyiDbEOciSjFhCggYMwgYCk
# fjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQD
# Ex1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMDANBgkqhkiG9w0BAQUFAAIF
# AOj/t8IwIhgPMjAyMzExMTYwNTMzNTRaGA8yMDIzMTExNzA1MzM1NFowdzA9Bgor
# BgEEAYRZCgQBMS8wLTAKAgUA6P+3wgIBADAKAgEAAgIHJwIB/zAHAgEAAgIRWjAK
# AgUA6QEJQgIBADA2BgorBgEEAYRZCgQCMSgwJjAMBgorBgEEAYRZCgMCoAowCAIB
# AAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3DQEBBQUAA4GBALOQOZrAKsvUjtsw
# NbWmTKgij2cQxdJ1oOjQxELUxMNETM3CtR0+lVKlfIqpbeeT2rWWh4HFiiampvz0
# 3qXnxHzVwY2X9gPlX2TGis2Cn6T/dgyRtUiGBLG1H2NsJ6c9XN6Oq6bmGeqTjhPy
# MbzX2+dOWtPl4vbOlj/uZO9yF/SLMYIEDTCCBAkCAQEwgZMwfDELMAkGA1UEBhMC
# VVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNV
# BAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRp
# bWUtU3RhbXAgUENBIDIwMTACEzMAAAHdXVcdldStqhsAAQAAAd0wDQYJYIZIAWUD
# BAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAvBgkqhkiG9w0B
# CQQxIgQgwu7o/1/BL/5/zum/1LObuDcX0WhNXHDjanYN4LW0HV0wgfoGCyqGSIb3
# DQEJEAIvMYHqMIHnMIHkMIG9BCBh/w4tmmWsT3iZnHtH0Vk37UCN02lRxY+RiON6
# wDFjZjCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9u
# MRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRp
# b24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB
# 3V1XHZXUraobAAEAAAHdMCIEIDnVfOYFf/B23xTOPEJYHTW7p65u8j9IB6M6+j4p
# 6L9nMA0GCSqGSIb3DQEBCwUABIICAH8F6ca60fFAFQOUYgqwnwu8bqTlZESw0qo4
# dKD/1wJI0CcRSpU8pT2PvFEJjJ/H79j62Gmoah2B2qr7V5UBacsR3nMtpYV51Nfg
# IDdDl7Z9eJt4zSbatqF6DBLTjcJBZybBp0if65le+ip1vGdcfAA5bw965F6Kcunb
# SR5rWafnbLOtuPuR1FwgsfteUEJNnQZX8ZFxRxF6V4YG7xwEtbhZ6LUPAYkSZ2BG
# 4NuryFvlS8nBn6vJSVynQ83mrzNLERADYrnGrDjpzVNdZkzDmEcVPb6eL12rwvte
# sfBGy4MaWPxQ7kvNKe2fYQbvrHBAU0YhN7QYz5SJrsddgGidX6G1o7qNBb0jTxb4
# flkxBvsO1RRjlEgu+hgYuoEMKxu6h08QXIZ9+YPTxfugm9EKYuE1jIclPESZZbXG
# H7vrou31oWUz5xVrVkdtmjSPB2RRrZ/2dO6hS3bVvpqtBJC5ei/ElOlUvjtOXN33
# g9+QDAn8OEJ2eA87r2bgbOVKSDn4RKcZhRLjE44L4G3K9AE1CLJcNKL3VOQlZMaa
# ocYHwKVRdqLF69o2N6StB8BkTzf4F52PbtqTmIz2GLcZBO0SRAleKSj0ccZyZ2AP
# d1nptCBOXkh5B3/0P4vETYg1lFuv7JxkeStOKDuWbnLS5vwhbD+eA2Zst7v5yYtn
# V2yw6c+0
# SIG # End signature block
