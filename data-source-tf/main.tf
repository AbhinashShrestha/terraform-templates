terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.66.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["al2023*"]
  }
}


resource "aws_instance" "web" {
  ami           = "data.aws_ami.amazon-linux.id"
  instance_type = "t2.micro"

  tags = {
    Name = "mero"
  }
}


output "aws_ami" {
	value = data.aws_ami.amazon-linux.id
}
