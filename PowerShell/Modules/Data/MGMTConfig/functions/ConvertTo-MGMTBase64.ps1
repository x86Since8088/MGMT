function ConvertTo-MGMTBase64 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$String,
        [byte[]]$Bytes = [System.Text.Encoding]::UTF8.GetBytes($String)
    )
    process {
        if ($null -eq $Bytes) {
            return Write-Warning -Message "No bytes to convert."
        }
        [System.Convert]::ToBase64String($Bytes)
    }
}
