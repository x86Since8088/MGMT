# Requires -Module powershell-yaml
Function Export-MGMTYAML {
    [cmdletbinding()]
    param (
        [object]$InputObject,
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
            $CompletionResults = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()
            $CompletionResults.Add('utf8')
            $CompletionResults.Add('utf7')
            $CompletionResults.Add('utf32')
            $CompletionResults.Add('ascii')
            $CompletionResults.Add('bigendianunicode')
            $CompletionResults.Add('unicode')
            return $CompletionResults | Where-Object { $_ -like "*$WordToComplete*" }
        })]
        [string]$Encoding = 'utf8',
        [switch]$Verify
    )
    begin {
    }
    process {
        $YAML = $InputObject|
            ConvertTo-Yaml
        if ($Verify) {
            Write-Host -Message $YAML
            if ((Read-Host -Prompt "Do you want to save the configuration? (Y/N)").ToUpper() -ne 'Y') {return}
        }
        #$YAML|
        #    Set-Content -LiteralPath $LiteralPath -Encoding $Encoding
        Split-Path $LiteralPath|Where-Object{!(test-path $_)}|ForEach-Object{new-item -ItemType Directory -Path $_ -Force}
        [system.io.file]::WriteAllLines($LiteralPath,$YAML,[System.Text.Encoding]::$Encoding)
    }
}