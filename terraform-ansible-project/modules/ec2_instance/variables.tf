variable "name" {
  description = "Name tag for the instance"
  type        = string
}

variable "ami" {
  description = "AMI ID for the instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "SSH Key pair name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
}
variable "user_data" {
  description = "User data script"
  type        = string
  default     = null
}

