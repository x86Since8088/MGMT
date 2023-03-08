param (
    [string]$TLS='Tls12,Tls13'
)
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]$TLS