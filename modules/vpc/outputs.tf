output "public_subnet_id" {
    description = "ID of the public subnet"
    value = aws_subnet.public_subnet.id
}

output "vpc_id" {
    description = "ID of our VPC"
    value = aws_vpc.jenkins_vpc.id
}