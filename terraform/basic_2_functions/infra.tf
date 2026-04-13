# VPC create.
resource "aws_vpc" "DemoBasicVpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    "source" = var.tagX
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

# Route Table.
resource "aws_route_table" "PublicRTB" {
    vpc_id = aws_vpc.DemoBasicVpc.id
    tags = {
        "source" = var.tagX
    }
    route {
        gateway_id = aws_internet_gateway.DemoBasicIGW.id
        cidr_block = "0.0.0.0/0"
    }
}
