output "ec2_global_ips" {
  value = [
    "${aws_spot_instance_request.jenkins_server.public_ip}",
    "${aws_spot_instance_request.jenkins_node_one.public_ip}",
    "${aws_spot_instance_request.jenkins_node_two.public_ip}"
  ]
}