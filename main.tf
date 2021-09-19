module "hf-bmi-api-gw" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = format("%s-%s-bmi-api-gateway",var.environment,var.project)
  description   = "HF API Gateway"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["*"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  # Routes and integrations
  integrations = {
    "ANY /" = {
      lambda_arn             = module.lambda_function.lambda_function_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }

    "$default" = {
      lambda_arn = module.lambda_function.lambda_function_arn
    }
  }

  tags = merge(local.common_tags,
  {
  })
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = format("%s-%s-bmi",var.environment,var.project)
  description   = "Far Away"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  source_path = "template/lambda-template-python"
  tags = merge(local.common_tags,
  {
  })
}
