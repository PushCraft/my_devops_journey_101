resource "aws_instance" "ec2Demo" {
  ami           = var.ami
  key_name      = var.key
  instance_type = var.type
   count          = length(var.subnet_az_list)
  subnet_id     = element(aws_subnet.public-subnet-demo[*].id, count.index)
  vpc_security_group_ids =[ aws_security_group.security-group-01.id]
  

  user_data = <<EOF1
#!/bin/bash
dnf update -y
dnf install nginx -y
systemctl enable nginx
systemctl start nginx
echo "<h1>  From ThinkPad > Testing. </h1>" > /usr/share/nginx/html/index.html
EOF1

}