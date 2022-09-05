# Creating the public route table and calling it public_rt
resource "aws_route_table" "public_rt" {
  # Creating it inside the jenkins_vpc VPC
  vpc_id = aws_vpc.jenkins_vpc.id

  # Adding the internet gateway to the route table
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins_igw.id
  }

  tags = {
    Name = "Jenkins/public/route-table"
    App  = "Jenkins"
  }
}

# Associating our public subnet with our public route table
resource "aws_route_table_association" "public" {
  # The ID of our public route table called public_rt
  route_table_id = aws_route_table.public_rt.id

  # The ID of our public subnet called public_subnet
  subnet_id = aws_subnet.public_subnet.id
}

# Associating our public subnet with our public route table
resource "aws_route_table_association" "kubernetes_public" {
  count = 2
  # The ID of our public route table called public_rt
  route_table_id = aws_route_table.public_rt.id

  # The ID of our public subnet called kubernetes_public_subnets
  subnet_id = aws_subnet.kubernetes_public_subnets[count.index].id
}

# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.jenkins_vpc.id

  # Adding the nat gateway to the route table
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "Jenkins/private/route-table"
    App  = "Jenkins"
  }
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = aws_subnet.kubernetes_private_subnets[count.index].id
  route_table_id = aws_route_table.private_rt.id
}