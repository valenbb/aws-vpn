variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Desired instance type for EC2"
  default = "t2.nano"
}

variable "vpc_prod_id" {
  description = "Production VPC ID"
  default = "vpc-0e628976"
}

variable "subnet_id" {
  description = "Subnet ID to use"
  default = "subnet-89d811b6 "
}

variable "az_id" {
  description = "Availability Zone"
  default = "us-east-1e"
}

variable "cidr" {
  description = "CIDR for subnet"
  default = "10.0.5.0/24"
}

# Amazon AMI
variable "aws_ami" {
  default = "ami-aa2ea6d0"
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default = "esn-devops"
}

variable "ssh_key_filename" {
  description = "Enter the path to the SSH Private Key to run provisioner."
  default = "/var/lib/jenkins/.ssh/esn-devops.pem"
}
