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

######
# S3 policies
######

# data "template_file" "terraform-bucket-policy" {
#   template = file("${path.module}/templates/s3-bucket-policy.tpl")

#   vars = {
#     read_only_user_arn   = aws_iam_user.bruce-read.arn
#     full_access_user_arn = aws_iam_user.bruce.arn
#     s3_bucket            = var.terraform_bucket_name
#   }
# }

# data "template_file" "bruce-policy" {
#   template = file("${path.module}/templates/s3-user-full-policy.tpl")

#   vars = {
#     s3_rw_bucket       = var.terraform_bucket_name
#     dynamodb_table_arn = aws_dynamodb_table.dynamodb-terraform-state-lock.arn
#   }
# }

# data "template_file" "bruce-read-policy" {
#   template = file("${path.module}/templates/s3-user-read-policy.tpl")

#   vars = {
#     s3_ro_bucket       = var.terraform_bucket_name
#     dynamodb_table_arn = aws_dynamodb_table.dynamodb-terraform-state-lock.arn
#   }
# }

# Setup users for full r/w access
resource "aws_iam_user" "rw_access" {
  #name = "bruce"
  count = length(var.remote_state_full_access_users)
  name = element(var.remote_state_full_access_users, count.index)
}

# Setup users for read access
resource "aws_iam_user" "read_access" {
  #name = "bruce-read"
  count = length(var.remote_state_read_users)
  name = element(var.remote_state_read_users, count.index)
}

# terraform state file setup
# create an S3 bucket to store the state file in
resource "aws_s3_bucket" "terraform-state-storage-s3-full" {
  count = length(var.remote_state_full_access_users)

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

  #policy = data.template_file.terraform-bucket-policy.rendered
  policy = templatefile("${path.module}/templates/s3-bucket-full-policy.tpl", {
    full_access_user_arn = element(aws_iam_user.rw_access, count.index)
    s3_bucket            = var.terraform_bucket_name
  })
}

resource "aws_s3_bucket" "terraform-state-storage-s3-read" {
  count = length(var.remote_state_read_users)

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

  #policy = data.template_file.terraform-bucket-policy.rendered
  policy = templatefile("${path.module}/templates/s3-bucket-read-policy.tpl", {
    read_only_user_arn = element(aws_iam_user.read_access, count.index)
    s3_bucket            = var.terraform_bucket_name
  })
}

resource "aws_iam_user_policy" "rw_access" {
  name = "rw_access_users"
  count = length(var.remote_state_full_access_users)
  user = element(var.remote_state_full_access_users, count.index)

  #policy = data.template_file.bruce-policy.rendered
  policy = templatefile("${path.module}/templates/s3-user-full-policy.tpl", {
    s3_rw_bucket       = var.terraform_bucket_name
    dynamodb_table_arn = aws_dynamodb_table.dynamodb-terraform-state-lock.arn
  })
}

resource "aws_iam_user_policy" "read_access" {
  name = "read_access_users"
  count = length(var.remote_state_read_users)
  user = element(var.remote_state_read_users, count.index)

  #policy = data.template_file.bruce-read-policy.rendered
  policy = templatefile("${path.module}/templates/s3-user-read-policy.tpl", {
    s3_ro_bucket       = var.terraform_bucket_name
    dynamodb_table_arn = aws_dynamodb_table.dynamodb-terraform-state-lock.arn
  })
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
