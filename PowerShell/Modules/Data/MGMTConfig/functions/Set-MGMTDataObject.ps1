function Set-MGMTDataObject {
    [cmdletbinding()]
    param(
        [hashtable]$InputObject,
        [string[]]$Name,
        $Value,
        [switch]$Passthru,
        [switch]$SaveConfig,
        [switch]$VerifyConfigBeforeSave
    )
    begin{
        if ($null -eq $InputObject) {
            write-error -Message "The input object is required and must be a hashtable."
        }
        if ($InputObject -isnot [hashtable]) {
            $InputObject = [hashtable]::Synchronized(@{})
        }
        if ($Name|Where-object{$_ -in ('keys','values')}) {
            return Write-Error -Message "The keys and values are reserved words."
        }
        if ($Name.count -le 1) {
            $InputObject.($Name[0]) = $Value
        }
        else {
            if ($InputObject.($Name[0]) -isnot [hashtable]) {
                $InputObject.($Name[0]) = [hashtable]::Synchronized(@{})
            }
            Set-MGMTDataObject -InputObject $InputObject.($Name[0]) -Name ($Name|Select-Object -Skip 1) -Value $Value
        }
        if ($PassThru.IsPresent) {
            [hashtable]::Synchronized($InputObject)
        }
        if ($SaveConfig.IsPresent) {
            Save-MGMTConfig -Force:(!$VerifyConfigBeforeSave)
        }
    }
}