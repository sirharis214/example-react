resource "aws_autoscaling_group" "this" {
  name = local.name

  health_check_type         = "ELB"
  health_check_grace_period = 300

  desired_capacity = 1
  max_size         = 2
  min_size         = 1

  vpc_zone_identifier = [
    data.aws_subnet.main_private_subnet_1.id,
    data.aws_subnet.main_private_subnet_2.id,
  ]

  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.this.arn
  ]

  tag {
    key                 = "Name"
    value               = local.name
    propagate_at_launch = true
  }

  depends_on = [ aws_lb.this ]
}
