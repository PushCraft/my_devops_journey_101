## Need to study this page.

resource "aws_route_table" "DemobasicPublic_RTB" {
  vpc_id = aws_vpc.basicvpc.id
  tags = {
      "Source" = var.source-tag
  }
  route {
    gateway_id = aws_internet_gateway.basic_igw.id
    cidr_block = "0.0.0.0/0"
  }
}


resource "aws_route_table_association" "DemoRouteAssociation-1" {
  route_table_id = aws_route_table.DemobasicPublic_RTB.id
  subnet_id      = aws_subnet.basic_subnet1.id
}

resource "aws_route_table_association" "DemoRouteAssociation-2" {
  route_table_id = aws_route_table.DemobasicPublic_RTB.id
  subnet_id      = aws_subnet.basic_subnet2.id
}