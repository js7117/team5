# # Create an EKS cluster
# resource "aws_eks_cluster" "main" {
#     name = "${values(var.tags)[0]}-EKS"
#     role_arn = "arn:aws:iam::257248662189:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS"

#     vpc_config {
#       subnet_ids = [aws_subnet.private[0].id, aws_subnet.private[1].id]
#     }
# }