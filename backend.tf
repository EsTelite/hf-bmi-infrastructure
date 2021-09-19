terraform {
  backend "remote" {
    organization = "rc94"

    workspaces {
      name = "hf-bmi-infrastructure"
    }
  }
}
