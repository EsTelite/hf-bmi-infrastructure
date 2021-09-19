locals {
  lambda-bucket = format("%s-%s-lambda-bucket", var.environment,var.project)
}
resource "aws_s3_bucket" "lambda-bucket" {
  bucket = format("%s-%s-lambda-bucket",var.environment,var.project)
  policy = templatefile("${path.cwd}/template/s3-restrict-only-https.json", { "bucket-name" = local.lambda-bucket })
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "block-public-acl" {
  bucket = aws_s3_bucket.lambda-bucket.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}
