resource "aws_lb" "this" {
  name               = local.name
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.alb.id,
  ]
  subnets = [
    data.aws_subnet.main_public_subnet_1.id,
    data.aws_subnet.main_public_subnet_2.id,
  ]

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
  enable_http2                     = true

  tags = local.tags
}

resource "aws_lb_target_group" "this" {
  name        = local.name
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = local.vpc_id

  health_check {
    path = "/"
  }

  tags = local.tags
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  tags = local.tags
}
