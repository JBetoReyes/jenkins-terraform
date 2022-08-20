resource "aws_instance" "jenkins_server" {
    ami =  "${data.aws_ami.amazon-linux-2.id}"
    subnet_id = var.public_subnet
    instance_type = var.instance_type
    vpc_security_group_ids  = [var.security_group]
    key_name = var.key_name
    user_data = "${data.template_file.master_docker_user_data.rendered}"
    associate_public_ip_address = true
    iam_instance_profile = aws_iam_instance_profile.jenkins_master_instance_profile.name
    tags = {
        ENVIRONMENT = "DEVELOPMENT"
        Name = "jenkins_master"
    }
    # We need to wait for our node to be able to connect with it
    depends_on = [
        aws_instance.jenkins_node
    ]
}

resource "aws_instance" "jenkins_node" {
    ami =  "${data.aws_ami.amazon-linux-2.id}"
    subnet_id = var.public_subnet
    instance_type = var.instance_type
    vpc_security_group_ids  = [var.security_group]
    key_name = var.key_name
    user_data = "${data.template_file.docker_node_user_data.rendered}"
    associate_public_ip_address = true
    tags = {
        ENVIRONMENT = "DEVELOPMENT"
        Name = "jenkins_node"
    }
}