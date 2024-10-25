provider "aws" {
  region = "eu-west-2"
}
module "vpc" {
  source            = "./modules/vpc"
  cidr_block        = "10.0.0.0/16"
  subnet_cidr_block = "10.0.1.0/24"
  name              = "infra_vpc"
}


# VPC
#resource "aws_vpc" "infra_vpc" {
  #cidr_block = "10.0.0.0/16"
  #enable_dns_support = true
  #enable_dns_hostnames = true
  #tags = {
    #Name = "infra_vpc"
  #}
#}

# Internet Gateway
resource "aws_internet_gateway" "infra_igw" {
  vpc_id = aws_vpc.infra_vpc.id
  tags = {
    Name = "infra_igw"
  }
}

# Route Table
resource "aws_route_table" "infra_route_table" {
  vpc_id = aws_vpc.infra_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.infra_igw.id
  }
  tags = {
    Name = "infra_route_table"
  }
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "infra_route_table_assoc" {
  subnet_id      = aws_subnet.infra_subnet.id
  route_table_id = aws_route_table.infra_route_table.id
}

# Public Subnet (with auto-assign public IP enabled)
resource "aws_subnet" "infra_subnet" {
  vpc_id                  = aws_vpc.infra_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "infra_subnet"
  }
}

# Security Group
resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.infra_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow traffic to Prometheus via port 9090
  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

# EC2 Instance
resource "aws_instance" "infra_instance" {
  ami           = "ami-01ec84b284795cbc7"  # Amazon Linux 2 AMI
  instance_type = "t3.medium"
  subnet_id     = aws_subnet.infra_subnet.id
  key_name      = "Server1_key"

  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  associate_public_ip_address = true  # Ensuring public IP is assigned

  tags = {
    Name = "infra-instance"
  }
}

# Output the public IP of the instance
output "instance_ip" {
  value = aws_instance.infra_instance.public_ip
}