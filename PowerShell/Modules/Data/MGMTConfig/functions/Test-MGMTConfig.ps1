Function Test-MGMTConfig {
    [cmdletbinding()]
    param (
        [string]$Name,
        [string]$Value
    )
    begin{
        Set-MGMTConfig -Verbose
    }
}