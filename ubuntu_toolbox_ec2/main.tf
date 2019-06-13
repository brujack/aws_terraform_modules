# Ubuntu toolbox Instances

# keypair is only needed to bootstrap the first node before adding in a proper key using ansible and building a new ami
# used with "key_name" in "aws_instance" below to build the first instance
# resource "aws_key_pair" "bjackson" {
#   key_name    = "bjackson"
#   public_key  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBUe6rUC2p5H2CiV3lxWQMjaalMVBhqjOFQ0A+H0qypGrzgvgroQlJByo0mWOREYMe5bqjbXzpQtN93zhWVnc4uHp/ZQIiGtp9EmeOPWiHkC2hcmuKqNF4mcIzm6z2w1KtTBvwcv3YKs1nAv1wXkTpfe9yyzmO1UeH/D5rULj8PsJEokh+TJ9Q4PFktMRa62AZY/QJYEcpx3OJKEl2NU8HzLztrJKEGZdu/v4FOdV96AWx33EncL+lXvrJgjmNp8cv7minkqXlwHlwSA2B0kJMrrYS1njrByCpjaZaSxU/sr8BSBmAwQgbJYsrg5CpOwnRS9AUB/wYipj0qQ4WEDJT"
# }

resource "aws_instance" "ubuntu-toolbox" {
  ami                         = var.ubuntu-toolbox_ami
  instance_type               = var.ubuntu-toolbox_ec2_type

  #key_name                    = "bjackson"
  count                       = var.ubuntu-toolbox_count

  # even distribution of instances across availability zones
  subnet_id                   = element(aws_subnet.public.*.id, count.index)
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.ubuntu-toolbox-hosts.id]
  user_data = templatefile("${path.module}/templates/ubuntu-toolbox-ec2-user-data.sh.tpl", {
    instance_hostname = "${var.environment_name}-ubuntu-toolbox-${count.index}"
  })

  iam_instance_profile = aws_iam_instance_profile.ubuntu-toolbox.id

  root_block_device {
    volume_size = var.ubuntu-toolbox_rootfs_size
    volume_type = var.ubuntu-toolbox_rootfs_volume_type
  }

  tags = {
    Name = "ubuntu-toolbox-${count.index}.${var.environment_name}"
    Role = "common"
  }

  # Ignore userdata changes
  lifecycle {
    ignore_changes = [user_data]
  }
}

# Security Group
resource "aws_security_group" "ubuntu-toolbox-hosts" {
  name        = "${var.environment_name}-ubuntu-toolbox-sg"
  description = "Default security group for ubuntu-toolbox hosts in ${var.environment_name}"
  vpc_id      = aws_vpc.default.id

  #SSH & ICMP & DNS from home
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.home_external_ip]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.public_subnet_cidr_blocks
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.home_cidr_block]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.home_cidr_block]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.home_external_ip]
  }

  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = [var.home_cidr_block]
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment_name}-ubuntu-toolbox-sg"
    Env  = var.environment_name
  }
}

# DNS Names
resource "aws_route53_record" "ubuntu-toolbox" {
  zone_id         = aws_route53_zone.primary.zone_id
  count           = var.ubuntu-toolbox_count
  name            = "ubuntu-toolbox-${count.index}"
  type            = "A"
  ttl             = "300"
  records         = [aws_instance.ubuntu-toolbox[count.index].private_ip]
  allow_overwrite = true
}

# IAM Role
resource "aws_iam_role" "EC2_Ubuntu-Toolbox" {
  name               = "${var.environment_name}_EC2_Ubuntu-Toolbox"
  description        = "Allows EC2 instances to call AWS services on your behalf."
  assume_role_policy = templatefile("${path.module}/templates/ec2-to-aws-services.tpl", {
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ReadOnlyAccess-Ubuntu-Toolbox" {
  role       = aws_iam_role.EC2_Ubuntu-Toolbox.id
  policy_arn = var.AmazonEC2ReadOnlyAccessARN
}

resource "aws_iam_instance_profile" "ubuntu-toolbox" {
  name = "${var.environment_name}_ubuntu-toolbox"
  role = aws_iam_role.EC2_Ubuntu-Toolbox.id
}
