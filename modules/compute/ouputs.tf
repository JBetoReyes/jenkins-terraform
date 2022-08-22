output "ec2_global_ips" {
  value = [
        "${aws_instance.jenkins_server.public_ip}",
        "${aws_instance.jenkins_node_one.public_ip}",
        "${aws_instance.jenkins_node_two.public_ip}"
    ]
}