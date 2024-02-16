
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
Adds new entity to servicePrincipals
.Description
Adds new entity to servicePrincipals
.Notes
COMPLEX PARAMETER PROPERTIES

To create the parameters described below, construct a hash table containing the appropriate properties. For information on hash tables, run Get-Help about_Hash_Tables.

ADDIN <IMicrosoftGraphAddIn[]>: Defines custom behavior that a consuming service can use to call an app in specific contexts. For example, applications that can render file streams may set the addIns property for its 'FileHandler' functionality. This will let services like Microsoft 365 call the application in the context of a document the user is working on.
  [Id <String>]: 
  [Property <IMicrosoftGraphKeyValue[]>]: 
    [Key <String>]: Key.
    [Value <String>]: Value.
  [Type <String>]: 

APPROLE <IMicrosoftGraphAppRole[]>: The roles exposed by the application which this service principal represents. For more information see the appRoles property definition on the application entity. Not nullable.
  [AllowedMemberType <String[]>]: Specifies whether this app role can be assigned to users and groups (by setting to ['User']), to other application's (by setting to ['Application'], or both (by setting to ['User', 'Application']). App roles supporting assignment to other applications' service principals are also known as application permissions. The 'Application' value is only supported for app roles defined on application entities.
  [Description <String>]: The description for the app role. This is displayed when the app role is being assigned and, if the app role functions as an application permission, during  consent experiences.
  [DisplayName <String>]: Display name for the permission that appears in the app role assignment and consent experiences.
  [Id <String>]: Unique role identifier inside the appRoles collection. When creating a new app role, a new Guid identifier must be provided.
  [IsEnabled <Boolean?>]: When creating or updating an app role, this must be set to true (which is the default). To delete a role, this must first be set to false.  At that point, in a subsequent call, this role may be removed.
  [Origin <String>]: Specifies if the app role is defined on the application object or on the servicePrincipal entity. Must not be included in any POST or PATCH requests. Read-only.
  [Value <String>]: Specifies the value to include in the roles claim in ID tokens and access tokens authenticating an assigned user or service principal. Must not exceed 120 characters in length. Allowed characters are : ! # $ % & ' ( ) * + , - . / : ;  =  ? @ [ ] ^ + _  {  } ~, as well as characters in the ranges 0-9, A-Z and a-z. Any other character, including the space character, are not allowed. May not begin with ..

APPROLEASSIGNEDTO <IMicrosoftGraphAppRoleAssignment[]>: App role assignments for this app or service, granted to users, groups, and other service principals.Supports $expand.
  [DeletedDateTime <DateTime?>]: 
  [AppRoleId <String>]: The identifier (id) for the app role which is assigned to the principal. This app role must be exposed in the appRoles property on the resource application's service principal (resourceId). If the resource application has not declared any app roles, a default app role ID of 00000000-0000-0000-0000-000000000000 can be specified to signal that the principal is assigned to the resource app without any specific app roles. Required on create.
  [PrincipalId <String>]: The unique identifier (id) for the user, group or service principal being granted the app role. Required on create.
  [ResourceDisplayName <String>]: The display name of the resource app's service principal to which the assignment is made.
  [ResourceId <String>]: The unique identifier (id) for the resource service principal for which the assignment is made. Required on create. Supports $filter (eq only).

APPROLEASSIGNMENT <IMicrosoftGraphAppRoleAssignment[]>: App role assignment for another app or service, granted to this service principal. Supports $expand.
  [DeletedDateTime <DateTime?>]: 
  [AppRoleId <String>]: The identifier (id) for the app role which is assigned to the principal. This app role must be exposed in the appRoles property on the resource application's service principal (resourceId). If the resource application has not declared any app roles, a default app role ID of 00000000-0000-0000-0000-000000000000 can be specified to signal that the principal is assigned to the resource app without any specific app roles. Required on create.
  [PrincipalId <String>]: The unique identifier (id) for the user, group or service principal being granted the app role. Required on create.
  [ResourceDisplayName <String>]: The display name of the resource app's service principal to which the assignment is made.
  [ResourceId <String>]: The unique identifier (id) for the resource service principal for which the assignment is made. Required on create. Supports $filter (eq only).

