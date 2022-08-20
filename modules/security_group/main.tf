resource "aws_security_group" "jenkins_sg" {
    name = "jenkins_sg"
    description = "Security group for Jenkins server"
    vpc_id = var.vpc_id

    ingress {
        description = "Allow access to jenkins from internet"
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "SSH access port"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        description = "All outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        ENVIRONMENT = "DEVELOPMENT"
    }
}
