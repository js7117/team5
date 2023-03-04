# Create launch template
resource "aws_launch_template" "main" {
  name                   = "${values(var.tags)[0]}-Launch-Template"
  image_id               = "ami-0557a15b87f6559cf"
  instance_type          = "t3.medium"
  # user_data              = base64encode(file("userdata.sh"))
  vpc_security_group_ids = [aws_security_group.nodes.id]
  tags = {
    Name = "${values(var.tags)[0]}-Launch-Template"
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 20
      volume_type = "gp3"
      delete_on_termination = true
    }
  }
}

# Create ELB for the public subnets
resource "aws_alb" "main" {
  name            = "${values(var.tags)[0]}-ALB"
  internal        = false
  security_groups = [aws_security_group.public.id]
  subnets         = [aws_subnet.public[0].id, aws_subnet.public[1].id]
  tags = {
    Name = "${values(var.tags)[0]}-ALB"
  }
}

resource "aws_alb_target_group" "main" {
  name     = "${values(var.tags)[0]}-Target-Group"
  port     = "80"
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    path                = "/"
  }
}

resource "aws_alb_listener_rule" "eks" {
  listener_arn = aws_alb_listener.main.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }

  depends_on = [aws_alb_listener.main]
}

resource "aws_alb_listener" "main" {
  load_balancer_arn = aws_alb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.main.arn
    type             = "forward"
  }

  depends_on = [aws_alb.main]
}
