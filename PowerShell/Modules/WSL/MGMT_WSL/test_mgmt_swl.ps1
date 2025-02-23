Remove-Module MGMT_WSL -Force -ErrorAction Ignore
Import-Module $PSScriptRoot -Force -DisableNameChecking
Invoke-MgmtWSL