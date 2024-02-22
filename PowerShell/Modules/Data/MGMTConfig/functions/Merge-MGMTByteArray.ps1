Function Merge-MGMTByteArray {
    param (
        [byte[]]$ByteArray1,
        [byte[]]$ByteArray2,
        [int]$Length = ($ByteArray1.Length)
    )
    [byte[]]$Key = 0..32|ForEach-Object{$ByteArray1[$_] -bxor $ByteArray2[$_]}
    return $Key
}
