
# ----------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See License.txt in the project root for license information.
# Code generated by Microsoft (R) AutoRest Code Generator.
# Changes may cause incorrect behavior and will be lost if the code is regenerated.
# ----------------------------------------------------------------------------------

<#
.Synopsis
Updates entity in users
.Description
Updates entity in users
.Notes
COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.

APPROLEASSIGNMENT <IMicrosoftGraphAppRoleAssignmentAutoGenerated2[]>: Represents the app roles a user has been granted for an application. Supports $expand.
  [DeletedDateTime <DateTime?>]: 
  [Id <String>]: Read-only.
  [AppRoleId <String>]: The identifier (id) for the app role which is assigned to the principal. This app role must be exposed in the appRoles property on the resource application's service principal (resourceId). If the resource application has not declared any app roles, a default app role ID of 00000000-0000-0000-0000-000000000000 can be specified to signal that the principal is assigned to the resource app without any specific app roles. Required on create.
  [CreatedDateTime <DateTime?>]: The time when the app role assignment was created.The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z. Read-only.
  [PrincipalDisplayName <String>]: The display name of the user, group, or service principal that was granted the app role assignment. Read-only. Supports $filter (eq and startswith).
  [PrincipalId <String>]: The unique identifier (id) for the user, group or service principal being granted the app role. Required on create.
  [PrincipalType <String>]: The type of the assigned principal. This can either be User, Group or ServicePrincipal. Read-only.
  [ResourceDisplayName <String>]: The display name of the resource app's service principal to which the assignment is made.
  [ResourceId <String>]: The unique identifier (id) for the resource service principal for which the assignment is made. Required on create. Supports $filter (eq only).

IDENTITY <IMicrosoftGraphObjectIdentity[]>: Represents the identities that can be used to sign in to this user account. An identity can be provided by Microsoft (also known as a local account), by organizations, or by social identity providers such as Facebook, Google, and Microsoft, and tied to a user account. May contain multiple items with the same signInType value. Supports $filter (eq) only where the signInType is not userPrincipalName.
  [Issuer <String>]: Specifies the issuer of the identity, for example facebook.com.For local accounts (where signInType is not federated), this property is the local B2C tenant default domain name, for example contoso.onmicrosoft.com.For external users from other Azure AD organization, this will be the domain of the federated organization, for example contoso.com.Supports $filter. 512 character limit.
  [IssuerAssignedId <String>]: Specifies the unique identifier assigned to the user by the issuer. The combination of issuer and issuerAssignedId must be unique within the organization. Represents the sign-in name for the user, when signInType is set to emailAddress or userName (also known as local accounts).When signInType is set to: emailAddress, (or a custom string that starts with emailAddress like emailAddress1) issuerAssignedId must be a valid email addressuserName, issuerAssignedId must be a valid local part of an email addressSupports $filter. 100 character limit.
  [SignInType <String>]: Specifies the user sign-in types in your directory, such as emailAddress, userName or federated. Here, federated represents a unique identifier for a user from an issuer, that can be in any format chosen by the issuer. Additional validation is enforced on issuerAssignedId when the sign-in type is set to emailAddress or userName. This property can also be set to any custom string.

PASSWORDPROFILE <IMicrosoftGraphPasswordProfile>: passwordProfile
  [(Any) <Object>]: This indicates any property can be added to this object.
  [ForceChangePasswordNextSignIn <Boolean?>]: true if the user must change her password on the next login; otherwise false. If not set, default is false. NOTE:  For Azure B2C tenants, set to false and instead use custom policies and user flows to force password reset at first sign in. See Force password reset at first logon.
  [ForceChangePasswordNextSignInWithMfa <Boolean?>]: If true, at next sign-in, the user must perform a multi-factor authentication (MFA) before being forced to change their password. The behavior is identical to forceChangePasswordNextSignIn except that the user is required to first perform a multi-factor authentication before password change. After a password change, this property will be automatically reset to false. If not set, default is false.
  [Password <String>]: The password for the user. This property is required when a user is created. It can be updated, but the user will be required to change the password on the next login. The password must satisfy minimum requirements as specified by the user’s passwordPolicies property. By default, a strong password is required.
