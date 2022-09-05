# Elastic-IP (eip) for NAT
resource "aws_eip" "nat_eip" {
  vpc              = true
  public_ipv4_pool = "amazon"
  depends_on       = [aws_internet_gateway.jenkins_igw]
  tags = {
    Name = "Jenkins/public/nat-eip"
    App  = "Jenkins"
  }
}

# NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.kubernetes_public_subnets[0].id

  tags = {
    Name = "Jenkins/public/nat"
    App  = "Jenkins"
  }
}