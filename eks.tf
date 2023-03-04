# Create an EKS cluster
resource "aws_eks_cluster" "main" {
  name     = "${values(var.tags)[0]}-EKS-Cluster"
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids = [aws_subnet.private[0].id, aws_subnet.private[1].id]
    endpoint_private_access = true
    endpoint_public_access = true
  }

  depends_on = [aws_iam_role.eks, aws_iam_role_policy_attachment.eks_access_policy]
}

# Create EKS node group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${values(var.tags)[0]}-Node-Group"
  

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  depends_on    = [aws_launch_template.main, 
                   aws_iam_role.eks_node_group,
                   aws_iam_role_policy_attachment.eks_node_group_policy_attachment,
                   aws_iam_role_policy_attachment.ecr_policy_attachment,
                   aws_iam_role_policy_attachment.ssm_policy_attachment,
                   aws_iam_role_policy_attachment.eks_cni_policy_attachment]
  subnet_ids    = [aws_subnet.private[0].id, aws_subnet.private[1].id]
  node_role_arn = aws_iam_role.eks_node_group.arn

  tags = {
    Name = "${values(var.tags)[0]}-Node-Group"
  }
}