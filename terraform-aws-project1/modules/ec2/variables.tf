variable "ami_id" {
  description = "The AMI ID for the EC2 instance (optional; defaults to latest Amazon Linux 2)"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
}

variable "environment" {
  description = "The deployment environment"
  type        = string
}

variable "key_pair_name" {
  description = "The name of the SSH key pair"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block for SSH access"
  type        = string
}
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
  
}
