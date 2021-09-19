variable "secret_key" {
}
variable "access_key" {
}
provider "aws" {
  region     = "ap-south-1"
  secret_key = var.secret_key
  access_key = var.access_key
}
