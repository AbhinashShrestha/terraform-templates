terraform {}
locals {
	value =  "something"
}
variable "string_list" {
	type = list(string)
	default = ["serv1" , "ser2"]
}

output "console_output" {
	#value = lower(local.value)
	#value = startswith(local.value, "s")
	#value = length(var.string_list)
	#value = join(":", var.string_list)
	#value = contains(var.string_list,"server")
	value = toset(var.string_list)	
	
}
