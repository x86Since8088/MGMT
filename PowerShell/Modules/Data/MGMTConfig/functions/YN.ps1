function YN {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    do{$YN = Read-Host -Prompt "$Message (Y/N)"}
    while ($YN -notmatch '^[YN]$')
    if ($YN -eq "Y") {
        return $true
    } else {
        return $false
    }
}
