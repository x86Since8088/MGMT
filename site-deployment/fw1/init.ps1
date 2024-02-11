param (
    [string[]]$Parent_DNS_Server            = "192.168.1.1",
    [string]$Site_Domain                  = "fw1.ds.skarke.net",
    [string[]]$Site_ESX                     = "esx1",
    $Site_ESX_FQDN                = ($Site_ESX|ForEach-Object{"$_.$Site_Domain"}),
    [string[]]$Site_PFSense                 = "pf1",
    [string[]]$Site_PFSense_FQDN            = ($Site_PFSense|ForEach-Object{"$_.$Site_Domain"})
)

                                if (!$global:MGMT_Env                      ) {$Global:MGMT_Env                          = [hashtable]::Synchronized(@{})}
                                if (!$global:MGMT_Env.sites                ) {$Global:MGMT_Env.sites                    = [hashtable]::Synchronized(@{})}
                                if (!$global:MGMT_Env.sites.$Site_Domain   ) {$Global:MGMT_Env.sites.$Site_Domain       = [hashtable]::Synchronized(@{})}
$site                         = $global:MGMT_Env.sites.$Site_Domain
                                if (!$site.esxi                            ) {$site.esxi  = [hashtable]::Synchronized(@{})}
$esxi_config                  = $site.esxi
                                if (!$esxi_config.default                  ) {$esxi_config.default = [hashtable]::Synchronized(@{})}
                                if (!$esxi_config.default.credential       ) {$esxi_config.default.credential = Get-Credential -Message "Enter the defailt ESXi credential." -UserName "root" }
                                if (!$esxi_config.default.$Site_ESX        ) {
                                    $esxi_config[$Site_ESX] = @{
                                        Site_Domain = $Site_Domain
                                        Site_ESX = $Site_ESX
                                        Site_ESX_FQDN = $Site_ESX_FQDN
                                        Site_PFSense = $Site_PFSense
                                        Parent_DNS_Server = $Parent_DNS_Server
                                    }
                                }

$Target_ESXi_Server           = $esxi_config[$Site_ESX]
# Test DNS Resulotion
                                Write-Verbose "Testing DNS Resolution for $($Target_ESXi_Server.Site_ESX_FQDN) on $($Parent_DNS_Server)"
$ResolutionTest               = Resolve-DnsName -Name $Target_ESXi_Server.Site_ESX_FQDN -Server $Parent_DNS_Server 
                                if ($ResolutionTest -eq $null) {
                                    Write-Host "DNS Resolution failed for $($Target_ESXi_Server.Site_ESX_FQDN) on $($Parent_DNS_Server)"
                                    Write-Host "Please verify the DNS server and the DNS record for $($Target_ESXi_Server.Site_ESX_FQDN)"
                                    break
                                }
                                elseif ($ResolutionTest.IPAddress -eq $null) {
                                    Write-Error "DNS Resolution IPAddress is null for $($Target_ESXi_Server.Site_ESX_FQDN) on $($Parent_DNS_Server)"
                                }
                                elseif ($ResolutionTest.IPAddress -notmatch '^(192.168.|10.|172.1[6-9].|172.2[0-9].|172.3[0-1].)') {
                                    Write-Error "DNS Resolution IPAddress is a PUBLIC IP for $($Target_ESXi_Server.Site_ESX_FQDN) on $($Parent_DNS_Server)"
                                }
                                $ResolutionTest = $null
                                if ($null -eq $Target_ESXi_Server.Connection) {
                                    Write-Host "Connecting to $($Target_ESXi_Server.Site_ESX_FQDN) with $($Target_ESXi_Server.default.credential)"
                                    $Target_ESXi_Server.Connection = Connect-VIServer -Server $Target_ESXi_Server.Site_ESX_FQDN -Credential $esxi_config.default.credential
                                }

                                    
