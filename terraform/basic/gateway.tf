#  Create IGW
resource "aws_internet_gateway" "basic_igw" {
  vpc_id = aws_vpc.basicvpc.id
  tags = {
    "source" = "Terraform-Learning"
  }
}