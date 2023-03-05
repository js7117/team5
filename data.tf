# Define availablility zone data
data "aws_availability_zones" "available" {
  state = "available"
}

# Define EKS node AMI
data "aws_ssm_parameter" "eks_ami" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.main.version}/amazon-linux-2/recommended/image_id"
}

# Define IAM policy document
data "aws_iam_policy_document" "eks_worker_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}