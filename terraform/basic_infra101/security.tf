resource "aws_security_group" "securitygroup-01" {
  vpc_id      = aws_vpc.basicvpc.id
  name        = "websecurity" # Name of the SG.
  description = "Allow X access."
  tags = {
    "Source" = var.source-tag
  }
  lifecycle {
    ignore_changes = [ tags ] # Terraform will ignore the manual 'tags' you add from AWS console.
    create_before_destroy = true    # This will create the infra first and then destroy it.
  }
}

# “Allow anyone on the internet to SSH into my instance”
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4" {
  security_group_id = aws_security_group.securitygroup-01.id
  cidr_ipv4         = "0.0.0.0/0" # Anyone from internet can connect.  
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

lifecycle {
  create_before_destroy = true
}

}

resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4" {
  security_group_id = aws_security_group.securitygroup-01.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

# “Allow ALL traffic from ANYWHERE on the internet, on ALL ports, ALL protocols” ( should never be used.  )
resource "aws_vpc_security_group_ingress_rule" "allow_everything_ipv4" {
  security_group_id = aws_security_group.securitygroup-01.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
  # Sementically equivalent to all the ports.
} # ALL ports (0–65535). No need to use "from_port" / "to_port".    