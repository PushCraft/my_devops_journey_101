
resource "aws_security_group" "name" {
   vpc_id = aws_vpc.basicvpc.id
    tags = {
      "Source" = var.source-tag
    }
}