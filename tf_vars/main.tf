terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.65.0"
    }
  }
}
provider "aws" {
  region = "us-east-1"
}


locals {
	owner = "me"
	name = "iac"
}
resource "aws_instance" "app_server" {
  ami           = "ami-02b49a24cfb95941c"
  instance_type = var.ec2-instance
  

  root_block_device {
	delete_on_termination = true
	volume_size 	      = var.ec2_config.volume_size
	volume_type           = var.ec2_config.volume_type
  }
  tags = merge(var.additional_tags,{
	Name = local.name
	})
}


