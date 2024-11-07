provider "aws" {
  region = "us-east-2" # Change to your desired AWS region
}

# Step 1: Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "11.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}

# Step 2: Create a Public Subnet
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "11.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-2a" # Choose an availability zone in your region
  tags = {
    Name = "my-subnet"
  }
}

# Step 3: Create an Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-igw"
  }
}

# Step 4: Create a Route Table and associate it with the Subnet
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-route-table"
  }
}

# Route for Internet access
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.my_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.my_igw.id
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "subnet_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

# Output values
output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_id" {
  value = aws_subnet.my_subnet.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.my_igw.id
}

output "route_table_id" {
  value = aws_route_table.my_route_table.id
}