BODY <IMicrosoftGraphServicePrincipal>: Represents an Azure Active Directory object. The directoryObject type is the base type for many other directory entity types.
  [(Any) <Object>]: This indicates any property can be added to this object.
  [DeletedDateTime <DateTime?>]: 
  [AccountEnabled <Boolean?>]: true if the service principal account is enabled; otherwise, false. Supports $filter (eq, ne, NOT, in).
  [AddIn <IMicrosoftGraphAddIn[]>]: Defines custom behavior that a consuming service can use to call an app in specific contexts. For example, applications that can render file streams may set the addIns property for its 'FileHandler' functionality. This will let services like Microsoft 365 call the application in the context of a document the user is working on.
    [Id <String>]: 
    [Property <IMicrosoftGraphKeyValue[]>]: 
      [Key <String>]: Key.
      [Value <String>]: Value.
    [Type <String>]: 
  [AlternativeName <String[]>]: Used to retrieve service principals by subscription, identify resource group and full resource ids for managed identities. Supports $filter (eq, NOT, ge, le, startsWith).
  [AppDescription <String>]: The description exposed by the associated application.
  [AppDisplayName <String>]: The display name exposed by the associated application.
  [AppId <String>]: The unique identifier for the associated application (its appId property).
  [AppOwnerOrganizationId <String>]: Contains the tenant id where the application is registered. This is applicable only to service principals backed by applications.Supports $filter (eq, ne, NOT, ge, le).
  [AppRole <IMicrosoftGraphAppRole[]>]: The roles exposed by the application which this service principal represents. For more information see the appRoles property definition on the application entity. Not nullable.
    [AllowedMemberType <String[]>]: Specifies whether this app role can be assigned to users and groups (by setting to ['User']), to other application's (by setting to ['Application'], or both (by setting to ['User', 'Application']). App roles supporting assignment to other applications' service principals are also known as application permissions. The 'Application' value is only supported for app roles defined on application entities.
    [Description <String>]: The description for the app role. This is displayed when the app role is being assigned and, if the app role functions as an application permission, during  consent experiences.
    [DisplayName <String>]: Display name for the permission that appears in the app role assignment and consent experiences.
    [Id <String>]: Unique role identifier inside the appRoles collection. When creating a new app role, a new Guid identifier must be provided.
    [IsEnabled <Boolean?>]: When creating or updating an app role, this must be set to true (which is the default). To delete a role, this must first be set to false.  At that point, in a subsequent call, this role may be removed.
    [Origin <String>]: Specifies if the app role is defined on the application object or on the servicePrincipal entity. Must not be included in any POST or PATCH requests. Read-only.
    [Value <String>]: Specifies the value to include in the roles claim in ID tokens and access tokens authenticating an assigned user or service principal. Must not exceed 120 characters in length. Allowed characters are : ! # $ % & ' ( ) * + , - . / : ;  =  ? @ [ ] ^ + _  {  } ~, as well as characters in the ranges 0-9, A-Z and a-z. Any other character, including the space character, are not allowed. May not begin with ..
  [AppRoleAssignedTo <IMicrosoftGraphAppRoleAssignment[]>]: App role assignments for this app or service, granted to users, groups, and other service principals.Supports $expand.
    [DeletedDateTime <DateTime?>]: 
    [AppRoleId <String>]: The identifier (id) for the app role which is assigned to the principal. This app role must be exposed in the appRoles property on the resource application's service principal (resourceId). If the resource application has not declared any app roles, a default app role ID of 00000000-0000-0000-0000-000000000000 can be specified to signal that the principal is assigned to the resource app without any specific app roles. Required on create.
    [PrincipalId <String>]: The unique identifier (id) for the user, group or service principal being granted the app role. Required on create.
    [ResourceDisplayName <String>]: The display name of the resource app's service principal to which the assignment is made.
    [ResourceId <String>]: The unique identifier (id) for the resource service principal for which the assignment is made. Required on create. Supports $filter (eq only).
  [AppRoleAssignment <IMicrosoftGraphAppRoleAssignment[]>]: App role assignment for another app or service, granted to this service principal. Supports $expand.
  [AppRoleAssignmentRequired <Boolean?>]: Specifies whether users or other service principals need to be granted an app role assignment for this service principal before users can sign in or apps can get tokens. The default value is false. Not nullable. Supports $filter (eq, ne, NOT).
  [ClaimsMappingPolicy <IMicrosoftGraphClaimsMappingPolicy[]>]: The claimsMappingPolicies assigned to this service principal. Supports $expand.
    [AppliesTo <IMicrosoftGraphDirectoryObject[]>]: 
      [DeletedDateTime <DateTime?>]: 
    [Definition <String[]>]: A string collection containing a JSON string that defines the rules and settings for a policy. The syntax for the definition differs for each derived policy type. Required.
    [IsOrganizationDefault <Boolean?>]: If set to true, activates this policy. There can be many policies for the same policy type, but only one can be activated as the organization default. Optional, default value is false.
    [Description <String>]: Description for this policy.
    [DisplayName <String>]: Display name for this policy.
    [DeletedDateTime <DateTime?>]: 
  [DelegatedPermissionClassification <IMicrosoftGraphDelegatedPermissionClassification[]>]: The permission classifications for delegated permissions exposed by the app that this service principal represents. Supports $expand.
    [Classification <String>]: permissionClassificationType
    [PermissionId <String>]: The unique identifier (id) for the delegated permission listed in the publishedPermissionScopes collection of the servicePrincipal. Required on create. Does not support $filter.
    [PermissionName <String>]: The claim value (value) for the delegated permission listed in the publishedPermissionScopes collection of the servicePrincipal. Does not support $filter.
  [Description <String>]: Free text field to provide an internal end-user facing description of the service principal. End-user portals such MyApps will display the application description in this field. The maximum allowed size is 1024 characters. Supports $filter (eq, ne, NOT, ge, le, startsWith) and $search.
  [DisabledByMicrosoftStatus <String>]: Specifies whether Microsoft has disabled the registered application. Possible values are: null (default value), NotDisabled, and DisabledDueToViolationOfServicesAgreement (reasons may include suspicious, abusive, or malicious activity, or a violation of the Microsoft Services Agreement).  Supports $filter (eq, ne, NOT).
  [DisplayName <String>]: The display name for the service principal. Supports $filter (eq, ne, NOT, ge, le, in, startsWith), $search, and $orderBy.
  [Endpoint <IMicrosoftGraphEndpoint[]>]: Endpoints available for discovery. Services like Sharepoint populate this property with a tenant specific SharePoint endpoints that other applications can discover and use in their experiences.
    [DeletedDateTime <DateTime?>]: 
    [Capability <String>]: Describes the capability that is associated with this resource. (e.g. Messages, Conversations, etc.)  Not nullable. Read-only.
    [ProviderId <String>]: Application id of the publishing underlying service. Not nullable. Read-only.
    [ProviderName <String>]: Name of the publishing underlying service. Read-only.
    [ProviderResourceId <String>]: For Microsoft 365 groups, this is set to a well-known name for the resource (e.g. Yammer.FeedURL etc.). Not nullable. Read-only.
    [Uri <String>]: URL of the published resource. Not nullable. Read-only.
  [HomeRealmDiscoveryPolicy <IMicrosoftGraphHomeRealmDiscoveryPolicy[]>]: The homeRealmDiscoveryPolicies assigned to this service principal. Supports $expand.
    [AppliesTo <IMicrosoftGraphDirectoryObject[]>]: 
    [Definition <String[]>]: A string collection containing a JSON string that defines the rules and settings for a policy. The syntax for the definition differs for each derived policy type. Required.
    [IsOrganizationDefault <Boolean?>]: If set to true, activates this policy. There can be many policies for the same policy type, but only one can be activated as the organization default. Optional, default value is false.
    [Description <String>]: Description for this policy.
    [DisplayName <String>]: Display name for this policy.
    [DeletedDateTime <DateTime?>]: 
  [Homepage <String>]: Home page or landing page of the application.
  [Info <IMicrosoftGraphInformationalUrl>]: informationalUrl
    [(Any) <Object>]: This indicates any property can be added to this object.
    [LogoUrl <String>]: CDN URL to the application's logo, Read-only.
    [MarketingUrl <String>]: Link to the application's marketing page. For example, https://www.contoso.com/app/marketing
    [PrivacyStatementUrl <String>]: Link to the application's privacy statement. For example, https://www.contoso.com/app/privacy
    [SupportUrl <String>]: Link to the application's support page. For example, https://www.contoso.com/app/support
    [TermsOfServiceUrl <String>]: Link to the application's terms of service statement. For example, https://www.contoso.com/app/termsofservice
  [KeyCredentials <IMicrosoftGraphKeyCredential[]>]: The collection of key credentials associated with the service principal. Not nullable. Supports $filter (eq, NOT, ge, le).
    [CustomKeyIdentifier <Byte[]>]: Custom key identifier
    [DisplayName <String>]: Friendly name for the key. Optional.
    [EndDateTime <DateTime?>]: The date and time at which the credential expires.The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z
    [Key <Byte[]>]: Value for the key credential. Should be a base 64 encoded value.
    [KeyId <String>]: The unique identifier (GUID) for the key.
    [StartDateTime <DateTime?>]: The date and time at which the credential becomes valid.The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z
    [Type <String>]: The type of key credential; for example, 'Symmetric'.
    [Usage <String>]: A string that describes the purpose for which the key can be used; for example, 'Verify'.
  [LoginUrl <String>]: Specifies the URL where the service provider redirects the user to Azure AD to authenticate. Azure AD uses the URL to launch the application from Microsoft 365 or the Azure AD My Apps. When blank, Azure AD performs IdP-initiated sign-on for applications configured with SAML-based single sign-on. The user launches the application from Microsoft 365, the Azure AD My Apps, or the Azure AD SSO URL.
  [LogoutUrl <String>]: Specifies the URL that will be used by Microsoft's authorization service to logout an user using OpenId Connect front-channel, back-channel or SAML logout protocols.
  [Note <String>]: Free text field to capture information about the service principal, typically used for operational purposes. Maximum allowed size is 1024 characters.
  [NotificationEmailAddress <String[]>]: Specifies the list of email addresses where Azure AD sends a notification when the active certificate is near the expiration date. This is only for the certificates used to sign the SAML token issued for Azure AD Gallery applications.
  [Oauth2PermissionScope <IMicrosoftGraphPermissionScope[]>]: The delegated permissions exposed by the application. For more information see the oauth2PermissionScopes property on the application entity's api property. Not nullable.
    [AdminConsentDescription <String>]: A description of the delegated permissions, intended to be read by an administrator granting the permission on behalf of all users. This text appears in tenant-wide admin consent experiences.
    [AdminConsentDisplayName <String>]: The permission's title, intended to be read by an administrator granting the permission on behalf of all users.
    [Id <String>]: Unique delegated permission identifier inside the collection of delegated permissions defined for a resource application.
    [IsEnabled <Boolean?>]: When creating or updating a permission, this property must be set to true (which is the default). To delete a permission, this property must first be set to false.  At that point, in a subsequent call, the permission may be removed.
    [Origin <String>]: 
    [Type <String>]: Specifies whether this delegated permission should be considered safe for non-admin users to consent to on behalf of themselves, or whether an administrator should be required for consent to the permissions. This will be the default behavior, but each customer can choose to customize the behavior in their organization (by allowing, restricting or limiting user consent to this delegated permission.)
    [UserConsentDescription <String>]: A description of the delegated permissions, intended to be read by a user granting the permission on their own behalf. This text appears in consent experiences where the user is consenting only on behalf of themselves.
    [UserConsentDisplayName <String>]: A title for the permission, intended to be read by a user granting the permission on their own behalf. This text appears in consent experiences where the user is consenting only on behalf of themselves.
    [Value <String>]: Specifies the value to include in the scp (scope) claim in access tokens. Must not exceed 120 characters in length. Allowed characters are : ! # $ % & ' ( ) * + , - . / : ;  =  ? @ [ ] ^ + _  {  } ~, as well as characters in the ranges 0-9, A-Z and a-z. Any other character, including the space character, are not allowed. May not begin with ..
  [PasswordCredentials <IMicrosoftGraphPasswordCredential[]>]: The collection of password credentials associated with the service principal. Not nullable.
    [CustomKeyIdentifier <Byte[]>]: Do not use.
    [DisplayName <String>]: Friendly name for the password. Optional.
    [EndDateTime <DateTime?>]: The date and time at which the password expires represented using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z. Optional.
    [KeyId <String>]: The unique identifier for the password.
    [StartDateTime <DateTime?>]: The date and time at which the password becomes valid. The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z. Optional.
  [PreferredSingleSignOnMode <String>]: Specifies the single sign-on mode configured for this application. Azure AD uses the preferred single sign-on mode to launch the application from Microsoft 365 or the Azure AD My Apps. The supported values are password, saml, notSupported, and oidc.
  [PreferredTokenSigningKeyThumbprint <String>]: Reserved for internal use only. Do not write or otherwise rely on this property. May be removed in future versions.
  [ReplyUrl <String[]>]: The URLs that user tokens are sent to for sign in with the associated application, or the redirect URIs that OAuth 2.0 authorization codes and access tokens are sent to for the associated application. Not nullable.
  [SamlSingleSignOnSetting <IMicrosoftGraphSamlSingleSignOnSettings>]: samlSingleSignOnSettings
    [(Any) <Object>]: This indicates any property can be added to this object.
    [RelayState <String>]: The relative URI the service provider would redirect to after completion of the single sign-on flow.
  [ServicePrincipalName <String[]>]: Contains the list of identifiersUris, copied over from the associated application. Additional values can be added to hybrid applications. These values can be used to identify the permissions exposed by this app within Azure AD. For example,Client apps can specify a resource URI which is based on the values of this property to acquire an access token, which is the URI returned in the 'aud' claim.The any operator is required for filter expressions on multi-valued properties. Not nullable.  Supports $filter (eq, NOT, ge, le, startsWith).
  [ServicePrincipalType <String>]: Identifies if the service principal represents an application or a managed identity. This is set by Azure AD internally. For a service principal that represents an application this is set as Application. For a service principal that represent a managed identity this is set as ManagedIdentity.
  [Tag <String[]>]: Custom strings that can be used to categorize and identify the service principal. Not nullable. Supports $filter (eq, NOT, ge, le, startsWith).
  [TokenEncryptionKeyId <String>]: Specifies the keyId of a public key from the keyCredentials collection. When configured, Azure AD issues tokens for this application encrypted using the key specified by this property. The application code that receives the encrypted token must use the matching private key to decrypt the token before it can be used for the signed-in user.
  [TokenIssuancePolicy <IMicrosoftGraphTokenIssuancePolicy[]>]: The tokenIssuancePolicies assigned to this service principal. Supports $expand.
    [AppliesTo <IMicrosoftGraphDirectoryObject[]>]: 
    [Definition <String[]>]: A string collection containing a JSON string that defines the rules and settings for a policy. The syntax for the definition differs for each derived policy type. Required.
    [IsOrganizationDefault <Boolean?>]: If set to true, activates this policy. There can be many policies for the same policy type, but only one can be activated as the organization default. Optional, default value is false.
    [Description <String>]: Description for this policy.
    [DisplayName <String>]: Display name for this policy.
    [DeletedDateTime <DateTime?>]: 
  [TokenLifetimePolicy <IMicrosoftGraphTokenLifetimePolicy[]>]: The tokenLifetimePolicies assigned to this service principal. Supports $expand.
    [AppliesTo <IMicrosoftGraphDirectoryObject[]>]: 
    [Definition <String[]>]: A string collection containing a JSON string that defines the rules and settings for a policy. The syntax for the definition differs for each derived policy type. Required.
    [IsOrganizationDefault <Boolean?>]: If set to true, activates this policy. There can be many policies for the same policy type, but only one can be activated as the organization default. Optional, default value is false.
    [Description <String>]: Description for this policy.
    [DisplayName <String>]: Display name for this policy.
    [DeletedDateTime <DateTime?>]: 
  [TransitiveMemberOf <IMicrosoftGraphDirectoryObject[]>]: 

