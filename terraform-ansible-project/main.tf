provider "aws" {
  region = "us-east-1"
}

# VPC, subnet, IGW, route table, and security group remain unchanged
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_security_group" "allow_ssh" {
  name   = "allow_ssh"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Generate a new SSH key pair
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "generated" {
  key_name   = "auto-ansible-key"
  public_key = tls_private_key.ssh.public_key_openssh
}

module "managed_node_1" {
  source          = "./modules/ec2_instance"
  name            = var.managed_node_1_name
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = aws_key_pair.generated.key_name
  subnet_id       = aws_subnet.main.id
  security_groups = [aws_security_group.allow_ssh.id]
}

module "managed_node_2" {
  source          = "./modules/ec2_instance"
  name            = var.managed_node_2_name
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = aws_key_pair.generated.key_name
  subnet_id       = aws_subnet.main.id
  security_groups = [aws_security_group.allow_ssh.id]
}

module "control_node" {
  source          = "./modules/ec2_instance"
  name            = var.control_node_name
  ami             = var.ami
  instance_type   = var.instance_type
  key_name        = aws_key_pair.generated.key_name
  subnet_id       = aws_subnet.main.id
  security_groups = [aws_security_group.allow_ssh.id]

  user_data = templatefile("${path.module}/template/control_node_setup.sh.tpl", {
    private_key_content = tls_private_key.ssh.private_key_pem,
    managed_ip_1        = module.managed_node_1.private_ip,
    managed_ip_2        = module.managed_node_2.private_ip
  })
}
