terraform {
  source = "git::git@github.com:terraform-aws-modules/terraform-aws-route53.git//modules/zones?ref=v2.8.1"
}

include "root" {
  path = find_in_parent_folders()
}

locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
}

inputs = {
  zones = {
    for zone in local.environment_vars.locals.hosted_zones :

    zone => {
      comment = "${zone} public"
      tags = {
        terraform   = true
        environment = local.environment_vars.locals.environment
      }
    }
  }
}