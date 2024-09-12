#EC2 Instance 
resource "aws_instance" "nginx_server" {
  ami           = "ami-0182f373e66f89c85"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
		#!/bin/bash
		sudo yum install epel-release -y
		sudo yum update -y
		sudo yum install nginx -y
		sudo service nginx start
	EOF

  tags = {
    Name = "ec2-nginx"
  }
}

