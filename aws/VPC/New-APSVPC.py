import boto3

# Set AWS region
region = 'us-east-1'

# Create a session using your AWS credentials
session = boto3.Session(region_name=region)

# Create an EC2 resource object
ec2 = session.resource('ec2')

# Create Internal VPC
internal_cidr_block = '10.0.0.0/16'
internal_vpc = ec2.create_vpc(CidrBlock=internal_cidr_block)
print("Created Internal VPC with ID", internal_vpc.id)

# Create External VPC
external_cidr_block = '10.1.0.0/16'
external_vpc = ec2.create_vpc(CidrBlock=external_cidr_block)
print("Created External VPC with ID", external_vpc.id)

# Create an Internet Gateway
internet_gateway = ec2.create_internet_gateway()
print("Created Internet Gateway with ID", internet_gateway.id)

# Attach the Internet Gateway to the External VPC
external_vpc.attach_internet_gateway(InternetGatewayId=internet_gateway.id)
print("Attached Internet Gateway to External VPC")

# Create a Public Route Table for the External VPC
public_route_table = external_vpc.create_route_table()
print("Created Public Route Table with ID", public_route_table.id)

# Create a Route to allow all traffic through the Internet Gateway
public_route_table.create_route(
    DestinationCidrBlock='0.0.0.0/0',
    GatewayId=internet_gateway.id
)
print("Added Route to Public Route Table")

# Create a Public Subnet for the External VPC
public_subnet = ec2.create_subnet(
    CidrBlock='',
    VpcId=external_vpc.id,
    AvailabilityZone='us-east-1a'
)
print("Created Public Subnet with ID", public_subnet.id)
