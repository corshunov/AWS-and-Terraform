resource "aws_lb" "web_lb" {
  name                        = "web-lb-${var.vpc_id}"
  internal                    = false
  load_balancer_type          = "application"
  subnets                     = var.subnet_ids
  security_groups             = [aws_security_group.web.id]
}

resource "aws_lb_listener" "web_lb_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port               = 80
  protocol           = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}

resource "aws_lb_target_group" "web_target_group" {
  name = "web"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    enabled = true
    path = "/"
  }
}

resource "aws_lb_target_group_attachment" "web_target_group_attachment" {
  count = length(aws_instance.web)
  target_group_arn = aws_lb_target_group.web_target_group.id
  target_id = aws_instance.web.*.id[count.index]
  port = 80
}
