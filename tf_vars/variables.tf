variable "ec2-instance" {
	description = "type of ec2"
	type = string
	default = "t2.micro"
	validation {
		condition = var.ec2-instance=="t2.micro" ||  var.ec2-instance=="t3.micro"
		error_message = "Only free tier stuff allowed i.e t2/t3/micro"
	}
}
#same category combine 
variable "ec2_config" {
	type = object({
		volume_size = number
		volume_type = string
	})
	default = {
		volume_size = 10
		volume_type = "gp2"
	}
}

variable "additional_tags" {
	type = map(string) #expects key value format
	default ={}
}