.Link
https://learn.microsoft.com/powershell/module/az.resources/update-azaduser
#>
function Update-AzADUser {
    [OutputType([System.Boolean])]
    [CmdletBinding(DefaultParameterSetName='UPNOrObjectIdParameterSet', PositionalBinding=$false, SupportsShouldProcess, ConfirmImpact='Medium')]
    [Alias('Set-AzADUser')]
    param(
        [Parameter(ParameterSetName='UPNOrObjectIdParameterSet', Mandatory)]
        [System.String]
        # The user principal name or object id of the user to be updated.
        ${UPNOrObjectId},
        
        [Parameter(ParameterSetName='ObjectIdParameterSet', Mandatory)]
        [System.String]
        # The user principal name of the user to be updated.
        ${ObjectId},
        
        [Parameter(ParameterSetName = 'InputObjectParameterSet', Mandatory, ValueFromPipeline)]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphUser]
        # user input object
        ${InputObject},

        [Parameter()]
        [System.Boolean]
        [Alias('EnableAccount')]
        # true for enabling the account; otherwise, false.
        # Always true when combined with `-Password`.
        # `-AccountEnabled $false` is ignored when changing the account's password.
        ${AccountEnabled},
        
        [Parameter()]
        [SecureString]
        # The password for the user. This property is required when a user is created. 
        # It can be updated, but the user will be required to change the password on the next login. 
        # The password must satisfy minimum requirements as speci./fied by the user's passwordPolicies property.
        # By default, a strong password is required. When changing the password using this method, AccountEnabled is set to true.
        ${Password},

        [Parameter()]
        [System.Management.Automation.SwitchParameter]
        # It must be specified if the user must change the password on the next successful login (true). Default behavior is (false) to not change the password on the next successful login.
        ${ForceChangePasswordNextLogin},

        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # Sets the age group of the user.
        # Allowed values: null, minor, notAdult and adult.
        # Refer to the legal age group property definitions for further information.
        # Supports $filter (eq, ne, NOT, and in).
        ${AgeGroup},
        
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # The city in which the user is located.
        # Maximum length is 128 characters.
        # Supports $filter (eq, ne, NOT, ge, le, in, startsWith).
        ${City},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # The company name which the user is associated.
        # This property can be useful for describing the company that an external user comes from.
        # The maximum length of the company name is 64 characters.Supports $filter (eq, ne, NOT, ge, le, in, startsWith).
        ${CompanyName},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # Sets whether consent has been obtained for minors.
        # Allowed values: null, granted, denied and notRequired.
        # Refer to the legal age group property definitions for further information.
        # Supports $filter (eq, ne, NOT, and in).
        ${ConsentProvidedForMinor},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # The country/region in which the user is located; for example, US or UK.
        # Maximum length is 128 characters.
        # Supports $filter (eq, ne, NOT, ge, le, in, startsWith).
        ${Country},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.DateTime]
        # .
        ${DeletedDateTime},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # The name for the department in which the user works.
        # Maximum length is 64 characters.Supports $filter (eq, ne, NOT , ge, le, and in operators).
        ${Department},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # The name displayed in the address book for the user.
        # This value is usually the combination of the user's first name, middle initial, and last name.
        # This property is required when a user is created and it cannot be cleared during updates.
        # Maximum length is 256 characters.
        # Supports $filter (eq, ne, NOT , ge, le, in, startsWith), $orderBy, and $search.
        ${DisplayName},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.DateTime]
        # The date and time when the user was hired or will start work in case of a future hire.
        # Supports $filter (eq, ne, NOT , ge, le, in).
        ${EmployeeHireDate},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # The employee identifier assigned to the user by the organization.
        # Supports $filter (eq, ne, NOT , ge, le, in, startsWith).
        ${EmployeeId},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # Captures enterprise worker type.
        # For example, Employee, Contractor, Consultant, or Vendor.
        # Supports $filter (eq, ne, NOT , ge, le, in, startsWith).
        ${EmployeeType},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # For an external user invited to the tenant using the invitation API, this property represents the invited user's invitation status.
        # For invited users, the state can be PendingAcceptance or Accepted, or null for all other users.
        # Supports $filter (eq, ne, NOT , in).
        ${ExternalUserState},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.DateTime]
        # Shows the timestamp for the latest change to the externalUserState property.
        # Supports $filter (eq, ne, NOT , in).
        ${ExternalUserStateChangeDateTime},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # The fax number of the user.
        # Supports $filter (eq, ne, NOT , ge, le, in, startsWith).
        ${FaxNumber},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # The given name (first name) of the user.
        # Maximum length is 64 characters.
        # Supports $filter (eq, ne, NOT , ge, le, in, startsWith).
        ${GivenName},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # Read-only.
        ${Id},
    
        [Parameter()]
        [AllowEmptyCollection()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphObjectIdentity[]]
        # Represents the identities that can be used to sign in to this user account.
        # An identity can be provided by Microsoft (also known as a local account), by organizations, or by social identity providers such as Facebook, Google, and Microsoft, and tied to a user account.
        # May contain multiple items with the same signInType value.
        # Supports $filter (eq) only where the signInType is not userPrincipalName.
        # To construct, see NOTES section for IDENTITY properties and create a hash table.
        ${Identity},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        # Do not use – reserved for future use.
        ${IsResourceAccount},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # The user's job title.
        # Maximum length is 128 characters.
        # Supports $filter (eq, ne, NOT , ge, le, in, startsWith).
        ${JobTitle},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # The SMTP address for the user, for example, admin@contoso.com.
        # Changes to this property will also update the user's proxyAddresses collection to include the value as an SMTP address.
        # While this property can contain accent characters, using them can cause access issues with other Microsoft applications for the user.
        # Supports $filter (eq, ne, NOT, ge, le, in, startsWith, endsWith).
        ${Mail},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # The mail alias for the user.
        # This property must be specified when a user is created.
        # Maximum length is 64 characters.
        # Supports $filter (eq, ne, NOT, ge, le, in, startsWith).
        ${MailNickname},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # The office location in the user's place of business.
        # Maximum length is 128 characters.
        # Supports $filter (eq, ne, NOT, ge, le, in, startsWith).
        ${OfficeLocation},

        [Parameter()]
        [System.String]
        # This property is used to associate an on-premises Active Directory user account to their Azure AD user object.
        # This property must be specified when creating a new user account in the Graph if you are using a federated domain for the user's userPrincipalName (UPN) property.
        # NOTE: The $ and _ characters cannot be used when specifying this property.
        # Returned only on $select.
        # Supports $filter (eq, ne, NOT, ge, le, in)..
        ${OnPremisesImmutableId},
    
        [Parameter()]
        [AllowEmptyCollection()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String[]]
        # A list of additional email addresses for the user; for example: ['bob@contoso.com', 'Robert@fabrikam.com'].NOTE: While this property can contain accent characters, they can cause access issues to first-party applications for the user.Supports $filter (eq, NOT, ge, le, in, startsWith).
        ${OtherMail},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # Specifies password policies for the user.
        # This value is an enumeration with one possible value being DisableStrongPassword, which allows weaker passwords than the default policy to be specified.
        # DisablePasswordExpiration can also be specified.
        # The two may be specified together; for example: DisablePasswordExpiration, DisableStrongPassword.Supports $filter (ne, NOT).
        ${PasswordPolicy},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphPasswordProfile]
        # passwordProfile
        # To construct, see NOTES section for PASSWORDPROFILE properties and create a hash table.
        ${PasswordProfile},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # The postal code for the user's postal address.
        # The postal code is specific to the user's country/region.
        # In the United States of America, this attribute contains the ZIP code.
        # Maximum length is 40 characters.
        # Supports $filter (eq, ne, NOT, ge, le, in, startsWith).
        ${PostalCode},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # The preferred language for the user.
        # Should follow ISO 639-1 Code; for example en-US.
        # Supports $filter (eq, ne, NOT, ge, le, in, startsWith).
        ${PreferredLanguage},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.Management.Automation.SwitchParameter]
        # true if the Outlook global address list should contain this user, otherwise false.
        # If not set, this will be treated as true.
        # For users invited through the invitation manager, this property will be set to false.
        # Supports $filter (eq, ne, NOT, in).
        ${ShowInAddressList},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # The state or province in the user's address.
        # Maximum length is 128 characters.
        # Supports $filter (eq, ne, NOT, ge, le, in, startsWith).
        ${State},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # The street address of the user's place of business.
        # Maximum length is 1024 characters.
        # Supports $filter (eq, ne, NOT, ge, le, in, startsWith).
        ${StreetAddress},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # The user's surname (family name or last name).
        # Maximum length is 64 characters.
        # Supports $filter (eq, ne, NOT, ge, le, in, startsWith).
        ${Surname},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # A two letter country code (ISO standard 3166).
        # Required for users that will be assigned licenses due to legal requirement to check for availability of services in countries.
        # Examples include: US, JP, and GB.
        # Not nullable.
        # Supports $filter (eq, ne, NOT, ge, le, in, startsWith).
        ${UsageLocation},
    
        [Parameter(ParameterSetName='UPNParameterSet', Mandatory)]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        [Alias("UPN")]
        # The user principal name (UPN) of the user.
        # The UPN is an Internet-style login name for the user based on the Internet standard RFC 822.
        # By convention, this should map to the user's email name.
        # The general format is alias@domain, where domain must be present in the tenant's collection of verified domains.
        # This property is required when a user is created.
        # The verified domains for the tenant can be accessed from the verifiedDomains property of organization.NOTE: While this property can contain accent characters, they can cause access issues to first-party applications for the user.
        # Supports $filter (eq, ne, NOT, ge, le, in, startsWith, endsWith) and $orderBy.
        ${UserPrincipalName},
    
        [Parameter()]
        [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
        [System.String]
        # A string value that can be used to classify user types in your directory, such as Member and Guest.
        # Supports $filter (eq, ne, NOT, in,).
        ${UserType},
    
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
            switch ($PSCmdlet.ParameterSetName) {
            'ObjectIdParameterSet' {
                $id = $PSBoundParameters['ObjectId']
                $null = $PSBoundParameters.Remove('ObjectId')
                break
            }
            'InputObjectParameterSet' {
                $id = $PSBoundParameters['InputObject'].Id
                $null = $PSBoundParameters.Remove('InputObject')
                break
            }
            'UPNOrObjectIdParameterSet' {
                $id = $PSBoundParameters['UPNOrObjectId']
                $null = $PSBoundParameters.Remove('UPNOrObjectId')
                break
            }
            'UPNParameterSet' {
              $id = $PSBoundParameters['UserPrincipalName']
              $null = $PSBoundParameters.Remove('UserPrincipalName')
              break
          }
      }
      if ($PSBoundParameters.ContainsKey('Password')) {
        $passwordProfile = [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.MicrosoftGraphPasswordProfile]::New()
        $passwordProfile.ForceChangePasswordNextSignIn = $ForceChangePasswordNextLogin
        $passwordProfile.Password = . "$PSScriptRoot/../utils/Unprotect-SecureString.ps1" $PSBoundParameters['Password']
        $null = $PSBoundParameters.Remove('Password')
        $null = $PSBoundParameters.Remove('ForceChangePasswordNextLogin')
        $PSBoundParameters['AccountEnabled'] = $true
        $PSBoundParameters['PasswordProfile'] = $passwordProfile
      }
      $PSBoundParameters['Id'] = $id

      Az.MSGraph.internal\Update-AzADUser @PSBoundParameters
    }
}
    
