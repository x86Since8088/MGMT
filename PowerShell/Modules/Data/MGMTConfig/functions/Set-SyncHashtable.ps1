Function Set-SyncHashtable {
    [cmdletbinding()]
    param (
        # Parameter help description
        [Parameter(ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$false,
                   Position=0,
                   Mandatory=$true)]
        $InputObject,
        [string]$Name
    )
    process {
        if ($null -eq $InputObject) {
            return Write-Error -Message "The input object is required."
        }
        if ('' -eq $Name) {return Write-Error -Message "The name is required."}
        
        if ($null -eq $InputObject.($Name)) {
            $InputObject.($Name) = [hashtable]::Synchronized(@{})
        }
        if($InputObject.($Name).GetType().Name -eq 'SyncHashtable') {}
        elseif ($InputObject.($Name).GetType().Name -eq 'Hashtable') {
            $V = $InputObject.($Name)
            $InputObject.($Name) = [hashtable]::Synchronized($v)
        }
        else {
            return Write-Error -Message "The input object is not a hashtable or a SyncHashtable."
        }
    }
}