resource "aws_launch_template" "this" {
  name_prefix = "${local.name}-"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "none"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_stop        = false
  disable_api_termination = false
  ebs_optimized           = false

  iam_instance_profile {
    name = "main-ec2-profile"
  }

  image_id                             = data.aws_ami.amazon_linux_2.id
  key_name                             = "main-us-east-1"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"

  monitoring {
    enabled = false
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.asg.id]
  }

  placement {
    tenancy = "default"
  }

  tag_specifications {
    resource_type = "instance"
    tags          = local.tags
  }

  user_data = filebase64("${path.module}/files/user_data_script.sh")

  tags = local.tags
}
