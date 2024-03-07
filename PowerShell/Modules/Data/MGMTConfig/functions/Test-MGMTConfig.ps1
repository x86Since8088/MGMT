function Test-MGMTConfig {
    [CmdletBinding()]
    param (
    )
    begin {
        [string]$PSSCR                  = $PSScriptRoot
        [string]$MGMTFolder             = $PSSCR -replace '\\MGMT\\.*','\MGMT'
        [string]$ModuleFolder           = $MGMTFolder + '\PowerShell\Modules'
        [string]$SavedModulesFolder     = $MGMTFolder + 'PowerShell\SavedModules'
        [string]$FunctionName           = $MyInvocation.MyCommand.Name
        . {
            Import-Module pester
            function Test-Execution {
                param (
                    [scriptblock]$CommandScriptBlock,
                    $FunctionName = $MyInvocation.MyCommand.Name
                )
                Set-SyncHashtable -InputObject $global:MGMT_Env -Name Findings
                Set-SyncHashtable -InputObject $global:MGMT_Env.Findings -Name $FunctionName
                [array]$Output = . $CommandScriptBlock *>&1
                $FindingName = $CommandScriptBlock.tostring()
                if ($output.count -ne 0) {
                    $global:MGMT_Env.Findings.$FunctionName.$FindingName = $Output
                }
            }
            . Test-Execution -CommandScriptBlock {Import-Module -Name "$ModuleFolder\Data\MGMTConfig"}
            . Test-Execution -CommandScriptBlock {Import-Module -Name "$SavedModulesFolder\Pester"}
            
            foreach($Site in $Global:MGMT_Env.config.sites.GetEnumerator()) {
                foreach($SystemType in $Site.value.GetEnumerator()) {
                    foreach($System in $SystemType.value) {
                        
                    }
                }
            }
        }
    }
}
