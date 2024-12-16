# Define the project ID for the GCP project
variable "project_id" {}

# Define the region where resources will be deployed
variable "region" {}

# Define the VPC names
variable "vpc_a_name" {  }

variable "vpc_b_name" {}

# Define subnet CIDR ranges
variable "subnet_a_cidr" {}
 
variable "subnet_b_cidr" {}

# Instance configuration
variable "instance_machine_type" {}

variable "instance_zone" {}

variable "image" {}
