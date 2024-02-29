Function Install-MGMTSSHKeyFile {
    [cmdletbinding()]
    param (
      [string]$HostName,
      [string]$UserName,
      [validateSet('Linux','PFSense')]
      [string]$HostType = 'Linux',
      [switch]$ShowCommands,
      [string]$KeyFilePath,
      [string]$RunFirst,
      [switch]$Force,
      [string]$authorized_keys_path = '~/.ssh/authorized_keys',
      [string]$Shell = 'bash',
      [string]$logoffcommands = 'exit'
    )
    process {
      Add-MGMTSSHHostKey -HostName $HostName -Force:$Force
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
          $shell = 'bash'
          $authorized_keys_path = '~/.ssh/authorized_keys'
          $SSHCommands = @"
          $RunFirst

          export  keyinfo='$(Get-Content "$keyFilePath.pub")'
          echo `$keyinfo
          echo `$keyinfo >> $authorized_keys_path
          mkdir $(Split-Path $authorized_keys_path) 2> /dev/null
          if [ grep -q "`$keyinfo" $authorized_keys_path ]; then
            echo "found keyinfo in authorized_keys"
          else
            echo "missing keyinfo in authorized_keys"
            echo `$keyinfo >> $authorized_keys_path
            chmod 600 $authorized_keys_path
          fi
          $logoffcommands
"@
        }
        'PFSense' {
          $shell = 'sh'
          $authorized_keys_path = '/root/.ssh/authorized_keys'
          $RunFirst = "`n8`nmkdir -p $(split-path $authorized_keys_path) 2> /dev/null"
          $logoffcommands = "exit`nexit`n0`n"
          $SSHCommands = @"
          $RunFirst

          keyinfo='$(Get-Content "$keyFilePath.pub")'
          echo "`$keyinfo"
          echo "`$keyinfo" >> $authorized_keys_path
          mkdir -p $(Split-Path $authorized_keys_path) 
          if cat $authorized_keys_path|grep -q "`$keyinfo"; then
            echo "found keyinfo in authorized_keys"
          else
            echo "missing keyinfo in authorized_keys"
            echo `$keyinfo >> $authorized_keys_path
            chmod 600 $authorized_keys_path
          fi
          $logoffcommands
"@
        }
      }
      if ($ShowCommands) {
        Write-Host -ForegroundColor Yellow "Commands to be executed on $HostName"
        Write-Host -ForegroundColor Yellow $SSHCommands
      }
      else {
        ssh -i $KeyFilePath $UserName@$HostName -t $Shell $SSHCommands
      }
  }   
}