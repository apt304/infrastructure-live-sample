locals {
  environment = "dev"

  hosted_zones = [
    "dev.apt304.com"
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}