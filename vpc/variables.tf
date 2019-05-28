# comes from ~/.aws/.tf_aws_creds_home
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

variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "0.0.0.0/0"
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR for the Public Subnets"
  type        = list(string)
  default     = []
}

# The number of public and private availability zones must be equal, as it is used for the calculation of the distribution of ec2 instances.
# If you change the number of availability zones defined below, terraform will recreate new ec2 instances and alb pointers, so do it with caution.
# Additionally changing the number of availability zones will cause a recalculation of subnet id's after the existing ones, which will cause a re-deploy of all nat gateways.
variable "public_subnet_avail_zones" {
  description = "availability zone assignment Public Subnets"
  type        = list(string)
  default     = []
}

variable "public_subnet_names" {
  description = "Public Subnets name tag"
  type        = list(string)
  default     = []
}

variable "private_subnet_cidr_blocks" {
  description = "CIDR for the Private Subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_avail_zones" {
  description = "availability zone assignment Private Subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_names" {
  description = "Private Subnets name tag"
  type        = list(string)
  default     = []
}
