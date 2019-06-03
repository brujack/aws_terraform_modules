variable "terraform_bucket_name" {
  description = "The name of the s3 bucket where terraform.tfstate will be stored"
  default     = "conecrazy-test-terraform-remote-state-storage-s3"
}

variable "remote_state_full_access_users" {
  description = "User list of users with full r/w access to the remote state file"
  type        = list(string)
  default     = []
}

variable "remote_state_read_users" {
  description = "User list of users with read only access to the remote state file"
  type        = list(string)
  default     = []
}
