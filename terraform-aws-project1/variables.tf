variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = "" # Empty default; module will use dynamic AMI if not provided
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "environment" {
  description = "The deployment environment (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "key_pair_name" {
  description = "The name of the SSH key pair"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block for SSH access"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}