terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git?ref=v3.14.0"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  # Extract the variables we need for easy access
  environment = local.environment_vars.locals.environment
}

inputs = {
  name = "${local.environment}-vpc"

  cidr             = "10.0.0.0/16"
  azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets   = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
  private_subnets  = ["10.0.48.0/20", "10.0.64.0/20", "10.0.80.0/20"]
  database_subnets = ["10.0.96.0/20", "10.0.112.0/20", "10.0.128.0/20"]

  enable_nat_gateway = true
  single_nat_gateway = true
  // one_nat_gateway_per_az = false
  enable_dhcp_options = true
  enable_dns_hostnames = true
}
