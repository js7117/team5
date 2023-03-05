# Create security group for EKS 
resource "aws_security_group" "EKS" {
  name        = "${values(var.tags)[0]}-EKS-SG"
  vpc_id      = aws_vpc.main.id
  description = "EKS attached security group for worker nodes"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "EKS1" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.EKS.id
  self              = true
  depends_on        = [aws_security_group.EKS, aws_security_group.nodes]
}

resource "aws_security_group_rule" "EKS2" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.EKS.id
  source_security_group_id = aws_security_group.nodes.id
  depends_on               = [aws_security_group.EKS, aws_security_group.nodes]
}

resource "aws_security_group_rule" "EKS3" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.EKS.id
  source_security_group_id = aws_security_group.nodes.id
  depends_on               = [aws_security_group.EKS, aws_security_group.nodes]
}

# Create security group for node group
resource "aws_security_group" "nodes" {
  name        = "${values(var.tags)[0]}-Nodes-SG"
  vpc_id      = aws_vpc.main.id
  description = "LT attached security group that allows cluster and nodes to communicate"
  tags = {
    Name = "${values(var.tags)[0]}-Nodes-SG"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "nodes1" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  security_group_id = aws_security_group.nodes.id
  self              = true
  depends_on        = [aws_security_group.EKS, aws_security_group.nodes]
}

resource "aws_security_group_rule" "nodes2" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.nodes.id
  source_security_group_id = aws_security_group.EKS.id
  depends_on               = [aws_security_group.EKS, aws_security_group.nodes]
}

resource "aws_security_group_rule" "nodes3" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.nodes.id
  cidr_blocks       = ["0.0.0.0/0"]
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