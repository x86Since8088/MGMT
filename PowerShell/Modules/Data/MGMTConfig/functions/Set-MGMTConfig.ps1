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
        $Changed = $False
        if ($null -eq $Global:MGMT_Env) {
            Initialize-MGMTConfig
        }
        else {
        }
        if ($null -eq $Global:MGMT_Env)                                 {
                                                                            Write-Warning -Message "The configuration file '$script:ConfigFile' is missing or corrupt."
                                                                            $Global:MGMT_Env = [hashtable]::Synchronized(@{});$Changed=$true
                                                                        }
        if ($null -eq $Global:MGMT_Env.config)                          {$Global:MGMT_Env.config = [hashtable]::Synchronized(@{});$Changed=$true}
        if ($ParamName -notmatch '\w')                                  {}
        elseif ($null -ne $ParamValue)                                  {
                                                                            Set-MGMTDataObject -InputObject $Global:MGMT_Env -Name $ParamName -Value $ParamValue
                                                                            $Changed=$true
                                                                        }
        if ($Changed)                                                   {
                                                                            Save-MGMTConfig
                                                                        }
        if ($PassThru)                                                  {$Global:MGMT_Env}
    }
}