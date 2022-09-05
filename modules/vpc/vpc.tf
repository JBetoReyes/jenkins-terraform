# Creting the VPC and calling it tutorial_vpc
resource "aws_vpc" "jenkins_vpc" {
  # Setting the CIDR block of the VPC to the variable vpc_cidr_block
  cidr_block = var.vpc_cidr_block

  # Enabling DNS hostnames on the VPC
  enable_dns_hostnames = true
  enable_dns_support   = true

  instance_tenancy = "default"

  # Setting the tag Name to tutorial_vpc
  tags = {
    Name = "Jenkins/VPC"
    App  = "Jenkins"
  }
}
