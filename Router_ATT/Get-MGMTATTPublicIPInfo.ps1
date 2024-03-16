param(
    $RouterIPAddress = '192.168.2.254'
)
$R = Invoke-WebRequest -Uri https://192.168.2.254/cgi-bin/broadbandstatistics.ha -SkipCertificateCheck -UseBasicParsing
try {
    $Data = [ordered]@{}
    $R.Content.ToString() -split "\s*\<tr[^\>]*\>|\</tr[^\>]*>|\<br[^\>]*\>\s*" -match '\<th' -replace '\&nbsp;',' ' -replace '\s*?\n\s*' -replace '\s*\<th[^\>]*\>\s*','{"' -replace '\s*\</th\>\<td[^\>]*\>\s*','":"' -replace '\s*\</td\>\s*','"}' |
        Foreach-Object{
            $DataItem = $_|ConvertFrom-Json -AsHashtable
            foreach ($Key in $DataItem.Keys)
            {
                $Data[$Key] = $DataItem[$Key]
            }
        }
    $Data
}
catch{
    write-warning -Message "there was an issue with robust parsing, attempting to parse the page with a less robust method.s"
    [string]$BroadbandIPv4Address = $R.Content.ToString() -split "\s*\<tr[^\>]*\>|\</tr[^\>]*>|\<br[^\>]*\>\s*" -match 'Broadband IPv4 Address' -split '\s*\<|\>' -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' 
    [string]$BroadbandIPv4Gateway = $R.Content.ToString() -split "\s*\<tr[^\>]*\>|\</tr[^\>]*>|\<br[^\>]*\>\s*" -match 'Gateway IPv4 Address'   -split '\s*\<|\>' -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' 
    @{
        BroadbandIPv4Address = $BroadbandIPv4Address
        BroadbandIPv4Gateway = $BroadbandIPv4Gateway
    }
}