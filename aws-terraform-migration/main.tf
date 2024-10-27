provider "aws" {
  region = "us-east-1"  # Update with your AWS region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_id = "vpc-0e4c17acfc9a5f696" 
}

module "ec2_1" {
  source       = "./modules/ec2"
  instance_id  = "i-0f107b3a56d29f39f" 
  vpc_id       = module.vpc.vpc_id
  subnet_id    = "subnet-01d181e44094a735e"  
}

module "ec2_2" {
  source       = "./modules/ec2"
  instance_id  = "i-0c75a9c8fa27e6a12"  
  vpc_id       = module.vpc.vpc_id
  subnet_id    = "subnet-01d181e44094a735e" 
}

module "security_group" {
  source            = "./modules/security-group"
  security_group_id = "sg-0043a61feca30f6fa" 
}