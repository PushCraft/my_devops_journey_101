resource "aws_instance" "DemoEC2" {
  ami                    = var.ami
  key_name               = var.key
  instance_type          = var.type
  subnet_id              = element(aws_subnet.PublicSubnet_functions.*.id, count.index)
  vpc_security_group_ids = [aws_security_group.demofunctionssg.id]

  count = var.env == "Dev" ? 2 : 3
  # If the environment is "Dev"? Create 2 or else create 3 instances.

  tags = {
    Name  = "${var.vpc_name} - Public-Server - ${count.index + 1}"
    "Env" = var.env
  }


  # User data ( Optional )
  user_data = <<EOF
   #!/bin/bash
   apt update -y
   apt install nginx -y
   service nginx start
   echo "------------------------------------------"
   echo "<h1><center> ${var.vpc_name} Web-Server-${count.index}</center></h1>" >> /var/html/index.nginx-debian.html 
   EOF


  # Changing the default Storage : ( Optional )
  root_block_device {
    volume_size           = 12 #It's in GB,  default is usually "8"
    volume_type           = "gp2"
    delete_on_termination = true
  }

}