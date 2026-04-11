# VPC
resource "aws_vpc" "DemoBasicVPC" {
  cidr_block           = var.vpcCidr
  enable_dns_hostnames = true
  tags = {
    "source" = var.tag1
  }
}

# IGW
resource "aws_internet_gateway" "DemoBasicIGW" {
  vpc_id = aws_vpc.DemoBasicVPC
  tags = {
    "source" = var.tag1
  }
}


# Subnets ------------
resource "aws_subnet" "subnet-1" {
  vpc_id = var.vpcCidr

  cidr_block        = var.cidrSubnet1
  availability_zone = var.az1

}