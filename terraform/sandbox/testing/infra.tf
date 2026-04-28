provider "aws" {
  # 
  region = "ca-central-1"
}

#VPC
resource "aws_vpc" "demoVPc" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "VsCode > Testing > VPC-1 "
  }
}

# Subnet-1
resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.demoVPc.id
    cidr_block = "10.1.1.0/24"
    tags = {Name = "VsCode > Testing > Subnet-1"}
}
