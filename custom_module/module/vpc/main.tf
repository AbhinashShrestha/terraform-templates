resource "aws_vpc" "vpc"{
	cidr_block = var.vpc_config.cidr_block
	tags = {
		Name = var.vpc_config.name
	}
}

resource "aws_subnet" "subnet" {
	vpc_id = aws_vpc.vpc.id
	for_each = var.subnet_config #key={cidr,az}
	cidr_block = each.value.cidr_block
	availability_zone = each.value.az
	tags = {
		Name = each.key
	}
}

locals {
	public_subnet = {
		for key,config in var.subnet_config: key => config if config.public
	}
}

resource "aws_internet_gateway" "igw" {
	vpc_id = aws_vpc.vpc.id
	count = length(local.public_subnet) > 0 ? 1 : 0

}
