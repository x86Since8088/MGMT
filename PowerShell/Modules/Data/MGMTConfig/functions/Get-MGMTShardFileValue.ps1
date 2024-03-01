function Get-MGMTShardFileValue {
    [cmdletbinding()]
    param (
        [string]$LiteralPath,
        [ArgumentCompleter({
            [OutputType([System.Management.Automation.CompletionResult])]
            param(
                [string] $CommandName,
                [string] $ParameterName,
                [string] $WordToComplete,
                [System.Management.Automation.Language.CommandAst] $CommandAst,
                [System.Collections.IDictionary] $FakeBoundParameters
            )
            if (!(Test-Path $LiteralPath)) {
                return 'file_not_found'
            }
            else {
                $inputObject = (Import-MGMTYAML -LiteralPath $FakeBoundParameters.LiteralPath -ErrorAction Ignore)
                return  $inputObject.Keys| Where-Object { $_ -like "*$WordToComplete*" }
            }
            return  'no_data_found'
        })]
        [string[]]$KeyName,
        [int]$KeyLength = 32,
        [switch]$Force
    )
    process {
        if ('' -eq $KeyName) {
            return write-error -Message "The key name is required."
        }
        Split-Path $LiteralPath | 
            Where-Object {! (Test-Path $_)} | 
            ForEach-Object {New-Item -Path $_ -ItemType Directory -Force} | 
            Out-Null
        if (!(Test-Path $LiteralPath)) {
            $Data = @{}
            foreach ($key in $KeyName) {
                Set-MGMTDataObject -InputObject $Data -Name $KeyName -Value ( ConvertTo-MGMTBase64 -Bytes (Get-MGMTRandomBytes -ByteLength $KeyLength))                
            }
            $Keys = $KeyName
            Export-MGMTShard -LiteralPath $LiteralPath -InputObject $Data
        }
        else{
            $Data = Import-MGMTShard -LiteralPath $LiteralPath -KeyName $KeyName
            if ($KeyName.count -eq 0) {
                [string[]]$Keys = $Data.keys
            }
            else {
                $Keys = $KeyName
            }
        }
        if ($null -eq $Data) {$Data = @{}}
        foreach($key in $Keys){
            if ($null -eq $Data[$Key]) {
                Write-Warning -Message "The data under key '$Key' was null.  Generating a new key"
                Set-MGMTDataObject -InputObject $Data -Name $Key -Value ( ConvertTo-MGMTBase64 -Bytes (Get-MGMTRandomBytes -ByteLength $KeyLength))  -Passthru
                Export-MGMTShard -LiteralPath $LiteralPath -InputObject $Data
            }
            if ($Force -and ($Data[$Key].length -ne $KeyLength)){
                Write-Warning -Message "The data under key '$KeyName' was not the correct length AND -force was specified.  Generating a new key"
                Set-MGMTDataObject -InputObject $Data -Name $Key -Value ( ConvertTo-MGMTBase64 -Bytes (Get-MGMTRandomBytes -ByteLength $KeyLength))  -Passthru
                Export-MGMTShard -LiteralPath $LiteralPath -InputObject $Data
            }
            elseif($Data[$Key].length -ne $KeyLength){
                write-error -Message "The data under key '$KeyName' was not the correct length."
            }
        }
        return $Data
    }
}

function Export-MGMTShard {
    param (
        [hashtable]$InputObject,
        [string]$LiteralPath,
        [string[]]$KeyName
    )
    process {
        $ExistingData = Import-MGMTYAML -LiteralPath $LiteralPath -ErrorAction Ignore
        $ToFile = $inputObject.Clone()
        foreach ($key in $ExistingData.keys) {
            if ($null -eq $ToFile[$key]) {
                $ToFile[$key] = $ExistingData[$key]
            }
        }
        if ($null -eq $ToFile) {
            return write-error -Message "The input object is required."
        }
        if ($KeyName.count -eq 0) {
            [string[]]$Keys = $inputObject.keys
        }
        else {
            $Keys = $KeyName
        }
        foreach($key in $Keys){
            if ($ToFile[$key] -is [byte[]]) {}
            elseif ($ToFile[$key] -is [int[]]) {}
            elseif ($ToFile[$key] -is [string]) {
                $test = ConvertFrom-MGMTBase64 -Base64 $ToFile[$key]
                if ($null -eq $test) {
                    write-error -Message "The data under key '$key' was a string, but not a base64 encoded string."
                }
            }
            else {
                write-error -Message "The input object data under key '$key' must be a byte array, int array, or a base64 encoded string."
            }
            if ($ToFile[$key].length -eq 0) {
                write-error -Message "The input object must not be empty."
            }
            elseif ($inputObject[$key] -is [string]) {<# do nothing #>}
            else {
                $ToFile[$key] = ConvertTo-MGMTBase64 -Bytes $ToFile[$key]
            }
        }
        Export-MGMTYAML -LiteralPath $LiteralPath -InputObject $ToFile -Encoding utf8
    }
}

function Import-MGMTShard {
    param (
        [string]$LiteralPath,
        [string[]]$KeyName
    )
    process {
        if (!(test-path $LiteralPath)) {
            return write-error -Message "The literal path '$LiteralPath' does not exist."
        }
        $Data = Import-MGMTYAML -LiteralPath $LiteralPath
        if ($KeyName.count -eq 0) {
            [string[]]$Keys = $Data.keys
        }
        else {
            $Keys = $KeyName
        }
        foreach($key in $Keys){
            if ($null -eq $Data[$key]) {}
            if ($data[$key].GetType().name -like 'list*') {
                $Data[$key] = [byte[]]$Data[$key]
            }
            elseif ($Data[$key] -is [byte[]]) {}
            elseif ($Data[$key] -is [string]) {
                $Data[$key] = [byte[]](ConvertFrom-MGMTBase64 -Base64 $Data[$key])
                if ($null -eq $Data[$key]) {
                    Write-Warning -Message "The data under key '$key' is null or was not a valud base64 string."
                }
            }
            else {
                write-error -Message "The data under key '$key' must be a byte array, int array, or a base64 encoded string."
            }
        }
        $Data
    }
}