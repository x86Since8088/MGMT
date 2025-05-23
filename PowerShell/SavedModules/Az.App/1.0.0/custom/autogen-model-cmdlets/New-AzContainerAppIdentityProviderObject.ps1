
# ----------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# Code generated by Microsoft (R) AutoRest Code Generator.Changes may cause incorrect behavior and will be lost if the code
# is regenerated.
# ----------------------------------------------------------------------------------

<#
.Synopsis
Create an in-memory object for IdentityProviders.
.Description
Create an in-memory object for IdentityProviders.

.Outputs
Microsoft.Azure.PowerShell.Cmdlets.App.Models.IdentityProviders
.Link
https://learn.microsoft.com/powershell/module/Az.App/new-azcontainerappidentityproviderobject
#>
function New-AzContainerAppIdentityProviderObject {
    [OutputType('Microsoft.Azure.PowerShell.Cmdlets.App.Models.IdentityProviders')]
    [CmdletBinding(PositionalBinding=$false)]
    Param(

        [Parameter(HelpMessage="The list of the allowed groups.")]
        [string[]]
        $AllowedPrincipalGroup,
        [Parameter(HelpMessage="The list of the allowed identities.")]
        [string[]]
        $AllowedPrincipalIdentity,
        [Parameter(HelpMessage="<code>false</code> if the Apple provider should not be enabled despite the set registration; otherwise, <code>true</code>.")]
        [bool]
        $AppleEnabled,
        [Parameter(HelpMessage="A list of the scopes that should be requested while authenticating.")]
        [string[]]
        $AppleLoginScope,
        [Parameter(HelpMessage="The Client ID of the app used for login.")]
        [string]
        $AppleRegistrationClientId,
        [Parameter(HelpMessage="The app setting name that contains the client secret.")]
        [string]
        $AppleRegistrationClientSecretSettingName,
        [Parameter(HelpMessage="<code>false</code> if the Azure Active Directory provider should not be enabled despite the set registration; otherwise, <code>true</code>.")]
        [bool]
        $AzureActiveDirectoryEnabled,
        [Parameter(HelpMessage="Gets a value indicating whether the Azure AD configuration was auto-provisioned using 1st party tooling.
        This is an internal flag primarily intended to support the Azure Management Portal. Users should not
        read or write to this property.")]
        [bool]
        $AzureActiveDirectoryIsAutoProvisioned,
        [Parameter(HelpMessage="The Client ID of this relying party application, known as the client_id.
        This setting is required for enabling OpenID Connection authentication with Azure Active Directory or
        other 3rd party OpenID Connect providers.
        More information on OpenID Connect: http://openid.net/specs/openid-connect-core-1_0.html.")]
        [string]
        $AzureActiveDirectoryRegistrationClientId,
        [Parameter(HelpMessage="The app setting name that contains the client secret of the relying party application.")]
        [string]
        $AzureActiveDirectoryRegistrationClientSecretSettingName,
        [Parameter(HelpMessage="The list of audiences that can make successful authentication/authorization requests.")]
        [string[]]
        $AzureActiveDirectoryValidationAllowedAudience,
        [Parameter(HelpMessage="<code>false</code> if the Azure Static Web Apps provider should not be enabled despite the set registration; otherwise, <code>true</code>.")]
        [bool]
        $AzureStaticWebAppEnabled,
        [Parameter(HelpMessage="The Client ID of the app used for login.")]
        [string]
        $AzureStaticWebAppsRegistrationClientId,
        [Parameter(HelpMessage="The map of the name of the alias of each custom Open ID Connect provider to the
        configuration settings of the custom Open ID Connect provider.")]
        [Microsoft.Azure.PowerShell.Cmdlets.App.Models.IIdentityProvidersCustomOpenIdConnectProviders]
        $CustomOpenIdConnectProvider,
        [Parameter(HelpMessage="The configuration settings of the Azure Active Directory allowed applications.")]
        [string[]]
        $DefaultAuthorizationPolicyAllowedApplication,
        [Parameter(HelpMessage="<code>false</code> if the Facebook provider should not be enabled despite the set registration; otherwise, <code>true</code>.")]
        [bool]
        $FacebookEnabled,
        [Parameter(HelpMessage="The version of the Facebook api to be used while logging in.")]
        [string]
        $FacebookGraphApiVersion,
        [Parameter(HelpMessage="A list of the scopes that should be requested while authenticating.")]
        [string[]]
        $FacebookLoginScope,
        [Parameter(HelpMessage="<code>false</code> if the GitHub provider should not be enabled despite the set registration; otherwise, <code>true</code>.")]
        [bool]
        $GitHubEnabled,
        [Parameter(HelpMessage="A list of the scopes that should be requested while authenticating.")]
        [string[]]
        $GitHubLoginScope,
        [Parameter(HelpMessage="The Client ID of the app used for login.")]
        [string]
        $GitHubRegistrationClientId,
        [Parameter(HelpMessage="The app setting name that contains the client secret.")]
        [string]
        $GitHubRegistrationClientSecretSettingName,
        [Parameter(HelpMessage="<code>false</code> if the Google provider should not be enabled despite the set registration; otherwise, <code>true</code>.")]
        [bool]
        $GoogleEnabled,
        [Parameter(HelpMessage="A list of the scopes that should be requested while authenticating.")]
        [string[]]
        $GoogleLoginScope,
        [Parameter(HelpMessage="The Client ID of the app used for login.")]
        [string]
        $GoogleRegistrationClientId,
        [Parameter(HelpMessage="The app setting name that contains the client secret.")]
        [string]
        $GoogleRegistrationClientSecretSettingName,
        [Parameter(HelpMessage="The configuration settings of the allowed list of audiences from which to validate the JWT token.")]
        [string[]]
        $GoogleValidationAllowedAudience,
        [Parameter(HelpMessage="The list of the allowed client applications.")]
        [string[]]
        $JwtClaimCheckAllowedClientApplication,
        [Parameter(HelpMessage="The list of the allowed groups.")]
        [string[]]
        $JwtClaimCheckAllowedGroup,
        [Parameter(HelpMessage="<code>true</code> if the www-authenticate provider should be omitted from the request; otherwise, <code>false</code>.")]
        [bool]
        $LoginDisableWwwAuthenticate,
        [Parameter(HelpMessage="Login parameters to send to the OpenID Connect authorization endpoint when
        a user logs in. Each parameter must be in the form `"key=value`".")]
        [string[]]
        $LoginParameter,
        [Parameter(HelpMessage="The App ID of the app used for login.")]
        [string]
        $RegistrationAppId,
        [Parameter(HelpMessage="The app setting name that contains the app secret.")]
        [string]
        $RegistrationAppSecretSettingName,
        [Parameter(HelpMessage="An alternative to the client secret thumbprint, that is the issuer of a certificate used for signing purposes. This property acts as
        a replacement for the Client Secret Certificate Thumbprint. It is also optional.")]
        [string]
        $RegistrationClientSecretCertificateIssuer,
        [Parameter(HelpMessage="An alternative to the client secret thumbprint, that is the subject alternative name of a certificate used for signing purposes. This property acts as
        a replacement for the Client Secret Certificate Thumbprint. It is also optional.")]
        [string]
        $RegistrationClientSecretCertificateSubjectAlternativeName,
        [Parameter(HelpMessage="An alternative to the client secret, that is the thumbprint of a certificate used for signing purposes. This property acts as
        a replacement for the Client Secret. It is also optional.")]
        [string]
        $RegistrationClientSecretCertificateThumbprint,
        [Parameter(HelpMessage="The OAuth 1.0a consumer key of the Twitter application used for sign-in.
        This setting is required for enabling Twitter Sign-In.
        Twitter Sign-In documentation: https://dev.twitter.com/web/sign-in.")]
        [string]
        $RegistrationConsumerKey,
        [Parameter(HelpMessage="The app setting name that contains the OAuth 1.0a consumer secret of the Twitter
        application used for sign-in.")]
        [string]
        $RegistrationConsumerSecretSettingName,
        [Parameter(HelpMessage="The OpenID Connect Issuer URI that represents the entity which issues access tokens for this application.
        When using Azure Active Directory, this value is the URI of the directory tenant, e.g. https://login.microsoftonline.com/v2.0/{tenant-guid}/.
        This URI is a case-sensitive identifier for the token issuer.
        More information on OpenID Connect Discovery: http://openid.net/specs/openid-connect-discovery-1_0.html.")]
        [string]
        $RegistrationOpenIdIssuer,
        [Parameter(HelpMessage="<code>false</code> if the Twitter provider should not be enabled despite the set registration; otherwise, <code>true</code>.")]
        [bool]
        $TwitterEnabled
    )

    process {
        $Object = [Microsoft.Azure.PowerShell.Cmdlets.App.Models.IdentityProviders]::New()

        if ($PSBoundParameters.ContainsKey('AllowedPrincipalGroup')) {
            $Object.AllowedPrincipalGroup = $AllowedPrincipalGroup
        }
        if ($PSBoundParameters.ContainsKey('AllowedPrincipalIdentity')) {
            $Object.AllowedPrincipalIdentity = $AllowedPrincipalIdentity
        }
        if ($PSBoundParameters.ContainsKey('AppleEnabled')) {
            $Object.AppleEnabled = $AppleEnabled
        }
        if ($PSBoundParameters.ContainsKey('AppleLoginScope')) {
            $Object.AppleLoginScope = $AppleLoginScope
        }
        if ($PSBoundParameters.ContainsKey('AppleRegistrationClientId')) {
            $Object.AppleRegistrationClientId = $AppleRegistrationClientId
        }
        if ($PSBoundParameters.ContainsKey('AppleRegistrationClientSecretSettingName')) {
            $Object.AppleRegistrationClientSecretSettingName = $AppleRegistrationClientSecretSettingName
        }
        if ($PSBoundParameters.ContainsKey('AzureActiveDirectoryEnabled')) {
            $Object.AzureActiveDirectoryEnabled = $AzureActiveDirectoryEnabled
        }
        if ($PSBoundParameters.ContainsKey('AzureActiveDirectoryIsAutoProvisioned')) {
            $Object.AzureActiveDirectoryIsAutoProvisioned = $AzureActiveDirectoryIsAutoProvisioned
        }
        if ($PSBoundParameters.ContainsKey('AzureActiveDirectoryRegistrationClientId')) {
            $Object.AzureActiveDirectoryRegistrationClientId = $AzureActiveDirectoryRegistrationClientId
        }
        if ($PSBoundParameters.ContainsKey('AzureActiveDirectoryRegistrationClientSecretSettingName')) {
            $Object.AzureActiveDirectoryRegistrationClientSecretSettingName = $AzureActiveDirectoryRegistrationClientSecretSettingName
        }
        if ($PSBoundParameters.ContainsKey('AzureActiveDirectoryValidationAllowedAudience')) {
            $Object.AzureActiveDirectoryValidationAllowedAudience = $AzureActiveDirectoryValidationAllowedAudience
        }
        if ($PSBoundParameters.ContainsKey('AzureStaticWebAppEnabled')) {
            $Object.AzureStaticWebAppEnabled = $AzureStaticWebAppEnabled
        }
        if ($PSBoundParameters.ContainsKey('AzureStaticWebAppsRegistrationClientId')) {
            $Object.AzureStaticWebAppsRegistrationClientId = $AzureStaticWebAppsRegistrationClientId
        }
        if ($PSBoundParameters.ContainsKey('CustomOpenIdConnectProvider')) {
            $Object.CustomOpenIdConnectProvider = $CustomOpenIdConnectProvider
        }
        if ($PSBoundParameters.ContainsKey('DefaultAuthorizationPolicyAllowedApplication')) {
            $Object.DefaultAuthorizationPolicyAllowedApplication = $DefaultAuthorizationPolicyAllowedApplication
        }
        if ($PSBoundParameters.ContainsKey('FacebookEnabled')) {
            $Object.FacebookEnabled = $FacebookEnabled
        }
        if ($PSBoundParameters.ContainsKey('FacebookGraphApiVersion')) {
            $Object.FacebookGraphApiVersion = $FacebookGraphApiVersion
        }
        if ($PSBoundParameters.ContainsKey('FacebookLoginScope')) {
            $Object.FacebookLoginScope = $FacebookLoginScope
        }
        if ($PSBoundParameters.ContainsKey('GitHubEnabled')) {
            $Object.GitHubEnabled = $GitHubEnabled
        }
        if ($PSBoundParameters.ContainsKey('GitHubLoginScope')) {
            $Object.GitHubLoginScope = $GitHubLoginScope
        }
        if ($PSBoundParameters.ContainsKey('GitHubRegistrationClientId')) {
            $Object.GitHubRegistrationClientId = $GitHubRegistrationClientId
        }
        if ($PSBoundParameters.ContainsKey('GitHubRegistrationClientSecretSettingName')) {
            $Object.GitHubRegistrationClientSecretSettingName = $GitHubRegistrationClientSecretSettingName
        }
        if ($PSBoundParameters.ContainsKey('GoogleEnabled')) {
            $Object.GoogleEnabled = $GoogleEnabled
        }
        if ($PSBoundParameters.ContainsKey('GoogleLoginScope')) {
            $Object.GoogleLoginScope = $GoogleLoginScope
        }
        if ($PSBoundParameters.ContainsKey('GoogleRegistrationClientId')) {
            $Object.GoogleRegistrationClientId = $GoogleRegistrationClientId
        }
        if ($PSBoundParameters.ContainsKey('GoogleRegistrationClientSecretSettingName')) {
            $Object.GoogleRegistrationClientSecretSettingName = $GoogleRegistrationClientSecretSettingName
        }
        if ($PSBoundParameters.ContainsKey('GoogleValidationAllowedAudience')) {
            $Object.GoogleValidationAllowedAudience = $GoogleValidationAllowedAudience
        }
        if ($PSBoundParameters.ContainsKey('JwtClaimCheckAllowedClientApplication')) {
            $Object.JwtClaimCheckAllowedClientApplication = $JwtClaimCheckAllowedClientApplication
        }
        if ($PSBoundParameters.ContainsKey('JwtClaimCheckAllowedGroup')) {
            $Object.JwtClaimCheckAllowedGroup = $JwtClaimCheckAllowedGroup
        }
        if ($PSBoundParameters.ContainsKey('LoginDisableWwwAuthenticate')) {
            $Object.LoginDisableWwwAuthenticate = $LoginDisableWwwAuthenticate
        }
        if ($PSBoundParameters.ContainsKey('LoginParameter')) {
            $Object.LoginParameter = $LoginParameter
        }
        if ($PSBoundParameters.ContainsKey('RegistrationAppId')) {
            $Object.RegistrationAppId = $RegistrationAppId
        }
        if ($PSBoundParameters.ContainsKey('RegistrationAppSecretSettingName')) {
            $Object.RegistrationAppSecretSettingName = $RegistrationAppSecretSettingName
        }
        if ($PSBoundParameters.ContainsKey('RegistrationClientSecretCertificateIssuer')) {
            $Object.RegistrationClientSecretCertificateIssuer = $RegistrationClientSecretCertificateIssuer
        }
        if ($PSBoundParameters.ContainsKey('RegistrationClientSecretCertificateSubjectAlternativeName')) {
            $Object.RegistrationClientSecretCertificateSubjectAlternativeName = $RegistrationClientSecretCertificateSubjectAlternativeName
        }
        if ($PSBoundParameters.ContainsKey('RegistrationClientSecretCertificateThumbprint')) {
            $Object.RegistrationClientSecretCertificateThumbprint = $RegistrationClientSecretCertificateThumbprint
        }
        if ($PSBoundParameters.ContainsKey('RegistrationConsumerKey')) {
            $Object.RegistrationConsumerKey = $RegistrationConsumerKey
        }
        if ($PSBoundParameters.ContainsKey('RegistrationConsumerSecretSettingName')) {
            $Object.RegistrationConsumerSecretSettingName = $RegistrationConsumerSecretSettingName
        }
        if ($PSBoundParameters.ContainsKey('RegistrationOpenIdIssuer')) {
            $Object.RegistrationOpenIdIssuer = $RegistrationOpenIdIssuer
        }
        if ($PSBoundParameters.ContainsKey('TwitterEnabled')) {
            $Object.TwitterEnabled = $TwitterEnabled
        }
        return $Object
    }
}


# SIG # Begin signature block
# MIIoLQYJKoZIhvcNAQcCoIIoHjCCKBoCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCADkJC1yp37DgVL
# bvAORZJBElZxIdKBwQ+XdIsMdeDXRaCCDXYwggX0MIID3KADAgECAhMzAAADTrU8
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGg0wghoJAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAANOtTx6wYRv6ysAAAAAA04wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIEyctJo0SjWPWkOVMrvGbngW
# I1IperjJRUBUvNIgwZP4MEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEA0rOrjdjE4cXHSjdBs2jmcCdOCiYAJRohwpnxU4w7pgtpTHiOT7URr3Kj
# fIYB6Mwyi3816j1waA7MvrsR1fE+SG3SzFTk82s+LIWevP0UGIuS37wORxghFJ3v
# OKUyx4+n9hVKmDRyVowKzZk81n0vhw0SSFpkfKbuqCfaX1vXMDgK4MrorHLgmcsD
# 3OyzzvUy2FO/xa+ckWf7Txi9FUUYjD2lXe7I3WAjtsfuEv39Vr09DG8do8CxhC9H
# EB0VVGMhw+aK/ZSBORSsywjmM0QyLS2vyrAi7y67khgkPzcDCBylkTDA1v9bftCA
# yS1jdAMmxSiDkMOjyYF6Ckdq5FtnvqGCF5cwgheTBgorBgEEAYI3AwMBMYIXgzCC
# F38GCSqGSIb3DQEHAqCCF3AwghdsAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFSBgsq
# hkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCCUdjwYqnqFLI1EMf/KVxnCEFz1dpmr1MtauV+KoVRlVgIGZSie3sty
# GBMyMDIzMTExMDA0MjUzMC41OTZaMASAAgH0oIHRpIHOMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046MzcwMy0w
# NUUwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Wg
# ghHtMIIHIDCCBQigAwIBAgITMwAAAdTk6QMvwKxprAABAAAB1DANBgkqhkiG9w0B
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
# 6Xu/OHBE0ZDxyKs6ijoIYn/ZcGNTTY3ugm2lBRDBcQZqELQdVTNYs6FwZvKhggNQ
# MIICOAIBATCB+aGB0aSBzjCByzELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEn
# MCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjM3MDMtMDVFMC1EOTQ3MSUwIwYDVQQD
# ExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMKAQEwBwYFKw4DAhoDFQAt
# M12Wjo2xxA5sduzB/3HdzZmiSKCBgzCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6PgGETAiGA8yMDIzMTExMDAxMjk1
# M1oYDzIwMjMxMTExMDEyOTUzWjB3MD0GCisGAQQBhFkKBAExLzAtMAoCBQDo+AYR
# AgEAMAoCAQACAiIUAgH/MAcCAQACAhMfMAoCBQDo+VeRAgEAMDYGCisGAQQBhFkK
# BAIxKDAmMAwGCisGAQQBhFkKAwKgCjAIAgEAAgMHoSChCjAIAgEAAgMBhqAwDQYJ
# KoZIhvcNAQELBQADggEBAC6f4TXPK1ilSwZV0aTKgLMoDkpYlXB/rl2rYtLJQRAJ
# g0sp8CkAHwf5z+T3Mz7mvkwRDlm3xX4ZewUQ4w+2gFkHxCex1Ld59Ngq95iZpcEL
# R4sEPuJ5XrYoH3KztPCpVZSHB1PIVgt+rLVCnuccwkOeDcUySzUnlqd+LuHz0rsD
# RBuvWGp5701p8zxDwefZAWlCHEzN/wMOuYLXHgxEuiwtQohXH382/J7YA7BlarV7
# bA/FjUQkB5mTGLdJA/ZFm16Q0irolrAJ8eL7u4Qqum5F/V17pamZoB+ZaxRdZMgv
# aSuDgS/97BhAMWAZeE+9D3vJ0K8SOgjFBpOIW7mm7QkxggQNMIIECQIBATCBkzB8
# MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVk
# bW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1N
# aWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAAAdTk6QMvwKxprAABAAAB
# 1DANBglghkgBZQMEAgEFAKCCAUowGgYJKoZIhvcNAQkDMQ0GCyqGSIb3DQEJEAEE
# MC8GCSqGSIb3DQEJBDEiBCDW7pqMok/eJwOuy3uwdC1RqL4lKYTmJqf7g/tpzMAS
# xTCB+gYLKoZIhvcNAQkQAi8xgeowgecwgeQwgb0EIMzqh/rYFKXOlzvWS5xCtPi9
# aU+fBUkxIriXp2WTPWI3MIGYMIGApH4wfDELMAkGA1UEBhMCVVMxEzARBgNVBAgT
# Cldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29m
# dCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENB
# IDIwMTACEzMAAAHU5OkDL8CsaawAAQAAAdQwIgQgnKCHJytdrevsu9Irt1Q7JeSZ
# p9D53lrTXJAJX48HNPowDQYJKoZIhvcNAQELBQAEggIAEBh9mlOgXozslDv2cK73
# aYlqQ7o/izZFCqcR+XTBmLAgUV8wJ3C7ih6f3GAglbkZvKoL/UVTfirsfVkO2zRe
# rMou/sXzRKau0gMSRcHjpC3fSiBfD+AlmZbLw3e4C5H72Ua3/jYQ8lTd/WwZrNW2
# QzlObbz6PLjUDxmn3B8prMJCglBzX/jUo55rr3E0A+jkrBrICL2pbcgy9ULWxr2b
# /aNnAB1oDWnrrRosvNdBawrtxdHoIcXjOR54UySsADYlaURamSFEVrxkx7oVuOwl
# qdSk63+akZqPnAxVkU/kehUt5yXqTjEbtn+ye6tOML6feWgtZlhvccrWwpP9V3iL
# rcV0Y4gGWI6xHqQNossQIAfZ6bYBLgVL82YjjgbPk2tJzKhJQpg+cXK35pmzOmlU
# jLCcnG7UzR1Ddxp6QvnD7/Twgycpjx9l3p7Y2EnhQTJZNdJcg5xz+mUj3HhDnW+H
# FusOxDc9u3YOsPbTg70knbl2bp61Cf8224oNj8rI3fVEWP8c8zNRU/+1XOfxQbj7
# LnlXfENy2PimEZc7sGgIhvba8fK5J/NmVuNXygQmmcBbDRmvY67zhAv/FFb/QHqB
# dppM0LyEzcqnOT/hU86VubQ/6trHxelhw5caB0txM0Hkm/qhaK/QWPbgB+peTZL1
# AQ9oouIF+PK7qWcwde05pmQ=
# SIG # End signature block
