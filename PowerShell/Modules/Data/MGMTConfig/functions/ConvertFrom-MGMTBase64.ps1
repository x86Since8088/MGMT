function ConvertFrom-MGMTBase64 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false,ValueFromPipeline)]
        [string]$Base64,
        [string]$encoding
    )
    process {
        if ('' -eq $Base64) {
            return Write-Error -Message "The parameter -Base64 is required."
        }
        $Base64Bytes = [System.Convert]::FromBase64String($Base64)
        if ('' -eq $encoding) {
            return $Base64Bytes
        }
        else {
            $Base64String = [System.Text.Encoding]::($encoding).GetString($Base64Bytes)
            return $Base64String
        }
    }
}