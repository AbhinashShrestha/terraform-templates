 provider "aws" {
	region = "us-east-1"
}
data "aws_availability_zones" "az-list" {
	state = "available"
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"
  
  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = data.aws_availability_zones.az-list.names
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
