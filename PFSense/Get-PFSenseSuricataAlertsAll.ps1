#Function Get-PFSenseSuricataAlerts_DOES {
    param (
        $Credential=$Global:Cred_PFSense,
        $PFSenseBaseURI=$global:URL_PFSense
    )

    Function GetTable {
        param(
            [Parameter(Mandatory = $true)]
            [Microsoft.PowerShell.Commands.HtmlWebResponseObject] $WebRequest,
  
            [Parameter(Mandatory = $true)]
            [int] $TableNumber
        )

        ## Extract the tables out of the web request
        $tables = @($WebRequest.ParsedHtml.getElementsByTagName("TABLE"))
        $table = $tables[$TableNumber]
        $titles = @()
        $rows = @($table.Rows)

        ## Go through all of the rows in the table
        foreach($row in $rows)
        {
            $cells = @($row.Cells)
   
            ## If we've found a table header, remember its titles
            if($cells[0].tagName -eq "TH")
            {
                $titles = @($cells | ForEach-ObjectorEach-Object { ("" + $_.InnerText).Trim() })
                continue
            }

            ## If we haven't found any table headers, make up names "P1", "P2", etc.
            if(-not $titles)
            {
                $titles = @(1..($cells.Count + 2) | ForEach-Object { "P$_" })
            }

            ## Now go through the cells in the the row. For each, try to find the
            ## title that represents that column and create a hashtable mapping those
            ## titles to content
            $resultObject = [Ordered] @{}
            for($counter = 0; $counter -lt $cells.Count; $counter++)
            {
                $title = $titles[$counter]
                if(-not $title) { continue }  

                $resultObject[$title] = ("" + $cells[$counter].InnerText).Trim()
            }

            ## And finally cast that hashtable to a PSCustomObject
            [PSCustomObject] $resultObject
        }
    }

    if ($null -eq $Credential)
    {
        $Global:Cred_PFSense=$Credential=get-credential -Credential admin
    }
    ELSE {
        $Global:Cred_PFSense=$Credential
    }
    if ($null -eq $PFSenseBaseURI)
    {
        $Global:PFSenseBaseURI=$PFSenseBaseURI=read-host -Prompt PFSenseBaseURI
    }
    ELSE {
        $Global:Cred_PFSense=$Credential
    }
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Tls11,Tls12'
    add-type @"
        using System.Net;
        using System.Security.Cryptography.X509Certificates;
        public class TrustAllCertsPolicy : ICertificatePolicy {
            public bool CheckValidationResult(
                ServicePoint srvPoint, X509Certificate certificate,
                WebRequest request, int certificateProblem) {
                return true;
            }
        }
"@
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
    if ($null -ne $Global:WebSession_PFSense_Web_UI){$WebSession_PFSense_Web_UI=$global:WebSession_PFSense_Web_UI}
    Try{
        $JSTimeInteger=$(((get-date).ToFileTimeUtc() - ('01/01/1970'|get-date).ToFileTimeUtc()))
        $results = Invoke-WebRequest -WebSession $WebSession_PFSense_Web_UI -Uri "$PFSenseBaseURI/suricata/suricata_alerts.php?instance=0" 
        #if ($results -like "<!DOCTYPE html>*") {Write-Error -Message goto_catch}
    }
    catch {
        $login = Invoke-WebRequest -SessionVariable WebSession_PFSense_Web_UI -Uri $PFSenseBaseURI 
        $forgeryToken = ($login.InputFields | 
                    Where-Object { $_.name -eq "__csrf_magic" }).value
        $authentication=
            Invoke-RestMethod -WebSession $WebSession_PFSense_Web_UI `
                -Uri $PFSenseBaseURI `
                -Body @{
                    usernamefld=$Credential.UserName;
                    passwordfld=$Credential.GetNetworkCredential().password;
                    login='Sign In';
                    __csrf_magic=$forgeryToken
                } -Method Post -UseBasicParsing
        
        $results = Invoke-WebRequest -WebSession $WebSession_PFSense_Web_UI -Uri "$PFSenseBaseURI/suricata/suricata_alerts.php?instance=0" 
    }

    GetTable -WebRequest $results -TableNumber 0
    $results = Invoke-WebRequest -WebSession $WebSession_PFSense_Web_UI -Uri "$PFSenseBaseURI/suricata/suricata_alerts.php?instance=1" 
    GetTable -WebRequest $results -TableNumber 0

    $global:WebSession_PFSense_Web_UI=$WebSession_PFSense_Web_UI
    
#}