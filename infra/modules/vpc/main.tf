resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}
