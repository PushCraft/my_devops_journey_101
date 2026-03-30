# Create VPC
resource "aws_vpc" "basicvpc" {
  cidr_block           = "10.200.0.0/16" # 65K IP's
  enable_dns_hostnames = true
  tags = {
    "source" = "Terraform-Learning."
  }
}