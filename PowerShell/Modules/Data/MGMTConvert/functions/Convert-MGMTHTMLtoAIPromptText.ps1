Function Convert-MGMTHTMLtoAIPromptText {
    param ($HTML)
    $HTML `
        -replace '^\s*|\s*$|' `
        -replace '\s*(<)','$1' `
        -replace '\r' `
        -join ' ' `
        -replace '\</{0,1}(p|div|br)\b[^\>]*\>',"`n" `
        -replace '\<head[^\>]*\>.*?\</script\>|\<head[^\>]*/\>','' `
        -replace '\<script[^\>]*\>.*?\</script\>|\<script[^\>]*/\>','' `
        -replace '\<style[^\>]*\>.*?\</script\>|\<style[^\>]*/\>','' `
        -replace '\<span [^\>]*\>',"`t" `
        -replace '\<[^\>]*\>' -split '\n\s\n+'
}

function Test-Convert_MGMTHTMLtoAIPromptText {
    [CmdletBinding()]
    param()
    begin{
        #$HTML = '"<div>div1_test<div>div2_test<span>spantest<p><pain>p_test</pain></p><p>p_test_2</p>after_p</span>after_span</div>after_div2</div>after_div1"'
        #$Expected = 
        Describe "Convert-MGMTHTMLtoAIPromptText"  -Verbose {
            It "Should return the expected value" -ForEach @(
                @{ 
                    Test=Convert-MGMTHTMLtoAIPromptText $HTML; 
                    Name = "HTMLTest"; 
                    Expected = '"\ndiv1_test\ndiv2_testspantest\np_test\n\np_test_2\nafter_pafter_span\nafter_div2\nafter_div1"'
                }
            ) {
                [regex]::Escape($test) | Should -Be $Expected -Verbose
            }
        }
    }
}