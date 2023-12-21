# Security Group for ALB
resource "aws_security_group" "alb" {
  name_prefix = "${local.name}-alb-"
  description = "ALB security group for ${local.name}."
  vpc_id      = local.vpc_id

  # HTTP - we would redirect HTTP to HTTPS but we havn't setup certs + domain name etc.
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow incoming traffic from anywhere
    description = "Allow incoming HTTP from anywhere"
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow incoming traffic from anywhere
    description = "Allow incoming HTTPS from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # Allow all outgoing traffic
    cidr_blocks = ["0.0.0.0/0"] # Allow outgoing traffic to anywhere
    description = "Allow all outbound traffic"
  }

  tags = local.tags
}
