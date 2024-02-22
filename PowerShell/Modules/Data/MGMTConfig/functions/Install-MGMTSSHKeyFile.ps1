Function Install-MGMTSSHKeyFile {
    [cmdletbinding()]
    param (
      [string]$HostName,
      [string]$UserName,
      [string]$KeyFilePath,
      [string]$RunFirst
    )
    process {
      Add-MGMTSSHHostKey -HostName $HostName -KeyFilePath $KeyFilePath
      if ('' -eq $KeyFilePath) {
          $KeyFilePath = "$env:userprofile/.ssh/id_rsa"
          if (!(test-path $KeyFilePath)) {
              ssh-keygen.exe -t rsa -b 4096 -C "default" -f $KeyFilePath -N ""
              icacls $KeyFilePath /inheritance:d
              icacls $KeyFilePath /remove everyone
          }
          #$sandbox.Password| scp $KeyFilePath "$($UserName)@$($HostName):/home/$UserName/$(split-path $KeyFilePath -leaf)"
          ssh -i $KeyFilePath $UserName@$HostName -t bash @"
          $RunFirst
          export  keyinfo='$(Get-Content "$keyFilePath.pub")'
          echo `$keyinfo
          echo `$keyinfo >> ~/.ssh/authorized_keys
          if (( grep -q "`$keyinfo" ~/.ssh/authorized_keys )); then
          echo "found keyinfo in authorized_keys"
          else
          echo "missing keyinfo in authorized_keys"
          echo `$keyinfo >> ~/.ssh/authorized_keys
          chmod 600 ~/.ssh/authorized_keys
          fi
"@
        }
    }   
}