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

variable "terraform_bucket_name" {
  description = "The name of the s3 bucket where terraform.tfstate will be stored"
  default     = "conecrazy-test-terraform-remote-state-storage-s3"
}

# terraform_key_file_name needs to be set to the environment that you are creating and should be the same as the name of the environment
# The terraform.tfstate file needs to be unique per environment
variable "terraform_key_file_name" {
  description = "The base path name of each region's terraform.tfstate file. It is generally the name of the environment"
  default     = "shared-infra"
}