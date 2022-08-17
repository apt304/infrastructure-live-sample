terraform {
  source = "git::git@github.com:cloudposse/terraform-aws-kms-key.git?ref=0.12.1"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  name                = "kms-sops"
  label_order         = ["name"]
  enable_key_rotation = false
  description         = "KMS key for Terragrunt secrets encryption/decryption with SOPS"
}
