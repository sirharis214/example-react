# Subnets

Below are examples of the public and private subnets you should create for this project along with the route tables that should be associated with each.

It is assumed that at this stage you only have a VPC with a Internet Gateway attached to it. We will create the following resources:

* 2 public subnets and their route tables
    - include a route to Internet Gateway
* 2 private subnets and their route tables

> Later in the project we will create NAT gateways that will sit in the public subnets. We will update the private subnets to include a route to their NAT gateway.

## Terraform examples

### 2 public subnets

You must have the VPC ID and Internet Gateway ID available, best to include it as a local or input variable.

```hcl 
locals = {
    vpc_id = "vpc-123abc123abc"
    internet_gateway_id = "igw-123abc123abc"
}

resource "aws_subnet" "public_1" {
  vpc_id                  = local.vpc_id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = merge(local.tags, { Name = "public-subnet-1" })
}

resource "aws_subnet" "public_2" {
  vpc_id                  = local.vpc_id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = merge(local.tags, { Name = "public-subnet-2" })
}
```

### public subnet route table

Include local routes and routes to the internet gateway.

```hcl
locals = {
    vpc_id = "vpc-123abc123abc"
    internet_gateway_id = "igw-123abc123abc"
}

resource "aws_route_table" "public" {
  vpc_id = local.vpc_id

  # local
  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  # to internet
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = local.internet_gateway_id
  }

  tags = merge(local.tags, { Name = "public-rt" })
}

# attach public route table to both public subnets

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}
```

### 2 private subnets

```hcl
locals = {
    vpc_id = "vpc-123abc123abc"
}

resource "aws_subnet" "private_1" {
  vpc_id            = local.vpc_id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = merge(local.tags, { Name = "private-subnet-1" })
}

resource "aws_subnet" "private_2" {
  vpc_id            = local.vpc_id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"

  tags = merge(local.tags, { Name = "private-subnet-2" })
}
```

### private subnet route table

We will later create NAT gateways in the public subnets after which we can include a route in the private subnets to their NAT gateway.

```hcl
locals = {
    vpc_id = local.vpc_id
}

resource "aws_route_table" "private_1" {
  vpc_id = local.vpc_id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  # If we were to create NAT gateways now and include the route
  # route would look like this
  /*
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private_1.id
  }
  */

  tags = merge(local.tags, { Name = "private-rt-1" })
}

resource "aws_route_table" "private_2" {
  vpc_id = local.vpc_id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }

  # If we were to create NAT gateways now and include the route
  # route would look like this
  /*
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private_2.id
  }
  */

  tags = merge(local.tags, { Name = "private-rt-2" })
}

# attach private route tables to private subnets

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_1.id
}
```

> Notice unlike public subnets where we created a single route table and attached it to both subnets, the private subnets get their own route tables because we want to later add routes to a NAT gateways which will be 1:1 with each private subnet.
