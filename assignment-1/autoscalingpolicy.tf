# scale up alarm

resource "aws_autoscaling_policy" "astro-app-cpu-policy" {
  name                   = "astro-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.astro-app-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_autoscaling_policy" "astro-web-cpu-policy" {
  name                   = "astro-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.astro-web-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "astro-app-cpu-alarm" {
  alarm_name          = "astro-app-cpu-alarm"
  alarm_description   = "astro-app-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.astro-app-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.astro-app-cpu-policy.arn]
}

resource "aws_cloudwatch_metric_alarm" "astro-web-cpu-alarm" {
  alarm_name          = "astro-web-cpu-alarm"
  alarm_description   = "astro-web-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.astro-web-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.astro-web-cpu-policy.arn]
}

# scale down alarm
resource "aws_autoscaling_policy" "astro-app-cpu-policy-scaledown" {
  name                   = "astro-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.astro-app-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_autoscaling_policy" "astro-web-cpu-policy-scaledown" {
  name                   = "astro-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.astro-web-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "astro-app-cpu-alarm-scaledown" {
  alarm_name          = "astro-app-cpu-alarm-scaledown"
  alarm_description   = "astro-app-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.astro-app-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.astro-app-cpu-policy-scaledown.arn]
}

resource "aws_cloudwatch_metric_alarm" "astro-web-cpu-alarm-scaledown" {
  alarm_name          = "astro-web-cpu-alarm-scaledown"
  alarm_description   = "astro-web-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.astro-web-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.astro-web-cpu-policy-scaledown.arn]
}
