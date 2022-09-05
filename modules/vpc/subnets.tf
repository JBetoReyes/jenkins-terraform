# Subnet for Master jenkins EC2 instance
resource "aws_subnet" "public_subnet" {
  # Creating it inside the vpc
  vpc_id = aws_vpc.jenkins_vpc.id

  # Setting the CIDR block to the variable public_subnet_cidr_block
  cidr_block = var.public_subnet_cidr_block

  # Setting the AZ to the first one in our available AZ data store
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Jenkins/public/subnet"
    App  = "Jenkins"
  }
}

# Subnet for EK8s Ingresses
resource "aws_subnet" "kubernetes_public_subnets" {
  count = 2

  # Creating it inside the vpc
  vpc_id = aws_vpc.jenkins_vpc.id

  # Iterates over public_eks_subnets_cidr_block and creates one per count
  cidr_block = var.public_eks_subnets_cidr_block[count.index]

  # Iterates over the AZ's and creates one per count
  availability_zone = data.aws_availability_zones.available.names[count.index]

  assign_ipv6_address_on_creation = false
  map_public_ip_on_launch         = false

  # Adding tags to enable auto discovery
  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
    Name                                        = "Jenkins/public/subnet-${count.index}/kubernetes/${var.cluster_name}-cluster"
    App                                         = "Jenkins"
  }
}

# Private Subnet for k8s nodes
resource "aws_subnet" "kubernetes_private_subnets" {
  vpc_id                          = aws_vpc.jenkins_vpc.id
  count                           = 2
  cidr_block                      = var.private_eks_subnets_cidr_block[count.index]
  availability_zone               = data.aws_availability_zones.available.names[count.index]
  assign_ipv6_address_on_creation = false
  map_public_ip_on_launch         = false

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"           = "1"
    Name                                        = "Jenkins/private/subnet-${count.index}/kubernetes/${var.cluster_name}-cluster"
    App                                         = "Jenkins"
  }
}