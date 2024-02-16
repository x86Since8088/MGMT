$script:PSSR                    = $PSScriptRoot
$script:DataFolder       = $script:PSSR  -replace '^(\\\\.*?|.*?)\\(.*\\.*)','$1\Data\$2'
$script:ConfigFile       = "$script:DataFolder\Config.yaml"
$script:MGMTFolder       = $WorkingFolder -replace "^(.*?\\MGMT).*",'$1'

Function Import-MGMTYAML {
    [cmdletbinding()]
    param (
        [string]$LiteralPath
    )
    process {
        return Get-Content -LiteralPath $LiteralPath|
            ConvertFrom-Yaml
    }
}
Function Export-MGMTYAML {
    [cmdletbinding()]
    param (
        [object]$InputObject,
        [string]$LiteralPath,
        [ArgumentCompleter({
            [OutputType([System.Management.Automation.CompletionResult])]
            param(
                [string] $CommandName,
                [string] $ParameterName,
                [string] $WordToComplete,
                [System.Management.Automation.Language.CommandAst] $CommandAst,
                [System.Collections.IDictionary] $FakeBoundParameters
            )
            $CompletionResults = [System.Collections.Generic.List[System.Management.Automation.CompletionResult]]::new()
            $CompletionResults.Add('utf8')
            $CompletionResults.Add('utf7')
            $CompletionResults.Add('utf32')
            $CompletionResults.Add('ascii')
            $CompletionResults.Add('bigendianunicode')
            $CompletionResults.Add('unicode')
            return $CompletionResults | Where-Object { $_ -like "*$WordToComplete*" }
        })]
        [string]$Encoding = 'utf8',
        [switch]$Verify
    )
    process {
        $YAML = $InputObject|
            ConvertTo-Yaml
        if ($Verify) {
            Write-Host -Message $YAML
            if ((Read-Host -Prompt "Do you want to save the configuration? (Y/N)").ToUpper() -ne 'Y') {return}
        }
        #$YAML|
        #    Set-Content -LiteralPath $LiteralPath -Encoding $Encoding
        [system.io.file]::WriteAllLines($LiteralPath,$YAML,[System.Text.Encoding]::$Encoding)
    }
}

Function Get-MGMTConfig {
    $ConfigData = Import-MGMTYAML -LiteralPath $script:ConfigFile
    return $ConfigData
}

