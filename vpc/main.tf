/*
  VPC Definitions
  A key construct:
    There is a one to one mapping between public and private subnets, which means there is always an equal number of private and public subnets
    Each private subnet requires a NAT gateway and corresponding Elastic IP to get out to the public internet
    The NAT gateway for a private subnet actually lives in the public subnet
    Each public/private subnet pairing should be on a different availability zone from other pairings
    There is only 1 Internet Gateway per VPC
    There is only 1 Customer Gateway per region.  This Customer Gateway is shared with each VPC in each AWS region.
    There is only 1 Virtual Private Gateway per VPC
    There are 2 VPN Connections per VPC as AWS builds 2 for redundancy.  To setup for Ubiquiti Unifi follow:  https://community.ubnt.com/t5/UniFi-Routing-Switching/USG-Pro-4-Site-to-Site-IPsec-AWS-using-WAN2/m-p/2585456
  To see what would be done:  terraform plan -var-file terraform.tfvars
  To implement:  terraform apply -var-file terraform.tfvars
  To remove everything defined:  terraform destroy -var-file terraform.tfvars
  Always do a "plan" first to see what will change, if some things are already there it will show you the changes
  The "destroy" will remove everything defined below
  **********************
  If you have built a VPC by hand and run terraform against it, terraform will build a new VPC even if you have defined everything the same
  **********************
*/

resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.environment_name
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = var.environment_name
  }
}

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "${var.environment_name}_${var.vpn_gateway_endpoint}"
  }
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)

  map_public_ip_on_launch = "true"
  vpc_id                  = aws_vpc.default.id
  cidr_block              = element(var.public_subnet_cidr_blocks, count.index)
  availability_zone       = element(var.public_subnet_avail_zones, count.index)

  tags = {
    Name = element(var.public_subnet_names, count.index)
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.default.id
  cidr_block        = element(var.private_subnet_cidr_blocks, count.index)
  availability_zone = element(var.private_subnet_avail_zones, count.index)

  tags = {
    "Name" = element(var.private_subnet_names, count.index)
  }
}

/*
resource "aws_default_subnet" "default_private_subnet" {
  availability_zone = "ca-central-1a"
    tags = {
      Name = "Default subnet for ca-central-1"
    }
}
*/

resource "aws_eip" "nat" {
  count = length(var.private_subnet_cidr_blocks)

  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  count = length(var.private_subnet_cidr_blocks)

  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  depends_on    = [aws_internet_gateway.gw]

  tags = {
    Name = element(var.private_subnet_names, count.index)
  }
}

resource "aws_route_table" "public" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id = aws_vpc.default.id

  tags = {
    Name = element(var.public_subnet_names, count.index)
  }
}

resource "aws_route" "public" {
  count = length(var.public_subnet_cidr_blocks)

  route_table_id         = element(aws_route_table.public.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route" "public_vpn_cidr" {
  count = length(var.public_subnet_cidr_blocks)

  route_table_id         = element(aws_route_table.public.*.id, count.index)
  destination_cidr_block = var.home_cidr_block
  gateway_id             = aws_vpn_gateway.vpn_gw.id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_blocks)

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}

resource "aws_route_table" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id = aws_vpc.default.id

  tags = {
    Name = element(var.private_subnet_names, count.index)
  }
}

resource "aws_route" "private" {
  count = length(var.private_subnet_cidr_blocks)

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.private]
  nat_gateway_id         = element(aws_nat_gateway.nat_gw.*.id, count.index)
}

resource "aws_route" "private_vpn_cidr" {
  count = length(var.private_subnet_cidr_blocks)

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = var.home_cidr_block
  gateway_id             = aws_vpn_gateway.vpn_gw.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr_blocks)

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_security_group" "sg_default" {
  name        = var.sg_name_default
  description = var.sg_description_default

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  vpc_id = aws_vpc.default.id

  tags = {
    Name = var.sg_name_default
  }
}

resource "aws_route53_zone" "primary" {
  name = "${var.environment_name}.${var.route53_private_zone_name}."
  vpc {
    vpc_id = aws_vpc.default.id
  }
  comment = var.environment_name
}
