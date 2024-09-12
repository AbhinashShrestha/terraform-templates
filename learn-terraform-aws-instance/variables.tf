variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "TerraformServerInstance"
}
variable "region" {
  description = "Value of the EC2 region"
  type = string
  default = "us-east-1"
}

