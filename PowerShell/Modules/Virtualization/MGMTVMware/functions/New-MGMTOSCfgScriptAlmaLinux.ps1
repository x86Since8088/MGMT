function New-MGMTOSCfgScriptAlmaLinux {
	[CmdletBinding()]
	param (
		[string]$HostName,
		[string]$Domain,
		[string]$IPAddressAndCIDR,
		[string[]]$DNSServer,
		[string]$Gateway,
		[string]$MacAddress,
		[switch]$ApplyToVM,
		[string]$VMwareServer,
		[pscredential]$VMwareCredential,
		[string]$VMName = $HostName,
		[pscredential]$GuestCredential
	)

	if ($IPAddressAndCIDR -notmatch '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/\d{1,2}') {
		Write-Error -Message "#The IP address $IPAddress is not valid."
		return
	}
	$IPAddress = $IPAddressAndCIDR -replace '/.*'

	if ($VMwareServer -match '\w' -and $VMwareCredential -match '\w') {
		$null =	Connect-VIServer -Server $VMwareServer -Credential $VMwareCredential -Force
	}
	if ($VMName -match '\w') {
		$VM = Get-VM -Name $VMName
		$NetworkAdapter = Get-NetworkAdapter -VM $VM
		[string]$VMMacAddress = $NetworkAdapter.MacAddress | Select-Object -First 1
	}
	$MacAddress = $MacAddress -replace '-',':'
	if ($MacAddress -notmatch '\w\w:\w\w:\w\w:\w\w:\w\w:\w\w') {
		Write-Host -Message "#The -MACAddress $MacAddress is not valid." -ForegroundColor yellow
		if ($VMMacAddress -match '\w\w:\w\w:\w\w:\w\w:\w\w:\w\w') {
			Write-Host -Message "#Using the MAC address of the VM: $VMMacAddress as -MacAddress."
			$MacAddress = $VMMacAddress
		}
		else {
			Write-Error -Message "#The MAC address is not valid."
			return
		}
	}
	if ($ApplyToVM) {
		if ($null -eq $GuestCredential) {
			Write-Error -Message "# -ApplyToVM was provided and the -GuestCredential is required when -ApplyToVM is specified."
			return
		}
		if ($null -eq $VM) {
			Write-Error -Message "# -ApplyToVM was provided and the VM for -VMName '$VMName' was not found.  Check -VMWareServer and -VMwareCredential."
			return
		}
		[bool]$Execute = $true
	}
	else {
		[bool]$Execute = $false
	}
	[string[]]$Script = @()

	if (Test-Connection -count 1 -computername $IPAddress -TimeoutSeconds 1 -quiet) {
		Write-Host -Message "#The IP address $IPAddress is already in use." -ForegroundColor yellow
	}
	foreach ($DNSServerItem in ($DNSServer -split ',')) {
		if (Test-Connection -count 1 -computername $DNSServerItem -TimeoutSeconds 1 -quiet) {
			Write-Host -Message "#The DNS server $DNSServerItem reachable."
		}
		else {
			Write-Host -Message "#The DNS server $DNSServerItem is not reachable." -ForegroundColor yellow
		}
	}

	$DNSServer = $DNSServer -join ','

	if ($HostName -match '\w') {
		$ScriptItem = "hostnamectl set-hostname $HostName"
		$ScriptItem = "echo '''`n$ScriptItem`n'''`n$ScriptItem"
		if ($Execute) {
			Invoke-VMScript -VM $VM -ScriptText $ScriptItem -GuestCredential $GuestCredential -ScriptType Bash -Verbose
		}
		else{
			$Script += $ScriptItem
		}
	}
	if ($Domain -match '\w') {
		#Remove the specified domain from the search list to prevent duplicates
		$DomainRegexEscaped = '\b' + [regex]::Escape($Domain) + '\b'
		$ScriptItem = @"
			sed -i '/$DomainRegexEscaped/d' /etc/resolv.conf"
			echo 'search $Domain' >> /etc/resolv.conf
"@
		$ScriptItem = "echo '''`n$ScriptItem`n'''`n$ScriptItem"
		if ($Execute) {
			Invoke-VMScript -VM $VM -ScriptText $ScriptItem -GuestCredential $GuestCredential -ScriptType Bash -Verbose
		}
		else{
			$Script += $ScriptItem
		}
	}
	$Script += @"
# The MAC address of the Ethernet device we're looking for
TARGET_MAC="$MacAddress"

# The new IP address you want to assign to this device
NEW_IP="$IPAddressAndCIDR"

# The default gateway IP address
GATEWAY_IP="$Gateway"

# The DNS IP address
DNSServer="$DNSServer"

"@

	$Script += @'
# Find the device name based on the MAC address
DEVICE_NAME=$(nmcli -t -f DEVICE,TYPE,STATE,CON-PATH device | awk -F':' '$2=="ethernet" && $3=="connected"{print $1}' | while read dev; do
  if nmcli -t -f GENERAL.HWADDR dev show $dev | grep -qi "$TARGET_MAC"; then
    echo "Dev: $dev"
    break
  fi
done)

if [ -z "$DEVICE_NAME" ]; then
  echo "Ethernet device with MAC $TARGET_MAC not found."
  exit 1
fi

# Find the connection name associated with the device
CONNECTION_NAME=$(nmcli -t -f GENERAL.CONNECTION device show "$DEVICE_NAME" | cut -d':' -f2)

if [ -z "$CONNECTION_NAME" ]; then
  echo "No active connection found for device $DEVICE_NAME."
  exit 1
fi

# Clear existing IP addresses for the adapter
nmcli con mod "$CONNECTION_NAME" ipv4.addresses ""

# Set the new IP address
nmcli con mod "$CONNECTION_NAME" ipv4.addresses "$NEW_IP" ipv4.gateway "$GATEWAY_IP" ipv4.method manual

# If needed, set DNS servers
# nmcli con mod "$CONNECTION_NAME" ipv4.dns "$DNSServer"

# Reload the connection to apply changes
nmcli con down "$CONNECTION_NAME" && nmcli con up "$CONNECTION_NAME"

echo "IP address for $DEVICE_NAME has been set to $NEW_IP."

'@
	if ($Execute) {
		[string]$scriptText = ($Script -split '\r*\n' -join "`r`n")
		$ScriptItem = "echo '''`n$scriptText`n'''`n$scriptText"
		Invoke-VMScript -VM $VM -ScriptText $ScriptItem -GuestCredential $GuestCredential -ScriptType Bash -Verbose
	}
	else {
		return $Script -join "`r`n"
	}
}