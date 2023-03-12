function Get-MGMTConfig {
    [cmdletbinding()]
    param (
        $Name
    )
    begin{
        $PSSR             = $PSScriptRoot
        $Invocation       = $MyInvocation
        $DataFolder       = $PSSR  -replace '^(\\\\.*?|.*?)\\(.*\\.*)','$1\Data\$2'
                            if (!(Test-Path $DataFolder)) {mkdir $DataFolder|out-null}
        $ConfigFile       = "$DataFolder\Config.yaml"
                            if (!(Test-Path $ConfigFile)) {
                                [ordered]@{
                                    Generated     = (get-date).ToString()
                                    GeneratedBy   = $MyInvocation.ScriptName
                                }
                            }
        try{
            $Data = [system.io.file]::ReadAllLines($ConfigFile)|ConvertFrom-Yaml
            if ($Name -match '\w') {
                Get-DataObject -InputObject $Data -Name $Name
            }
            else {
                $Data
            }
        }catch{
            Write-Error -Message "Run Set-MGMTConfig and edit '$ConfigFile'."
        }
    }
}

function Set-MGMTConfig {
    [cmdletbinding()]
    param(
        $Name,
        $Value,
        [switch]$PassThru
    )
    begin{
        $ParamName = $Name
        $ParamValue = $Value
        $Data = . Get-MGMTConfig 2> $Null
        if ($null -eq $Data) {
            $Data = [ordered]@{}
            $Changed = $true
        }
        else {
            $Changed = $False
        }
        if ($null -eq $Data['proxmox']  )   {$Data['proxmox']=@();$Changed=$true}
        if ($Data['proxmox'].count -eq 0)   {
                                                $Data['proxmox']=@(
                                                    @{Server='';Node='';tags=@()}
                                                )
                                                $Changed=$true
                                            }
        if ($null -eq $Data['vmware']   )   {$Data['vmware']=@();$Changed=$true}
        if ($Data['vmware'].count -eq 0)    {
                                                $Data['vmware']=@(
                                                    @{Server='';tags=@()}
                                                )
                                                $Changed=$true
                                            }
        if ($null -eq $Data['unraid']   )   {$Data['unraid']=@();$Changed=$true}
        if ($Data['unraid'].count -eq 0)    {
                                                $Data['unraid']=@(
                                                    @{Server='';tags=@()}
                                                )
                                                $Changed=$true
                                            }
        if ($ParamName -notmatch '\w')           {}
        elseif ($null -ne $ParamValue)           {
                                                Set-DataObject -InputObject $Data -Name $ParamName -Value $ParamValue
                                                $Changed=$true
                                            }
        if ($Changed)                       {
                                                $Yaml = $Data|ConvertTo-Yaml
                                                [system.io.file]::WriteAllLines($ConfigFile,$Yaml,[System.Text.Encoding]::UTF8)
                                            }
        if ($PassThru)                      {$Data}
    }
}

function Set-DataObject {
    param(
        $InputObject,
        $Name,
        $Value,
        [switch]$Passthru
    )
    begin{
        [array]$NameSplit = $Name -split '\.|\[|\]' | Where-Object{$_ -match '\w'}
        if ($NameSplit.count -eq 1) {
            $InputObject[$NameSplit[0]]=$Value
        }
        else {
            $InputObject[$NameSplit[0]] = Set-DataObject -InputObject $InputObject[$NameSplit[0]] -Name ($NameSplit|Select-Object -Skip 1) -Value $Value -Passthru
        }
        if ($PassThru.IsPresent) {
            $InputObject
        }
    }
}

function Get-DataObject {
    param(
        $InputObject,
        $Name
    )
    begin{
        $NameSplit = $Name -split '\.|\[|\]' | Where-Object{$_ -match '\w'}
        $Reference = $InputObject
        foreach ($NameItem in $NameSplit) {
            $Reference=$Reference[$NameItem]
        }
        return $Reference
    }
}
