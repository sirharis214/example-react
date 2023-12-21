resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = data.aws_subnet.main_public_subnet_1.id

  tags = merge(local.tags, { Name = "${local.name}-nat-gateway-1" })
}

resource "aws_eip" "nat_eip_1" {
  tags = merge(local.tags, { Name = "${local.name}-nat-eip-1" })
}

/*
resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = data.aws_subnet.main_public_subnet_2.id

  tags = merge(local.tags, { Name = "${local.name}-nat-gateway-2" })
}

resource "aws_eip" "nat_eip_2" {
  tags = merge(local.tags, { Name = "${local.name}-nat-eip-2" })
}
*/