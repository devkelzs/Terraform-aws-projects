resource "aws_instance" "this" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  associate_public_ip_address = true
  security_groups             = var.security_groups
  user_data                   = var.user_data

  tags = {
    Name = var.name
  }
}
