provider "aws" {
  region = "eu-west-2"
}

module "vpc" {
  source            = "./modules/vpc"
  cidr_block        = "10.0.0.0/16"
  subnet_cidr_block = "10.0.1.0/24"
  name              = "infra_vpc"
}

module "security_group" {
  source        = "./modules/security_group"
  vpc_id       = module.vpc.vpc_id
  ingress_ports = [22, 9090]
  name          = "allow_ssh"
}

module "ec2" {
  source            = "./modules/ec2"
  ami               = "ami-01ec84b284795cbc7"  # Amazon Linux 2 AMI
  instance_type     = "t3.medium"
  subnet_id        = module.vpc.public_subnet_id
  security_group_id = module.security_group.security_group_id
  key_name         = "Server1_key"

  # Example: If you want to pass a secret value to the EC2 module (if supported)
  # secret_value     = data.aws_secretsmanager_secret_version.my_secret_version.secret_string
}

# Retrieve secret from AWS Secrets Manager
#data "aws_secretsmanager_secret" "my_secret" {
#   name = "database_credentials"  
# }

# data "aws_secretsmanager_secret_version" "my_secret_version" {
#   secret_id = data.aws_secretsmanager_secret.my_secret.id
# }


# output "instance_ip" {
#   value = module.ec2.instance_ip
# }