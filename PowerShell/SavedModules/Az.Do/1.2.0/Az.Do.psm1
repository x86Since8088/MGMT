#Region './Public/Add-ADOWorkItemFields.ps1' 0
function Add-ADOWorkItemFields {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Name,
        [Parameter(Mandatory = $true)]
        $WorkItemType,
        [Parameter(Mandatory = $true)]
        $FieldType,
        [Parameter(Mandatory = $true)]
        $Org,
        [Parameter(Mandatory = $true)]
        $ProcessName,
        [Parameter(Mandatory = $true)]
        $PageName,
        [Parameter(Mandatory = $true)]
        $GroupName,
        [switch] $IsCustomControl,
        $CustomControlInput,
        [Parameter(Mandatory = $true)]
        $Section,
        [Parameter(Mandatory = $true)]
        $NiceName

    )
    if ($PageName -eq "Home") {
        $PageName = "Details"
    }
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }

    try {
        $ProcessId = ((Get-ADOProcess -Auth $Auth -Org $Org).value | where { $_.name -eq "$ProcessName" }).id
        if ($null -eq $ProcessId) {
            Write-Host "ProcessID is not present."
            break
        }
    
        if ($FieldType -eq "boolean") {
            $FieldBody = @{
                "referenceName" = "Custom.$Name";
                "required"      = $true;
                "readOnly"      = $false;
                "defaultValue"  = "False";
                "allowedValues" = @() 
            }
        }
        elseif ($FieldType -eq "integer") {
            $FieldBody = @{
                "referenceName" = "Custom.$Name";
                "name"          = "$Name";
                "required"      = $false;
                "readOnly"      = $false;
                "isLocked"      = $false;
                "defaultValue"  = "0";
                "customization" = "custom";
            }
        }
        else {
            $FieldBody = @{
                "referenceName" = "Custom.$Name";
                "name"          = "$Name";
                "required"      = $false;
                "readOnly"      = $false;
                "isLocked"      = $false;
                "customization" = "custom";
            }
        }
    
        # Add fields to process work item type
        Write-Verbose "ADD FIELDS | $($Name)"
        $uri = "https://dev.azure.com/$org/_apis/work/processes/$ProcessId/workItemTypes/$ProcessName.$WorkItemType/fields?api-version=5.0"
        $data = Invoke-RestMethod -Uri $Uri -Headers $headers -Method POST -Body ($FieldBody | Convertto-Json)
        Write-Verbose "ADD FIELDS | $($Name) | $Uri"
    
        Write-Verbose "ADD LAYOUT | $($Name)"
        $layouturi = "https://dev.azure.com/$Org/_apis/work/processes/$ProcessId/workItemTypes/$ProcessName.$WorkItemType/layout?api-version=5.0"
        $layoutdata = Invoke-RestMethod -Uri $layouturi -Headers $headers -Method GET
        Write-Verbose "ADD LAYOUT | $($Name) | $layouturi"
    
        $page = $layoutdata.pages | where { $_.label -eq "$PageName" }
        $pageid = ($layoutdata.pages | where { $_.label -eq "$PageName" }).id
        $groupid = (($page.sections | where { $_.id -eq "Section$Section" }).groups | where { $_.label -eq "$GroupName" }).id
        
        if ($IsCustomControl) {
            Write-Verbose "ADD CUSTOM CONTROL | $($Name)"
            $cci = $CustomControlInput
            $NiceName = $NiceName
            $GroupBody = @{
                "id"             = "";
                "label"          = "$NiceName";
                "controlType"    = "";
                "readOnly"       = $false;
                "visible"        = $true;
                "isContribution" = $true
                "contribution"   = @{
                    "contributionId" = "$($cci.contributionId)"
                    "inputs"         = $cci.inputs
                }        
            }
    
            $groupuri = "https://dev.azure.com/$Org/_apis/work/processes/$ProcessId/workItemTypes/$ProcessName.$WorkItemType/layout/groups/$groupid/Controls?api-version=5.0"
            $data = Invoke-RestMethod -Uri $groupuri -Headers $headers -Method POST -Body ($GroupBody | ConvertTo-Json -Depth 10)
            Write-Verbose "ADD CUSTOM CONTROL | $($Name) | $groupuri"
        }
        else {
            if ($FieldType -eq "html") {
                Write-Verbose "ADD HTML | $($Name)"
                $GroupBody = @{
                    "id"             = "Custom.$Name";
                    "label"          = "$NiceName";
                    "controlType"    = "";
                    "readOnly"       = $false;
                    "visible"        = $true;
                    "isContribution" = $false
                    "contribution"   = "";
                    "controls"       = @(
                        @{
                            "label"          = "$NiceName";
                            "readOnly"       = $false;
                            "visible"        = $true;
                            "id"             = "Custom.$Name";
                            "isContribution" = $false
                        }
                    )     
                }
                $groupuri = "https://dev.azure.com/$Org/_apis/work/processes/$ProcessId/workItemTypes/$ProcessName.$WorkItemType/layout/pages/$pageid/sections/Section1/Groups?api-version=5.0"
                $data = Invoke-RestMethod -Uri $groupuri -Headers $headers -Method POST -Body ($GroupBody | ConvertTo-Json -Depth 10)
                Write-Verbose "ADD HTML | $($Name) | $groupuri"
            }
            else {
                Write-Verbose "ADD GENERIC | $($Name)"
                $GroupBody = @{
                    "id"             = "Custom.$Name";
                    "label"          = "$NiceName";
                    "controlType"    = "";
                    "readOnly"       = $false;
                    "visible"        = $true;
                    "isContribution" = $false
                    "contribution"   = "";       
                }
                $groupuri = "https://dev.azure.com/$Org/_apis/work/processes/$ProcessId/workItemTypes/$ProcessName.$WorkItemType/layout/groups/$groupid/Controls/Custom.$($Name)?api-version=5.0"
                $data = Invoke-RestMethod -Uri $groupuri -Headers $headers -Method PUT -Body ($GroupBody | ConvertTo-Json -Depth 10)
                Write-Verbose "ADD GENERIC | $($Name) | $groupuri"
            }
        }
        return $data    
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err    
    }
}
#EndRegion './Public/Add-ADOWorkItemFields.ps1' 158
#Region './Public/Get-ADOContent.ps1' 0
function Get-ADOContent {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Org,
        [Parameter(Mandatory = $true)]
        $Project,
        [Parameter(Mandatory = $true)]
        $RepoId,
        [Parameter(Mandatory = $true)]
        $FileName

    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }
    $uri = "https://dev.azure.com/$org/$project/_apis/git/repositories/$repoid/items?scopePath=/$($FileName)&recursionLevel=Full&includeContentMetadata=true&api-version=7.0"
    try {
        $data = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers -ContentType "application/json"
        return $data
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/Get-ADOContent.ps1' 30
#Region './Public/Get-ADOFields.ps1' 0
function Get-ADOFields {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Org
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }
    
    $uri = "https://dev.azure.com/$org/_apis/wit/fields?api-version=7.0"

    try {
        $data = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers -ContentType "application/json"
        return $data
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/Get-ADOFields.ps1' 25
#Region './Public/Get-ADOList.ps1' 0
function Get-ADOList {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Org
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }
    
    $uri = "https://dev.azure.com/$org/_apis/work/processes/lists?api-version=7.0"

    try {
        $data = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers -ContentType "application/json"
        return $data       
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/Get-ADOList.ps1' 25
#Region './Public/Get-ADOProcess.ps1' 0
function Get-ADOProcess {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Org
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }

    try {
        $uri = "https://dev.azure.com/$org/_apis/process/processes?api-version=7.2-preview.1"
        $data = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers -ContentType "application/json"
        return $data
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/Get-ADOProcess.ps1' 24
#Region './Public/Get-ADOProject.ps1' 0
function Get-ADOProject {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Org
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }
    $uri = "https://dev.azure.com/$org/_apis/projects?api-version=6.1-preview.4"
    
    try {
        $data = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers -ContentType "application/json"
        return $data.value
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/Get-ADOProject.ps1' 24
#Region './Public/Get-ADOPullRequest.ps1' 0
function Get-ADOPullRequest {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Org,
        [Parameter(Mandatory = $true)]
        $Project,
        [Parameter(Mandatory = $true)]
        $RepoId,
        [Parameter(Mandatory = $true)]
        $PullReqId
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }

    try {
        $uri = "https://dev.azure.com/$org/$project/_apis/git/repositories/$repoid/pullRequests/$($PullReqId)/?api-version=7.0"
        $data = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers -ContentType "application/json"
        $commitid = $data.lastMergeCommit.commitId
        $uri = "https://dev.azure.com/$org/$project/_apis/git/repositories/$repoid/commits/$($commitid)/changes?api-version=7.1-preview.1"
        $commitdata = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers -ContentType "application/json"
        $modifiedfiles = @()
        foreach ($i in $commitdata.changes) {
            $item = $i.item
            $modifiedfiles += $item
        }
        return $modifiedfiles
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/Get-ADOPullRequest.ps1' 38
#Region './Public/Get-ADORefs.ps1' 0
function Get-ADORefs {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $RepoId,
        [Parameter(Mandatory = $true)]
        $Org
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }
    
    $uri = "https://dev.azure.com/$org/_apis/git/repositories/$repoid/refs?filter=heads/&includeStatuses=True?api-version=7.0"

    try {
        $data = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers -ContentType "application/json"
        return $data.value
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/Get-ADORefs.ps1' 27
#Region './Public/Get-ADORepo.ps1' 0
function Get-ADORepo {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Org
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }
    $listuri = "https://dev.azure.com/$org/_apis/git/repositories?api-version=7.1"
    try {
        $data = Invoke-RestMethod -Uri $listuri -Method GET -Headers $headers -ContentType "application/json"
        return $data.value
    
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/Get-ADORepo.ps1' 24
#Region './Public/Get-ADOUpdates.ps1' 0
function Get-ADOUpdates {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Org,
        [Parameter(Mandatory = $true)]
        $Project,
        [Parameter(Mandatory = $true)]
        $WorkItemId,
        [Parameter(Mandatory = $true)]
        $RevNumber
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }

    try {
        $uri = "https://dev.azure.com/$org/$project/_apis/wit/workItems/$($WorkItemId)/updates/$($RevNumber)?api-version=6.1-preview.3"
        $data = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers -ContentType "application/json"
        return $data
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/Get-ADOUpdates.ps1' 30
#Region './Public/Get-ADOWorkItem.ps1' 0
function Get-ADOWorkItem {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Org,
        [Parameter(Mandatory = $true)]
        $Project,
        [Parameter(Mandatory = $true)]
        $WorkItemId
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }

    try {
        $uri = "https://dev.azure.com/$org/$project/_apis/wit/workitems/$($WorkItemId)?`$expand=All&api-version=7.1-preview.3"
        $data = Invoke-RestMethod -Uri $uri -Method Get -Headers $headers -ContentType "application/json"
        return $data
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/Get-ADOWorkItem.ps1' 28
#Region './Public/Get-ADOWorkItemList.ps1' 0
function Get-ADOWorkItemList {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Org,
        [Parameter(Mandatory = $true)]
        $Project,
        [Parameter(Mandatory = $true)]
        $Query
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }
    $Body = @{
        "Query" = "$Query"
    } | ConvertTo-Json

    try {
        $uri = "https://dev.azure.com/$org/$project/_apis/wit/wiql?api-version=7.0"
        $data = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $Body -ContentType "application/json"
        return $data.workitems
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/Get-ADOWorkItemList.ps1' 31
#Region './Public/Get-ADOWorkItemPages.ps1' 0
function Get-ADOWorkItemPages {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Org,
        [Parameter(Mandatory = $true)]
        $ProcessName,
        [Parameter(Mandatory = $true)]
        $WorkItemType
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }

    try {
        $ProcessId = ((Get-ADOProcess -Auth $Auth -Org $Org).value | where { $_.name -eq "$ProcessName" }).id
        $uri = "https://dev.azure.com/$Org/_apis/work/processes/$ProcessId/workItemTypes/$ProcessName.$WorkItemType/layout?api-version=5.0"
        $data = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers -ContentType "application/json"
        return $data
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/Get-ADOWorkItemPages.ps1' 29
#Region './Public/Get-ADOWorkItemStates.ps1' 0
function Get-ADOWorkItemStates {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $ProcessName,
        [Parameter(Mandatory = $true)]
        $Org,
        [Parameter(Mandatory = $true)]
        $WorkItemType

    )
    $ProcessId = ((Get-ADOProcess -Auth $Auth -Org $Org).value | where { $_.name -eq "$ProcessName" }).id
    if ($null -eq $ProcessId) {
        Write-Host "ProcessID is not present."
        break
    }
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }

    try {
        $uri = "https://dev.azure.com/$Org/_apis/work/processes/$ProcessId/workItemTypes/$ProcessName.$($WorkItemType)/states?api-version=7.0"
        $data = Invoke-RestMethod -Uri $uri -Method GET -Headers $headers -ContentType "application/json"
        return $data.value    
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/Get-ADOWorkItemStates.ps1' 34
#Region './Public/New-ADOAuthToken.ps1' 0
function New-ADOAuthToken {
    param (
        [Parameter(Mandatory = $true)][string] $AppId,
        [Parameter(Mandatory = $true)][string] $AppSecret,
        [Parameter(Mandatory = $true)][string] $TenantId
    )
    $uri = "https://login.microsoftonline.com/$tenantId/oauth2/token"
    $resource = "499b84ac-1321-427f-aa17-267ca6975798"
    
    # Construct Body for token request
    $Body = [Ordered] @{
        resource      = $resource
        client_id     = $AppId
        grant_type    = "client_credentials"
        client_secret = $AppSecret
    }
    try {
        $response = Invoke-RestMethod -Uri $uri -Method Post -Body $body -ContentType "application/x-www-form-urlencoded"
        return $response.access_token
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/New-ADOAuthToken.ps1' 26
#Region './Public/New-ADOComment.ps1' 0
function New-ADOComment {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        [string] $Org,
        [Parameter(Mandatory = $true)]
        [string] $Project,
        [Parameter(Mandatory = $true)]
        [string] $WorkItemId,
        [Parameter(Mandatory = $true)]
        [string] $Comment,
        [string] $PersonId,
        [string] $PersonDisplayName
    )

    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }

    if ($null -ne $PersonId) {
        $cs = "<div><a href=`"#`" data-vss-mention=`"version:2.0,$PersonId`">@$PersonDisplayName</a>&nbsp; $Comment</div>"
        $body = @{
            "text" = $cs;
    
        }
    }
    else {
        $body = @{
            "text" = $Comment;
    
        }
    }
    
    $uri = "https://dev.azure.com/$org/$project/_apis/wit/workItems/$($WorkItemId)/comments?api-version=7.0-preview.3"
    
    try {
        $data = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body ($Body | ConvertTo-Json) -ContentType "application/json"
    } 
    catch {
        $data = $_.ErrorDetails.Message | ConvertFrom-Json
    }
    return $data
}
#EndRegion './Public/New-ADOComment.ps1' 47
#Region './Public/New-ADOField.ps1' 0
function New-ADOField {
  param (
    [Parameter(Mandatory = $true)]
    [string]$Auth,
    [Parameter(Mandatory = $true)]
    $Name,
    [Parameter(Mandatory = $true)]
    $Type,
    [Parameter(Mandatory = $true)]
    $Org,
    [Parameter(Mandatory = $true)]
    $Project,
    [bool]$IsPickList,
    [ValidateScript({ $IsPickList -eq $true -and $_ -ne $null })]
    [Parameter(Mandatory = $false)]
    $ListId
  )
  $headers = @{
    Authorization  = 'Bearer ' + $Auth;
    'Content-Type' = "application/json";
    charset        = "utf-8"
  }
  $supportedops = @"
    [
        {
          "referenceName": "SupportedOperations.Equals",
          "name": "="
        },
        {
          "referenceName": "SupportedOperations.NotEquals",
          "name": "<>"
        },
        {
          "referenceName": "SupportedOperations.GreaterThan",
          "name": ">"
        },
        {
          "referenceName": "SupportedOperations.LessThan",
          "name": "<"
        },
        {
          "referenceName": "SupportedOperations.GreaterThanEquals",
          "name": ">="
        },
        {
          "referenceName": "SupportedOperations.LessThanEquals",
          "name": "<="
        },
        {
          "referenceName": "SupportedOperations.Contains",
          "name": "Contains"
        },
        {
          "referenceName": "SupportedOperations.NotContains",
          "name": "Does Not Contain"
        },
        {
          "referenceName": "SupportedOperations.In",
          "name": "In"
        },
        {
        "referenceName": "SupportedOperations.NotIn",
          "name": "Not In"
        },
        {
          "referenceName": "SupportedOperations.InGroup",
          "name": "In Group"
        },
        {
          "referenceName": "SupportedOperations.NotInGroup",
          "name": "Not In Group"
        },
        {
          "referenceName": "SupportedOperations.Ever",
          "name": "Was Ever"
        },
        {
          "referenceName": "SupportedOperations.EqualsField",
          "name": "= [Field]"
        },
        {
          "referenceName": "SupportedOperations.NotEqualsField",
          "name": "<> [Field]"
        },
        {
          "referenceName": "SupportedOperations.GreaterThanField",
          "name": "> [Field]"
        },
        {
          "referenceName": "SupportedOperations.LessThanField",
          "name": "< [Field]"
        },
        {
          "referenceName": "SupportedOperations.GreaterThanEqualsField",
          "name": ">= [Field]"
        },
        {
          "referenceName": "SupportedOperations.LessThanEqualsField",
          "name": "<= [Field]"
        }
    ]
"@ | ConvertFrom-Json

  if ($IsPickList) {
    $Body = @{
      "name"                = "$Name";
      "type"                = "$Type";
      "usage"               = "workItem";
      "readOnly"            = $false;
      "canSortBy"           = $true;
      "isQueryable"         = $true;
      "supportedOperations" = $supportedops;
      "isIdentity"          = $false;
      "isPicklist"          = $true;
      "picklistId"          = "$listid";
    }
  }
  else {
    $Body = @{
      "name"                = "$Name";
      "type"                = "$Type";
      "usage"               = "workItem";
      "readOnly"            = $false;
      "canSortBy"           = $true;
      "isQueryable"         = $true;
      "supportedOperations" = $supportedops;
      "isIdentity"          = $false;
      "isPicklist"          = $false;
      # "picklistId"          = "$listid";
    }
  }

  try {
    $uri = "https://dev.azure.com/$org/$project/_apis/wit/fields?api-version=7.1-preview.3"
    $data = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body ($Body | ConvertTo-Json) -ContentType "application/json"
    return $data
  }
  catch {
    $err = $_.ErrorDetails.Message | ConvertFrom-Json
    return $err
  }
}
#EndRegion './Public/New-ADOField.ps1' 143
#Region './Public/New-ADOList.ps1' 0
function New-ADOList {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Name,
        [Parameter(Mandatory = $true)]
        $Items,
        [Parameter(Mandatory = $true)]
        $Type,
        [Parameter(Mandatory = $true)]
        $Org
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }
    $body = @{
        "id"          = "";
        "type"        = "$Type";
        "name"        = "$Name";
        "items"       = $Items;
        "isSuggested" = $true;
    }

    try {
        $uri = "https://dev.azure.com/$org/_apis/work/processes/lists?api-version=7.0"
        $data = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body ($Body | ConvertTo-Json) -ContentType "application/json"
        return $data        
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/New-ADOList.ps1' 37
#Region './Public/New-ADOProcess.ps1' 0
function New-ADOProcess {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Name,
        [Parameter(Mandatory = $true)]
        $Org
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }
    try {
        $basicprocessid = ((Get-ADOProcess -Auth $Auth -Org $Org).value | where { $_.name -eq "Basic" }).id
        if ($null -eq $basicprocessid) {
            Write-Error "Error obtaining basic process ID."
            break
        }
        $body = @{
            "parentProcessTypeId" = "$basicprocessid";
            "name"                = "$Name";
        }
        $uri = "https://dev.azure.com/$org/_apis/work/processes?api-version=7.0"
        $data = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body ($Body | ConvertTo-Json) -ContentType "application/json"
        return $data   
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    } 
}
#EndRegion './Public/New-ADOProcess.ps1' 34
#Region './Public/New-ADOWorkItem.ps1' 0
function New-ADOWorkItem {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $WorkItemType,
        [Parameter(Mandatory = $true)]
        $Org,
        [Parameter(Mandatory = $true)]
        $Project,
        [Parameter(Mandatory = $true)]
        $Data
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }
    foreach ($d in $data) {
        Write-Host $d.'System.Title'
        $jpl = @()
        $props = $d.PSObject.Properties | Where-Object { $_.Name -eq "System.Title" -or $_.Name -eq "System.Description" -or $_.Name -like "Custom.*" }
        foreach ($evt in $props) {
            $body = @{
                "op"    = "add"
                "path"  = "/fields/$($evt.Name)"
                "value" = $evt.Value
            }
            $jpl += $body
        }
        $uri = "https://dev.azure.com/$org/$project/_apis/wit/workitems/`$$($WorkItemType)?api-version=7.2-preview.3"
        try {
            $rdata = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body ($jpl | ConvertTo-Json -Depth 10) -ContentType "application/json-patch+json"    
            return $rdata
        }
        catch {
            $err = $_.ErrorDetails.Message | ConvertFrom-Json
            return $err
        }
    }
}
#EndRegion './Public/New-ADOWorkItem.ps1' 42
#Region './Public/New-ADOWorkItemPage.ps1' 0
function New-ADOWorkItemPage {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Name,
        [Parameter(Mandatory = $true)]
        $ProcessName,
        [Parameter(Mandatory = $true)]
        $WorkItemType,
        [Parameter(Mandatory = $true)]
        $Org
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }
    # Get Process ID
    $ProcessId = ((Get-ADOProcess -Auth $Auth -Org $Org).value | where { $_.name -eq "$ProcessName" }).id
    $body = @{
        "id"             = "";
        "label"          = "$name";
        "pageType"       = "custom";
        "visible"        = $true;
        "isContribution" = $false;
        "sections"       = @(
            @{
                "id"     = "Section1";
                "groups" = @()
            },
            @{
                "id"     = "Section2";
                "groups" = @()
            },
            @{
                "id"     = "Section3";
                "groups" = @()
            },
            @{
                "id"     = "Section4";
                "groups" = @()
            }
        )
    }

    try {
        $uri = "https://dev.azure.com/$Org/_apis/work/processes/$ProcessId/workItemTypes/$ProcessName.$WorkItemType/layout/Pages?api-version=5.0"
        $data = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body ($Body | ConvertTo-Json -Depth 10) -ContentType "application/json"
        return $data    
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/New-ADOWorkItemPage.ps1' 57
#Region './Public/New-ADOWorkItemPageGroup.ps1' 0
function New-ADOWorkItemPageGroup {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Name,
        [Parameter(Mandatory = $true)]
        $ProcessName,
        [Parameter(Mandatory = $true)]
        $WorkItemType,
        [Parameter(Mandatory = $true)]
        $Org,
        [Parameter(Mandatory = $true)]
        $PageName,
        [Parameter(Mandatory = $true)]
        $Section
    )
    if ($PageName -eq "Home") {
        $PageName = "Details"
    }
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }

    try {
        $ProcessId = ((Get-ADOProcess -Auth $Auth -Org $Org).value | where { $_.name -eq "$ProcessName" }).id
        $PageId = ((Get-ADOWorkItemPages -Auth $Auth -Org $Org -ProcessName $ProcessName -WorkItemType $WorkItemType).pages | where { $_.label -eq "$PageName" }).id
        if ($null -eq $ProcessId) {
            Write-Host "ProcessID is not present."
            break
        }
        $body = @{
            "id"             = "";
            "label"          = "$Name";
            "isContribution" = $false;
            "visible"        = $true;
            "controls"       = @()
        }
        $uri = "https://dev.azure.com/$Org/_apis/work/processes/$ProcessId/workItemTypes/$ProcessName.$WorkItemType/layout/pages/$($PageId)/sections/Section$Section/Groups?api-version=5.0"
        $data = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body ($Body | ConvertTo-Json) -ContentType "application/json"
        return $data    
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/New-ADOWorkItemPageGroup.ps1' 50
#Region './Public/New-ADOWorkItemState.ps1' 0
function New-ADOWorkItemState {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Name,
        [Parameter(Mandatory = $true)]
        $Category,
        [Parameter(Mandatory = $true)]
        $Colour,
        [Parameter(Mandatory = $true)]
        $ProcessName,
        [Parameter(Mandatory = $true)]
        $WorkItemType,
        [Parameter(Mandatory = $true)]
        $Org
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }

    try {
        $ProcessId = ((Get-ADOProcess -Auth $Auth -Org $Org).value | where { $_.name -eq "$ProcessName" }).id
        if ($null -eq $ProcessId) {
            Write-Host "ProcessID is not present."
            break
        }
        $StateBody = @{
            "color"         = "$Colour"
            "name"          = "$Name"
            "stateCategory" = "$Category"
        }
        $stateuri = "https://dev.azure.com/$Org/_apis/work/processes/$ProcessId/workItemTypes/$ProcessName.$WorkItemType/states?api-version=5.0"
        $data = Invoke-RestMethod -Uri $stateuri -Method POST -Headers $headers -Body ($StateBody | ConvertTo-Json) -ContentType "application/json"
        return $data 
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }   
}
#EndRegion './Public/New-ADOWorkItemState.ps1' 44
#Region './Public/New-ADOWorkItemType.ps1' 0
function New-ADOWorkItemType {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Name,
        [Parameter(Mandatory = $true)]
        $Org,
        [Parameter(Mandatory = $true)]
        $ProcessName,
        [Parameter(Mandatory = $true)]
        $Colour,
        [Parameter(Mandatory = $true)]
        $Icon,
        [Parameter(Mandatory = $true)]
        $Description
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }

    try {
        $ProcessID = ((Get-ADOProcess -Auth $Auth -Org $Org).value | where { $_.name -eq $ProcessName }).id
        if ($null -eq $ProcessID) {
            Write-Error "ProcessID for $ProcessName not found"
        }
        $body = @{
            "color"       = "$Colour";
            "icon"        = "$Icon";
            "name"        = "$Name";
            "description" = "$Description";
        }
        $uri = "https://dev.azure.com/$org/_apis/work/processes/$ProcessId/workitemtypes?api-version=7.2-preview.2"
        $data = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body ($Body | ConvertTo-Json) -ContentType "application/json"
        return $data     
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    } 
}
#EndRegion './Public/New-ADOWorkItemType.ps1' 44
#Region './Public/Remove-ADOFields.ps1' 0
function Remove-ADOFields {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Org,
        [Parameter(Mandatory = $true)]
        $Project,
        [Parameter(Mandatory = $true)]
        $FieldName
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }

    try {
        $uri = "https://dev.azure.com/$org/$project/_apis/wit/fields/$($FieldName)?api-version=7.0"
        $data = Invoke-RestMethod -Uri $uri -Method DELETE -Headers $headers -ContentType "application/json"
        if ($null -ne $data) {
            return "Deleting: $($FieldName)"
        }
        else {
            return "Error Deleting: $FieldName"
        }    
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/Remove-ADOFields.ps1' 33
#Region './Public/Remove-ADOList.ps1' 0
function Remove-ADOList {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Org,
        [Parameter(Mandatory = $true)]
        $ListName
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }
    try {
        $flist = Get-ADOList -Auth $Auth -Org $Org
        $listid = ($flist.value | where { $_.name -contains $ListName }).id
        $listuri = "https://dev.azure.com/$org/_apis/work/processdefinitions/lists/$($listid)?api-version=7.0"
        $data = Invoke-RestMethod -Uri $listuri -Method DELETE -Headers $headers -ContentType "application/json"
        if ($null -ne $data) {
            return "Deleting: $($ListName)"
        }
        else {
            return "Error Deleting: $ListName"
        }
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/Remove-ADOList.ps1' 32
#Region './Public/Remove-ADORefs.ps1' 0
function Remove-ADORefs {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Auth,
        [Parameter(Mandatory = $true)]
        $Org,
        [Parameter(Mandatory = $true)]
        $Project,
        [Parameter(Mandatory = $true)]
        $RepoId,
        [Parameter(Mandatory = $true)]
        $RefsName,
        [Parameter(Mandatory = $true)]
        $ObjectId
    )
    $headers = @{
        Authorization  = 'Bearer ' + $Auth;
        'Content-Type' = "application/json";
        charset        = "utf-8"
    }
    $body = @(
        @{
            "name"        = $RefsName
            "newObjectId" = "0000000000000000000000000000000000000000"
            "oldObjectId" = $ObjectId
        }
    )
    $newbod = "[$($body|convertto-json)]"
    try {
        $uri = "https://dev.azure.com/$Org/$Project/_apis/git/repositories/$RepoId/refs?api-version=5.1"
        $data = Invoke-RestMethod -Uri $uri -Method POST -Headers $headers -Body $newbod -ContentType "application/json"
        if ($data.value.success -eq $true) {
            return "Deleting: $($RefsName)"
        }
        else {
            Write-host "Error Deleting: $RefsName"
            return $data

        }    
    }
    catch {
        $err = $_.ErrorDetails.Message | ConvertFrom-Json
        return $err
    }
}
#EndRegion './Public/Remove-ADORefs.ps1' 46
