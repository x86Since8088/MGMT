Function Import-MGMTYAML {
    [cmdletbinding()]
    param (
        [string]$LiteralPath
    )
    process {
        return Get-Content -LiteralPath $LiteralPath|
            ConvertFrom-Yaml
    }
}