# Create security group for EKS 
resource "aws_security_group" "EKS" {
  name        = "${values(var.tags)[0]}-EKS-SG"
  vpc_id      = aws_vpc.main.id
  description = "EKS attached security group for worker nodes"

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.private.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create security group for private subnet to public subnet traffic
resource "aws_security_group" "private" {
  name        = "${values(var.tags)[0]}-Private-SG"
  vpc_id      = aws_vpc.main.id
  description = "LT attached security group that allows access from public to private subnets"
  tags = {
    Name = "${values(var.tags)[0]}-Private-SG"
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create public to elb security group
resource "aws_security_group" "public" {
  name        = "${values(var.tags)[0]}-Public-SG"
  vpc_id      = aws_vpc.main.id
  description = "ELB attached SG that allows traffic from public to load balancer"
  tags = {
    Name = "${values(var.tags)[0]}-Public-SG"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}