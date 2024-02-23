function Set-MGMTConfig {
    [cmdletbinding()]
    param(
        [string[]]$Name,
        $Value,
        [switch]$PassThru
    )
    begin{
        $ParamName = $Name
        $ParamValue = $Value
        if ($null -eq $Global:MGMT_Env) {
            Initialize-MGMTConfig
            $Changed = $true
        }
        else {
            $Changed = $False
        }
        if ($null -eq $Global:MGMT_Env.config.defaults['proxmox']  )             {$Global:MGMT_Env.config.defaults['proxmox']=@();$Changed=$true}
        if ($Global:MGMT_Env.config.defaults['proxmox'].count -eq 0)             {
                                                                            $Global:MGMT_Env.config.defaults['proxmox']=@(
                                                                                @{Server='';Node='';tags=@()}
                                                                            )
                                                                            $Changed=$true
                                                                        }
        if ($null -eq $Global:MGMT_Env.config.defaults['vmware']  )              {$Global:MGMT_Env.config.defaults['vmware']=@();$Changed=$true}
        if ($Global:MGMT_Env.config.defaults['vmware'].count -eq 0)              {
                                                                            $Global:MGMT_Env.config.defaults['vmware']=@(
                                                                                @{Server='';tags=@()}
                                                                            )
                                                                            $Changed=$true
                                                                        }
        if ($null -eq $Global:MGMT_Env.config.defaults['unraid']   )             {$Global:MGMT_Env.config.defaults['unraid']=@();$Changed=$true}
        if ($Global:MGMT_Env.config.defaults['unraid'].count -eq 0)              {
                                                                            $Global:MGMT_Env.config.defaults['unraid']=@(
                                                                                @{Server='';tags=@()}
                                                                            )
                                                                            $Changed=$true
                                                                        }
        if ($null -eq $Global:MGMT_Env.config['sites']    )               {$Global:MGMT_Env.config['sites']=@();$Changed=$true}
        if (!$Global:MGMT_Env.Contains('Crypto'))                         {$Global:MGMT_Env.config['Crypto']=[hashtable]::Synchronized(@{});$Changed=$true}
        if (($Global:MGMT_Env.config['crypto']['salt']).length -ne 8)     {$Global:MGMT_Env.config['Crypto']['salt']=Get-MGMTRandomBytes -ByteLength 8;$Changed=$true}
        if (($Global:MGMT_Env.config['crypto']['key']).length -ne 32)     {$Global:MGMT_Env.config['Crypto']['key']=Get-MGMTRandomBytes -ByteLength 32;$Changed=$true}
        if (($Global:MGMT_Env.config['crypto']['iv']).length -ne 16)      {$Global:MGMT_Env.config['Crypto']['iv']=Get-MGMTRandomBytes -ByteLength 16;$Changed=$true}
        if ($ParamName -notmatch '\w')                  {}
        elseif ($null -ne $ParamValue)                  {
                                                            Set-MGMTDataObject -InputObject $Global:MGMT_Env -Name $ParamName -Value $ParamValue
                                                            $Changed=$true
                                                        }
        if ($Changed)                                   {
                                                            Save-MGMTConfig
                                                        }
        if ($PassThru)                                  {$Global:MGMT_Env}
    }
}