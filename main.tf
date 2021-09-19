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

locals {
  awsconfig-bucket = format("%s-%s-awsconfig-logs", var.project, var.environment)
}
resource "aws_s3_bucket" "lambda-bucket" {
  bucket = format("%s-%s-lambda-bucket",var.environment,var.project)
  policy = templatefile("${path.cwd}/template/s3-restrict-only-https.json", { "bucket-name" = local.awsconfig-bucket })
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
