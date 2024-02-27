function Test-MGMTCredentialAZ {
    param (
        [pscredential]$credential = $global:MGMT_Env.Auth.("AZ($Deployment_Environment)")
    )
    if ($credential -eq $null) {
        $credential = Get-Credential -Message "Enter your Azure credentials for 'AZ($Deployment_Environment)'"
    }
    # Import the module
    Import-Module Az.Accounts

    # Connect to Azure
    $AZConnection = Connect-AzAccount -Credential $credential
    if ($null -eq $AZConnection) {
        Write-Host -Message "Failed to connect to Azure" -ForegroundColor Red
    } else {
        Write-Host -Message "Successfully connected to Azure" -ForegroundColor Green
        Set-MGMTCredential -FQDN "AZ($Deployment_Environment)" -Credential $credential -Scope currentuser
    }
    Set-MGMTDataObject -InputObject $MGMT_Env -Name Status,environment,$Deployment_Environment, -Value @{
        AZConnection = $AZConnection
        AVCredential = $credential
        Tested       = (Get-Date)
    }
}