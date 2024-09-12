terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.65.0"
    }
  }
  backend "s3" {
	bucket = mero-afanai-9450197335310142466
	key = "backend.tfstate"
	region = "us-east-1"
  }
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami           = "ami-02b49a24cfb95941c"
  instance_type = "t2.micro"

  tags = {
    Name = "tf-backend"
  }
}


