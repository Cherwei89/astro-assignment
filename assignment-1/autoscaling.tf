resource "aws_launch_configuration" "astro-app-launchconfig" {
  name_prefix     = "astro-app-launchconfig"
  image_id        = var.AMIS[var.AWS_REGION]
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.astro-key-pair.key_name
  security_groups = [aws_security_group.astro-app-alb-sg.id]
  user_data = filebase64("userdata_app.sh")
  associate_public_ip_address = false
  iam_instance_profile = aws_iam_instance_profile.s3-astro-role-instanceprofile.name
}

resource "aws_launch_configuration" "astro-web-launchconfig" {
  name_prefix     = "astro-web-launchconfig"
  image_id        = var.AMIS[var.AWS_REGION]
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.astro-key-pair.key_name
  security_groups = [aws_security_group.astro-web-alb-sg.id]
  associate_public_ip_address = true
  user_data = filebase64("userdata_web.sh")
}


resource "aws_autoscaling_group" "astro-app-autoscaling" {
  name                      = "astro-app-autoscaling"
  vpc_zone_identifier       = [aws_subnet.astro-private-app-1.id, aws_subnet.astro-private-app-2.id]
  launch_configuration      = aws_launch_configuration.astro-app-launchconfig.name
  target_group_arns         = [aws_alb_target_group.app-target-group.arn]
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  # load_balancers            = [aws_alb.app-alb.name]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "App Tier"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "astro-web-autoscaling" {
  name                      = "astro-web-autoscaling"
  vpc_zone_identifier       = [aws_subnet.astro-public-1.id, aws_subnet.astro-public-2.id]
  launch_configuration      = aws_launch_configuration.astro-web-launchconfig.name
  target_group_arns         = [aws_alb_target_group.web-target-group.arn]
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
  # load_balancers            = [aws_alb.web-alb.name]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "Web Tier"
    propagate_at_launch = true
  }
}

