
# This is to understand "Dynamic Block."

resource "aws_security_group" "demofunctionssg" {
  vpc_id = aws_vpc.DemoBasicVpc.id
  name   = "websecurity"
  tags = {
    Name = "${var.vpc_name}-SG"
  }


  description = "Allowing web server ports"


  dynamic "ingress" {
    for_each = local.ingress_rule1
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"         # This is not part of 'locals.tf' file so we provide the value manually. 
      cidr_blocks = ["0.0.0.0/0"] # This is not part of 'locals.tf' file so we provide the value manually. 
    }
  }


  dynamic "ingress" {
    for_each = local.ingress_rule2
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }





}