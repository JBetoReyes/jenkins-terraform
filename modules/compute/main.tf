resource "aws_instance" "jenkins_server" {
    ami =  "${data.aws_ami.amazon-linux-2.id}"
    subnet_id = var.public_subnet
    instance_type = var.instance_type
    vpc_security_group_ids  = [var.security_group]
    key_name = var.key_name
    user_data = "${file("${path.module}/install_jenkins_master_docker.sh")}"
    associate_public_ip_address = true
    tags = {
        ENVIRONMENT = "DEVELOPMENT"
        Name = "jenkins_master"
    }
}

resource "aws_instance" "jenkins_node" {
    ami =  "${data.aws_ami.amazon-linux-2.id}"
    subnet_id = var.public_subnet
    instance_type = var.instance_type
    vpc_security_group_ids  = [var.security_group]
    key_name = var.key_name
    user_data = "${file("${path.module}/install_docker_node.sh")}"
    associate_public_ip_address = true
    tags = {
        ENVIRONMENT = "DEVELOPMENT"
        Name = "jenkins_node"
    }
}