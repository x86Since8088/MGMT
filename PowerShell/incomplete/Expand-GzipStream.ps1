function Convertfrom-GzipStreaminBase64 {
    param (
        [Parameter(ValueFromPipeline = $true)]
        $InputData
    )
    begin{

    }
    process {
        if ($inputData[0] -is [byte]) {
            $Bytes = $InputData
        }
        else {
            [byte[]]$Bytes = [System.Text.Encoding]::utf8.GetBytes($InputData)
        }
        $gzipStream = New-Object System.IO.Compression.GzipStream ([System.IO.MemoryStream]::new($Bytes), [System.IO.Compression.CompressionMode]::Decompress)
        $buffer = [byte[]]::new(1024)
        while ($true) {
            $read = $gzipStream.Read($buffer, 0, 1024)
            if ($read -le 0) { break }
            [System.Console]::OpenStandardOutput().Write($buffer, 0, $read)
        }
        $gzipStream.Close()
    }
}# Path: git/MGMT/PowerShell/incomplete/Expand-GzipStream.ps1


function Expand-GzipStream {
    param (
        [Parameter(ValueFromPipeline = $true)]
        $InputData
    )
    begin{

    }
    process {
        if ($inputData[0] -is [byte]) {
            $Bytes = $InputData
        }
        else {
            [byte[]]$Bytes = [System.Text.Encoding]::utf8.GetBytes($InputData)
        }
        $gzipStream = New-Object System.IO.Compression.GzipStream ([System.IO.MemoryStream]::new($Bytes), [System.IO.Compression.CompressionMode]::Decompress)
        $buffer = [byte[]]::new(1024)
        while ($true) {
            $read = $gzipStream.Read($buffer, 0, 1024)
            if ($read -le 0) { break }
            [System.Console]::OpenStandardOutput().Write($buffer, 0, $read)
        }
        $gzipStream.Close()
    }
}