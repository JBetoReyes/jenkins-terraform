# Creating the Internet Gateway and naming it tutorial_igw
resource "aws_internet_gateway" "jenkins_igw" {
  # Attaching it to the VPC called jenkins_vpc
  vpc_id = aws_vpc.jenkins_vpc.id

  # Setting the Name tag to tutorial_igw
  tags = {
    Name = "Jenkins/internet-gateway"
    App  = "Jenkins"
  }
}
