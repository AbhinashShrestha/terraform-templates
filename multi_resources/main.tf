terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.66.0"
    }
  }
}

provider "aws" {
  # Configuration options
	region = "us-east-1"
}

locals {
	project = "omega"
}
resource "aws_vpc" "mero-vpc" {
	cidr_block = "10.0.0.0/16"
	tags = {
		Name = "${local.project}-vpc"
	}
}

resource "aws_subnet" "m-subnet" {
	vpc_id = aws_vpc.mero-vpc.id
	cidr_block = "10.0.${count.index}.0/24"
	count = 2
	tags = {
		Name = "${local.project}-subnet-${count.index}"
	}
}

resource "aws_instance" "ec2_instance" {
  for_each	= var.ec2_map
  ami           = each.value.ami
  instance_type = each.value.instance_type  

  #ami           = var.ec2_config[count.index].ami
  #instance_type = var.ec2_config[count.index].instance_type
  #count		= length(var.ec2_config)
  #subnet_id 	= element(aws_subnet.m-subnet[*].id,count.index % length(aws_subnet.m-subnet))
  subnet_id 	= element(aws_subnet.m-subnet[*].id, index(keys(var.ec2_map),each.key) % length(aws_subnet.m-subnet))
  tags = {
    #Name = "${local.project}-ec2-${count.index}"
    Name = "${local.project}-ec2-${each.key}"
  }

}

output "aws_subnet_id" {
	value = aws_subnet.m-subnet[*].id
}
