resource "aws_instance" "infra_instance" {
  ami                    = var.ami
  instance_type         = var.instance_type
  subnet_id             = var.subnet_id
  key_name              = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address = true

  tags = {
    Name = "infra-instance"
  }
}

output "instance_ip" {
  value = aws_instance.infra_instance.public_ip
}