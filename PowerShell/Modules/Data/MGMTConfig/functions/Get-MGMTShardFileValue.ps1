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
            $Data = Set-MGMTDataObject -InputObject $inputObject -Name $KeyName -Value (Get-MGMTRandomBytes -ByteLength $KeyLength) -Passthru
            Export-MGMTYAML -LiteralPath $LiteralPath -InputObject $Data -Encoding utf8
        }
        else{
            $inputObject = (Import-MGMTYAML -LiteralPath $LiteralPath -ErrorAction Ignore)
        }
        $Data = Get-MGMTDataObject -InputObject $inputObject -Name $KeyName
        if ($null -eq $Data) {
            $Data = Set-MGMTDataObject -InputObject $inputObject -Name $KeyName -Value (Get-MGMTRandomBytes -ByteLength $KeyLength) -Passthru
            Export-MGMTYAML -LiteralPath $LiteralPath -InputObject $Data -Encoding utf8
        }
        if ($Force -and ($Data.length -ne $KeyLength)){
            $Data = Set-MGMTDataObject -InputObject $inputObject -Name $KeyName -Value (Get-MGMTRandomBytes -ByteLength $KeyLength) -Passthru
            Export-MGMTYAML -LiteralPath $LiteralPath -InputObject $Data -Encoding utf8
        }
        return $Data
    }
}