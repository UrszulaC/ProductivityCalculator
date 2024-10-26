variable "vpc_id" {
  description = "The ID of the VPC in which to create the security group"
  type        = string
}

variable "ingress_ports" {
  description = "List of ports to allow ingress traffic"
  type        = list(number)
}

variable "name" {
  description = "The name of the security group"
  type        = string
}