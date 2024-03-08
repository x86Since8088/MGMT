Function Install-MGMTSSHKeyFile {
    [cmdletbinding()]
    param (
      [string]$HostName,
      [string]$UserName,
      [validateSet('Linux','PFSense','VMwareEsxi')]
      [string]$HostType = 'Linux',
      [switch]$ShowCommands,
      [ArgumentCompleter({
        [OutputType([System.Management.Automation.CompletionResult])]
        param(
          [string] $CommandName,
          [string] $ParameterName,
          [string] $WordToComplete,
          [System.Management.Automation.Language.CommandAst] $CommandAst,
          [System.Collections.IDictionary] $FakeBoundParameters
        )
        (Get-ChildItem -Path "$env:userprofile\.ssh\*.pub" -File).FullName
      })]
      [string]$KeyFilePath,
      [string]$RunFirst,
      [switch]$Force,
      [string]$authorized_keys_path = '~/.ssh/authorized_keys',
      [string]$Shell,
      [string]$logoffcommands = 'exit'
    )
    process {
      if (!$ShowCommands) {
        Add-MGMTSSHHostKey -HostName $HostName -Force:$Force
      }
      if ('' -eq $KeyFilePath) {
          $KeyFilePath = "$env:userprofile/.ssh/id_rsa"
          #$sandbox.Password| scp $KeyFilePath "$($UserName)@$($HostName):/home/$UserName/$(split-path $KeyFilePath -leaf)"
      } 
      if (!(test-path $KeyFilePath)) {
          ssh-keygen.exe -t rsa -b 4096 -C "default" -f $KeyFilePath -N ""
          icacls $KeyFilePath /inheritance:d
          icacls $KeyFilePath /remove everyone
      }
      switch ($HostType) {
        'Linux' {
          #if ('' -eq $Shell) {$shell = 'sh'}
          $authorized_keys_path = '~/.ssh/authorized_keys'
          $SSHCommands = @"
          $RunFirst
          export  keyinfo='$(Get-Content "$keyFilePath.pub")'
          #echo `$keyinfo
          mkdir -p `$(dirname '$authorized_keys_path') 
          if [ ! -e "$authorized_keys_path" ]; then
            touch $authorized_keys_path
          fi
          if grep -q "`$keyinfo" $authorized_keys_path ; then
            echo "found keyinfo in authorized_keys"
          else
            echo "missing keyinfo in authorized_keys"
            echo "`$keyinfo" >> $authorized_keys_path
            echo "added keyinfo to authorized_keys"
            echo "set permissions on authorized_keys"
            chmod 600 $authorized_keys_path
          fi
          $logoffcommands
"@
        }
        'VMwareEsxi' {
          #if ('' -eq $Shell) {$shell = 'sh'}
          $authorized_keys_path = '/etc/ssh/keys-root/authorized_keys'
          $SSHCommands = @"
          $RunFirst
          export  keyinfo='$(Get-Content "$keyFilePath.pub")'
          #echo `$keyinfo
          mkdir -p `$(dirname '$authorized_keys_path') 
          if [ ! -e "$authorized_keys_path" ]; then
            touch $authorized_keys_path
          fi
          if grep -q "`$keyinfo" $authorized_keys_path ; then
            echo "found keyinfo in authorized_keys"
          else
            echo "missing keyinfo in authorized_keys"
            echo "`$keyinfo" >> $authorized_keys_path
            echo "added keyinfo to authorized_keys"
            echo "set permissions on authorized_keys"
            chmod 600 $authorized_keys_path
          fi
          $logoffcommands
"@
        }
        'PFSense' {
          #if ('' -eq $Shell) {$shell = 'sh'}
          $authorized_keys_path = '/root/.ssh/authorized_keys'
          $RunFirst = ""
          $logoffcommands = "exit"
          $SSHCommands = @"
          $RunFirst
          export keyinfo='$(Get-Content "$keyFilePath.pub")'
          #echo "`$keyinfo"
          mkdir -p `$(dirname '$authorized_keys_path') 
          if [ ! -e "$authorized_keys_path" ]; then
            touch $authorized_keys_path
          fi
          if grep -q "`$keyinfo" $authorized_keys_path ; then
            echo "found keyinfo in authorized_keys"
          else
            echo "missing keyinfo in authorized_keys"
            echo "`$keyinfo" >> $authorized_keys_path
            echo "added keyinfo to authorized_keys"
            echo "set permissions on authorized_keys"
            chmod 600 $authorized_keys_path
          fi
          $logoffcommands
"@
        }
      }
      #if ('' -eq $Shell) {$shell = 'sh'}
      if ($ShowCommands) {
        Write-Host -ForegroundColor Yellow "Commands to be executed on $HostName"
        Write-Host -ForegroundColor Yellow $SSHCommands
      }
      else {
        $SSHCommands = $SSHCommands -replace '(\n)\s*','$1'
        $SSHCommands = $SSHCommands -replace '\r'
        if ('' -ne $Shell) {
          ssh -i $KeyFilePath $UserName@$HostName -t $Shell $SSHCommands
        }
        else {
          ssh -i $KeyFilePath $UserName@$HostName $SSHCommands
        }
      }
  }
}