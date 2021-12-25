resource "aws_lb" "web_lb" {
  name                        = "web_lb_${aws_vpc.vpc.id}"
  internal                    = false
  load_balancer_type          = "application"
  subnets                     = aws_subnet.public.*.id
  security_groups             = [aws_security_group.sg_web.id]
}

resource "aws_lb_listener" "web_lb_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port               = 80
  protocol           = "http"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}

resource "aws_lb_target_group" "web_target_group" {
  name = "web_target_group"
  port = 80
  protocol = "http"
  vpc_id = aws_vpc.vpc.id

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