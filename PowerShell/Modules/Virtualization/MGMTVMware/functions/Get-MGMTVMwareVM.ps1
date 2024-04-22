
function Get-MGMTVMwareVM {
    [cmdletbinding()]
    param(
        [string[]]$Server,
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
            [string[]]$Server = $FakeBoundParameters['Server']
            [string]$Regex = $FakeBoundParameters['Regex']
            if ($null -eq $global:DefaultVIServers) {
                $UnconnectedServers = $Server
            }
            else {
                $UnconnectedServers = $Server | 
                    Where-Object { $_ -notin $global:DefaultVIServers.Name }
            }
            foreach ($UnconnectedServer in $UnconnectedServers) {
                Connect-MGMTViserver -Server $UnconnectedServer -Credential $FakeBoundParameters['Credential']
            }
            $params = @{}
            if ($Server.count -gt 0) {
                $params['Server'] = $Server
            }
            $CompletionResults = Get-VM @params | 
                Where-Object {$_.Name -match $Regex}| 
                Where-Object { $_.Name -like "$WordToComplete*" } | 
                ForEach-Object { [System.Management.Automation.CompletionResult]::new($_.Name, $_.Name, 'ParameterValue', $_.Name) }
            return $CompletionResults
        })]
        $VMName,
        [string]$Regex = '.'
    )
    begin{
        $Params = @{}
        if ($null -ne $Server) {
            $Params['Server'] = $Server
            if ($null -ne $Credential) {
                $Params['Credential'] = $Credential
            }
        }
        Get-VM -Name $VMName @Params | 
            Where-Object { $_.Name -match $Regex }
    }
    process{}
}