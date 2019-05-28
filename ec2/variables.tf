variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "aws_account_id" {
}

variable "environment_name" {
  description = "Short name for the environment (i.e. bruce_test)"
  default     = "bruce"
}

variable "aws_region" {
  description = "EC2 Region for the VPC"
  default     = "ca-central-1"
}

variable "home_external_ip" {
  description = "The external ip of bjackson office"
  default     = "174.118.67.198/32"
}

variable "sg_name_1" {
  description = "the name of your security group, there will likely be more than 1"
  default     = "bruce_all_test"
}

variable "sg_description_1" {
  description = "the description of your security group, there will likely be more than 1"
  default     = "all access"
}

variable "route53_private_zone_name" {
  description = "Suffix for the private DNS zone - will be "
  default     = "conecrazy.aws"
}

variable "route53_private_zones" {
  description = "A list of all of our private zones. This needs to be overriden per environment to remove themselves."

  default = [
    "bruce.conecrazy.aws",
  ]
}

# We should dynamically look this up at some point...
variable "route53_private_zone_ids" {
  description = "Map of zone IDs (indexed by route53_private_zones)"

  default = {
    "bruce.conecrazy.aws" = "Z1XNN3MFBODE1M"
  }
}

variable "ubuntu-toolbox_ami" {
  description = "AMI ID to use when creating ubuntu-toolbox hosts"
  default     = "ami-01b60a3259250381b"
}

variable "ubuntu-toolbox_count" {
  description = "Number of ubuntu-toolbox hosts"
  default     = 1
}

variable "ubuntu-toolbox_ec2_type" {
  description = "EC2 instanct type for the ubuntu-toolbox hosts"
  default     = "t2.micro"
}

variable "ubuntu-toolbox_rootfs_size" {
  description = "root volume size for vault admin ec2 instances"
  default     = 10
}

variable "ubuntu-toolbox_rootfs_volume_type" {
  description = "the type of volume that the root partition is"
  default     = "gp2"
}

variable "k8s-master_ami" {
  description = "AMI ID to use when creating k8s-master hosts"
  default     = "ami-01b60a3259250381b"
}

variable "k8s-master_count" {
  description = "Number of k8s-master hosts"
  default     = 1
}

variable "k8s-master_ec2_type" {
  description = "EC2 instanct type for the k8s-master hosts"
  default     = "t2.micro"
}

variable "k8s-master_rootfs_size" {
  description = "root volume size for vault admin ec2 instances"
  default     = 10
}

variable "k8s-master_rootfs_volume_type" {
  description = "the type of volume that the root partition is"
  default     = "gp2"
}

variable "k8s-worker_ami" {
  description = "AMI ID to use when creating k8s-worker hosts"
  default     = "ami-01b60a3259250381b"
}

variable "k8s-worker_count" {
  description = "Number of k8s-worker hosts"
  default     = 1
}

variable "k8s-worker_ec2_type" {
  description = "EC2 instanct type for the k8s-worker hosts"
  default     = "t2.micro"
}

variable "k8s-worker_rootfs_size" {
  description = "root volume size for vault admin ec2 instances"
  default     = 10
}

variable "k8s-worker_rootfs_volume_type" {
  description = "the type of volume that the root partition is"
  default     = "gp2"
}

variable "AmazonEC2ReadOnlyAccessARN" {
  description = "The ARN for the AmazonEC2ReadOnlyAccess managed policy"
  default     = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}