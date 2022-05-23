resource "aws_security_group" "alb" {
  name        = "terraform_alb_security_group"
  description = "Terraform load balancer security group"
  vpc_id      = var.vpc_id
  dynamic "ingress" {
    for_each = var.ingress_alb
    content {
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = module.tags.commontags

  
}
/*************************************
* Application load balancer
*************************************/

resource "aws_alb" "alb" {
  name            = "Dev-alb"
  security_groups = ["${aws_security_group.alb.id}"]
  subnets         = data.aws_subnet_ids.subnets.ids
  internal           = var.internal
  load_balancer_type = "application"

  enable_cross_zone_load_balancing = var.cross_zone_load_balancing_enabled
  enable_http2                     = var.http2_enabled
  idle_timeout                     = var.idle_timeout
  ip_address_type                  = var.ip_address_type
  enable_deletion_protection       = var.deletion_protection_enabled
  drop_invalid_header_fields       = var.drop_invalid_header_fields
  depends_on = [
    aws_security_group.alb
  ]
}

resource "aws_alb_target_group" "group" {
  name     = "Dev-alb-target"
  port     = 8080
  protocol = "HTTP"
  protocol_version = "HTTP1"
  vpc_id   = var.vpc_id
  target_type          = var.target_group_target_type
  deregistration_delay = var.deregistration_delay
  
  
  # Alter the destination of the health check to be the login page.
  health_check {
    protocol            = var.target_group_protocol
    path                = var.health_check_path
    port                = var.health_check_port
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
  }

  lifecycle {
    create_before_destroy = true
  }
  tags = module.tags.commontags
}



resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.group.arn
    type             = "forward"
  }
}

resource "aws_alb_listener" "listener_https" {
  count = var.https_enabled  ? 1 : 0
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy      = var.https_ssl_policy
  certificate_arn = var.certificate_arn
  default_action {
    target_group_arn = aws_alb_target_group.group.arn
    type             = "forward"
  }
}
  
  
resource "aws_lb_listener_certificate" "https_sni" {
  count = var.https_enabled  ? 1 : 0
  listener_arn    = join("", aws_alb_listener.listener_https.*.arn)
  certificate_arn = var.additional_certs[count.index]
}

  
