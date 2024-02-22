function Get-MGMTDataObject {
    param(
        $InputObject,
        $Name
    )
    begin{
        [string[]]$NameSplit = $Name -split '\.|\[|\]' | Where-Object{$_ -match '\w'}
        if ($NameSplit.count -eq 1) {
            return $InputObject.($NameSplit[0])
        }
        else {
            return Get-MGMTDataObject -InputObject ($InputObject).($NameSplit[0]) -Name ($NameSplit|Select-Object -Skip 1)
        }
    }
}