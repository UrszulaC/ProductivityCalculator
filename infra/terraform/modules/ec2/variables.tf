variable "ami" {
  description = "The AMI to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet in which to launch the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "The name of the key pair to use for the EC2 instance"
  type        = string
}

variable "security_group_id" {
  description = "The security group ID to associate with the EC2 instance"
  type        = string
}