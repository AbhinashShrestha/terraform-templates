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
	users_config_file = file("./users.yaml")
}

output "output" {
	value = local.users_config_file
}
