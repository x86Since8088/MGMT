pushd
cd $PSScriptRoot
$Date = Get-Date
[string]$Timestamp = $Date.ToString('yyyMMdd')
git branch $Timestamp
git add *;
git commit -m "GitFastPush $Timestamp"
[string]$To=''
git push | 
    ForEach-Object{
        $_;
        if ($_ -match '^To '){$To = $_ -split '\s'|Select-Object -Last 1}
    }
popd
start $To