$WorkingFolder   = $PSScriptRoot
$Datafolder      = $WorkingFolder -replace "^(.*?)\\(.*)$",'$1\Data\$2'
if (!(Test-Path $Datafolder)) {New-Item -Path $Datafolder -ItemType Directory | Out-Null}
Function Get-MGMTConfig {
    $ConfigData = Get-Content -LiteralPath "$Datafolder\config.yaml" | 
        ConvertFrom-YAML
    return $ConfigData
}
Get-MGMTConfig
[byte[]]$Shard = 0,11,159,136,217,167,1,185,196,169,243,35,234,88,147,217,223,229,80,38,100,181,255,250,223,177,45,128,109,107,253,110

$global:MGMT_Env = [hashtable]::Synchronized(@{

    sites = [hashtable]::Synchronized(@{
        default = [hashtable]::Synchronized(@{
            credential = Get-Credential -Message "Enter the defailt PFSense credential." -UserName "admin"
        })
        "fw1.ds.skarke.net" = [hashtable]::Synchronized(@{
            pfsense = [hashtable]::Synchronized(@{
                "pf1.fw1.ds.skarke.net" = @{
                    hostname = 'pf1'
                    domain = "fw1.ds.skarke.net"
                    unbound = @{
                        host_overrides = [hashtable]::Synchronized(@{
                            "esx1.fw1.ds.skarke.net" = "192.168.1.35"
                            "pf1.fw1.ds.skarke.net" = "192.168.1.2"
                            
                        })
                    }
                }
            })
            esxi = [hashtable]::Synchronized(@{
                default = [hashtable]::Synchronized(@{
                    credential = Get-Credential -Message "Enter the defailt ESXi credential." -UserName "root"
                })
                esx1 = [hashtable]::Synchronized(@{
                    Site_Domain = "fw1.ds.skarke.net"
                    Site_ESX = "esx1"
                    Site_ESX_FQDN = "esx1.fw1.ds.skarke.net"
                    Site_PFSense = "pf1"
                    Parent_DNS_Server = "192.168.1.1"
                })
            })
        })
    })
    AWS = [hashtable]::Synchronized(@{})
    Azure = [hashtable]::Synchronized(@{})
    GCP = [hashtable]::Synchronized(@{})
    Splunk = [hashtable]::Synchronized(@{})
    ESXi = [hashtable]::Synchronized(@{})
    PFSense = [hashtable]::Synchronized(@{})
    Windows = [hashtable]::Synchronized(@{})
    Linux = [hashtable]::Synchronized(@{})
    MacOS = [hashtable]::Synchronized(@{})
    Docker = [hashtable]::Synchronized(@{})
    Kubernetes = [hashtable]::Synchronized(@{})
    Ansible = [hashtable]::Synchronized(@{})
    Terraform = [hashtable]::Synchronized(@{})
    Packer = [hashtable]::Synchronized(@{})
    Vagrant = [hashtable]::Synchronized(@{})
    Jenkins = [hashtable]::Synchronized(@{})
    Git = [hashtable]::Synchronized(@{})
    GitHub = [hashtable]::Synchronized(@{})
    GitLab = [hashtable]::Synchronized(@{})
    BitBucket = [hashtable]::Synchronized(@{})
    Jira = [hashtable]::Synchronized(@{})
    Confluence = [hashtable]::Synchronized(@{})
    Slack = [hashtable]::Synchronized(@{})
    Teams = [hashtable]::Synchronized(@{})
    Zoom = [hashtable]::Synchronized(@{})
    WebEx = [hashtable]::Synchronized(@{})
    Office365 = [hashtable]::Synchronized(@{})
    Exchange = [hashtable]::Synchronized(@{})
    SharePoint = [hashtable]::Synchronized(@{})
    OneDrive = [hashtable]::Synchronized(@{})
    PowerBI = [hashtable]::Synchronized(@{})
    AzureDevOps = [hashtable]::Synchronized(@{})
    AWSCodeCommit = [hashtable]::Synchronized(@{})
})