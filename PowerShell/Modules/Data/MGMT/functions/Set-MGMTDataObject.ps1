function Set-MGMTDataObject {
    [cmdletbinding()]
    param(
        [hashtable]$InputObject = @{},
        $Name,
        $Value,
        [switch]$Passthru
    )
    begin{
        [string[]]$NameSplit = $Name -split '\.|\[|\]' | Where-Object{$_ -match '\w'}
        if ($InputObject -isnot [hashtable]) {
            $InputObject = [hashtable]::Synchronized(@{})
        }
        if ($NameSplit|Where-object{$_ -in ('keys','values')}) {
            return Write-Error -Message "The keys and values are reserved words."
        }
        if ($NameSplit.count -le 1) {
            $InputObject.($NameSplit[0]) = $Value
        }
        else {
            if ($InputObject.($NameSplit[0]) -isnot [hashtable]) {
                $InputObject.($NameSplit[0]) = [hashtable]::Synchronized(@{})
            }
            Set-MGMTDataObject -InputObject $InputObject.($NameSplit[0]) -Name ($NameSplit|Select-Object -Skip 1) -Value $Value
        }
        if ($PassThru.IsPresent) {
            [hashtable]::Synchronized($InputObject)
        }
    }
}
