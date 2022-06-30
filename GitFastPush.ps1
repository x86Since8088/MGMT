pushd
cd $PSScriptRoot
$Date = Get-Date
$Timestamp = $Date.ToString('yyyMMdd-HHmm')
git branch $Timestamp
git add *;
git commit -m "GitFastPush $Timestamp"
git push
popd