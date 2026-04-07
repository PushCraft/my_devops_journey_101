# VPC
resource "aws_vpc" "basicVpc" {
   cidr_block = var.vpcCidr
   enable_dns_hostnames = true
   tags = {
    "source" = var.tag1
   }
}

# IGW
resource "aws_internet_gateway" "DemoBasicIGW" {
  vpc_id = aws_vpc.basicVpc.id
  depends_on = [ aws_vpc.basicVpc ]
}