# Create launch template
resource "aws_launch_template" "main" {
  name                   = "${values(var.tags)[0]}-Launch-Template"
  image_id               = "ami-0aa7d40eeae50c9a9"
  instance_type          = "t3.medium"
  key_name               = "jimyywang-key"
  user_data              = base64encode(file("userdata.sh"))
  vpc_security_group_ids = [aws_security_group.private.id]
  tags = {
    Name = "${values(var.tags)[0]}-Launch-Template"
  }
}

# Create auto scaling group
resource "aws_autoscaling_group" "main" {
  name                      = "${values(var.tags)[0]}-Autoscaling-Group"
  max_size                  = 4
  min_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  vpc_zone_identifier       = [aws_subnet.private[0].id, aws_subnet.private[1].id]

  launch_template {
    id = aws_launch_template.main.id
  }

  tag {
    key                 = "Name"
    value               = "${values(var.tags)[0]}-Instance"
    propagate_at_launch = true
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
}

resource "aws_alb_listener" "main" {
  load_balancer_arn = aws_alb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.main.arn
    type             = "forward"
  }
}
