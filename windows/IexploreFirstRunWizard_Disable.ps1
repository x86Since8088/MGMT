<#
.ONLINE
https://blog.dhampir.no/content/how-to-use-invoke-webrequest-in-powershell-without-having-to-first-open-internet-explorer
#>
$keyPath = 'Registry::HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Internet Explorer\Main'
if (!(Test-Path $keyPath)) { New-Item $keyPath -Force | Out-Null }
Set-ItemProperty -Path $keyPath -Name "DisableFirstRunCustomize" -Value 1