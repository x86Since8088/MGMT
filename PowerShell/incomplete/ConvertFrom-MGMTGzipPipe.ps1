function ConvertFrom-MGMTGZipPipe {
    param (
        [Parameter(ValueFromPipeline = $true)]
        $CompressedData,
        [string]$OutputFile,
        [switch]$Base64Encoded
    )
    begin {
        #Add-Type -AssemblyName System.IO.Compression.FileSystem
        [bool]$tofile = '' -ne $OutputFile
        $ms = New-Object System.IO.MemoryStream
        $sr = New-Object System.IO.StreamReader (New-Object System.IO.Compression.GZipStream ($ms, [System.IO.Compression.CompressionMode]::Decompress))
    }
    process {
        if ($Base64Encoded) {
            [byte[]]$Bytes = [System.Convert]::FromBase64String($CompressedData)
        }
        elseif ($CompressedData[0] -is [byte]) {
            [byte[]]$Bytes = $CompressedData
        }
        else {
            [byte[]]$Bytes = [System.Text.Encoding]::UTF8.GetBytes($CompressedData)
        }
        $ms.Write($Bytes, 0, $Bytes.Length)
        $ms.Position = 0
        $sr.ReadLine()
        $ms.Flush()
    }
    end{
        $sr.Close()
        $ms.Close()
    }
}

