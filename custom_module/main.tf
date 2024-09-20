provider "aws" {
	region = "us-east-1"
}

module "vpc" {
	source = "./module/vpc"
	vpc_config = {
		cidr_block = "10.0.0.0/16"
		name = "my-custom-module-vpc"
	}
	subnet_config = {
		public_subnet = {
			cidr_block = "10.0.1.0/24"
			az = "us-east-1a"
			public = true
		}
		public_subnet2 = {
                        cidr_block = "10.0.3.0/24"
                        az = "us-east-1c"
                        public = true
                }

		private_subnet = {
                        cidr_block = "10.0.2.0/24"
                        az = "us-east-1b"
                }
	}
}
