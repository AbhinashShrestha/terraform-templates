terraform {}

#Number List
variable "num_list" {
	type = list(number)
	default = [1,2,3,4,5]
}

#Object List
variable "object_list" {
	 type = list(object({
		fname = string
		lname = string
	}))
	default = [{
		fname = "iac"
		lname = "ansible"
	},
	{
		fname = "iac"
		lname = "terraform"
	}
	]
}

variable "map_list" {
	type = map(number)
	default = {
		"first-name" = 1
		"last" = 1
	}
}
#Calculations
locals {
	mul = 2 * 2

	double = [for num in var.num_list: num * 2 ]
	odd = [for num in var.num_list: num if num%2!=0]
	lname = [for data in var.object_list: data.lname]

	#work with map
	map_info = [for key,value in var.map_list: value]
	kv_double = {for key,value in var.map_list : key => value *20}
}
output "output" {
	value = local.kv_double
}
