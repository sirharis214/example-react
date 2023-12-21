locals {
  default_region = "us-east-1"
  name           = "example-react"
  my_ip          = jsondecode(data.http.my_public_ip.response_body)
  vpc_id         = data.aws_vpcs.main_vpc.ids[0]

  tags = {
    Name        = "${local.name}"
    module_repo = "https://github.com/sirharis214/example-react"
  }
}
