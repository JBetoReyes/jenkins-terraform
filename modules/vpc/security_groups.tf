resource "aws_security_group" "eks-cluster" {
  name   = "SG-eks-cluster"
  vpc_id = aws_vpc.jenkins_vpc.id

  # Egress allows Outbound traffic from the EKS cluster to the  Internet 

  egress { # Outbound Rule
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Ingress allows Inbound traffic to EKS cluster from the  Internet 

  ingress { # Inbound Rule
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}