provider "aws" {
  # 
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "vpcDemo" {
    cidr_block = "10.0.0.0/16"
    tags = {Name = "My-Custom-VPC-01"}
    
}

# IGW
resource "aws_internet_gateway" "IGW" {
    vpc_id = aws_vpc.vpcDemo.id
}


# Subnet 
resource "aws_subnet" "subnet1" {
    vpc_id = aws_vpc.vpcDemo.id
    cidr_block = "10.0.1.0/24"
    tags = {Name = "Subnet -1 "}
}

