/*
This creates a remote tfstate file in a s3 aws_s3_bucket
It is used to remotely sync the tfstate file so that more than 1 person can work on the same code and share the tfstate file
There is a bucket per "environment"
interesting links:
https://www.terraform.io/docs/backends/types/s3.html
https://www.terraform.io/docs/state/remote.html
https://medium.com/@jessgreb01/how-to-terraform-locking-state-in-s3-2dc9a5665cb6

This will automatically push the local state file to a remote s3 bucket for sharing
*/


# terraform state file setup
# create an S3 bucket to store the state file in
resource "aws_s3_bucket" "terraform-state-storage-s3" {

  bucket = var.terraform_bucket_name

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "S3 Remote Terraform State Store"
  }
}

# create a dynamodb table for locking the state file as this is important when sharing the same state file across users
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
}
