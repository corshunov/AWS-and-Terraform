resource "aws_lb" "web" {
  name                        = "web-lb"
  internal                    = false
  load_balancer_type          = "application"
  subnets                     = var.subnet_ids
  security_groups             = [aws_security_group.web.id]
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port               = 80
  protocol           = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

resource "aws_lb_target_group" "web" {
  name = "web"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    enabled = true
    path = "/"
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 60
  }
}

resource "aws_lb_target_group_attachment" "web" {
  count = length(aws_instance.web)
  target_group_arn = aws_lb_target_group.web.id
  target_id = aws_instance.web.*.id[count.index]
  port = 80
}
