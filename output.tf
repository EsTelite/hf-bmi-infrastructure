output "bucket-lambda" {
  value = aws_s3_bucket.lambda-bucket.bucket_domain_name
}