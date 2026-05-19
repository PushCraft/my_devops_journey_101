# Create Route Table
resource "aws_route_table" "RTB" {
  vpc_id = aws_vpc.vpc_demo.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_demo.id
  }
  depends_on = [aws_subnet.public-subnet-demo]
}


# Associate route table.
resource "aws_route_table_association" "public_assoc" {
  # depends_on = [ aws_route_table.RTB ]
  route_table_id = aws_route_table.RTB.id
  count          = length(var.subnet_az_list)
  # The below line needs understanding
  subnet_id = element(aws_subnet.public-subnet-demo[*].id, count.index)

}
