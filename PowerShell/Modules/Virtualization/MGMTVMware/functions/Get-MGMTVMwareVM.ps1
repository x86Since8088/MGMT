
function Get-MGMTVMwareVM {
    [cmdletbinding()]
    param(
        $Server,
        [pscredential]$Credential,
        [ArgumentCompleter({
            [OutputType([System.Management.Automation.CompletionResult])]
            param(
                [string] $CommandName,
                [string] $ParameterName,
                [string] $WordToComplete,
                [System.Management.Automation.Language.CommandAst] $CommandAst,
                [System.Collections.IDictionary] $FakeBoundParameters
            )
            $ConnectVMHostPatams = @{}
            if ($null -ne $FakeBoundParameters['Server']) {
                Connect-MGMTViserver -Server $FakeBoundParameters['Server'] -Credential $FakeBoundParameters['Credential']
            }
            $CompletionResults = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()
            Get-VM -VMHost $VMHost -VMHostCredential $VMHostCredential | ForEach-Object {
                $CompletionResults.Add([System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Name))
            }
            
            return $CompletionResults
        })]
        $VMName
    )
    begin{
        $Params = @{}
        if ($null -ne $Server) {
            $Params['Server'] = $Server
            if ($null -ne $Credential) {
                $Params['Credential'] = $Credential
            }
        }
        Get-VM -Name $VMNamn @Params
    }
    process{}
}