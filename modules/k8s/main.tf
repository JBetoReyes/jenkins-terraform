module "aws_eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.29"

  cluster_name    = var.cluster_name
  cluster_version = "1.22"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  vpc_id     = var.vpc_id
  subnet_ids = var.subnets_ids

  # eks_managed_node_group_defaults = {
  #     remote_access = {
  #         ec2_ssh_key = var.key_name
  #     }
  # }

  eks_managed_node_groups = {
    one = {
      ami_type = "AL2_x86_64"
      name     = "node-group-1"
      # create_launch_template = "false"

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"

      min_size     = 1
      max_size     = 3
      desired_size = 2

      network_interfaces = [{
        delete_on_termination       = true
        associate_public_ip_address = true
      }]

      # vpc_security_group_ids = [
      #     aws_security_group.node_group_one.id
      # ]
    }
  }
}

# resource "aws_eks_cluster" "eks_cluster" {
#   name     = "jenkins/k8s/cluster"
#   role_arn =  "${aws_iam_role.eks_cluster_role.arn}"
#   version  = "1.22"

# # Adding VPC Configuration

#     vpc_config {             # Configure EKS with vpc and network settings 
#         security_group_ids = ["${aws_security_group.eks-cluster.id}"]
#         subnet_ids         = ["subnet-1312586","subnet-8126352"] 
#     }

#   depends_on = [
#     "aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy",
#     "aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy",
#    ]
# }

# resource "aws_eks_node_group" "node_group_1" {
#     cluster_name = module.aws_eks_cluster.cluster_id
#     node_group_name = "node-group-1"
#     instance_types = ["t3.medium"]
#     capacity_type  = "SPOT"
#     subnet_ids = var.subnets_ids
#     node_role_arn = module.aws_eks_cluster.role

#     scaling_config {
#         desired_size = 2
#         max_size     = 3
#         min_size     = 1
#     }

#     remote_access = {
#         ec2_ssh_key = var.key_name
#     }

#     depends_on = [
#       module.aws_eks_cluster
#     ]
# }