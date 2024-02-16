param (
    # Define the MSI installer path
    $msiPath = (Get-ChildItem ~\downloads\*splunkfor*.msi|Sort-Object LastWriteTime -Descending|Select-Object -First 1).FullName,
    # Define the Splunk server
    $splunkServer = (read-host -Prompt "Enter the Splunk server")
)

# Install the Universal Forwarder
Start-Process 'msiexec.exe' -ArgumentList "/i $msiPath AGREETOLICENSE=Yes /quiet" -Wait

# Set the deployment server
& 'C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe' set deploy-poll $splunkServer:8089 -auth admin:changeme

# Enable the receiver
& 'C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe' enable listen 9997 -auth admin:changeme

# Restart the Splunk service
Restart-Service -Name SplunkForwarder
