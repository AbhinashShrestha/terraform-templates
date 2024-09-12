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
	users_config_file = yamldecode(file("./users.yaml")).users
	user_role_pair = flatten([for user in local.users_config_file: [for role in user.roles: {
		username = user.username
		role = role
	}]])
}

resource "aws_iam_user" "users" {
	for_each = toset(local.users_config_file[*].username)
	name = each.value 
}


resource "aws_iam_user_login_profile" "iam-config" {
  for_each = aws_iam_user.users
  user     = each.value.name
  password_length = 12
  pgp_key = "keybase:some_person_that_exists"
  lifecycle {
    ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }
}

#Attaching policy
resource "aws_iam_user_policy_attachment" "iam-policy" {
	for_each = {
		for pair in local.user_role_pair :
		"${pair.username}-${pair.role}" => pair
	}
	user 	   = aws_iam_user.users[each.value.username].name
	policy_arn = "arn:aws:iam::aws:policy/${each.value.role}"
}

output "output" {
	value = local.user_role_pair
}
