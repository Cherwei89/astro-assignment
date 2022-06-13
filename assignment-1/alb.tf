resource "aws_alb" "app-alb" {
  subnets = [aws_subnet.astro-private-app-1.id, aws_subnet.astro-private-app-2.id]
  internal = false
  security_groups = [aws_security_group.astro-app-alb-sg.id]
  depends_on = [aws_internet_gateway.astro-main-gw, aws_vpc_dhcp_options_association.dns_resolver]
}

resource "aws_alb" "web-alb" {
  subnets = [aws_subnet.astro-public-1.id, aws_subnet.astro-public-2.id]
  internal = false
  security_groups = [aws_security_group.astro-web-alb-sg.id]
  depends_on = [aws_internet_gateway.astro-main-gw, aws_vpc_dhcp_options_association.dns_resolver]
}

resource "aws_alb_target_group" "app-target-group" {
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.main.id}"
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    path                = "/"
    interval            = 30
    port                = 80
    matcher             = "200-399"
  }
  stickiness {
    type = "lb_cookie"
    enabled = true
  }
}

resource "aws_alb_target_group" "web-target-group" {
  port = 80
  protocol = "HTTP"
  vpc_id = "${aws_vpc.main.id}"
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    path                = "/"
    interval            = 30
    port                = 80
    matcher             = "200-399"
  }
  stickiness {
    type = "lb_cookie"
    enabled = true
  }
}

# resource "aws_alb_target_group_attachment" "app-attach" {
#   target_group_arn = "${aws_alb_target_group.app-target-group.arn}"
# #   target_id = "${element(aws_instance.wp.*.id, count.index)}"
#   target_id = aws_autoscaling_group.astro-app-autoscaling
#   port = 80
#   count = 2
# }

# resource "aws_alb_target_group_attachment" "web-attach" {
#   target_group_arn = "${aws_alb_target_group.web-target-group.arn}"
# #   target_id = "${element(aws_instance.wp.*.id, count.index)}"
#   target_id = aws_autoscaling_group.astro-app-autoscaling
#   port = 80
#   count = 2
# }

resource "aws_alb_listener" "app-list" {
  default_action {
    target_group_arn = "${aws_alb_target_group.app-target-group.arn}"
    type = "forward"
  }
  load_balancer_arn = "${aws_alb.app-alb.arn}"
  port = 80
}

resource "aws_alb_listener" "web-list" {
  default_action {
    target_group_arn = "${aws_alb_target_group.web-target-group.arn}"
    type = "forward"
  }
  load_balancer_arn = "${aws_alb.web-alb.arn}"
  port = 80
}