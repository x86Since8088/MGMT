$Workingfolder = $PSScriptRoot
$MGMTFolder      = $WorkingFolder -replace "^(.*?\\MGMT).*",'$1'
. "$MGMTFolder\PowerShell\init.ps1"
$script:PSSR = $PSScriptRoot
$script:Environment = "$PSSR" | Split-Path| Split-Path -Leaf
Write-Host -Message "Environment Name: $script:Environment pulled from current folder '$script:PSSR'" -ForegroundColor Yellow

function GetMGMTASAppID { 
    $MGMTASAppID = $MGMT_Env.Auth.($script:Environment).AppID
    return $MGMTASAppID
}

function GetMGMTASAppSecret { 
    $MGMTASAppSecret = $MGMT_Env.Auth.($script:Environment).AppSecret
    return $MGMTASAppSecret
}

function Test-MGMTCredentialAZ {
    param (
        [pscredential]$credential = $global:MGMT_Env.Auth."AZ($script:Environment)"
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
    Set-MGMTDataObject -VariableName MGMT_Env -Name "Status.environment.$script:Environment" -Value @{
        AZConnection = $AZConnection
    }
}
Test-MGMTCredentialAZ

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