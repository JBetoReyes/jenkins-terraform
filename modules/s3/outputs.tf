output "bucket_name" {
  description = "The ID of the security group"
  value = aws_s3_bucket.my_bucket.id
}