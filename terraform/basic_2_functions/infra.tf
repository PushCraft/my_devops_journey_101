# Provider
provider "aws" {
  region = var.region
}

# VPC create.
resource "aws_vpc" "DemoBasicVpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    "source" = var.tagX
    Name     = var.Pushing_from
  }
}

# IGW create. 
resource "aws_internet_gateway" "DemoBasicIGW" {
  vpc_id = aws_vpc.DemoBasicVpc.id
  tags = {
    "source" = var.tagX
  }
  depends_on = [aws_vpc.DemoBasicVpc]
}







