$Workingfolder = $PSScriptRoot
$MGMTFolder      = $WorkingFolder -replace "^(.*?\\MGMT).*",'$1'
. "$MGMTFolder\PowerShell\init.ps1"
$script:PSSR = $PSScriptRoot
$Deployment_Environment = "$PSSR" -replace "^.*?site-deployment(\\|/)" -replace "(/|\\).*"
$Script:ConfigInfo = $global:MGMT_Env.config.sites.($Deployment_Environment)
Write-Host -Message "Environment Name: $Deployment_Environment pulled from current folder '$script:PSSR'" -ForegroundColor Yellow
$AZCredentialID = @{
    SystemType = "Azure"
    SystemName = "Skarke.net"
}

Add-MGMTSite -Name $Deployment_Environment
$global:MGMT_Env.config.sites.($Deployment_Environment).SystemTypes
Set-SyncHashtable -InputObject $global:MGMT_Env.config.sites.($Deployment_Environment) -Name SystemTypes
$global:MGMT_Env.config.sites.($Deployment_Environment) = @{
    Name = $Deployment_Environment
    domain = ''
    DNS_Servers = @()
    APIS = @()
    Type = ''
    SystemType = @{
        ESXI = @()
        PFSense = @()
        Windows = @()
        Linux = @()
        Azure = @()
        AWS = @()
        GCP = @()
        VCenter = @()
        Linode = @()
        DigitalOcean = @()
        CloudFlare = @()
        Wix = @()
        GoDaddy = @()
        NameCheap = @()
        GoogleDomains = @()
        Names_com = @()
    }
}

 = @{
    SystemType = "Linux"
    Systems = @()
    fqdn = "lab1.skarke.net"
    ip = ""
}


#Test-MGMTCredentialAZ
$AZCredential = Get-MGMTCredential @AZCredentialID -Scope currentuser -SystemType
if ($Null -eq $AZCredential) {
    $AZCredential = Get-Credential -Message "Enter your Azure credentials for:`n$($AZCredentialID|convertto-yaml)"
    #$test = Test-MGMTCredentialAZ -credential $AZCredential
    $Connection = Connect-AzAccount -Credential $AZCredential
    if ($null -eq $Connection) {
        Write-Host -Message "Failed to connect to Azure" -ForegroundColor Red
    } else {
        Write-Host -Message "Successfully connected to Azure" -ForegroundColor Green
        Set-MGMTCredential @AZCredentialID -Credential $AZCredential -Scope currentuser
    }
}
$AZTennantInfo = Get-AzTenant
$AZOrganization = Get-AzADOrganization
foreach ($VerifiedDomain in $AZOrganization.VerifiedDomain) {
    Set-MGMTCredential -SystemType "Azure" -SystemName $VerifiedDomain.Name -Credential $AZCredential -Scope currentuser 
}
