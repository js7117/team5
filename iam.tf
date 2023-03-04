# Create EKS role with the appropriate policies
resource "aws_iam_role" "eks" {
  name = "${values(var.tags)[0]}-eks-role"

  assume_role_policy = jsonencode({
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Effect" = "Allow"
        "Principal" = {
          "Service" = "eks.amazonaws.com"
        }
        "Action" = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "eks_access_policy" {
  name        = "${values(var.tags)[0]}-eks-cluster-policy"
  path        = "/"
  description = "IAM policy for EKS cluster access"

  policy = jsonencode({
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Effect" = "Allow",
        "Action": [
            "eks:ListFargateProfiles",
            "eks:DescribeNodegroup",
            "eks:ListNodegroups",
            "eks:ListUpdates",
            "eks:AccessKubernetesApi",
            "eks:ListAddons",
            "eks:DescribeCluster",
            "eks:DescribeAddonVersions",
            "eks:ListClusters",
            "eks:ListIdentityProviderConfigs",
            "iam:ListRoles"
        ],
        "Resource" = "*"
      },
      {
    "Effect": "Allow",
    "Action": "ssm:GetParameter",
    "Resource": "arn:aws:ssm:*:257248662189:parameter/*"
      }
    ]
  })
}

resource "aws_iam_policy" "cloud_watch" {
  name = "${values(var.tags)[0]}-eks-cloud-watch-policy"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cloudwatch:PutMetricData"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
  })
}

resource "aws_iam_policy" "elb_perm" {
  name = "${values(var.tags)[0]}-eks-elb-policy"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeInternetGateways"
            ],
            "Resource": "*",
            "Effect": "Allow"
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

resource "aws_iam_role_policy_attachment" "eks_CSI_policy" {
  policy_arn = "arn:aws:iam::257248662189:policy/AmazonEKS_EFS_CSI_Driver_Policy"
  role = aws_iam_role.eks.name
}

resource "aws_iam_role_policy_attachment" "eks_access_policy" {
  policy_arn = aws_iam_policy.eks_access_policy.arn
  role       = aws_iam_role.eks.name
}

resource "aws_iam_role_policy_attachment" "eks_cloud_watch" {
  policy_arn = aws_iam_policy.cloud_watch.arn
  role = aws_iam_role.eks.name
}

resource "aws_iam_role_policy_attachment" "eks_elb_perm" {
  policy_arn = aws_iam_policy.elb_perm.arn
  role = aws_iam_role.eks.name
}

# Create EKS node group role with appropriate policies
resource "aws_iam_role" "eks_node_group" {
  name = "${values(var.tags)[0]}-eks-node-group"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_node_group_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group.name
}

