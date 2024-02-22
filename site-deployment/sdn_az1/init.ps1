$Workingfolder = $PSScriptRoot
$MGMTFolder      = $WorkingFolder -replace "^(.*?\\MGMT).*",'$1'
. "$MGMTFolder\PowerShell\init.ps1"
$script:PSSR = $PSScriptRoot
$script:Environment = "$PSSR" -replace "^.*?site-deployment(\\|/)" -replace "(/|\\).*"
$Script:ConfigInfo = $global:MGMT_Env.config.sites.($script:Environment)
Write-Host -Message "Environment Name: $script:Environment pulled from current folder '$script:PSSR'" -ForegroundColor Yellow


function Test-MGMTCredentialAZ {
    param (
        [pscredential]$credential = $global:MGMT_Env.Auth.("AZ($script:Environment)")
    )
    if ($credential -eq $null) {
        $credential = Get-Credential -Message "Enter your Azure credentials for 'AZ($script:Environment)'"
    }
    # Import the module
    Import-Module Az.Accounts

    # Connect to Azure
    $AZConnection = Connect-AzAccount -Credential $credential
    if ($null -eq $Connection) {
        Write-Host -Message "Failed to connect to Azure" -ForegroundColor Red
    } else {
        Write-Host -Message "Successfully connected to Azure" -ForegroundColor Green
        Set-MGMTCredential -FQDN "AZ($script:Environment)" -Credential $credential -Scope currentuser
    }
    Set-MGMTDataObject -InputObject $MGMT_Env -Name "Status.environment.$script:Environment" -Value @{
        AZConnection = $AZConnection
        AVCredential = $credential
        Tested       = (Get-Date)
    }
}
#Test-MGMTCredentialAZ
Get-MGMTCredential 
function Get-MGMTAZAccountApplications { 
    param (
        [pscredential]$credential = $global:MGMT_Env.Auth."AZ($script:Environment)"
    )
    if ($credential -eq $null) {
        $credential = Get-Credential -Message "Enter your Azure credentials for 'AZ($script:Environment)'"
    }
    # Import the module
    Import-Module Az.Accounts

    # Connect to Azure
    Connect-AzAccount -Credential $credential

    # Get all Azure AD applications
    Get-AzADApplication
}

function Get-MGMTAZSubscription {
    # Import the module
    Import-Module Az.Accounts

    # Set your tenant ID, application ID, and password
    $tenantId = "<TenantId>"
    $appId = "<AppId>"
    $password = ConvertTo-SecureString "<Password>" -AsPlainText -Force

    # Create a PS credential object
    $psCred = New-Object System.Management.Automation.PSCredential($appId, $password)

    # Connect to Azure
    Connect-AzAccount -Credential $psCred -TenantId $tenantId -ServicePrincipal

    # Get all subscriptions
    Get-AzSubscription
}