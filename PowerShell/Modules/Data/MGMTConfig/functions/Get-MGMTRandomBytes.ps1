function Get-MGMTRandomBytes {
    param (
        [int]$ByteLength = 256
    )
    begin{
        $contents = [Byte[]]::new($ByteLength);
        
        $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new();
        $rng.GetBytes($contents);
        return $contents
    }
}
