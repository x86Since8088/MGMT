If (Import-RequiredModules -ModuleFilePath $PSCommandPath -AutoInstall )
{
    Write-Verbose "All PSRequiredModules loaded !"

    <#
    .SYNOPSIS
        Test-LogAnalyticsWorkspaceExist

    .DESCRIPTION
        Return if Log Analytics workspace exists

    .PARAMETER  LogAnalyticsId
        Set Log Analytics workspace id (resourceId)

    .PARAMETER  BearerToken
        Set an explicit bearer token (if you're not using an Azure PowerShell session with Az.Accounts)

    .EXAMPLE
        PS C:\> Test-LogAnalyticsWorkspaceExist -LogAnalyticsId '/subscriptions/<subId>/resourcegroups/<rgName>/providers/microsoft.operationalinsights/workspaces/<workspaceName>'
        Return if Log Analytics workspace exists (using Az PowerShell session)

    .EXAMPLE
        PS C:\> Test-LogAnalyticsWorkspaceExist -LogAnalyticsId '/subscriptions/<subId>/resourcegroups/<rgName>/providers/microsoft.operationalinsights/workspaces/<workspaceName>' -BearerToken $BearerToken
        Return if Log Analytics workspace exists (using an explicit token)

    .INPUTS
        System.String

    .OUTPUTS
        System.Boolean

    .NOTES
        Author: JDMSFT
        Created: 21/03/21
    #>
    Function Test-LogAnalyticsWorkspaceExist ([Parameter(Mandatory = $true)] [string]$LogAnalyticsId, [String] $BearerToken = (Get-AzAccessToken).Token)
    {
        $headers = @{"authorization" = "bearer $bearerToken" }
        $baseUri = 'https://management.azure.com'
        $uri = "$baseUri$LogAnalyticsId`?api-version=2020-08-01" 
        Try { $request = iwr -Uri $uri -Method GET -Headers $headers -UseBasicParsing } Catch { $null }
        Finally { If ($request.StatusCode -eq 200) { $true } Else { $false } }
    }

    <#
    .SYNOPSIS
        Get-LogAnalyticsWorkspace

    .DESCRIPTION
        Get Log Analytics workspace information. Return null if information can't be retrieved.

    .PARAMETER  LogAnalyticsId
        Set Log Analytics workspace id (resourceId)

    .PARAMETER  BearerToken
        Set an explicit bearer token (if you're not using an Azure PowerShell session with Az.Accounts)

    .EXAMPLE
        PS C:\> Get-LogAnalyticsWorkspace -LogAnalyticsId '/subscriptions/<subId>/resourcegroups/<rgName>/providers/microsoft.operationalinsights/workspaces/<workspaceName>'
        Get Log Analytics workspace information (using Az PowerShell session)

    .EXAMPLE
        PS C:\> Get-LogAnalyticsWorkspace -LogAnalyticsId '/subscriptions/<subId>/resourcegroups/<rgName>/providers/microsoft.operationalinsights/workspaces/<workspaceName>' -BearerToken $BearerToken
        Get Log Analytics workspace information (using an explicit token)

    .INPUTS
        System.String

    .OUTPUTS
        System.Object

    .NOTES
        Author: JDMSFT
        Created: 21/03/21
    #>
    Function Get-LogAnalyticsWorkspace ([Parameter(Mandatory = $true)] [string]$LogAnalyticsId, [String] $BearerToken = (Get-AzAccessToken).Token)
    {

        $headers = @{"authorization" = "bearer $bearerToken" }
        $baseUri = 'https://management.azure.com'
        $uri = "$baseUri$LogAnalyticsId`?api-version=2020-08-01" 
        Try { $request = iwr -Uri $uri -Method GET -Headers $headers -UseBasicParsing } Catch { $null }
        Finally { If ($request.StatusCode -eq 200) { $request.Content | ConvertFrom-Json } Else { $null } }
    }

    <#
    .SYNOPSIS
        Get-LogAnalyticsWorkspaceSharedKeys

    .DESCRIPTION
        Get Log Analytics workspace shared keys. Return null if information can't be retrieved.

    .PARAMETER  LogAnalyticsId
        Set Log Analytics workspace id (resourceId)

    .PARAMETER  BearerToken
        Set an explicit bearer token (if you're not using an Azure PowerShell session with Az.Accounts)

    .EXAMPLE
        PS C:\> Get-LogAnalyticsWorkspaceSharedKeys -LogAnalyticsId '/subscriptions/<subId>/resourcegroups/<rgName>/providers/microsoft.operationalinsights/workspaces/<workspaceName>'
        Get Log Analytics workspace shared keys (using Az PowerShell session)

    .EXAMPLE
        PS C:\> Get-LogAnalyticsWorkspaceSharedKeys -LogAnalyticsId '/subscriptions/<subId>/resourcegroups/<rgName>/providers/microsoft.operationalinsights/workspaces/<workspaceName>' -BearerToken $BearerToken
        Get Log Analytics workspace shared keys (using an explicit token)

    .INPUTS
        System.String

    .OUTPUTS
        System.Object

    .NOTES
        Author: JDMSFT
        Created: 21/03/21
    #>
    Function Get-LogAnalyticsWorkspaceSharedKeys ([Parameter(Mandatory = $true)] [string]$LogAnalyticsId, [String] $BearerToken = (Get-AzAccessToken).Token)
    {

        $headers = @{"authorization" = "bearer $bearerToken" }
        $baseUri = 'https://management.azure.com'
        $uri = "$baseUri$LogAnalyticsId/sharedKeys`?api-version=2020-08-01" 
        Try { $request = iwr -Uri $uri -Method POST -Headers $headers -UseBasicParsing } Catch { $null }
        Finally { If ($request.StatusCode -eq 200) { $request.Content | ConvertFrom-Json } Else { $null } }
    }

    # NOTE : Internal Function
     Function Build-LogAnalyticsSignature ($CustomerId, $SharedKey, $ContentLength, $ContentType, $Date, $Resource, $Methodd)
    {
        Try
        {
            # Signature string
            $SignatureString = $Method + "`n" + $ContentLength + "`n" + $ContentType + "`n" + "x-ms-date:" + $Date + "`n" + $Resource

            # Signature encoding
            $bytesToHash = [Text.Encoding]::UTF8.GetBytes($SignatureString)
            $keyBytes = [Convert]::FromBase64String($sharedKey)
            $sha256 = New-Object System.Security.Cryptography.HMACSHA256
            $sha256.Key = $keyBytes
            $calculatedHash = $sha256.ComputeHash($bytesToHash)
            $encodedHash = [Convert]::ToBase64String($calculatedHash)
            $authorization = 'SharedKey {0}:{1}' -f $customerId, $encodedHash

            return $authorization
        }
        Catch { Write-Output "[ERROR] $($_)`n[ERROR] [$($_.InvocationInfo.ScriptLineNumber)] $($_.InvocationInfo.ScriptName) >> $($_.InvocationInfo.Line.TrimStart())" }
    }

    <#
    .SYNOPSIS
        Send-LogToLogAnalytics

    .DESCRIPTION
        Send custom log to Log Analytics workspace.

    .PARAMETER  CustomerId
        Set Log Analytics workspace customer id (customerId)

    .PARAMETER  SharedKey
        Set Log Analytics workspace shared key (sharedKey)

    .PARAMETER  Log
        Set log content to send to Log Analytics

    .PARAMETER  LogType
        Set log type (defines the table name) for the log to send to Log Analytics

    .EXAMPLE
        PS C:\> Send-LogToLogAnalytics -CustomerId <customerId> -SharedKey <sharedKey> -Log $jsonObject -LogType 'MyCustomLog'
        Send custom log to Log Analytics workspace.

    .INPUTS
        System.String

    .OUTPUTS
        

    .NOTES
        Author: JDMSFT
        Created: 21/03/21
    #>
    Function Send-LogToLogAnalytics ([Parameter(Mandatory = $true)][string]$CustomerId, [Parameter(Mandatory = $true)][string]$SharedKey, [Parameter(Mandatory = $true)][string]$Log, [Parameter(Mandatory = $true)][string]$LogType)
    {
        Try
        {
     
            # Set variables
            $contentLength = $Log.Length
            $contentType = "application/json"
            $resource = "/api/logs"
            $method = "POST"

            # Dates should use UTC (TimeZone used by Azure)
            $date_RFC1123 = [DateTime]::UtcNow.ToString("r")
            $date_ISO8661 = Get-Date ([DateTime]::UtcNow) -Format yyyy-MM-ddThh:mm:ssZ
        
            # Set uri + headers
            $uri = "https://" + $customerId + ".ods.opinsights.azure.com" + $resource + "?api-version=2016-04-01"

            $authorization = Build-LogAnalyticsSignature `
                -customerId $customerId `
                -sharedKey $sharedKey `
                -contentLength $contentLength `
                -contentType $contentType `
                -date $date_RFC1123 `
                -resource $resource `
                -method $method

            $headers = @{
                "Authorization"        = $authorization;
                "Log-Type"             = $logType;
                "x-ms-date"            = $date_RFC1123;
                "time-generated-field" = $date_ISO8661;
            }

            # Send Log
            Write-Verbose "Sending log to log Analytics ..."
            $response = Invoke-WebRequest -Uri $uri -Method $method -ContentType $contentType -Headers $headers -Body $Log -UseBasicParsing

            # Get log send result
            If ($response.StatusCode -eq 200) { Write-Output "Log sent to Log Analytics!" }
            Else { Write-Warning "Log not sent! [STATUS = $($response.StatusCode)]" }
        }
        Catch { Write-Output "[ERROR] $($_)`n[ERROR] [$($_.InvocationInfo.ScriptLineNumber)] $($_.InvocationInfo.ScriptName) >> $($_.InvocationInfo.Line.TrimStart())" }
    }
} 
Else { Remove-Module PSRequiredModules ; throw "Some required modules versions aren't imported/installed. Can't load this module. See PSRequiredModules data in module manifest for more details about required modules." }