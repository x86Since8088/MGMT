$Workingfolder = $PSScriptRoot
#. "$(split-path $workingfolder)\init.ps1"
Import-Module pester
# Test that init.ps1 has been sourced and variables are available.
$error.clear()
#new pester test to check if the init.ps1 has been sourced and the variables are available
. "$(split-path $workingfolder)\init.ps1" 
Describe "Test init.ps1" {
    it 'Validate that $Error is null.' {
        $Error | Should -BeNullOrEmpty
    }
    It 'Validate $MGMTFolder is not null' {
        $MGMTFolder | Should -Be ($PSSR -replace "^(.*?\\MGMT).*",'$1')
    }
    It 'Validate $ESXI_Obj is not null' {
        $ESXI_Obj | Should -Not -BeNullOrEmpty
    }
    It 'Validate $ESXI_Creds is not null' {
        $ESXI_Creds | Should -Not -BeNullOrEmpty
    }
    It 'Validate $PFSense_Obj is not null' {
        $PFSense_Obj | Should -Not -BeNullOrEmpty
    }
    It 'Validate $PFSense_Creds is not null' {
        $PFSense_Creds | Should -Not -BeNullOrEmpty
    }
}