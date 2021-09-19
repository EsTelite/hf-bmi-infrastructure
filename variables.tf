variable "environment" {
  default = "prod"
}
variable "project" {
  default = "hf"
}
locals {
  common_tags = {
    Created     = "19-Sept-2021"
    Project     = var.project
    Environment = var.environment
    Terraform   = "yes"
  }
}
