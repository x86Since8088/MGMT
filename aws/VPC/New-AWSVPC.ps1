# Import the AWS module
Import-Module AWSPowerShell

# Set the AWS region
$region = 'us-east-1'
Set-DefaultAWSRegion -Region $region

# Create Internal VPC
$internalCidrBlock = '10.0.0.0/16'
$internalVpc = New-EC2Vpc -CidrBlock $internalCidrBlock
Write-Host "Created Internal VPC with ID $($internalVpc.VpcId)"

# Create External VPC
$externalCidrBlock = '10.1.0.0/16'
$externalVpc = New-EC2Vpc -CidrBlock $externalCidrBlock
Write-Host "Created External VPC with ID $($externalVpc.VpcId)"

# Create an Internet Gateway (IGW) for the External VPC
$internetGateway = New-EC2InternetGateway
Write-Host "Created Internet Gateway with ID $($internetGateway.InternetGatewayId)"

# Attach the Internet Gateway to the External VPC
Add-EC2InternetGateway -InternetGatewayId $internetGateway.InternetGatewayId -VpcId $externalVpc.VpcId
Write-Host "Attached Internet Gateway to External VPC"

# Create a Public Route Table for the External VPC
$publicRouteTable = New-EC2RouteTable -VpcId $externalVpc.VpcId
Write-Host "Created Public Route Table with ID $($publicRouteTable.RouteTableId)"

# Add a Route to the Public Route Table
New-EC2Route -RouteTableId $publicRouteTable.RouteTableId -DestinationCidrBlock '0.0.0.0/0' -GatewayId $internetGateway.InternetGatewayId
Write-Host "Added Route to Public Route Table"