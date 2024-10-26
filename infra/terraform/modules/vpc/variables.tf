variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the public subnet"
  type        = string
}

variable "name" {
  description = "Name of the VPC"
  type        = string
}