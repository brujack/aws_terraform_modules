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

variable "home_external_ip_simple" {
  description = "The external ip of bjackson office"
  default     = "174.118.67.198"
}

variable "customer_gateway_name" {
  description = "The name of the office/router that you will connecting to"
  default     = "bruce-home"
}

variable "vpn_gateway_endpoint" {
  description = "VPN Gateway connection endpoint"
  default     = "conecrazy"
}

variable "home_cidr_block" {
  description = "home full cidr block"
  default     = "192.168.1.0/24"
}