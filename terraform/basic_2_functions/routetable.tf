# Route Table create. ( Public )
resource "aws_route_table" "publicRTB" {
  vpc_id = aws_vpc.DemoBasicVpc.id

  tags = {
      Name     = "${var.Pushing_from} -Public"
  }
  route {
    gateway_id = aws_internet_gateway.DemoBasicIGW.id
    cidr_block = "0.0.0.0/0"
  }
}

# Associate the Public-RTB with specific subnets. 
resource "aws_route_table_association" "PublicSubnetRTBAssociation" {
  route_table_id = aws_route_table.publicRTB.id
  count          = length(var.publicSubnetCidr)

  subnet_id = element(aws_subnet.PublicSubnet_functions.*.id, count.index)
  # This will provide all the subnet ID's ( like a for loop )
}


# Route table create ( Private )
resource "aws_route_table" "privateRTB" {
  vpc_id = aws_vpc.DemoBasicVpc.id
  # route => Not defined.

  tags = {
      Name     = "${var.Pushing_from} -Private"
  }
}


# Associate the Private-RTB with specific subnets. 

resource "aws_route_table_association" "PrivateSubnetRTBAssociate" {
  route_table_id = aws_route_table.privateRTB.id
  count          = length(var.privateSubnetCidr)
  subnet_id      = element(aws_subnet.PrivateSubnet_function.*.id, count.index)
   # aws_subnet.PrivateSubnet_function.*.id

}

/*
Public Route Table:
Add 0.0.0.0/0 as destination and Internet Gateway as target.
This gives the subnet a direct path to/from the internet.

Private Route Table:
AWS automatically adds the local VPC route, for example 10.0.0.0/16 → local.
I do not need to define this manually.
If the private subnet needs outbound internet access, add 0.0.0.0/0 → NAT Gateway.
Do not add 0.0.0.0/0 → IGW to a private route table.

Interview tip => 
Every AWS route table automatically has a local route for the VPC CIDR
, so I do not manually add routes for internal VPC communication. For a private subnet, I only add a default route to a NAT Gateway if the subnet needs outbound internet access. 
I avoid routing private subnets directly to an Internet Gateway.
*/