CLAIMSMAPPINGPOLICY <IMicrosoftGraphClaimsMappingPolicy[]>: The claimsMappingPolicies assigned to this service principal. Supports $expand.
  [AppliesTo <IMicrosoftGraphDirectoryObject[]>]: 
    [DeletedDateTime <DateTime?>]: 
  [Definition <String[]>]: A string collection containing a JSON string that defines the rules and settings for a policy. The syntax for the definition differs for each derived policy type. Required.
  [IsOrganizationDefault <Boolean?>]: If set to true, activates this policy. There can be many policies for the same policy type, but only one can be activated as the organization default. Optional, default value is false.
  [Description <String>]: Description for this policy.
  [DisplayName <String>]: Display name for this policy.
  [DeletedDateTime <DateTime?>]: 

DELEGATEDPERMISSIONCLASSIFICATION <IMicrosoftGraphDelegatedPermissionClassification[]>: The permission classifications for delegated permissions exposed by the app that this service principal represents. Supports $expand.
  [Classification <String>]: permissionClassificationType
  [PermissionId <String>]: The unique identifier (id) for the delegated permission listed in the publishedPermissionScopes collection of the servicePrincipal. Required on create. Does not support $filter.
  [PermissionName <String>]: The claim value (value) for the delegated permission listed in the publishedPermissionScopes collection of the servicePrincipal. Does not support $filter.

ENDPOINT <IMicrosoftGraphEndpoint[]>: Endpoints available for discovery. Services like Sharepoint populate this property with a tenant specific SharePoint endpoints that other applications can discover and use in their experiences.
  [DeletedDateTime <DateTime?>]: 
  [Capability <String>]: Describes the capability that is associated with this resource. (e.g. Messages, Conversations, etc.)  Not nullable. Read-only.
  [ProviderId <String>]: Application id of the publishing underlying service. Not nullable. Read-only.
  [ProviderName <String>]: Name of the publishing underlying service. Read-only.
  [ProviderResourceId <String>]: For Microsoft 365 groups, this is set to a well-known name for the resource (e.g. Yammer.FeedURL etc.). Not nullable. Read-only.
  [Uri <String>]: URL of the published resource. Not nullable. Read-only.

HOMEREALMDISCOVERYPOLICY <IMicrosoftGraphHomeRealmDiscoveryPolicy[]>: The homeRealmDiscoveryPolicies assigned to this service principal. Supports $expand.
  [AppliesTo <IMicrosoftGraphDirectoryObject[]>]: 
    [DeletedDateTime <DateTime?>]: 
  [Definition <String[]>]: A string collection containing a JSON string that defines the rules and settings for a policy. The syntax for the definition differs for each derived policy type. Required.
  [IsOrganizationDefault <Boolean?>]: If set to true, activates this policy. There can be many policies for the same policy type, but only one can be activated as the organization default. Optional, default value is false.
  [Description <String>]: Description for this policy.
  [DisplayName <String>]: Display name for this policy.
  [DeletedDateTime <DateTime?>]: 

