resource "aws_vpc" "infra_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.infra_vpc.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-subnet"
  }
}

output "vpc_id" {
  value = aws_vpc.infra_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}