Function Set-SyncHashtable {
    [cmdletbinding()]
    param (
        $VariableName,
        $scope = 'global',
        $InputObject = (Get-Variable -Name $VariableName -Scope $scope -ErrorAction SilentlyContinue),
        [string]$Name,
        $Value = (
            .{
                if (
                    ('InputObject' -in $PSBoundParameters.Keys) -or 
                    ($null -ne $InputObject.value)
                ) 
                {($InputObject.Value).($Name)} else {[hashtable]::Synchronized(@{})
            }
            }
        )
    )
    process {
        if ($null -eq $InputObject) {
            $InputObject = New-Variable   -Name $VariableName -Value $Value -Scope $scope -PassThru
        }
        if ($null -eq $InputObject.Value) {
            $InputObject.Value = [hashtable]::Synchronized(@{})
        }
        elseif ($InputObject.Value.GetType().Name -eq 'Hashtable') {
            $V = $InputObject.Value
            $InputObject.Value = [hashtable]::Synchronized($v)
        }
        if($InputObject.Value.GetType().Name -eq 'SyncHashtable') {}
        else {
            #return Write-Error -Message "The input object is not a hashtable or a SyncHashtable."
        }
        if ('' -ne $Name) {
            $InputObject.Value.($Name) = $Value
        }
    }
}