INFO <IMicrosoftGraphInformationalUrl>: informationalUrl
  [(Any) <Object>]: This indicates any property can be added to this object.
  [LogoUrl <String>]: CDN URL to the application's logo, Read-only.
  [MarketingUrl <String>]: Link to the application's marketing page. For example, https://www.contoso.com/app/marketing
  [PrivacyStatementUrl <String>]: Link to the application's privacy statement. For example, https://www.contoso.com/app/privacy
  [SupportUrl <String>]: Link to the application's support page. For example, https://www.contoso.com/app/support
  [TermsOfServiceUrl <String>]: Link to the application's terms of service statement. For example, https://www.contoso.com/app/termsofservice

KEYCREDENTIALS <IMicrosoftGraphKeyCredential[]>: The collection of key credentials associated with the service principal. Not nullable. Supports $filter (eq, NOT, ge, le).
  [CustomKeyIdentifier <Byte[]>]: Custom key identifier
  [DisplayName <String>]: Friendly name for the key. Optional.
  [EndDateTime <DateTime?>]: The date and time at which the credential expires.The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z
  [Key <Byte[]>]: Value for the key credential. Should be a base 64 encoded value.
  [KeyId <String>]: The unique identifier (GUID) for the key.
  [StartDateTime <DateTime?>]: The date and time at which the credential becomes valid.The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z
  [Type <String>]: The type of key credential; for example, 'Symmetric'.
  [Usage <String>]: A string that describes the purpose for which the key can be used; for example, 'Verify'.

OAUTH2PERMISSIONSCOPE <IMicrosoftGraphPermissionScope[]>: The delegated permissions exposed by the application. For more information see the oauth2PermissionScopes property on the application entity's api property. Not nullable.
  [AdminConsentDescription <String>]: A description of the delegated permissions, intended to be read by an administrator granting the permission on behalf of all users. This text appears in tenant-wide admin consent experiences.
  [AdminConsentDisplayName <String>]: The permission's title, intended to be read by an administrator granting the permission on behalf of all users.
  [Id <String>]: Unique delegated permission identifier inside the collection of delegated permissions defined for a resource application.
  [IsEnabled <Boolean?>]: When creating or updating a permission, this property must be set to true (which is the default). To delete a permission, this property must first be set to false.  At that point, in a subsequent call, the permission may be removed.
  [Origin <String>]: 
  [Type <String>]: Specifies whether this delegated permission should be considered safe for non-admin users to consent to on behalf of themselves, or whether an administrator should be required for consent to the permissions. This will be the default behavior, but each customer can choose to customize the behavior in their organization (by allowing, restricting or limiting user consent to this delegated permission.)
  [UserConsentDescription <String>]: A description of the delegated permissions, intended to be read by a user granting the permission on their own behalf. This text appears in consent experiences where the user is consenting only on behalf of themselves.
  [UserConsentDisplayName <String>]: A title for the permission, intended to be read by a user granting the permission on their own behalf. This text appears in consent experiences where the user is consenting only on behalf of themselves.
  [Value <String>]: Specifies the value to include in the scp (scope) claim in access tokens. Must not exceed 120 characters in length. Allowed characters are : ! # $ % & ' ( ) * + , - . / : ;  =  ? @ [ ] ^ + _  {  } ~, as well as characters in the ranges 0-9, A-Z and a-z. Any other character, including the space character, are not allowed. May not begin with ..

PASSWORDCREDENTIALS <IMicrosoftGraphPasswordCredential[]>: The collection of password credentials associated with the service principal. Not nullable.
  [CustomKeyIdentifier <Byte[]>]: Do not use.
  [DisplayName <String>]: Friendly name for the password. Optional.
  [EndDateTime <DateTime?>]: The date and time at which the password expires represented using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z. Optional.
  [KeyId <String>]: The unique identifier for the password.
  [StartDateTime <DateTime?>]: The date and time at which the password becomes valid. The Timestamp type represents date and time information using ISO 8601 format and is always in UTC time. For example, midnight UTC on Jan 1, 2014 is 2014-01-01T00:00:00Z. Optional.

SAMLSINGLESIGNONSETTING <IMicrosoftGraphSamlSingleSignOnSettings>: samlSingleSignOnSettings
  [(Any) <Object>]: This indicates any property can be added to this object.
  [RelayState <String>]: The relative URI the service provider would redirect to after completion of the single sign-on flow.

TOKENISSUANCEPOLICY <IMicrosoftGraphTokenIssuancePolicy[]>: The tokenIssuancePolicies assigned to this service principal. Supports $expand.
  [AppliesTo <IMicrosoftGraphDirectoryObject[]>]: 
    [DeletedDateTime <DateTime?>]: 
  [Definition <String[]>]: A string collection containing a JSON string that defines the rules and settings for a policy. The syntax for the definition differs for each derived policy type. Required.
  [IsOrganizationDefault <Boolean?>]: If set to true, activates this policy. There can be many policies for the same policy type, but only one can be activated as the organization default. Optional, default value is false.
  [Description <String>]: Description for this policy.
  [DisplayName <String>]: Display name for this policy.
  [DeletedDateTime <DateTime?>]: 

TOKENLIFETIMEPOLICY <IMicrosoftGraphTokenLifetimePolicy[]>: The tokenLifetimePolicies assigned to this service principal. Supports $expand.
  [AppliesTo <IMicrosoftGraphDirectoryObject[]>]: 
    [DeletedDateTime <DateTime?>]: 
  [Definition <String[]>]: A string collection containing a JSON string that defines the rules and settings for a policy. The syntax for the definition differs for each derived policy type. Required.
  [IsOrganizationDefault <Boolean?>]: If set to true, activates this policy. There can be many policies for the same policy type, but only one can be activated as the organization default. Optional, default value is false.
  [Description <String>]: Description for this policy.
  [DisplayName <String>]: Display name for this policy.
  [DeletedDateTime <DateTime?>]: 

TRANSITIVEMEMBEROF <IMicrosoftGraphDirectoryObject[]>: .
  [DeletedDateTime <DateTime?>]: 
