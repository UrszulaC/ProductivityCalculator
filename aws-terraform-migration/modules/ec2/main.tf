resource "aws_instance" "main" {
  ami           = "ami-04a02d44310f3390b"  
  instance_type = "t3.medium"
  subnet_id     = var.subnet_id  # Use the passed Subnet ID
  tags = {
    Name = "Imported EC2 Instance ${var.instance_id}"  # Dynamic naming for instances
  }
}