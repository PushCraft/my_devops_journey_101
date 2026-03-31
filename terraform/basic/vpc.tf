# Create VPC
resource "aws_vpc" "basicvpc" {
  cidr_block           = var.vpc_cidr # 65K IP's
  enable_dns_hostnames = true
  tags = {
    "Source" = var.source-tag
  }
}