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

variable "vpn_gateway_endpoint" {
  description = "VPN Gateway connection endpoint"
  type        = string
  default     = ""
}

variable "home_cidr_block" {
  description = "home full cidr block"
  type        = string
  default     = ""
}

variable "sg_name_default" {
  description = "the name of your security group, there will likely be more than 1"
  type        = string
  default     = "default_one"
}

variable "sg_description_default" {
  description = "the description of your security group, there will likely be more than 1"
  type        = string
  default     = "default all access"
}

variable "route53_private_zone_name" {
  description = "Suffix for the private DNS zone - will be"
  type        = string
  default     = ""
}
