variable "region" {
  description = "value for the AWS region"
  type        = string
}

variable "ami" {
  description = "value for the AMI ID"
  type        = string
}

variable "instance_type" {
  description = "value for the EC2 instance type"
  type        = string
}

variable "key_name_managed" {
  default = "managed-key"
}

variable "control_node_name" {
  default = "ansible-control-node"
}

variable "managed_node_1_name" {
  default = "managed-node-1"
}

variable "managed_node_2_name" {
  default = "managed-node-2"
}

variable "private_key_path" {
  default = "managed-key.pem"
}
