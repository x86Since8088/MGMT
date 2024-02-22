function Get-MGMTHashtableKeys {
    param(
        [hashtable]$Hashtable,
        [string]$ParentKey = ''
    )
    if ($null -eq $Hashtable) {
        return Write-Error -Message "The input object is not a hashtable."
    }
    foreach ($key in $Hashtable.Keys) {
        $value = $Hashtable[$key]
        $newKey = if ($ParentKey) { "$ParentKey.$key" } else { $key }

        if ($value -is [hashtable]) {
            Get-MGMTHashtableKeys -Hashtable $value -ParentKey $newKey
        } else {
            $newKey
        }
    }
}