Function Test-MGMTConfig {
    [cmdletbinding()]
    param (
        [string]$Name,
        [string]$Value
    )
    begin{
        Set-MGMTConfig -Verbose
    }
}
function Set-MGMTConfig {
    [cmdletbinding()]
    param(
        [string]$Name,
        $Value,
        [switch]$PassThru
    )
    begin{
        $ParamName = $Name
        $ParamValue = $Value
        if ($null -eq $Global:MGMT_Env) {
            Load-MGMTConfig
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
Function Set-SyncHashtable {
    [cmdletbinding()]
    param (
        $VariableName,
        $scope = 'global',
        $InputObject = (Get-Variable -Name $VariableName -Scope $scope -ErrorAction SilentlyContinue),
        [string]$Name,
        $Value = (
            .{
                if (
                    ('InputObject' -in $PSBoundParameters.Keys) -or 
                    ($null -ne $InputObject.value)
                ) 
                {($InputObject.Value).($Name)} else {[hashtable]::Synchronized(@{})
            }
            }
        )
    )
    process {
        if ($null -eq $InputObject) {
            $InputObject = New-Variable   -Name $VariableName -Value $Value -Scope $scope -PassThru
        }
        if ($null -eq $InputObject.Value) {
            $InputObject.Value = [hashtable]::Synchronized(@{})
        }
        elseif ($InputObject.Value.GetType().Name -eq 'Hashtable') {
            $V = $InputObject.Value
            $InputObject.Value = [hashtable]::Synchronized($v)
        }
        if($InputObject.Value.GetType().Name -eq 'SyncHashtable') {}
        else {
            #return Write-Error -Message "The input object is not a hashtable or a SyncHashtable."
        }
        if ('' -ne $Name) {
            $InputObject.Value.($Name) = $Value
        }
    }
}
function Set-MGMTDataObject {
    [cmdletbinding()]
    param(
        [hashtable]$InputObject = @{},
        $Name,
        $Value,
        [switch]$Passthru
    )
    begin{
        [string[]]$NameSplit = $Name -split '\.|\[|\]' | Where-Object{$_ -match '\w'}
        if ($InputObject -isnot [hashtable]) {
            $InputObject = [hashtable]::Synchronized(@{})
        }
        if ($NameSplit|Where-object{$_ -in ('keys','values')}) {
            return Write-Error -Message "The keys and values are reserved words."
        }
        if ($NameSplit.count -le 1) {
            $InputObject.($NameSplit[0]) = $Value
        }
        else {
            if ($InputObject.($NameSplit[0]) -isnot [hashtable]) {
                $InputObject.($NameSplit[0]) = [hashtable]::Synchronized(@{})
            }
            Set-MGMTDataObject -InputObject $InputObject.($NameSplit[0]) -Name ($NameSplit|Select-Object -Skip 1) -Value $Value
        }
        if ($PassThru.IsPresent) {
            [hashtable]::Synchronized($InputObject)
        }
    }
}

function Get-MGMTDataObject {
    param(
        $InputObject,
        $Name
    )
    begin{
        [string[]]$NameSplit = $Name -split '\.|\[|\]' | Where-Object{$_ -match '\w'}
        if ($NameSplit.count -eq 1) {
            return $InputObject.($NameSplit[0])
        }
        else {
            return Get-MGMTDataObject -InputObject ($InputObject).($NameSplit[0]) -Name ($NameSplit|Select-Object -Skip 1)
        }
    }
}

$Global:MGMTModule = Get-MGMTConfig -ErrorAction Ignore

function Get-MGMTCredential {
    [cmdletbinding()]
    param(
        [parameter(alias='ComputerName','FQDN')]$Name,
        $UserName,
        [string[]]$Tags,
        [pscredential]$SetCredential,
        [switch]$NoPrompt
    )
    begin{
        if ($Tags.count -ne 0) {
            $Name = "$Name(-)$($Tags -join '-'))"
        }
        if ($null -ne $SetCredential) {
            Set-MGMTCredential -FQDN $Name -Credential $SetCredential
            $Global:MGMT_Env.Auth.($Name) = $SetCredential
        }
        elseif ($Null -eq $Global:MGMT_Env.Auth.($Name)) {
            if ($NoPrompt) {
                return Write-Error -Message "The credential for $Name is not found."
            }
            else {
                if ('Y' -eq (Read-Host -Prompt "Do you want to set the credentials for $Name? (Y/N)").ToUpper()) {
                    $TempCredential = Get-Credential -Message "Enter the credentials for $Name"
                    if ($null -ne $TempCredential) {
                        Set-MGMTCredential -FQDN $Name -Credential $TempCredential
                        $Global:MGMT_Env.Auth.($Name) = $TempCredential
                    }
                }
            }
        }
        $Global:MGMT_Env.Auth.($Name)
    }
}

function Get-MGMTRandomBytes {
    param (
        [int]$ByteLength = 256
    )
    begin{
        $contents = [Byte[]]::new($ByteLength);
        
        $rng = [System.Security.Cryptography.RNGCryptoServiceProvider]::new();
        $rng.GetBytes($contents);
        return $contents
    }
}


Function Set-MGMTCredential {
    [cmdletbinding()]
    param (
        [ArgumentCompleter({
            [OutputType([System.Management.Automation.CompletionResult])]
            param(
                [string] $CommandName,
                [string] $ParameterName,
                [string] $WordToComplete,
                [System.Management.Automation.Language.CommandAst] $CommandAst,
                [System.Collections.IDictionary] $FakeBoundParameters
            )
            return [string[]]$global:MGMT_Env.Auth.Keys | Where-Object { $_ -like "*$WordToComplete*" }
        })]
        [string]$FQDN,
        [System.Management.Automation.PSCredential]$Credential,
        [validateset('currentuser','allusers')]
        [string]$Scope = 'currentuser',
        [ArgumentCompleter({
            [OutputType([System.Management.Automation.CompletionResult])]
            param(
                [string] $CommandName,
                [string] $ParameterName,
                [string] $WordToComplete,
                [System.Management.Automation.Language.CommandAst] $CommandAst,
                [System.Collections.IDictionary] $FakeBoundParameters
            )
            return [string[]]$global:MGMT_Env.Auth.Keys | Where-Object { $_ -like "*$WordToComplete*" }
        })]
        [string]$From
    )
    process {
        $Global:MGMT_Env.Auth.($FQDN) = $Credential
        $Authsave = @{}
        if ('' -ne $From){
            $Credential = $Global:MGMT_Env.Auth.($From)
        }
        if ($null -eq $Credential) {
            Write-Error -Message "The source credential is not found."
            return
        }
        if ($Scope -eq 'global') {
            return write-error -Message "The global scope is not implemented yet."
        }
        $UserKeyRingFile = "$env:appdata\powershell\MGMT\keyring.yaml"
        $UserShard = Get-MGMTShardFileValue -LiteralPath $UserKeyRingFile -KeyName 'UShard' -KeyLength 32
        [byte[]]$Key = 0..32|ForEach-Object{$UserShard[$_] -bxor $global:MGMT_Env.Shard[$_]}
        foreach ($obj in ($global:MGMT_Env.Auth.GetEnumerator()|Where-Object{$null -ne $_.Value})) {
            $Authsave.($obj.Key) =
                foreach ($CredItem in $obj.Value){
                    @{
                        UserName = $CredItem.UserName
                        Password = $CredItem.Password | ConvertFrom-SecureString -Key $global:MGMT_Env.Key
                    }
                }
            if ($null -eq $_.Value){}
            elseif ($null -eq $_.value.password){}
            else {
                $Authsave.($_.Key) = @{
                    UserName = $_.Value.UserName
                    Password = $_.Value.password | ConvertFrom-SecureString -Key $global:MGMT_Env.Key
                }
            }
        }
        Split-Path $MGMT_Env.AuthFile|Where-Object{! (Test-Path $_)}|ForEach-Object{New-Item -Path $_ -ItemType Directory -Force} | Out-Null
        Export-MGMTYAML -InputObject $Authsave -LiteralPath $MGMT_Env.AuthFile -Encoding utf8
    }
}
Function Save-MGMTConfig {
    [cmdletbinding()]
    param(
        [switch]$Verify,
        [switch]$Force
    )
    process {
        Export-MGMTYAML -InputObject $global:MGMT_Env.config -LiteralPath $script:ConfigFile -Encoding utf8 -Verify:$((!$force))
        $Authsave = @{}
        $global:MGMT_Env.Auth.GetEnumerator()|ForEach-Object{
            if ($null -eq $_.Value){}
            elseif ($null -eq $_.value.password){}
            else {
                $Authsave.($_.Key) = @{
                    UserName = $_.Value.UserName
                    Password = $_.Value.password | ConvertFrom-SecureString -Key $global:MGMT_Env.Key
                }
            }
        }
        Split-Path $MGMT_Env.AuthFile|Where-Object{! (Test-Path $_)}|ForEach-Object{New-Item -Path $_ -ItemType Directory -Force} | Out-Null
        Export-MGMTYAML -InputObject $Authsave -LiteralPath $MGMT_Env.AuthFile -Encoding utf8 -Verify:$Verify
    }
}
function Get-MGMTShardFileValue {
    [cmdletbinding()]
    param (
        [string]$LiteralPath,
        [ArgumentCompleter({
            [OutputType([System.Management.Automation.CompletionResult])]
            param(
                [string] $CommandName,
                [string] $ParameterName,
                [string] $WordToComplete,
                [System.Management.Automation.Language.CommandAst] $CommandAst,
                [System.Collections.IDictionary] $FakeBoundParameters
            )
            if (!(Test-Path $LiteralPath)) {
                return 'file_not_found'
            }
            else {
                $inputObject = (Import-MGMTYAML -LiteralPath $FakeBoundParameters.LiteralPath -ErrorAction Ignore)
                return  $inputObject.Keys| Where-Object { $_ -like "*$WordToComplete*" }
            }
            return  'no_data_found'
        })]
        [string]$KeyName,
        [int]$KeyLength = 32,
        [switch]$Force
    )
    process {
        if ('' -eq $KeyName) {
            return write-error -Message "The key name is required."
        }
        Split-Path $LiteralPath | 
            Where-Object {! (Test-Path $_)} | 
            ForEach-Object {New-Item -Path $_ -ItemType Directory -Force} | 
            Out-Null
        if (!(Test-Path $LiteralPath)) {
            $Data = Set-MGMTDataObject -InputObject $inputObject -Name $KeyName -Value (Get-MGMTRandomBytes -ByteLength $KeyLength) -Passthru
            #Set-SyncHashtable -VariableName InputObject -scope global -Name $KeyName -Value (Get-MGMTRandomBytes -ByteLength $KeyLength)
            Export-MGMTYAML -LiteralPath $LiteralPath -InputObject $Data -Encoding utf8
        }
        else{
            $inputObject = (Import-MGMTYAML -LiteralPath $LiteralPath -ErrorAction Ignore)
        }
        $Data = Get-MGMTDataObject -InputObject $inputObject -Name $KeyName
        if ($null -eq $inputObject.($KeyName)) {
            $Data = Set-MGMTDataObject -InputObject $inputObject -Name $KeyName -Value (Get-MGMTRandomBytes -ByteLength $KeyLength) -Passthru
            #Set-SyncHashtable -VariableName InputObject -scope global -Name $KeyName -Value (Get-MGMTRandomBytes -ByteLength $KeyLength)
            Export-MGMTYAML -LiteralPath $LiteralPath -InputObject $Data -Encoding utf8
        }
        if ($Force -and ($inputObject.($KeyName).length -ne $KeyLength)){
            $Data = Set-MGMTDataObject -InputObject $inputObject -Name $KeyName -Value (Get-MGMTRandomBytes -ByteLength $KeyLength) -Passthru
            #Set-SyncHashtable -VariableName InputObject -scope global -Name $KeyName -Value (Get-MGMTRandomBytes -ByteLength $KeyLength)
            Export-MGMTYAML -LiteralPath $LiteralPath -InputObject $Data -Encoding utf8
        }
        return $inputObject.($KeyName)
    }
}
function Load-MGMTConfig {
    Set-SyncHashtable -VariableName MGMT_Env -scope global
    Set-SyncHashtable -VariableName MGMT_Env -scope global -Name Auth
    $script:ConfigFile      = "$Datafolder\config.yaml"
    $MGMT_Env.AuthFile        = "$env:appdata\powershell\auth.yaml"
    Set-SyncHashtable -VariableName MGMT_Env -scope global -Name config -Value (Get-MGMTConfig)
    if ($null -eq $global:MGMT_Env) {$global:MGMT_Env = [hashtable]::Synchronized(@{})}
    if ($null -eq $global:MGMT_Env.Auth) {$global:MGMT_Env.Auth = [hashtable]::Synchronized(@{})}
    #$global:MGMT_Env.config = Get-MGMTConfig
    [byte[]]$Shard = 0,11,159,136,217,167,1,185,196,169,243,35,234,88,147,217,223,229,80,38,100,181,255,250,223,177,45,128,109,107,253,110
    # Define the credentials for each site hosts.
    if ($null -eq $global:MGMT_Env.config.Shard) {
        $global:MGMT_Env.config.Shard = [int[]](get-randonbytes -ByteLength 32)
    }
    $global:MGMT_Env.Key = 0..31|ForEach-Object{$global:MGMT_Env.config.Shard[$_] -bxor $shard[$_]}
    $Authsave = Import-MGMTYAML -LiteralPath $MGMT_Env.AuthFile -ErrorAction SilentlyContinue
    foreach ($obj in $Authsave.GetEnumerator()){
        $global:MGMT_Env.Auth.($obj.Name) = 
            New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList @(
                $obj.Value.UserName,
                ($obj.Value.Password | ConvertTo-SecureString -Key $global:MGMT_Env.Key)
            )
    }
    foreach ($FQDN in ($Global:MGMT_Env.config.sites.values.values.fqdn|Where-Object{$_ -match '\w'}))
    {
        $Cred = $Global:MGMT_Env.Auth.($FQDN)
        if ($null -eq $Cred) {
            
            $Cred = Get-Credential -Message "Enter the credentials for $FQDN"
            $Global:MGMT_Env.Auth.($FQDN) = $Cred
        }
    }
}
function Add-MGMTConfig {
    [cmdletbinding()]
    param (
        [ArgumentCompleter({
            [OutputType([System.Management.Automation.CompletionResult])]
            param(
                [string] $CommandName,
                [string] $ParameterName,
                [string] $WordToComplete,
                [System.Management.Automation.Language.CommandAst] $CommandAst,
                [System.Collections.IDictionary] $FakeBoundParameters
            )
            return (Get-MGMTHashtableKeys -Hashtable $global:MGMT_Env.config | 
                Where-Object { $_ -like "*$WordToComplete*" }
            ) -replace '^(.*)','config.$1'
        })]
        [string]$ConfigPath
    )
    process {
        $Global:MGMT_Env.config = $Global:MGMT_Env.config + $OptionalParameters
    }
}
function Get-MGMTHashtableKeys {
    param(
        [hashtable]$Hashtable,
        [string]$ParentKey = ''
    )
    if ($null -eq $Hashtable) {
        return Write-Error -Message "The input object is not a hashtable."
    }
    foreach ($key in $Hashtable.Keys) {
        $value = $Hashtable[$key]
        $newKey = if ($ParentKey) { "$ParentKey.$key" } else { $key }

        if ($value -is [hashtable]) {
            Get-MGMTHashtableKeys -Hashtable $value -ParentKey $newKey
        } else {
            $newKey
        }
    }
}

function Add-MGMTSSHHostKey {
    param (
        [string]$HostName,
        [string]$KeyFilePath
    )
    [string]$HostKey = ssh-keyscan -t rsa $HostName
    if ('' -eq $HostKey) {
        Write-Error "Failed to retrieve the SSH host key for $HostName"
        break
    }
    [string[]]$Match = Get-Content "$env:USERPROFILE\.ssh\known_hosts" | Where-Object{$_ -eq $HostKey}
    if ($Match.count -eq 0) {
        Write-Host "Adding the SSH host key for $HostName to the known_hosts file"
        Add-Content -Path "$env:USERPROFILE\.ssh\known_hosts" -Value $HostKey
    }
    else {
        Write-host "The SSH host key for $HostName is already in the known_hosts file."
    }
}

Function Merge-MGMTByteArray {
    param (
      [byte[]]$ByteArray1,
      [byte[]]$ByteArray2,
      [int]$Length = ($ByteArray1.Length),
      [ArgumentCompleter({
        [OutputType([System.Management.Automation.CompletionResult])]
        param(
          [string] $CommandName,
          [string] $ParameterName,
          [string] $WordToComplete,
          [System.Management.Automation.Language.CommandAst] $CommandAst,
          [System.Collections.IDictionary] $FakeBoundParameters
        )
        return 'bxor' | Where-Object {$_ -like "$WordToComplete*"}
      })]
      [string]$operation = 'bxor'
    )
    [byte[]]$Key = 0..32|ForEach-Object{$ByteArray1[$_] -bxor $ByteArray2[$_]}
}
