terraform {
  source = "git::git@github.com:cloudposse/terraform-aws-ecr?ref=0.34.0"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  name         = "helloworld"
  use_fullname = false

  principals_readonly_access = ["arn:aws:iam::xxx:root"]

  encryption_configuration = {
    encryption_type = "AES256"
    kms_key         = null
  }
}
