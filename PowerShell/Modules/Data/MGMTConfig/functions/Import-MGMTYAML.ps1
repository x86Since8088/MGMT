Function Import-MGMTYAML {
    [cmdletbinding()]
    param (
        [string]$LiteralPath
    )
    process {
        if (-not (Test-Path -LiteralPath $LiteralPath)) {
            return Write-Warning -Message "The file $LiteralPath does not exist."
        }
        return Get-Content -LiteralPath $LiteralPath|
            ConvertFrom-Yaml
    }
}