.Link
https://learn.microsoft.com/powershell/module/az.resources/new-azadserviceprincipal
#>
function New-AzADServicePrincipal {
  [OutputType([Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphServicePrincipal])]
  [CmdletBinding(DefaultParameterSetName = 'SimpleParameterSet', PositionalBinding = $false, SupportsShouldProcess, ConfirmImpact = 'Medium')]
  param(
    [Parameter(ParameterSetName = 'DisplayNameWithPasswordCredentialParameterSet', Mandatory)]
    [Parameter(ParameterSetName = 'DisplayNameWithKeyCredentialParameterSet', Mandatory)]
    [Parameter(ParameterSetName = 'DisplayNameWithKeyPlainParameterSet', Mandatory)]
    [Parameter(ParameterSetName = 'SimpleParameterSet')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String]
    # The display name for the service principal.
    # Supports $filter (eq, ne, NOT, ge, le, in, startsWith), $search, and $orderBy.
    ${DisplayName},

    [Parameter(ParameterSetName = 'ApplicationObjectParameterSet', Mandatory, ValueFromPipeline, HelpMessage = "The application object, could be used as pipeline input.")]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphApplication]
    ${ApplicationObject},

    [Parameter(ParameterSetName = 'ApplicationIdParameterSet')]
    [Alias('AppId')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.Guid]
    # The unique identifier for the associated application (its appId property).
    ${ApplicationId},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String]
    # The role that the service principal has over the scope.
    ${Role},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String]
    # The scope that the service principal has permissions for.
    ${Scope},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String]
    # Home page or landing page of the application.
    ${Homepage},

    [Parameter()]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String[]]
    # The URLs that user tokens are sent to for sign in with the associated application, or the redirect URIs that OAuth 2.0 authorization codes and access tokens are sent to for the associated application.
    # Not nullable.
    ${ReplyUrl},

    [Parameter(ParameterSetName = 'DisplayNameWithKeyPlainParameterSet', Mandatory, HelpMessage = "The value of the 'asymmetric' credential type. It represents the base 64 encoded certificate.")]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String]
    ${CertValue},

    [Parameter(ParameterSetName = 'DisplayNameWithKeyPlainParameterSet', HelpMessage = "The effective start date of the credential usage. The default start date value is today. For an 'asymmetric' type credential, this must be set to on or after the date that the X509 certificate is valid from.")]
    [Parameter(ParameterSetName = 'SimpleParameterSet')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.DateTime]
    ${StartDate},

    [Parameter(ParameterSetName = 'DisplayNameWithKeyPlainParameterSet', HelpMessage = "The effective end date of the credential usage. The default end date value is one year from today. For an 'asymmetric' type credential, this must be set to on or before the date that the X509 certificate is valid.")]
    [Parameter(ParameterSetName = 'SimpleParameterSet', HelpMessage = "The effective end date of the credential usage. The default end date value is one year from today. For an 'asymmetric' type credential, this must be set to on or before the date that the X509 certificate is valid.")]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.DateTime]
    ${EndDate},

    [Parameter(ParameterSetName = 'DisplayNameWithKeyCredentialParameterSet', Mandatory, HelpMessage = "key credentials associated with the service principal.")]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphKeyCredential[]]
    [Alias("KeyCredentials")]
    # The collection of key credentials associated with the service principal.
    # Not nullable.
    # Supports $filter (eq, NOT, ge, le).
    # To construct, see NOTES section for KEYCREDENTIALS properties and create a hash table.
    ${KeyCredential},

    [Parameter(ParameterSetName = 'DisplayNameWithPasswordCredentialParameterSet', Mandatory, HelpMessage = "Password credentials associated with the service principal.")]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphPasswordCredential[]]
    [Alias("PasswordCredentials")]
    # The collection of password credentials associated with the service principal.
    # Not nullable.
    # To construct, see NOTES section for PASSWORDCREDENTIALS properties and create a hash table.
    ${PasswordCredential},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.Management.Automation.SwitchParameter]
    # true if the service principal account is enabled; otherwise, false.
    # Supports $filter (eq, ne, NOT, in).
    ${AccountEnabled},

    [Parameter()]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphAddIn[]]
    # Defines custom behavior that a consuming service can use to call an app in specific contexts.
    # For example, applications that can render file streams may set the addIns property for its 'FileHandler' functionality.
    # This will let services like Microsoft 365 call the application in the context of a document the user is working on.
    # To construct, see NOTES section for ADDIN properties and create a hash table.
    ${AddIn},

    [Parameter()]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String[]]
    # Used to retrieve service principals by subscription, identify resource group and full resource ids for managed identities.
    # Supports $filter (eq, NOT, ge, le, startsWith).
    ${AlternativeName},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String]
    # The description exposed by the associated application.
    ${AppDescription},    

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String]
    # Contains the tenant id where the application is registered.
    # This is applicable only to service principals backed by applications.Supports $filter (eq, ne, NOT, ge, le).
    ${AppOwnerOrganizationId},

    [Parameter()]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphAppRole[]]
    # The roles exposed by the application which this service principal represents.
    # For more information see the appRoles property definition on the application entity.
    # Not nullable.
    # To construct, see NOTES section for APPROLE properties and create a hash table.
    ${AppRole},

    [Parameter()]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphAppRoleAssignment[]]
    # App role assignments for this app or service, granted to users, groups, and other service principals.Supports $expand.
    # To construct, see NOTES section for APPROLEASSIGNEDTO properties and create a hash table.
    ${AppRoleAssignedTo},

    [Parameter()]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphAppRoleAssignment[]]
    # App role assignment for another app or service, granted to this service principal.
    # Supports $expand.
    # To construct, see NOTES section for APPROLEASSIGNMENT properties and create a hash table.
    ${AppRoleAssignment},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.Management.Automation.SwitchParameter]
    # Specifies whether users or other service principals need to be granted an app role assignment for this service principal before users can sign in or apps can get tokens.
    # The default value is false.
    # Not nullable.
    # Supports $filter (eq, ne, NOT).
    ${AppRoleAssignmentRequired},

    [Parameter()]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphClaimsMappingPolicy[]]
    # The claimsMappingPolicies assigned to this service principal.
    # Supports $expand.
    # To construct, see NOTES section for CLAIMSMAPPINGPOLICY properties and create a hash table.
    ${ClaimsMappingPolicy},

    [Parameter()]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphDelegatedPermissionClassification[]]
    # The permission classifications for delegated permissions exposed by the app that this service principal represents.
    # Supports $expand.
    # To construct, see NOTES section for DELEGATEDPERMISSIONCLASSIFICATION properties and create a hash table.
    ${DelegatedPermissionClassification},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.DateTime]
    # .
    ${DeletedDateTime},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String]
    # Free text field to provide an internal end-user facing description of the service principal.
    # End-user portals such MyApps will display the application description in this field.
    # The maximum allowed size is 1024 characters.
    # Supports $filter (eq, ne, NOT, ge, le, startsWith) and $search.
    ${Description},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String]
    # Specifies whether Microsoft has disabled the registered application.
    # Possible values are: null (default value), NotDisabled, and DisabledDueToViolationOfServicesAgreement (reasons may include suspicious, abusive, or malicious activity, or a violation of the Microsoft Services Agreement).
    # Supports $filter (eq, ne, NOT).
    ${DisabledByMicrosoftStatus},

    [Parameter()]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphEndpoint[]]
    # Endpoints available for discovery.
    # Services like Sharepoint populate this property with a tenant specific SharePoint endpoints that other applications can discover and use in their experiences.
    # To construct, see NOTES section for ENDPOINT properties and create a hash table.
    ${Endpoint},

    [Parameter()]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphHomeRealmDiscoveryPolicy[]]
    # The homeRealmDiscoveryPolicies assigned to this service principal.
    # Supports $expand.
    # To construct, see NOTES section for HOMEREALMDISCOVERYPOLICY properties and create a hash table.
    ${HomeRealmDiscoveryPolicy},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphInformationalUrl]
    # informationalUrl
    # To construct, see NOTES section for INFO properties and create a hash table.
    ${Info},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String]
    # Specifies the URL where the service provider redirects the user to Azure AD to authenticate.
    # Azure AD uses the URL to launch the application from Microsoft 365 or the Azure AD My Apps.
    # When blank, Azure AD performs IdP-initiated sign-on for applications configured with SAML-based single sign-on.
    # The user launches the application from Microsoft 365, the Azure AD My Apps, or the Azure AD SSO URL.
    ${LoginUrl},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String]
    # Specifies the URL that will be used by Microsoft's authorization service to logout an user using OpenId Connect front-channel, back-channel or SAML logout protocols.
    ${LogoutUrl},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String]
    # Free text field to capture information about the service principal, typically used for operational purposes.
    # Maximum allowed size is 1024 characters.
    ${Note},

    [Parameter()]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String[]]
    # Specifies the list of email addresses where Azure AD sends a notification when the active certificate is near the expiration date.
    # This is only for the certificates used to sign the SAML token issued for Azure AD Gallery applications.
    ${NotificationEmailAddress},

    [Parameter()]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphPermissionScope[]]
    # The delegated permissions exposed by the application.
    # For more information see the oauth2PermissionScopes property on the application entity's api property.
    # Not nullable.
    # To construct, see NOTES section for OAUTH2PERMISSIONSCOPE properties and create a hash table.
    ${Oauth2PermissionScope},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String]
    # Specifies the single sign-on mode configured for this application.
    # Azure AD uses the preferred single sign-on mode to launch the application from Microsoft 365 or the Azure AD My Apps.
    # The supported values are password, saml, notSupported, and oidc.
    ${PreferredSingleSignOnMode},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String]
    # Reserved for internal use only.
    # Do not write or otherwise rely on this property.
    # May be removed in future versions.
    ${PreferredTokenSigningKeyThumbprint},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphSamlSingleSignOnSettings]
    # samlSingleSignOnSettings
    # To construct, see NOTES section for SAMLSINGLESIGNONSETTING properties and create a hash table.
    ${SamlSingleSignOnSetting},

    [Parameter()]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String[]]
    # Contains the list of identifiersUris, copied over from the associated application.
    # Additional values can be added to hybrid applications.
    # These values can be used to identify the permissions exposed by this app within Azure AD.
    # For example,Client apps can specify a resource URI which is based on the values of this property to acquire an access token, which is the URI returned in the 'aud' claim.The any operator is required for filter expressions on multi-valued properties.
    # Not nullable.
    # Supports $filter (eq, NOT, ge, le, startsWith).
    ${ServicePrincipalName},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String]
    # Identifies if the service principal represents an application or a managed identity.
    # This is set by Azure AD internally.
    # For a service principal that represents an application this is set as Application.
    # For a service principal that represent a managed identity this is set as ManagedIdentity.
    ${ServicePrincipalType},

    [Parameter()]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String[]]
    # Custom strings that can be used to categorize and identify the service principal.
    # Not nullable.
    # Supports $filter (eq, NOT, ge, le, startsWith).
    ${Tag},

    [Parameter()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [System.String]
    # Specifies the keyId of a public key from the keyCredentials collection.
    # When configured, Azure AD issues tokens for this application encrypted using the key specified by this property.
    # The application code that receives the encrypted token must use the matching private key to decrypt the token before it can be used for the signed-in user.
    ${TokenEncryptionKeyId},

    [Parameter()]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphTokenIssuancePolicy[]]
    # The tokenIssuancePolicies assigned to this service principal.
    # Supports $expand.
    # To construct, see NOTES section for TOKENISSUANCEPOLICY properties and create a hash table.
    ${TokenIssuancePolicy},

    [Parameter()]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphTokenLifetimePolicy[]]
    # The tokenLifetimePolicies assigned to this service principal.
    # Supports $expand.
    # To construct, see NOTES section for TOKENLIFETIMEPOLICY properties and create a hash table.
    ${TokenLifetimePolicy},

    [Parameter()]
    [AllowEmptyCollection()]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Category('Body')]
    [Microsoft.Azure.PowerShell.Cmdlets.Resources.MSGraph.Models.ApiV10.IMicrosoftGraphDirectoryObject[]]
    # .
    # To construct, see NOTES section for TRANSITIVEMEMBEROF properties and create a hash table.
    ${TransitiveMemberOf},

    [Parameter()]
    [Alias('AzureRMContext', 'AzureCredential')]
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
    if ($PSBoundParameters['Role']) {
      $spRole = $PSBoundParameters['Role']
      $null = $PSBoundParameters.Remove('Role')
    }
    if ($PSBoundParameters['Scope']) {
      $spScope = $PSBoundParameters['Scope']
      $null = $PSBoundParameters.Remove('Scope')
    }
    
    $param = @{}
    if ($PSBoundParameters['Debug']) {
      $param['Debug'] = $PSBoundParameters['Debug']
    }

    if ($PSBoundParameters['ApplicationObject']) {
      $PSBoundParameters['AppId'] = $PSBoundParameters['ApplicationObject'].AppId
      $null = $PSBoundParameters.Remove('ApplicationObject')
    } elseif ($PSBoundParameters['ApplicationId']) {
      $PSBoundParameters['AppId'] = $PSBoundParameters['ApplicationId']
      $null = $PSBoundParameters.Remove('ApplicationId')
    } else {
      if (!$PSBoundParameters['DisplayName']) {
        $param['DisplayName'] = "azure-powershell-" + (Get-Date).ToString("MM-dd-yyyy-HH-mm-ss")
      } else {
        $param['DisplayName'] = $PSBoundParameters['DisplayName']
        $null = $PSBoundParameters.Remove('DisplayName')
      }

      if ($PSBoundParameters['PasswordCredential']) {
        $param['PasswordCredentials'] = $PSBoundParameters['PasswordCredential']
        $null = $PSBoundParameters.Remove('PasswordCredential')
      } elseif ($PSBoundParameters['KeyCredential']) {
        $param['KeyCredentials'] = $PSBoundParameters['KeyCredential']
        $null = $PSBoundParameters.Remove('KeyCredential')
      } else {
        if (!$PSBoundParameters['StartDate']) {
          $param['StartDate'] = [System.DateTime]::UtcNow
        } else {
          $param['StartDate'] = $PSBoundParameters['StartDate']
          $null = $PSBoundParameters.Remove('StartDate')
        }
        if (!$PSBoundParameters['EndDate']) {
          $param['EndDate'] = $param['StartDate'].AddYears(1)
        } else {
          $param['EndDate'] = $PSBoundParameters['EndDate']
          $null = $PSBoundParameters.Remove('EndDate')
        }
        if ($PSBoundParameters['CertValue']) {
          $param['CertValue'] = $PSBoundParameters['CertValue']
          $null = $PSBoundParameters.Remove('CertValue') 
        }
      }

      $app = New-AzADApplication @param
      $PSBoundParameters['AppId'] = $app.AppId
    }

    $sp = Az.MSGraph.internal\New-AzADServicePrincipal @PSBoundParameters
    if ($app) {
      $sp.PasswordCredentials = $app.PasswordCredentials
    }

    $PSCmdlet.WriteObject($sp)

    if ($spRole) {
      $param = @{'ObjectId' = $sp.Id; 'RoleDefinitionName' = $spRole}
      if ($PSBoundParameters['Debug']) {
        $param['Debug'] = $PSBoundParameters['Debug']
      }
      if ($spScope) {
        $param['Scope'] = $spScope
      }
      $param['ObjectType'] = "ServicePrincipal"
      $ra = New-AzRoleAssignment @param
      Write-Verbose "Role assignment with role $($ra.RoleDefinitionName) and scope $($ra.Scope) successfully created for the created service principal."
    }
  }
}
# SIG # Begin signature block
# MIIoOAYJKoZIhvcNAQcCoIIoKTCCKCUCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCCkwVQNXqJBJtKQ
# NDkFGMmsQnbLnbIzi+vuOS0S9sYzZKCCDYUwggYDMIID66ADAgECAhMzAAADTU6R
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
# cVZOSEXAQsmbdlsKgEhr/Xmfwb1tbWrJUnMTDXpQzTGCGgkwghoFAgEBMIGVMH4x
# CzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRt
# b25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01p
# Y3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTECEzMAAANNTpGmGiiweI8AAAAA
# A00wDQYJYIZIAWUDBAIBBQCgga4wGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQw
# HAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwLwYJKoZIhvcNAQkEMSIEIEcl
# /RF1WLghj7kAtfTr2SoVu3SnX4VlLFcSTm+xxK3+MEIGCisGAQQBgjcCAQwxNDAy
# oBSAEgBNAGkAYwByAG8AcwBvAGYAdKEagBhodHRwOi8vd3d3Lm1pY3Jvc29mdC5j
# b20wDQYJKoZIhvcNAQEBBQAEggEAnJ0xBONYyfkIK6p4yIE+h0RzxoAQ3JKvcnDD
# m0O/30pibzy2lJmNQEY6bRwrM6qG5SnI8JjVPTNkRrs39kPH0VX0KDS1+mDcp+Kt
# 3Fy2n0MwzVdKfnm9ZbhP8IIEG5VpWN++n7g9qyc4BLf1Jbez1y6Hn2J6qKWKNSmM
# 5pKGdkNKDrZuH8ScOsdnOGkdM6CeF6A1tUaHyYXuxbq2Nd6xQhWxJHgbjV+24bTn
# 6xo9ENVyoJDIGMVr8NNN6wzqwW9thi1G+u6RSUj44mg4Al7lglTPPnIprqxm9rgv
# ybKcBkxUx3gtbEhA0sdY8LprkKwtQfydkMrwLkMUjIb5YgnXF6GCF5MwghePBgor
# BgEEAYI3AwMBMYIXfzCCF3sGCSqGSIb3DQEHAqCCF2wwghdoAgEDMQ8wDQYJYIZI
# AWUDBAIBBQAwggFSBgsqhkiG9w0BCRABBKCCAUEEggE9MIIBOQIBAQYKKwYBBAGE
# WQoDATAxMA0GCWCGSAFlAwQCAQUABCC5CwqzTr7FZWvnX48g9TCp0T/gOP0WBc5N
# H2VoYq3//gIGZMvCZ6tMGBMyMDIzMDgwNDAzMTA1MS41NThaMASAAgH0oIHRpIHO
# MIHLMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQL
# ExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxk
# IFRTUyBFU046QTkzNS0wM0UwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1l
# LVN0YW1wIFNlcnZpY2WgghHpMIIHIDCCBQigAwIBAgITMwAAAdGyW0AobC7SRQAB
# AAAB0TANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2Fz
# aGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENv
# cnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAx
# MDAeFw0yMzA1MjUxOTEyMThaFw0yNDAyMDExOTEyMThaMIHLMQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3NvZnQgQW1l
# cmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uU2hpZWxkIFRTUyBFU046QTkzNS0w
# M0UwLUQ5NDcxJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1wIFNlcnZpY2Uw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCZTNo0OeGz2XFd2gLg5nTl
# Bm8XOpuwJIiXsMU61rwq1ZKDpa443RrSG/pH8Gz6XNnFQKGnCqNCtmvoKULApwrT
# /s7/e1X0lNFKmj7U7X4p00S0uQbW6LwSn/zWHaG2c54ZXsGY+BYfhWDgbFpCTxRz
# TnRCG62bkWPp6ZHbZPg4Ht1CRCAMhhOGTR8wI4G7wwWZwdMc6UvUUlq0ql9AxAfz
# kYRpi2tRvDHMdmZ3vyXpqhFwvRG8cgCH/TTCjW5q6aNbdqKL3BFDPzUtuCNsPXL3
# /E0dR2bDMqa0aNH+iIfhGC4/vcwuteOMCPUIDVSqDCNfIaPDEwYci1fd9gu1zVw+
# HEhDZM7Ea3nxIUrzt+Rfp5ToMMj4QAmJ6Uadm+TPbDbo8kFIK70ShmW8wn8fJk9R
# eQQEpTtIN43eRv9QmXy3Ued80osOBE+WkdMvSCFh+qgCsKdzQxQJG62cTeoU2eqN
# hH3oppXmyfVUwbsefQzMPtbinCZd0FUlmlM/dH+4OniqQyaHvrtYy3wqIafY3zeF
# ITlVAoP9q9vF4W7KHR/uF0mvTpAL5NaTDN1plQS0MdjMkgzZK5gtwqOe/3rTlqBz
# xwa7YYp3urP5yWkTzISGnhNWIZOxOyQIOxZfbiIbAHbm3M8hj73KQWcCR5Javgkw
# UmncFHESaQf4Drqs+/1L1QIDAQABo4IBSTCCAUUwHQYDVR0OBBYEFAuO8UzF7DcH
# 0mmsF4XQxxHQvS2jMB8GA1UdIwQYMBaAFJ+nFV0AXmJdg/Tl0mWnG1M1GelyMF8G
# A1UdHwRYMFYwVKBSoFCGTmh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMv
# Y3JsL01pY3Jvc29mdCUyMFRpbWUtU3RhbXAlMjBQQ0ElMjAyMDEwKDEpLmNybDBs
# BggrBgEFBQcBAQRgMF4wXAYIKwYBBQUHMAKGUGh0dHA6Ly93d3cubWljcm9zb2Z0
# LmNvbS9wa2lvcHMvY2VydHMvTWljcm9zb2Z0JTIwVGltZS1TdGFtcCUyMFBDQSUy
# MDIwMTAoMSkuY3J0MAwGA1UdEwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUH
# AwgwDgYDVR0PAQH/BAQDAgeAMA0GCSqGSIb3DQEBCwUAA4ICAQCbu9rTAHV24mY0
# qoG5eEnImz5akGXTviBwKp2Y51s26w8oDrWor+m00R4/3BcDmYlUK8Nrx/auYFYi
# dZddcUjw42QxSStmv/qWnCQi/2OnH32KVHQ+kMOZPABQTG1XkcnYPUOOEEor6f/3
# Js1uj4wjHzE4V4aumYXBAsr4L5KR8vKes5tFxhMkWND/O7W/RaHYwJMjMkxVosBo
# k7V21sJAlxScEXxfJa+/qkqUr7CZgw3R4jCHRkPqQhMWibXPMYar/iF0ZuLB9O89
# DMJNhjK9BSf6iqgZoMuzIVt+EBoTzpv/9p4wQ6xoBCs29mkj/EIWFdc+5a30kuCQ
# OSEOj07+WI29A4k6QIRB5w+eMmZ0Jec0sSyeQB5KjxE51iYMhtlMrUKcr06nBqCs
# SKPYsSAITAzgssJD+Z/cTS7Cu35fJrWhM9NYX24uAxYLAW0ipNtWptIeV6akuZEe
# EV6BNtM3VTk+mAlV5/eC/0Y17aVSjK5/gyDoLNmrgVwv5TAaBmq/wgRRFHmW9UJ3
# zv8Lmk6mIoAyTpqBbuUjMLyrtajuSsA/m2DnKMO0Qiz1v+FSVbqM38J/PTlhCTUb
# FOx0kLT7Y/7+ZyrilVCzyAYfFIinDIjWlM85tDeU8ZfJCjFKwq3DsRxV4JY18xww
# 8TTmod3lkr9NqGQ54LmyPVc+5ibNrjCCB3EwggVZoAMCAQICEzMAAAAVxedrngKb
# SZkAAAAAABUwDQYJKoZIhvcNAQELBQAwgYgxCzAJBgNVBAYTAlVTMRMwEQYDVQQI
# EwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3Nv
# ZnQgQ29ycG9yYXRpb24xMjAwBgNVBAMTKU1pY3Jvc29mdCBSb290IENlcnRpZmlj
# YXRlIEF1dGhvcml0eSAyMDEwMB4XDTIxMDkzMDE4MjIyNVoXDTMwMDkzMDE4MzIy
# NVowfDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcT
# B1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEmMCQGA1UE
# AxMdTWljcm9zb2Z0IFRpbWUtU3RhbXAgUENBIDIwMTAwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQDk4aZM57RyIQt5osvXJHm9DtWC0/3unAcH0qlsTnXI
# yjVX9gF/bErg4r25PhdgM/9cT8dm95VTcVrifkpa/rg2Z4VGIwy1jRPPdzLAEBjo
# YH1qUoNEt6aORmsHFPPFdvWGUNzBRMhxXFExN6AKOG6N7dcP2CZTfDlhAnrEqv1y
# aa8dq6z2Nr41JmTamDu6GnszrYBbfowQHJ1S/rboYiXcag/PXfT+jlPP1uyFVk3v
# 3byNpOORj7I5LFGc6XBpDco2LXCOMcg1KL3jtIckw+DJj361VI/c+gVVmG1oO5pG
# ve2krnopN6zL64NF50ZuyjLVwIYwXE8s4mKyzbnijYjklqwBSru+cakXW2dg3viS
# kR4dPf0gz3N9QZpGdc3EXzTdEonW/aUgfX782Z5F37ZyL9t9X4C626p+Nuw2TPYr
# bqgSUei/BQOj0XOmTTd0lBw0gg/wEPK3Rxjtp+iZfD9M269ewvPV2HM9Q07BMzlM
# jgK8QmguEOqEUUbi0b1qGFphAXPKZ6Je1yh2AuIzGHLXpyDwwvoSCtdjbwzJNmSL
# W6CmgyFdXzB0kZSU2LlQ+QuJYfM2BjUYhEfb3BvR/bLUHMVr9lxSUV0S2yW6r1AF
# emzFER1y7435UsSFF5PAPBXbGjfHCBUYP3irRbb1Hode2o+eFnJpxq57t7c+auIu
# rQIDAQABo4IB3TCCAdkwEgYJKwYBBAGCNxUBBAUCAwEAATAjBgkrBgEEAYI3FQIE
# FgQUKqdS/mTEmr6CkTxGNSnPEP8vBO4wHQYDVR0OBBYEFJ+nFV0AXmJdg/Tl0mWn
# G1M1GelyMFwGA1UdIARVMFMwUQYMKwYBBAGCN0yDfQEBMEEwPwYIKwYBBQUHAgEW
# M2h0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9wa2lvcHMvRG9jcy9SZXBvc2l0b3J5
# Lmh0bTATBgNVHSUEDDAKBggrBgEFBQcDCDAZBgkrBgEEAYI3FAIEDB4KAFMAdQBi
# AEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAWgBTV
# 9lbLj+iiXGJo0T2UkFvXzpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8vY3Js
# Lm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRfMjAx
# MC0wNi0yMy5jcmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRwOi8v
# d3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEwLTA2
# LTIzLmNydDANBgkqhkiG9w0BAQsFAAOCAgEAnVV9/Cqt4SwfZwExJFvhnnJL/Klv
# 6lwUtj5OR2R4sQaTlz0xM7U518JxNj/aZGx80HU5bbsPMeTCj/ts0aGUGCLu6WZn
# OlNN3Zi6th542DYunKmCVgADsAW+iehp4LoJ7nvfam++Kctu2D9IdQHZGN5tggz1
# bSNU5HhTdSRXud2f8449xvNo32X2pFaq95W2KFUn0CS9QKC/GbYSEhFdPSfgQJY4
# rPf5KYnDvBewVIVCs/wMnosZiefwC2qBwoEZQhlSdYo2wh3DYXMuLGt7bj8sCXgU
# 6ZGyqVvfSaN0DLzskYDSPeZKPmY7T7uG+jIa2Zb0j/aRAfbOxnT99kxybxCrdTDF
# NLB62FD+CljdQDzHVG2dY3RILLFORy3BFARxv2T5JL5zbcqOCb2zAVdJVGTZc9d/
# HltEAY5aGZFrDZ+kKNxnGSgkujhLmm77IVRrakURR6nxt67I6IleT53S0Ex2tVdU
# CbFpAUR+fKFhbHP+CrvsQWY9af3LwUFJfn6Tvsv4O+S3Fb+0zj6lMVGEvL8CwYKi
# excdFYmNcP7ntdAoGokLjzbaukz5m/8K6TT4JDVnK+ANuOaMmdbhIurwJ0I9JZTm
# dHRbatGePu1+oDEzfbzL6Xu/OHBE0ZDxyKs6ijoIYn/ZcGNTTY3ugm2lBRDBcQZq
# ELQdVTNYs6FwZvKhggNMMIICNAIBATCB+aGB0aSBzjCByzELMAkGA1UEBhMCVVMx
# EzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQxHjAcBgNVBAoT
# FU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWljcm9zb2Z0IEFtZXJp
# Y2EgT3BlcmF0aW9uczEnMCUGA1UECxMeblNoaWVsZCBUU1MgRVNOOkE5MzUtMDNF
# MC1EOTQ3MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiMK
# AQEwBwYFKw4DAhoDFQBHJY2Fv+GhLQtRDR2vIzBaSv/7LKCBgzCBgKR+MHwxCzAJ
# BgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25k
# MR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMTHU1pY3Jv
# c29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwMA0GCSqGSIb3DQEBCwUAAgUA6HbpljAi
# GA8yMDIzMDgwNDAzMDU1OFoYDzIwMjMwODA1MDMwNTU4WjBzMDkGCisGAQQBhFkK
# BAExKzApMAoCBQDodumWAgEAMAYCAQACAWIwBwIBAAICE/EwCgIFAOh4OxYCAQAw
# NgYKKwYBBAGEWQoEAjEoMCYwDAYKKwYBBAGEWQoDAqAKMAgCAQACAwehIKEKMAgC
# AQACAwGGoDANBgkqhkiG9w0BAQsFAAOCAQEAm1bwDYruyuB3yxCgmalA+7pVSifj
# d/faMVBA4nOlwGjnDKgSFtUf8634WZGvaCjeOPpeHhfgn+S4QXLTiamTpaigu3XY
# ayvXKyJgC69sbWq9T8P27wPoIYQkdZWaVg+UPGYrUYulG0oRhEIeHcNz/OKKdqsP
# bUTE8ogpSlK7u5K8m0yZP5jXflcdCOOwC/E16CFsk173KixfPWUoGTJHT9zMbfXH
# 8Wc+TvaoQiLJkGPe4ZEbYojbQ0W41Y/MRFGxZaEa+Yn0XaBOLQPV9tslNRBapldo
# yjM0Q5cbd+JqMnxJq/Wkb/Cjs3NATVkwDWfOzZxcs94NiFhvdFliRGxlTTGCBA0w
# ggQJAgEBMIGTMHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAw
# DgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24x
# JjAkBgNVBAMTHU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAB0bJb
# QChsLtJFAAEAAAHRMA0GCWCGSAFlAwQCAQUAoIIBSjAaBgkqhkiG9w0BCQMxDQYL
# KoZIhvcNAQkQAQQwLwYJKoZIhvcNAQkEMSIEIGb/AYXAx05lZ7P+dzhFOBSRZ6o/
# 5w2qsqzdYf7UQuR9MIH6BgsqhkiG9w0BCRACLzGB6jCB5zCB5DCBvQQgzLxheQIA
# u/ntzmxGGs9O5vWrhPAnqhUDfqTwiIj8BwwwgZgwgYCkfjB8MQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGlt
# ZS1TdGFtcCBQQ0EgMjAxMAITMwAAAdGyW0AobC7SRQABAAAB0TAiBCDS7BFeIu84
# 2Ne7ANilAy8mmgiymEZ8AYvXGEyGxEleIDANBgkqhkiG9w0BAQsFAASCAgA6Udwr
# d1DVzjdmAc+FZMpRvZTkjbXbPMKsk2Q9TSMpS56/tdLZcAoHIJ2bz4CiCuuzuHO/
# gKnBHZ4m/lCDzefD3iUtnF4MXnx5tf0lVZg37qKXNWW+J38jLJCVJRm0r6cHfCPU
# efza0ksU2y8j+VDFbE9QBVNgQWDdac5xQi3fzJJI+j7HcRi5EVZ7M8sA3F/SetnU
# m9ysYB2wJuPAhilWO7Z0gnEDhrtJAISIZc9hQzKVy3LUKEJfI73j/BcSNbmSfZnZ
# E5WuHO8QRq2PSG8AtV9zO/1g39YV0ak6JbM1y7L57nweQkCRcz+hphn3SaxBFn3V
# 34oSjXxe7qlhQvx3I8WS0pMEHh0202cdF8PlFxRLH6YUj0/VQ4dBU0dZoaxlLx73
# jXss0uJlcaIVyFLCc83buI/r3HYuLbmTyOsWbawfthe42JZpDqckxNNNpXyx/UTS
# 4ias0LD63Qt3G53phcH6AXUc4+/wIh2+m/P9GvYzbOoH22ncBsYa02N+tJ2V0mwS
# ike/Z9d3XJE9nB6MgCFU5m8R+1hhS5oaFw9XNucXlrOzDdAhviKbLvkfV3wdFg/F
# iVMSqeGQ8AhOIJ6YCWS5yCCU5BAJSvHrmGLS6mTMfMpNv2Y+Ij8VM9tsRiq5ckNf
# Juhmypg2osXStjamEtgGLYWGIQcyUa1fTkxphg==
# SIG # End signature block
