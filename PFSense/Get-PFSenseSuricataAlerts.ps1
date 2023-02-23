#Function Get-PFSenseSuricataAlerts_DOES {
    param (
        $Credential=$Global:Cred_PFSense,
        $PFSenseBaseURI=$global:URL_PFSense
    )
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

    if ($null -ne $Global:WebSession_PFSense_Web_UI){$WebSession_PFSense_Web_UI=$global:WebSession_PFSense_Web_UI}
    Try{
        $JSTimeInteger=$(((get-date).ToFileTimeUtc() - ('01/01/1970'|get-date).ToFileTimeUtc()))
        $results = Invoke-RestMethod -WebSession $WebSession_PFSense_Web_UI -Uri "https://pf.ds.skarke.net:442/widgets/widgets/suricata_alerts.widget.php?getNewAlerts=$JSTimeInteger"
        if ($results -like "<!DOCTYPE html>*") {Write-Error -Message goto_catch}
    }
    catch {
        $login = Invoke-WebRequest -SessionVariable WebSession_PFSense_Web_UI -Uri $PFSenseBaseURI
        $forgeryToken = ($login.InputFields | 
                    Where { $_.name -eq "__csrf_magic" }).value
        $authentication=
            Invoke-RestMethod -WebSession $WebSession_PFSense_Web_UI `
                -Uri $PFSenseBaseURI `
                -Body @{
                    usernamefld=$Credential.UserName;
                    passwordfld=$Credential.GetNetworkCredential().password;
                    login='Sign In';
                    __csrf_magic=$forgeryToken
                } -Method Post
        $results = Invoke-RestMethod -WebSession $WebSession_PFSense_Web_UI -Uri "https://pf.ds.skarke.net:442/widgets/widgets/suricata_alerts.widget.php?getNewAlerts=$(((get-date).ToFileTimeUtc() - ('01/01/1970'|get-date).ToFileTimeUtc()))"
    }
    $global:WebSession_PFSense_Web_UI=$WebSession_PFSense_Web_UI
    return $Results
#}