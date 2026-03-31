# Create subnet - 1
resource "aws_subnet" "basic_subnet1" {
  vpc_id                  = aws_vpc.basicvpc.id
  cidr_block              = var.Public_subnet_1_Cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = true
  tags = {
    "source" = var.source-tag
  }
}


# Create subnet - 1
resource "aws_subnet" "basic_subnet2" {
  vpc_id                  = aws_vpc.basicvpc.id
  cidr_block              =  var.Publid_subnet_2_Cidr
  availability_zone       = var.az2
  map_public_ip_on_launch = true
  tags = {
    "source" = var.source-tag
  }
}