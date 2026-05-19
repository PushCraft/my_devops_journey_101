# Provider.
provider "aws" {
  region = "ca-central-1"
}

/*
terraform {
  backend "s3" {
     bucket = "terraform-state-file-bucketxyzz"
     key = "data-here"
     region = "ca-central-1"
  }
}
*/

# VPC.
resource "aws_vpc" "vpc_demo" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.tagSource
  }
}

# IGW 
resource "aws_internet_gateway" "igw_demo" {
  vpc_id = aws_vpc.vpc_demo.id
  tags = {
    Name = var.tagSource
  }
}

# Bucket 
/*
resource "aws_s3_bucket" "s3_bucket_demo" {
    bucket = "terraform-state-file-bucketxyzz"  

 }
*/

# SG 
resource "aws_security_group" "security-group-01" {
  vpc_id = aws_vpc.vpc_demo.id
  name   = "Custom SG-X"
  tags = {
    Name = var.tagSource
  }
}

resource "aws_vpc_security_group_ingress_rule" "allowSSHipv4" {
  security_group_id = aws_security_group.security-group-01.id
  to_port           = "22"
  from_port         = "22"
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  tags = {
    Name = "${var.tagSource} + > Rule"
  }
}
         
resource "aws_vpc_security_group_egress_rule" "allowAlloutbound" {
    security_group_id = aws_security_group.security-group-01.id
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"

}

resource "aws_vpc_security_group_ingress_rule" "allowHttp" {
  security_group_id = aws_security_group.security-group-01.id
  to_port           = "80"
  from_port         = "80"
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  tags = {
    Name = "${var.tagSource} + > Rule"
  }
}

