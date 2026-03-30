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


    	# Create subnet - 1
	resource "aws_subnet" "basic_subnet2" {
	  vpc_id            = aws_vpc.basicvpc.id
	  cidr_block        = "10.200.2.0/24"          # 256 IP's
	  availability_zone = "ca-central-1b"
	  map_public_ip_on_launch = true
	  tags = {
	    "source" = "Terraform-Learning"
	  }
	}