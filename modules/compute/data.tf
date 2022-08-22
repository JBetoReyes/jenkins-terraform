data "aws_ami" "amazon-linux-2" {
    most_recent = true

    filter {
        name = "owner-alias"
        values = ["amazon"]
    }

    filter {
      name = "name"
      values = [ "amzn2-ami-hvm*" ]
    }
}

data "template_file" "master_docker_user_data" {
  template = "${file("${path.module}/install_jenkins_master_docker.sh")}"
  vars = {
    bucket_name = var.bucket_name
    node_one_ip = aws_instance.jenkins_node_one.public_ip
    node_two_ip = aws_instance.jenkins_node_two.public_ip
    github_token = var.github_token
  }
}

data "template_file" "docker_node_user_data" {
  template = "${file("${path.module}/install_docker_node.sh")}"
  vars = {
    bucket_name = var.bucket_name
  }
}