# SIG # Begin signature block
# MIIoKAYJKoZIhvcNAQcCoIIoGTCCKBUCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAur9tTiLkd+Jsa
# 4j1tY0w5rIfEcE92isv+juWB1+vFUKCCDXYwggX0MIID3KADAgECAhMzAAADrzBA
# DkyjTQVBAAAAAAOvMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMjMxMTE2MTkwOTAwWhcNMjQxMTE0MTkwOTAwWjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDOS8s1ra6f0YGtg0OhEaQa/t3Q+q1MEHhWJhqQVuO5amYXQpy8MDPNoJYk+FWA
# hePP5LxwcSge5aen+f5Q6WNPd6EDxGzotvVpNi5ve0H97S3F7C/axDfKxyNh21MG
# 0W8Sb0vxi/vorcLHOL9i+t2D6yvvDzLlEefUCbQV/zGCBjXGlYJcUj6RAzXyeNAN
# xSpKXAGd7Fh+ocGHPPphcD9LQTOJgG7Y7aYztHqBLJiQQ4eAgZNU4ac6+8LnEGAL
# go1ydC5BJEuJQjYKbNTy959HrKSu7LO3Ws0w8jw6pYdC1IMpdTkk2puTgY2PDNzB
# tLM4evG7FYer3WX+8t1UMYNTAgMBAAGjggFzMIIBbzAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQURxxxNPIEPGSO8kqz+bgCAQWGXsEw
# RQYDVR0RBD4wPKQ6MDgxHjAcBgNVBAsTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEW
# MBQGA1UEBRMNMjMwMDEyKzUwMTgyNjAfBgNVHSMEGDAWgBRIbmTlUAXTgqoXNzci
# tW2oynUClTBUBgNVHR8ETTBLMEmgR6BFhkNodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20vcGtpb3BzL2NybC9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3JsMGEG
# CCsGAQUFBwEBBFUwUzBRBggrBgEFBQcwAoZFaHR0cDovL3d3dy5taWNyb3NvZnQu
# Y29tL3BraW9wcy9jZXJ0cy9NaWNDb2RTaWdQQ0EyMDExXzIwMTEtMDctMDguY3J0
# MAwGA1UdEwEB/wQCMAAwDQYJKoZIhvcNAQELBQADggIBAISxFt/zR2frTFPB45Yd
# mhZpB2nNJoOoi+qlgcTlnO4QwlYN1w/vYwbDy/oFJolD5r6FMJd0RGcgEM8q9TgQ
# 2OC7gQEmhweVJ7yuKJlQBH7P7Pg5RiqgV3cSonJ+OM4kFHbP3gPLiyzssSQdRuPY
# 1mIWoGg9i7Y4ZC8ST7WhpSyc0pns2XsUe1XsIjaUcGu7zd7gg97eCUiLRdVklPmp
# XobH9CEAWakRUGNICYN2AgjhRTC4j3KJfqMkU04R6Toyh4/Toswm1uoDcGr5laYn
# TfcX3u5WnJqJLhuPe8Uj9kGAOcyo0O1mNwDa+LhFEzB6CB32+wfJMumfr6degvLT
# e8x55urQLeTjimBQgS49BSUkhFN7ois3cZyNpnrMca5AZaC7pLI72vuqSsSlLalG
# OcZmPHZGYJqZ0BacN274OZ80Q8B11iNokns9Od348bMb5Z4fihxaBWebl8kWEi2O
# PvQImOAeq3nt7UWJBzJYLAGEpfasaA3ZQgIcEXdD+uwo6ymMzDY6UamFOfYqYWXk
# ntxDGu7ngD2ugKUuccYKJJRiiz+LAUcj90BVcSHRLQop9N8zoALr/1sJuwPrVAtx
# HNEgSW+AKBqIxYWM4Ev32l6agSUAezLMbq5f3d8x9qzT031jMDT+sUAoCw0M5wVt
# CUQcqINPuYjbS1WgJyZIiEkBMIIHejCCBWKgAwIBAgIKYQ6Q0gAAAAAAAzANBgkq
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
# /Xmfwb1tbWrJUnMTDXpQzTGCGggwghoEAgEBMIGVMH4xCzAJBgNVBAYTAlVTMRMw
# EQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVN
# aWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNp
# Z25pbmcgUENBIDIwMTECEzMAAAOvMEAOTKNNBUEAAAAAA68wDQYJYIZIAWUDBAIB
# BQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEO
# MAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIA/lEpnOvBN33kb0B2TCAgof
# 1ugg08IdAIx6uqcQ23tdMEIGCisGAQQBgjcCAQwxNDAyoBSAEgBNAGkAYwByAG8A
# cwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20wDQYJKoZIhvcNAQEB
# BQAEggEAXrAQiMuOzfP77mxfE8r5Ha9WaHGgR+eOMuwgGn8fXaV6elnjeQ0AsZ+2
# hCXPUTV7LjUqRELQMqBaMt8ATbU2pyRsNozKKiEN0N8uMmzU0FFHKNJFl10eStsy
# Qd4GUYiU9a7ZyKjClTrvb4b6ftlfL1mU11178Z7ChjH+RsXbVjlaxXROhLiRAFpe
# jRRzAoANmxC0M68aGQffnCMhekWYCWrl1RzxhHv+fLm42TAR78l1zgQkF7RrIY8D
# EXcA3Tk16LgR+75EVkchLfPcpmyy5/XSy1ZOo8OqDhc2Bkpa65CKZi7/Tz+Xrv8P
# mIHRd1goBFDEsvKw2vYGK6P5jaAb6qGCF5IwgheOBgorBgEEAYI3AwMBMYIXfjCC
# F3oGCSqGSIb3DQEHAqCCF2swghdnAgEDMQ8wDQYJYIZIAWUDBAIBBQAwggFQBgsq
# hkiG9w0BCRABBKCCAT8EggE7MIIBNwIBAQYKKwYBBAGEWQoDATAxMA0GCWCGSAFl
# AwQCAQUABCCvbliN5DtHFme54NKQQdgH0aNWJYWLm2rHvRq/cBebagIGZbwSjygc
# GBEyMDI0MDIwODA5NDA1NS4zWjAEgAIB9KCB0aSBzjCByzELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJp
# Y2EgT3BlcmF0aW9uczEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjg2MDMtMDVF
# MC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloIIR
# 6jCCByAwggUIoAMCAQICEzMAAAHxs0X1J+jAFtYAAQAAAfEwDQYJKoZIhvcNAQEL
# BQAwfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
# B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UE
# AxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwHhcNMjMxMjA2MTg0NTU1
# WhcNMjUwMzA1MTg0NTU1WjCByzELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hp
# bmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jw
# b3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEn
# MCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOjg2MDMtMDVFMC1EOTQ3MSUwIwYDVQQD
# ExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNlMIICIjANBgkqhkiG9w0BAQEF
# AAOCAg8AMIICCgKCAgEAsbpQmbbSH/F/e61vfyfkOFYPT4roAdcmtfw0ccS1tocM
# uEILVN4+X1e+WSmul000IVuQpZBpeoKdZ3eVQbMeCW/qFOD7DANn6HvID/W0DT1c
# SBzCbuk2HK659/R3XXrdsZHalIc88kl2jxahTJNlYnxH4/h0eiYXjbNiy85vBQyZ
# vqQXXTwy2oP0fgDyFh8n7avYrcDNFj+WdHX0MiOFpVXlEvr6LbD21pvkSrB+BUDY
# c29Lfw+IrrXHwit/yyvsS5kunZgIewDCrhFJfItpHVgQ0XHPiVmttUgnn8eUj4SR
# BYGIXRjwKKdxtZfE993Kq2y7XBSasMOE0ImIgpHcrAnJyBdGakjQB3HyPUgL94H5
# MsakDSSd7E7IORj0RfeZqoG30G5BZ1Ne4mG0SDyasIEi4cgfN92Q4Js8WypiZnQ2
# m280tMhoZ4B2uvoMFWjlKnB3/cOpMMTKPjqht0GSHMHecBxArOawCWejyMhTOwHd
# oUVBR0U4t+dyO1eMRIGBrmW+qhcej3+OIuwI126bVKJQ3Fc2BHYC0ElorhWo0ul4
# N5OwsvE4jORz1CvS2SJ5aE8blC0sSZie5041Izo+ccEZgu8dkv5sapfJ7x0gjdTh
# A9v8BAjqLejBHvWy9586CsDvEzZREraubHHduRgNIDEDvqjV1f8UwzgUyfMwXBkC
# AwEAAaOCAUkwggFFMB0GA1UdDgQWBBS8tsXufbAhNEo8nKhORK2+GK0tYDAfBgNV
# HSMEGDAWgBSfpxVdAF5iXYP05dJlpxtTNRnpcjBfBgNVHR8EWDBWMFSgUqBQhk5o
# dHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NybC9NaWNyb3NvZnQlMjBU
# aW1lLVN0YW1wJTIwUENBJTIwMjAxMCgxKS5jcmwwbAYIKwYBBQUHAQEEYDBeMFwG
# CCsGAQUFBzAChlBodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRz
# L01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNydDAMBgNV
# HRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMIMA4GA1UdDwEB/wQEAwIH
# gDANBgkqhkiG9w0BAQsFAAOCAgEA4UhI0gRUgmycpd1P0JhTFtnizwZJ55bHyA/+
# 4EzLwDRJ4atPCPRx226osKgxB0rwEbyrS+49M5yAmAWzK1Upr4A8VPIwBqjMoi6D
# PNO/PEqN/k+iGVf/1GUSagZeKDN2wiEIBRqNFU3kOkc2C/rdcwlF5pqT5jOMXEnF
# RQE14+U8ewcuEoVlAu1YZu6YnA4lOYoBo7or0YcT726X5W4f27IhObceXLjiRCUh
# vrlnKgcke0wuHBr7mrx0o5NYkV0/0I2jhHiaDp33rGznbyayXW5vpXmC0SOuzd3H
# fAf7LlNtbUXYMDp05NoTrmSrP5C8Gl+jbAG1MvaSrA5k8qFpxpsk1gT4k29q6eaI
# KPGPITFNWELO6x0eYaopRKvPIxfvR/CnHG/9YrJiUxpwZ0TL+vFHdpeSxYTmeJ0b
# ZeJR64vjdS/BAYO2hPBLz3vAmvYM/LIdheAjk2HdTx3HtboC771ltfmjkqXfDZ8B
# IneM4A+/WUMYrCasjuJTFjMwIBHhYVJuNBbIbc17nQLF+S6AopeKy2x38GLRjqcP
# Q1V941wFfdLRvYkW3Ko7bd74VvU/i93wGZTHq2ln4e3lJj5bTFPJREDjHpaP9XoZ
# CBju2GTh8VKniqZhfUGlvC1009PdAB2eJOoPrXaWRXwjKLchvhOF6jemVrShAUIh
# N8S9uwQwggdxMIIFWaADAgECAhMzAAAAFcXna54Cm0mZAAAAAAAVMA0GCSqGSIb3
# DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4G
# A1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMTIw
# MAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0ZSBBdXRob3JpdHkgMjAx
# MDAeFw0yMTA5MzAxODIyMjVaFw0zMDA5MzAxODMyMjVaMHwxCzAJBgNVBAYTAlVT
# MRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQK
# ExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1l
# LVN0YW1wIFBDQSAyMDEwMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA
# 5OGmTOe0ciELeaLL1yR5vQ7VgtP97pwHB9KpbE51yMo1V/YBf2xK4OK9uT4XYDP/
# XE/HZveVU3Fa4n5KWv64NmeFRiMMtY0Tz3cywBAY6GB9alKDRLemjkZrBxTzxXb1
# hlDcwUTIcVxRMTegCjhuje3XD9gmU3w5YQJ6xKr9cmmvHaus9ja+NSZk2pg7uhp7
# M62AW36MEBydUv626GIl3GoPz130/o5Tz9bshVZN7928jaTjkY+yOSxRnOlwaQ3K
# Ni1wjjHINSi947SHJMPgyY9+tVSP3PoFVZhtaDuaRr3tpK56KTesy+uDRedGbsoy
# 1cCGMFxPLOJiss254o2I5JasAUq7vnGpF1tnYN74kpEeHT39IM9zfUGaRnXNxF80
# 3RKJ1v2lIH1+/NmeRd+2ci/bfV+AutuqfjbsNkz2K26oElHovwUDo9Fzpk03dJQc
# NIIP8BDyt0cY7afomXw/TNuvXsLz1dhzPUNOwTM5TI4CvEJoLhDqhFFG4tG9ahha
# YQFzymeiXtcodgLiMxhy16cg8ML6EgrXY28MyTZki1ugpoMhXV8wdJGUlNi5UPkL
# iWHzNgY1GIRH29wb0f2y1BzFa/ZcUlFdEtsluq9QBXpsxREdcu+N+VLEhReTwDwV
# 2xo3xwgVGD94q0W29R6HXtqPnhZyacaue7e3PmriLq0CAwEAAaOCAd0wggHZMBIG
# CSsGAQQBgjcVAQQFAgMBAAEwIwYJKwYBBAGCNxUCBBYEFCqnUv5kxJq+gpE8RjUp
# zxD/LwTuMB0GA1UdDgQWBBSfpxVdAF5iXYP05dJlpxtTNRnpcjBcBgNVHSAEVTBT
# MFEGDCsGAQQBgjdMg30BATBBMD8GCCsGAQUFBwIBFjNodHRwOi8vd3d3Lm1pY3Jv
# c29mdC5jb20vcGtpb3BzL0RvY3MvUmVwb3NpdG9yeS5odG0wEwYDVR0lBAwwCgYI
# KwYBBQUHAwgwGQYJKwYBBAGCNxQCBAweCgBTAHUAYgBDAEEwCwYDVR0PBAQDAgGG
# MA8GA1UdEwEB/wQFMAMBAf8wHwYDVR0jBBgwFoAU1fZWy4/oolxiaNE9lJBb186a
# GMQwVgYDVR0fBE8wTTBLoEmgR4ZFaHR0cDovL2NybC5taWNyb3NvZnQuY29tL3Br
# aS9jcmwvcHJvZHVjdHMvTWljUm9vQ2VyQXV0XzIwMTAtMDYtMjMuY3JsMFoGCCsG
# AQUFBwEBBE4wTDBKBggrBgEFBQcwAoY+aHR0cDovL3d3dy5taWNyb3NvZnQuY29t
# L3BraS9jZXJ0cy9NaWNSb29DZXJBdXRfMjAxMC0wNi0yMy5jcnQwDQYJKoZIhvcN
# AQELBQADggIBAJ1VffwqreEsH2cBMSRb4Z5yS/ypb+pcFLY+TkdkeLEGk5c9MTO1
# OdfCcTY/2mRsfNB1OW27DzHkwo/7bNGhlBgi7ulmZzpTTd2YurYeeNg2LpypglYA
# A7AFvonoaeC6Ce5732pvvinLbtg/SHUB2RjebYIM9W0jVOR4U3UkV7ndn/OOPcbz
# aN9l9qRWqveVtihVJ9AkvUCgvxm2EhIRXT0n4ECWOKz3+SmJw7wXsFSFQrP8DJ6L
# GYnn8AtqgcKBGUIZUnWKNsIdw2FzLixre24/LAl4FOmRsqlb30mjdAy87JGA0j3m
# Sj5mO0+7hvoyGtmW9I/2kQH2zsZ0/fZMcm8Qq3UwxTSwethQ/gpY3UA8x1RtnWN0
# SCyxTkctwRQEcb9k+SS+c23Kjgm9swFXSVRk2XPXfx5bRAGOWhmRaw2fpCjcZxko
# JLo4S5pu+yFUa2pFEUep8beuyOiJXk+d0tBMdrVXVAmxaQFEfnyhYWxz/gq77EFm
# PWn9y8FBSX5+k77L+DvktxW/tM4+pTFRhLy/AsGConsXHRWJjXD+57XQKBqJC482
# 2rpM+Zv/Cuk0+CQ1ZyvgDbjmjJnW4SLq8CdCPSWU5nR0W2rRnj7tfqAxM328y+l7
# vzhwRNGQ8cirOoo6CGJ/2XBjU02N7oJtpQUQwXEGahC0HVUzWLOhcGbyoYIDTTCC
# AjUCAQEwgfmhgdGkgc4wgcsxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5n
# dG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9y
# YXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVyaWNhIE9wZXJhdGlvbnMxJzAl
# BgNVBAsTHm5TaGllbGQgVFNTIEVTTjo4NjAzLTA1RTAtRDk0NzElMCMGA1UEAxMc
# TWljcm9zb2Z0IFRpbWUtU3RhbXAgU2VydmljZaIjCgEBMAcGBSsOAwIaAxUA+5+w
# ZOILDNrW1P4vjNwbUZy49PeggYMwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UE
# CBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9z
# b2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQ
# Q0EgMjAxMDANBgkqhkiG9w0BAQsFAAIFAOlued0wIhgPMjAyNDAyMDcyMTUxMjVa
# GA8yMDI0MDIwODIxNTEyNVowdDA6BgorBgEEAYRZCgQBMSwwKjAKAgUA6W553QIB
# ADAHAgEAAgIIRTAHAgEAAgITaDAKAgUA6W/LXQIBADA2BgorBgEEAYRZCgQCMSgw
# JjAMBgorBgEEAYRZCgMCoAowCAIBAAIDB6EgoQowCAIBAAIDAYagMA0GCSqGSIb3
# DQEBCwUAA4IBAQCJ5UWuH29zNhAxUUwUDNr40pL4jyvatQdQ03hzRT6myICNrCbe
# zuQ3MubMy34B7pdDDj5M4i/q9/9DjGnaMsOd9vwY8/X/7Ly29caEwiwDCqe60yKn
# XXNmQaCQq9LeJ94Oy7YObz69MSBK7CG6mDAbNEQFQNgYBRR6paFpW/1nXgGByjfS
# xxP0tz68AdEBlQ4q++CUoWmCYemjuMYXrh5YaQ0ElrERJ7ta3+gi8hjx+puxkiJ+
# KegR2iphBGC6Sci+9aZ5fjvLrggiVdcdq99ZZae6Gn9Eu4UmaCJtdTKXOpKvXvur
# Ht6wq5IJ4dtVzpl4/bIoO/Zakx4WD1O0gzLtMYIEDTCCBAkCAQEwgZMwfDELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UEAxMdTWljcm9z
# b2Z0IFRpbWUtU3RhbXAgUENBIDIwMTACEzMAAAHxs0X1J+jAFtYAAQAAAfEwDQYJ
# YIZIAWUDBAIBBQCgggFKMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAvBgkq
# hkiG9w0BCQQxIgQgiJagRyU9enDIeGqhuTmIWE54ywQqBdP4pRhIR2KwSEgwgfoG
# CyqGSIb3DQEJEAIvMYHqMIHnMIHkMIG9BCDVd/0+YUu4o8GqOOukaLAe8MBIm7dG
# tT+RKiMBI/YReDCBmDCBgKR+MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNo
# aW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29y
# cG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEw
# AhMzAAAB8bNF9SfowBbWAAEAAAHxMCIEIEU2Z+vPvI5f4lRVDdmeL+JYGdBh06gr
# VMypgloKiVJUMA0GCSqGSIb3DQEBCwUABIICAKkDOJqhdoPgzpZtoVnBiFVSsECZ
# q7Ydda11qz9b6whoVmjfzMGsKRZQaN9oEbYEJWnidJfu2KvCJ1JSGVfsw2mubv+A
# tPoAdBRmR0uxk9jbZa/IKZRrQB1LLUTEpNyKDsIaquNvZVZlXyLXYIaBr9asqxYQ
# XzzCyTXlxb58uhYu4JujmURsdCtp3ho5Ovn/+kPlWb1q6YEncjh8NHVm21hEL0sQ
# B2EjjMNRPWEhh/1YPulIdzBz2swep5xrwz3TsaEXkO2X+FUT5j5a4q+WVLv4UJMR
# AshQxUkUafgliJu8F6TrshZZd11uj7XJsfiCgvMM/aSecqAXx1TchA8y2G3eUuN+
# vmyX9swOxhsebxKmxYQqltIvUFw5SzZ82RF1zQh//1F9RySeQu3EjcMg+pW3JE4U
# IX2pwNuSkFGkigWu3XvEwAeqlInC+lFPB5VOz0cdOBRlQ+aIj2HdrEPWYOHph99n
# lXPra/ip6IKZdEFcAL6g/XDvYBluJPqfLYky87AGbV1h2z3r9AwXamgBxr2o82mF
# fLBlU6hcOafyQTcw6vGgHm12qfrLl1ZSX/DzsixhKT2vGvlDTGzJPKnXdvH3FTlH
# rzdrFj2DQr5CKbAhZmmONoYBCPo7xaIpOR7FqrCcXLfbQYMYBE8rejAeSpICFRHp
# xyST4KotJxnokSFO
# SIG # End signature block