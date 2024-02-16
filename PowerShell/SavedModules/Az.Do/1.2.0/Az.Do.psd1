@{
    RootModule         = 'Az.Do.psm1'
    ModuleVersion      = '1.2.0'
    GUID               = 'de89fafa-de5d-422e-a507-b2d9d0a01947'
    Author             = 'Dylan J'
    CompanyName        = ''
    Copyright          = 'Dylan J. All rights reserved.'
    Description        = 'A PowerShell module to interact with and manage Azure DevOps.'
    PowerShellVersion  = '5.0'
    FunctionsToExport  = @('Add-ADOWorkItemFields','Get-ADOContent','Get-ADOFields','Get-ADOList','Get-ADOProcess','Get-ADOProject','Get-ADOPullRequest','Get-ADORefs','Get-ADORepo','Get-ADOUpdates','Get-ADOWorkItem','Get-ADOWorkItemList','Get-ADOWorkItemPages','Get-ADOWorkItemStates','New-ADOAuthToken','New-ADOComment','New-ADOField','New-ADOList','New-ADOProcess','New-ADOWorkItem','New-ADOWorkItemPage','New-ADOWorkItemPageGroup','New-ADOWorkItemState','New-ADOWorkItemType','Remove-ADOFields','Remove-ADOList','Remove-ADORefs')
    CmdletsToExport    = @()
    VariablesToExport  = @()
    AliasesToExport    = @()
    RequiredAssemblies = @()
    NestedModules      = @()
    # RequiredModules    = @('Az.Storage', 'Az.KeyVault', 'Az.Resources', 'Az.Automation')
    ModuleList         = @()

    PrivateData        = @{
        PSData = @{
            Prerelease   = ''
            ReleaseNotes = ''
            Tags         = @()
            LicenseUri   = ''
            ProjectUri   = ''
            IconUri      = ''
        }
    }
}
