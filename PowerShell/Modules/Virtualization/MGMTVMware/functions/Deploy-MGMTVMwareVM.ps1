function Deploy-MGMTVMwareVM {
    [cmdletbinding()]
    param(
        [string]$VMName,
        [string]$VMHost,
        [string]$VMDatastore,
        [string]$VMNetwork = 'VM Network',
        [string]$VMTemplate,
        [string]$ISOFileName,
        [string[]]$SourceFileFolder = '~/Downloads',
        [int]$VMCpuCount = 2,
        [int]$VMRamSizeGB = 4,
        [int]$VMHDDSizeGB = 32,
        [string]$VMHDDType = 'Thin',
        [string]$VMHDDStorageFormat = 'Thin',
        #[string]$VMHDDStorageType = 'SSD',
        $HostName = $VMName,
        $DomainName = 'local',
        [string]$IPAddress,
        [string]$Subnet,
        [string]$Gateway,
        [string[]]$DNSServer,
        [string]$VLAN,
        [validateset('Linux','Windows','MacOS','Solaris','FreeBSD','VMware ESXi')]
        [string]$OS = 'Linux',
        $OSCustomizationSpec,
        [switch]$NestedVirtualization
    )
    Remove-Module hyper-v -force -erroraction Ignore
    $VM = Get-VM -Name $VMName -ErrorAction Ignore
    if ($null -eq $VM) {
        if ('' -eq $VMDatastore) {
            $VMwareVMDatastore = Get-Datastore | Sort-Object FreeSpaceGB -Descending | Select-Object -First 1
            $VMDatastore = $VMwareVMDatastore.Name
        }
        else {
            $VMwareVMDatastore = Get-Datastore -Name $VMDatastore
            if ($null -eq $VMwareVMDatastore) {
                return Write-Error -Message "The datastore '$VMDatastore' does not exist on the VMware host '$VMHost'."
            }
        }
        $VMwareISODatastore = Get-Datastore | Where-Object{Get-ChildItem $_.DatastoreBrowserPath -filter iso*} | Sort-Object FreeSpaceGB -Descending | Select-Object -First 1
        $VMwareIsoFolderPath = $VMwareISODatastore.DatastoreBrowserPath
        $VMwareISOFolders = Get-ChildItem 'vmstore:'  | Get-ChildItem | Get-ChildItem | Where-Object {$_.Name -match '^isos{0,1}$'}
        $VMwareIsoFiles = $VMwareISOFolders | Get-ChildItem -Filter *.iso
        $SelectedISO = $VMwareIsoFiles | Where-Object {$_.Name -eq $LinuxISOFIleName}
        if ($null -eq $SelectedISO) {
            $inDownloads = Test-Path "~\Downloads\$ISOFileName"
            $LocalIsoFile = $SourceFileFolder | 
                                Get-ChildItem -Filter *.iso | 
                                Sort-Object LastWriteTime -Descending | 
                                Where-Object {$_.Name -like $ISOFileName}|
                                Select-Object -First 1
            if ($inDownloads) {
                Copy-DatastoreItem -Item $LocalIsoFile.FullName -Destination $VMwareIsoFolderPath
            }
        }
        If ($null -eq $OSCustomizationSpec) {
            switch($OS) {
                'Windows' {
                    $OSCustomizationSpec = New-OSCustomizationSpec -FullName windows -OrgName new -OSType Windows -Type Persistent -DnsServer $DNSServer -Name $HostName -DnsSuffix $Domain -ChangeSid:$true -DeleteAccounts:$false -Server $null -AdminPasswod '34syP@$$' -Confirm:$false -Verbose
                }
                'Linux' {
                    $OSCustomizationSpec = New-OSCustomizationSpec -FullName linux -OrgName new -OSType Linux -Type Persistent -DnsServer $DNSServer -Name $HostName -DnsSuffix $Domain -ChangeSid:$false -DeleteAccounts:$false -Server $null -AdminPasswod '34syP@$$' -Confirm:$false -Verbose
                }
            }
        }
        $VMDeploymentParameters = @{
            Name                = $VMName
            VMHost              = $VMHost
            Datastore           = $VMDatastore
            DiskGB              = $VMHDDSizeGB
            MemoryGB            = $VMRamSizeGB
            NumCpu              = $VMCpuCount
            NetworkName         = $VMNetwork
            Template            = $VMTemplate
            OSCustomizationSpec = $OSCustomizationSpec

        }
        # Remove null values from the hashtable
        $VMDeploymentParameters.Keys|Where-Object{$null -eq $VMDeploymentParameters.($_)} | ForEach-Object{ $VMDeploymentParameters.Remove($_)}
        $VM = New-VM  -Confirm:$false @VMDeploymentParameters -Verbose
    }
}