# Security Group for ASG by adding to Launch Template
resource "aws_security_group" "asg" {
  name_prefix = "${local.name}-asg-"
  description = "ASG security group for ${local.name}."
  vpc_id      = local.vpc_id

  # HTTP from ALB
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    security_groups = [
      aws_security_group.alb.id,
    ]
    description = "Allow incoming HTTP from Load balancer"
  }

  # HTTPS from ALB
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    security_groups = [
      aws_security_group.alb.id,
    ]
    description = "Allow incoming HTTPS from Load balancer"
  }

  # Allow SSH from any internal instance in the VPC
  # I use a public EC2 instance to SSH into instances created by ASG
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    # public EC2 instance is under this security group which was NOT created for the purpose of this project
    security_groups = [
      "sg-077d89eca08b13f9e",
    ]
    description = "Allows SSH from instances under that SG, (main-instance)."
  }

  # Ingress rule for SSH (port 22) restricted to your current public IP address
  /*ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${local.my_ip.ip}/32"]
  }*/

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # Allow all outgoing traffic
    cidr_blocks = ["0.0.0.0/0"] # Allow outgoing traffic to anywhere
    description = "Allow all outbound traffic"
  }

  tags = local.tags
}
