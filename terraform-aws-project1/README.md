# AWS EC2 Instance with Security Group
This Terraform project deploys a single AWS EC2 instance (t2.micro) in the default VPC with a security group allowing SSH access (port 22). The configuration is modular, parameterized, and follows AWS best practices for beginners.

## Features

EC2 Instance: t2.micro instance running Amazon Linux 2 (dynamic AMI).

Security Group: Allows SSH (port 22) from a specified IP and all outbound traffic.

Modularity: Resources are encapsulated in a reusable modules/ec2 module.

Variables: Configurable AMI, instance type, environment, key pair, and SSH CIDR block.

Outputs: Public IP and instance ID for easy access.

Best Practices: Pinned AWS provider, tagged resources, and restricted ingress.

## Prerequisites

Terraform: Version >= 1.0 installed. Download here.

AWS Account: Active account with IAM user credentials configured.

AWS CLI: Optional, for credential setup. Install here.

SSH Key Pair: An AWS key pair for SSH access. Create one in the AWS Console (EC2 > Key Pairs).

Public IP: Your IP address for SSH access (find via curl ifconfig.me).

## Project Structure
.
├── main.tf              # Root module calling the EC2 module

├── variables.tf         # Root module variables

├── outputs.tf           # Outputs for public IP and instance ID

├── terraform.tf         # Provider configuration

├── terraform.tfvars     # Variable values (not committed to Git)

├── modules/
│   └── ec2/

│       ├── main.tf      # EC2 instance and security group

│       ├── variables.tf # Module variables

│       ├── outputs.tf   # Module outputs
├── README.md            # This file

## Setup Instructions

Clone or Create the Repository:

Clone this repository or create the directory structure above.

Copy the Terraform files provided into the respective locations.


## Configure AWS Credentials:

Run aws configure to set your Access Key ID and Secret Access Key, or

Set environment variables:export AWS_ACCESS_KEY_ID="<your-access-key>"

export AWS_SECRET_ACCESS_KEY="<your-secret-key>"




## Create an SSH Key Pair:

In the AWS Console, navigate to EC2 > Key Pairs > Create Key Pair.

Download the .pem file and store it securely (e.g., ~/.ssh/my-key-pair.pem).





## Update terraform.tfvars:

Edit terraform.tfvars with your values:ami_id        = "" # Leave empty for dynamic AMI

instance_type = "t2.micro"

environment   = "dev"

key_pair_name = "<your-key-pair-name>" # e.g., "my-key-pair"

allowed_ssh_cidr = "<your-ip>/32"      # e.g., "203.0.113.10/32"

region        = "us-east-1"


Find your IP: curl ifconfig.me.
Do not commit terraform.tfvars to Git (add to .gitignore).


### Initialize Terraform:

```terraform init``


### Validate Configuration:

```terraform validate```



## Usage

### Plan the Deployment:

```terraform plan -out=tfplan```

**Review the plan to confirm resources (1 EC2 instance, 1 security group).** 

### Apply the Configuration:

```terraform apply tfplan```

### After applying, note the outputs:

instance_public_ip: Public IP for SSH access.

instance_id: EC2 instance ID.


Access the Instance:SSH into the instance using the public IP:

```ssh -i ~/.ssh/<your-key-pair>.pem ec2-user@<instance_public_ip>```


Clean Up:To avoid AWS charges, destroy resources when done:

```terraform destroy```



## Best Practices

###  Security:
Restrict SSH access to your IP in allowed_ssh_cidr.

Use a secure key pair and protect the .pem file.


Modularity: The ec2 module is reusable for other projects.

Version Control:

Pin AWS provider (~> 5.0) for reproducibility.

Add **terraform.tfvars** and .terraform/ to **.gitignore.**


Dynamic AMI: The module fetches the latest Amazon Linux 2 AMI.
Tagging: Resources are tagged with Environment and Name.

## Troubleshooting

Invalid AMI: If ami_id is hardcoded, ensure it’s valid for your region. Alternatively, leave ami_id empty to use 
the dynamic AMI.

SSH Connection Issues:

Verify allowed_ssh_cidr matches your IP.

Check key pair permissions (chmod 400 <key.pem>).

Ensure the instance is in a public subnet with a public IP.


Region/AZ Errors: Update region in terraform.tfvars or AZ in modules/ec2/main.tf if us-east-1a is unavailable.

## Notes

Costs: The t2.micro instance is free-tier eligible, but always destroy resources after use to avoid charges.

Production Enhancements:
Use remote state storage (e.g., S3 with DynamoDB locking).

Add a user_data script to configure the instance.

Tighten egress rules in the security group.


Customizations:

Change instance_type or region in terraform.tfvars.

Modify modules/ec2/main.tf to use a different AMI (e.g., Ubuntu).


