resource "aws_s3_bucket" "my_bucket" {
  bucket = "${var.bucket_name}"

  tags = {
    Name        = "jenkins bucket"
    ENVIRONMENT = "DEVELOPMENT"
  }
}

resource "aws_s3_bucket_acl" "example_bucket_acl" {
  bucket = aws_s3_bucket.my_bucket.id
  acl    = "private"
}

resource "aws_s3_object" "master_files" {
  for_each = fileset("${path.module}/master", "*")
  bucket = aws_s3_bucket.my_bucket.id
  key = format("master/%s", each.value)
  source = "${path.module}/master/${each.value}"
  etag = filemd5("${path.module}/master/${each.value}")
}

resource "aws_s3_object" "key_files" {
  for_each = fileset("${path.module}/.ssh", "*")
  bucket = aws_s3_bucket.my_bucket.id
  key = format("keys/%s", each.value)
  source = "${path.module}/.ssh/${each.value}"
  etag = filemd5("${path.module}/.ssh/${each.value}")
}

resource "aws_s3_object" "github_key_files" {
  for_each = fileset("${path.module}/github_keys", "*")
  bucket = aws_s3_bucket.my_bucket.id
  key = format("github_keys/%s", each.value)
  source = "${path.module}/github_keys/${each.value}"
  etag = filemd5("${path.module}/github_keys/${each.value}")
}