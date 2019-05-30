/*
This terraform module is for setting up and managing iam users and groups that are in addition to the original administrator setup with the account.
It exists in the shared-infra section since IAM users/groups are regionless
*/


resource "aws_iam_user" "bruce" {
  name = "bruce"
}

resource "aws_iam_user" "bruce-read" {
  name = "bruce-read"
}

resource "aws_iam_group" "ec2admin" {
  name = "EC2Admin"
}

resource "aws_iam_group_policy_attachment" "ec2admin-attach" {
  group      = aws_iam_group.ec2admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_membership" "add-ec2admin" {
  name = "add-ec2admin"

  users = [
    aws_iam_user.bruce.name,
    aws_iam_user.bruce-read.name,
  ]

  group = aws_iam_group.ec2admin.name
}
