# Terraform Automated Ansible Infrastructure on AWS

## Overview

This project provisions a fully automated Ansible infrastructure on AWS using Terraform. It creates:

- **1 Ansible Control Node**
- **2 Ansible Managed Nodes**

All managed nodes use the **same AWS key pair** for SSH access. The private key of this key pair is automatically injected into the control node during provisioning, allowing the control node to SSH into the managed nodes without manual intervention.

## Features

- Automatic provisioning of AWS VPC, subnet, internet gateway, routing, and security groups.
- Modular Terraform code for reusable EC2 instance provisioning.
- Automatic injection of private SSH key into the control node.
- Ansible installation and configuration on the control node.
- Automatic Ansible inventory setup to manage the two nodes.
- Immediate ability to run `ansible all -m ping` from the control node after deployment.

## Prerequisites

- Terraform installed ([Terraform installation guide](https://learn.hashicorp.com/tutorials/terraform/install-cli))
- AWS CLI configured with appropriate credentials and permissions
- AWS key pair created (used for both managed nodes)
- Downloaded private key file (`.pem`) for the AWS key pair placed in the project directory (default: `managed-key.pem`)

## Project Structure


terraform-ansible-infra/

├── main.tf

├── variables.tf

├── outputs.tf

├── templates/

│   └── control\_node\_setup.sh.tpl

└── modules/

└── ec2\_instance/

├── main.tf

├── variables.tf

└── outputs.tf

├──



## Usage

1. **Update variables**

Modify `variables.tf` as needed:
- Set your AWS region, AMI ID, instance type.
- Set the `key_name_managed` to your AWS key pair name.
- Set `private_key_path` to the path of your downloaded private key (`managed-key.pem`).

2. **Initialize Terraform**

```bash
terraform init
terraform fmt 
terraform validate 
terraform plan
````

3. **Preview and apply the infrastructure**

```bash
terraform apply
```

Confirm the apply. Terraform will provision infrastructure, create EC2 instances, inject the private key into the control node, and configure Ansible automatically.

4. **Connect to the Control Node**

Find the control node public IP in Terraform outputs:

```bash
terraform output control_node_public_ip
```

SSH into the control node:

```bash
ssh -i managed-key.pem ubuntu@<control_node_public_ip>
```

5. **Test Ansible connectivity**

On the control node, test Ansible can reach the managed nodes:

```bash
ansible all -m ping
```

You should see successful ping responses from both managed nodes.

## Troubleshooting

* Ensure the security group allows inbound SSH (port 22) from your IP.
* Verify the private key file permissions on your local machine (`chmod 400 managed-key.pem`).


