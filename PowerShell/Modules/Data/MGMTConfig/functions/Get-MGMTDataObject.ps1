function Get-MGMTDataObject {
    param(
        $InputObject,
        [string[]]$Name
    )
    begin{
        if ($Name.count -eq 1) {
            return $InputObject.($Name[0])
        }
        else {
            return Get-MGMTDataObject -InputObject ($InputObject).($Name[0]) -Name ($Name|Select-Object -Skip 1)
        }
    }
}