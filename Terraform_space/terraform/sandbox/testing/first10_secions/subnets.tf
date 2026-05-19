# Subnet  > Private
resource "aws_subnet" "private-subnet-Demo" {
  vpc_id = aws_vpc.vpc_demo.id
  count  = length(var.subnet_az_list)

  cidr_block        = element(var.subnet_private_cidr_list, count.index)
  availability_zone = element(var.subnet_az_list, count.index)
  tags = {
    Name = "Private -> ${var.tagSource}"
  }
  map_public_ip_on_launch = false
}


resource "aws_subnet" "public-subnet-demo" {
  vpc_id                  = aws_vpc.vpc_demo.id
  count                   = length(var.subnet_az_list)
  availability_zone       = element(var.subnet_az_list, count.index)
  cidr_block              = element(var.subnet_public_cidr_list, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Public  -> ${var.tagSource}"
  }
}
