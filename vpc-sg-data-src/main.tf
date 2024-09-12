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

data "aws_security_group" "mero" {
	tags = {
		mero-sg = "ho"
	}
}
#Subnet
data "aws_subnet" "ps"{
	filter {
                name = "vpc-id"
                values = [data.aws_vpc.vpc-stuff.id]
        }
        tags = {
                Name = "private-subnet"
        }

}
resource "aws_instance" "web" {
  ami           = "ami-0182f373e66f89c85"
  instance_type = "t2.micro"
  subnet_id = data.aws_subnet.ps.id
  security_groups = [data.aws_security_group.mero.id]

  tags = {
    Name = "mero"
  }
}
data "aws_vpc" "vpc-stuff" {
	tags = {
		"Name" : "mero-vpc"
	}
}
data "aws_availability_zones" "azs" {
	state = "available"
}
output "aws_ami" {
	value = data.aws_ami.amazon-linux.id
}
output "vpc-output" {
	value = data.aws_vpc.vpc-stuff.id
}
output "security_group" {
	value = data.aws_security_group.mero.id
}
