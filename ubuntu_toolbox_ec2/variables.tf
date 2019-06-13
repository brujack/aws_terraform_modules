variable "aws_region" {
  description = "EC2 Region for the VPC"
  type        = string
  default     = "ca-central-1"
}

variable "environment_name" {
  description = "Short name for the environment (i.e. bruce_test)"
  type        = string
  default     = ""
}

variable "ubuntu-toolbox_ami" {
  description = "AMI ID to use when creating ubuntu-toolbox hosts"
  type        = "map"
  default     = {
    "ca-central-1" = "ami-01b60a3259250381b"
  }
}

variable "ubuntu-toolbox_count" {
  description = "Number of ubuntu-toolbox hosts"
  type        = "string"
  default     = 1
}

variable "ubuntu-toolbox_ec2_type" {
  description = "EC2 instanct type for the ubuntu-toolbox hosts"
  type        = "string"
  default     = "t2.micro"
}

variable "ubuntu-toolbox_rootfs_size" {
  description = "root volume size for vault admin ec2 instances"
  type        = "string"
  default     = "10"
}

variable "ubuntu-toolbox_rootfs_volume_type" {
  description = "the type of volume that the root partition is"
  type        = "string"
  default     = "gp2"
}

variable "home_external_ip" {
  description = "The external ip of bjackson office"
  type        = string
  default     = "174.118.67.198/32"
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR for the Public Subnets"
  type        = list(string)
  default     = ["10.192.1.0/24", "10.192.2.0/24"]
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR for the Private Subnets"
  type        = list(string)
  default     = ["10.192.3.0/24", "10.192.4.0/24"]
}

variable "home_cidr_block" {
  description = "home full cidr block"
  type        = string
  default     = "192.168.1.0/24"
}

variable "AmazonEC2ReadOnlyAccessARN" {
  description = "The ARN for the AmazonEC2ReadOnlyAccess managed policy"
  type        = string
  default     = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}
