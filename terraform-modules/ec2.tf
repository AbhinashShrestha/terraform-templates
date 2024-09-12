module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.7.0"

  name = "module-instance"

  instance_type          = "t2.micro"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]
  ami 			 = "ami-0182f373e66f89c85"
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
