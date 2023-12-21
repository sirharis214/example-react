# update private routables with route to NAT
resource "aws_route" "private_1" {
  route_table_id         = data.aws_route_table.main_private_rt_1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1.id
}

resource "aws_route" "private_2" {
  route_table_id         = data.aws_route_table.main_private_rt_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_1.id
}

/*
resource "aws_route" "private_2" {
  route_table_id         = data.aws_route_table.main_private_rt_2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway_2.id
}
*/
