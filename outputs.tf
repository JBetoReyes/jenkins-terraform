output "ec2_global_ips" {
  value = ["${module.ec2_instance.ec2_global_ips}"]
}