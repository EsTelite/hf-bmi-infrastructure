module "hf-bmi-api-gw" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = format("%s-%s-bmi-api-gateway",var.environment,var.project)
  description   = "HF API Gateway"
  protocol_type = "HTTP"
  domain_name = "hf-bmi.ssdindo.com"
  domain_name_certificate_arn = "arn:aws:acm:ap-south-1:237612645500:certificate/44e3f37f-c455-43a3-8719-9275e7551a95"
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
      integration_type      = "AWS_PROXY"
    }

    "$default" = {
      lambda_arn = module.lambda_function.lambda_function_arn
      integration_type      = "AWS_PROXY"
    }
  }

  tags = merge(local.common_tags,
  {
  })
}

module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"
  version = "2.17.0"
  function_name = format("%s-%s-bmi",var.environment,var.project)
  description   = "HF Lambda for BMI Calculator"
  handler       = "main.lambda_handler"
  runtime       = "python3.8"
  source_path = "template/lambda-template-python"
  ignore_source_code_hash = true
  recreate_missing_package = false
  publish = true
  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.hf-bmi-api-gw.apigatewayv2_api_execution_arn}/*/*"
    }
  }
  tags = merge(local.common_tags,
  {
  })
}
