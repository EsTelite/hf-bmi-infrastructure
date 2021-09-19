/*
module "hf-bmi-api-gw" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = format("%s-%s-bmi-api-gateway",var.environment,var.project)
  description   = "HappyFresh API Gateway"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["*"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  # Routes and integrations
  integrations = {
    "ANY /" = {
      lambda_arn             = "lambda arn"
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }

    "$default" = {
      lambda_arn = "lambda arn"
    }
  }

  tags = merge(local.common_tags,
  {
  })
}
*/

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
}
