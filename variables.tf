variable "aws_region" {}
variable "instance_type" {}
variable "key_name" {}
variable "bucket_name" {
  description = "jenkins bucket for script files"
}
variable "github_token" {
  description = "token to automate webhook initialization"
}
variable "docker_hub_user" {}
variable "docker_hub_password" {}
variable "cluster_name" {}

# VPC variables
variable "vpc_cidr_block" {
  description = "VPC main CIDR block"
}
variable "public_subnet_cidr_block" {
  description = "CIDR block for ec2 instances subnets"
}
variable "private_eks_subnets_cidr_block" {
  description = "cidr block list for eks private subnets"
  type        = list(string)
}
variable "public_eks_subnets_cidr_block" {
  description = "cidr block list for eks public subnets"
  type        = list(string)
}