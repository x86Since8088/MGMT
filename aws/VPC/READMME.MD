# Scripts to create AWS internal and external VPCs

## In Powershell

This script uses AWS Tools for PowerShell. Make sure you have the module installed and configured with the appropriate AWS credentials.

### Import the AWS module

Import-Module AWSPowerShell

### Set the AWS region

$region = 'us-east-1'
Set-DefaultAWSRegion -Region $region

### Create Internal VPC

$internalCidrBlock = '10.0.0.0/16'
$internalVpc = New-EC2Vpc -CidrBlock $internalCidrBlock
Write-Host "Created Internal VPC with ID $($internalVpc.VpcId)"

### Create External VPC

$externalCidrBlock = '10.1.0.0/16'
$externalVpc = New-EC2Vpc -CidrBlock $externalCidrBlock
Write-Host "Created External VPC with ID $($externalVpc.VpcId)"

### Create an Internet Gateway (IGW) for the External VPC

$internetGateway = New-EC2InternetGateway
Write-Host "Created Internet Gateway with ID $($internetGateway.InternetGatewayId)"

### Attach the Internet Gateway to the External VPC

Add-EC2InternetGateway -InternetGatewayId $internetGateway.InternetGatewayId -VpcId $externalVpc.VpcId
Write-Host "Attached Internet Gateway to External VPC"

### Create a Public Route Table for the External VPC

$publicRouteTable = New-EC2RouteTable -VpcId $externalVpc.VpcId
Write-Host "Created Public Route Table with ID $($publicRouteTable.RouteTableId)"

### Add a Route to the Public Route Table

New-EC2Route -RouteTableId $publicRouteTable.RouteTableId -DestinationCidrBlock '0.0.0.0/0' -GatewayId $internetGateway.InternetGatewayId
Write-Host "Added Route to Public Route Table"
Please note:

You need to have the appropriate permissions and roles in your AWS account to execute these commands.
This is just a basic example, and it doesn't handle all possible configurations, subnetting, security settings, etc. Please adjust as needed for your specific use case.

## The same script in Python

You can use the Boto3 library in Python to achieve the same functionality. Below is a script that will create both internal and external VPCs, with the external VPC having an attached Internet Gateway.

python
Copy code
import boto3

### Python: Set AWS region

region = 'us-east-1'

### Python: Create a session using your AWS credentials

session = boto3.Session(region_name=region)

### Python: Create an EC2 resource object

ec2 = session.resource('ec2')

### Python: Create Internal VPC

internal_cidr_block = '10.0.0.0/16'
internal_vpc = ec2.create_vpc(CidrBlock=internal_cidr_block)
print("Created Internal VPC with ID", internal_vpc.id)

### Python: Create External VPC

external_cidr_block = '10.1.0.0/16'
external_vpc = ec2.create_vpc(CidrBlock=external_cidr_block)
print("Created External VPC with ID", external_vpc.id)

### Python: Create an Internet Gateway

internet_gateway = ec2.create_internet_gateway()
print("Created Internet Gateway with ID", internet_gateway.id)

### Python: Attach the Internet Gateway to the External VPC

external_vpc.attach_internet_gateway(InternetGatewayId=internet_gateway.id)
print("Attached Internet Gateway to External VPC")

### Python: Create a Public Route Table for the External VPC

public_route_table = external_vpc.create_route_table()
print("Created Public Route Table with ID", public_route_table.id)

### Python: Create a Route to allow all traffic through the Internet Gateway

public_route_table.create_route(
    DestinationCidrBlock='0.0.0.0/0',
    GatewayId=internet_gateway.id
)
print("Added Route to Public Route Table")
Make sure that the Boto3 library is installed in your environment, and the AWS credentials are configured properly to authenticate with your AWS account.

This script provides a very basic setup. In a real-world scenario, you would likely want to add more details such as subnets, security groups, and other configurations tailored to your specific needs.
