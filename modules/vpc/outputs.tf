output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "kubernetes_public_subnet_ids" {
  description = "IDs of the k8s public subnets"
  value       = aws_subnet.kubernetes_public_subnets.*.id
}

output "kubernetes_private_subnet_ids" {
  description = "IDs of the k8s private subnets"
  value       = aws_subnet.kubernetes_private_subnets.*.id
}

output "vpc_id" {
  description = "ID of our VPC"
  value       = aws_vpc.jenkins_vpc.id
}