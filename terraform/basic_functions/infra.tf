resource "aws_vpc" "basicVpc" {
   cidr_block = var.vpcCidr
   enable_dns_hostnames = true
   tags = {
    "source" = var.tag1
   }
}
