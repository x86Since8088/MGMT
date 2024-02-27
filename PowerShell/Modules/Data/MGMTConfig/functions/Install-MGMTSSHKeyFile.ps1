Function Install-MGMTSSHKeyFile {
    [cmdletbinding()]
    param (
      [string]$HostName,
      [string]$UserName,
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
          if (!(test-path $KeyFilePath)) {
              ssh-keygen.exe -t rsa -b 4096 -C "default" -f $KeyFilePath -N ""
              icacls $KeyFilePath /inheritance:d
              icacls $KeyFilePath /remove everyone
          }
          #$sandbox.Password| scp $KeyFilePath "$($UserName)@$($HostName):/home/$UserName/$(split-path $KeyFilePath -leaf)"
          ssh -i $KeyFilePath $UserName@$HostName -t $shell @"
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
    }   
}