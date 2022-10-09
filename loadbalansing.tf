#==========Target=Group======================================================
resource "aws_lb_target_group" "wagtail_tg" {
  name     = "targetgroup"
  port     = var.lb_tg_port
  protocol = var.lb_tg_protocol
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    port                = var.lb_tg_port
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
    matcher             = "400" # healthcheck is configured on 400code because app require additional setup 
  }

  tags = merge(var.common_tags, { Name = "${local.name}-Target-Group" })

  depends_on = [
    module.ec2_server
  ]
}

resource "aws_lb_target_group_attachment" "wagtail_tg_attachment" {
  count            = length(module.ec2_server.aws_instance_id)
  target_group_arn = aws_lb_target_group.wagtail_tg.arn
  target_id        = module.ec2_server.aws_instance_id[count.index]
  port             = var.lb_tg_port

  depends_on = [
    aws_lb_target_group.wagtail_tg
  ]
}
#==========Load=Balanser======================================================
resource "aws_lb" "wagtail_lb" {
  name               = "wagtailloadbalanser"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [data.aws_subnets.default.ids[0], data.aws_subnets.default.ids[1]]

  depends_on = [
    aws_lb_target_group_attachment.wagtail_tg_attachment
  ]

  tags = merge(var.common_tags, { Name = "${local.name}-Load-Balancer" })
}

resource "aws_lb_listener" "wagtail_lb_listener" {
  load_balancer_arn = aws_lb.wagtail_lb.arn
  port              = var.lb_tg_port
  protocol          = var.lb_tg_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wagtail_tg.arn
  }

  depends_on = [
    aws_lb.wagtail_lb
  ]
}
#==========Route53=Record======================================================
resource "aws_route53_record" "wagtail" {
  zone_id = data.aws_route53_zone.vln.id
  name    = var.common_tags["Environment"] == "prod" ? "wagtail" : "wagtail-${var.common_tags["Environment"]}"
  type    = "A"

  alias {
    name                   = aws_lb.wagtail_lb.dns_name
    zone_id                = aws_lb.wagtail_lb.zone_id
    evaluate_target_health = true
  }

  depends_on = [
    aws_lb.wagtail_lb
  ]
}