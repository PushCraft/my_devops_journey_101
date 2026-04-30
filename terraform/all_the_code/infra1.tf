provider "aws" {
  region = "ca-central-1"
}

# VPC
resource "aws_vpc" "vpcDemo" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "My-Custom-VPC-01" }

}

# IGW
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpcDemo.id
}


# Subnet 
resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.vpcDemo.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ca-central-1a"
  tags = {
    Name = "Subnet > Custom > 1"
  }
}

# Security group 
resource "aws_security_group" "sg01" {
  vpc_id      = aws_vpc.vpcDemo.id
  name        = "SG  Custom  X"
  description = "Allow X access."
  lifecycle {
    ignore_changes = [tags]
  }
}

# Security group > Rule 1
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.sg01.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 22
  to_port           = 22
}

# Security group > Rule 2
resource "aws_vpc_security_group_ingress_rule" "allow_all" {
  security_group_id = aws_security_group.sg01.id
  referenced_security_group_id = aws_security_group.sg01.id
  ip_protocol       = "-1"
}