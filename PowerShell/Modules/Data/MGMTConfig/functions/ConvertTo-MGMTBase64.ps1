function ConvertTo-MGMTBase64 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$String,
        [byte[]]$Bytes = [System.Text.Encoding]::UTF8.GetBytes($String)
    )

    process {
        [System.Convert]::ToBase64String($Bytes)
    }
}
