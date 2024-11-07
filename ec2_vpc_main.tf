# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # Update to your preferred region
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "My-VPC"
  }
}

# Create a subnet
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Update based on your region
  tags = {
    Name = "My-Subnet"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "My-Internet-Gateway"
  }
}

# Create a Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "My-Route-Table"
  }
}

# Add a route to the Internet Gateway in the Route Table
resource "aws_route" "internet_route" {
  route_table_id         = aws_route_table.my_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Associate the Subnet with the Route Table
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Create a VPN Gateway
resource "aws_vpn_gateway" "my_vpn_gw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "My-VPN-Gateway"
  }
}

# Create an EC2 instance with an existing Key Pair
resource "aws_instance" "my_instance" {
  ami           = "ami-0866a3c8686eaeeba" # Replace with your preferred AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id
  key_name      = "New-KP" # Use the existing Key Pair

  tags = {
    Name = "My-EC2-Instance"
  }
}

