	provider "aws" {
	  region = "ca-central-1"
	}
	
	# Create VPC
	resource "aws_vpc" "basicvpc" {
	  cidr_block           = "10.200.0.0/16"           # 65K IP's
	  enable_dns_hostnames = true
	  tags = {
	    "source" = "Terraform-Learning."
	  }
	}
	
	#  Create IGW
	resource "aws_internet_gateway" "basic_igw" {
	  vpc_id = aws_vpc.basicvpc.id
	  tags = {
	    "source" = "Terraform-Learning"
	  }
	}
	
	# Create subnet - 1
	resource "aws_subnet" "basic_subnet1" {
	  vpc_id            = aws_vpc.basicvpc.id
	  cidr_block        = "10.200.1.0/24"          # 256 IP's
	  availability_zone = "ca-central-1a"
	  map_public_ip_on_launch = true
	  tags = {
	    "source" = "Terraform-Learning"
	  }
	}
