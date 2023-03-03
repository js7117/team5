# Create an EKS cluster
resource  "aws_eks_cluster" "main" {
    name = "${values(var.tags)[0]}-EKS-Cluster"
    role_arn = aws_iam_role.eks.arn

    vpc_config {
        subnet_ids = [aws_subnet.private[0].id, aws_subnet.private[1].id]
    }

    depends_on = [aws_iam_role.eks]
}

# Create EKS node group
resource "aws_eks_node_group" "main" {
    cluster_name = aws_eks_cluster.main.name
    node_group_name = "${values(var.tags)[0]}-Node-Group"

    scaling_config {
        desired_size = 2
        max_size = 4
        min_size = 2
    }

    launch_template {
      id = aws_launch_template.main.id
      version = "$Latest"
    }

    depends_on = [aws_launch_template.main]
    subnet_ids = [aws_subnet.private[0].id, aws_subnet.private[1].id]
    node_role_arn = "arn:aws:iam::257248662189:role/aws-service-role/eks-nodegroup.amazonaws.com/AWSServiceRoleForAmazonEKSNodegroup"

    tags = {
        Name = "${values(var.tags)[0]}-Node-Group"
    }
}

# Create EKS role
resource "aws_iam_role" "eks" {
  name = "${values(var.tags)[0]}-eks-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks.name
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks.name
}

resource "aws_iam_role_policy_attachment" "eks_vpc_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks.name
}
