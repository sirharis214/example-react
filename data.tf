data "aws_region" "this" {}
data "aws_caller_identity" "this" {}

data "aws_vpcs" "main_vpc" {
  # You can filter the VPCs based on certain criteria, e.g., by name or tags.
  tags = {
    Name = "main-vpc"
  }
}

data "aws_subnet" "main_public_subnet_1" {
  vpc_id = data.aws_vpcs.main_vpc.ids[0]

  tags = {
    Name = "main-public-subnet-1"
  }
}

data "aws_subnet" "main_public_subnet_2" {
  vpc_id = data.aws_vpcs.main_vpc.ids[0]

  tags = {
    Name = "main-public-subnet-2"
  }
}

data "aws_subnet" "main_private_subnet_1" {
  vpc_id = data.aws_vpcs.main_vpc.ids[0]

  tags = {
    Name = "main-private-subnet-1"
  }
}

data "aws_subnet" "main_private_subnet_2" {
  vpc_id = data.aws_vpcs.main_vpc.ids[0]

  tags = {
    Name = "main-private-subnet-2"
  }
}

data "aws_route_table" "main_private_rt_1" {
  subnet_id = data.aws_subnet.main_private_subnet_1.id
}

data "aws_route_table" "main_private_rt_2" {
  subnet_id = data.aws_subnet.main_private_subnet_2.id
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

data "http" "my_public_ip" {
  #url = "https://ifconfig.co/json"
  url = "https://ipinfo.io/json"
  request_headers = {
    Accept = "application/json"
  }
}
