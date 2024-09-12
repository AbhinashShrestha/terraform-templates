terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.65.0"
    }
  }
}
provider "aws" {
  region = var.region
}

resource "aws_instance" "app_server" {
  ami           = "ami-02b49a24cfb95941c"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}

