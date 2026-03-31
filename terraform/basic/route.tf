resource "aws_route_table" "DemobasicPublic_RTB" {
  vpc_id = aws_vpc.basicvpc.id
  tags = {
    "source" = var.source-tag
  }
  route {
    gateway_id = aws_internet_gateway.basic_igw.id
    cidr_block = "0.0.0.0/0"
  }
}