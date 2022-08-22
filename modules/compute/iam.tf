resource "aws_iam_policy" "jenkins_master_s3_policy" {
    name = "jenkins-master-s3-policy"
    path = "/"
    description = "permissions to pull jenkins files"
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
            Effect = "Allow",
            Action = [
                "s3:GetObject",
                "s3:List*"
            ],
            Resource = [
                "arn:aws:s3:::${var.bucket_name}/master/*",
                "arn:aws:s3:::${var.bucket_name}/keys/id_rsa",
                "arn:aws:s3:::${var.bucket_name}/github_keys/*",
            ]
        }]
    })
}

resource "aws_iam_policy" "jenkins_node_s3_policy" {
    name = "jenkins-node-s3-policy"
    path = "/"
    description = "permissions to pull public key"
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [{
            Effect = "Allow",
            Action = [
                "s3:GetObject",
                "s3:List*"
            ],
            Resource = [
                "arn:aws:s3:::${var.bucket_name}/keys/id_rsa.pub",
            ]
        }]
    })
}

resource "aws_iam_role" "jenkins_master_role" {
    name = "jenkins-master-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid = ""
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
    })
}

resource "aws_iam_role" "jenkins_node_role" {
    name = "jenkins-node-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid = ""
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
    })
}

resource "aws_iam_policy_attachment" "jenkins_master_role_attachment" {
    name = "jenkins_master_role_attachment"
    roles = [aws_iam_role.jenkins_master_role.name]
    policy_arn = aws_iam_policy.jenkins_master_s3_policy.arn
}

resource "aws_iam_policy_attachment" "jenkins_node_role_attachment" {
    name = "jenkins_node_role_attachment"
    roles = [aws_iam_role.jenkins_node_role.name]
    policy_arn = aws_iam_policy.jenkins_node_s3_policy.arn
}

resource "aws_iam_instance_profile" "jenkins_master_instance_profile" {
  name = "jenkins_master_instance_profile"
  role = aws_iam_role.jenkins_master_role.name
}

resource "aws_iam_instance_profile" "jenkins_node_instance_profile" {
  name = "jenkins_node_instance_profile"
  role = aws_iam_role.jenkins_node_role.name
}