terraform {
  source = "git::git@github.com:cloudposse/terraform-aws-iam-role.git?ref=0.16.2"
}

include "root" {
  path = find_in_parent_folders()
}

dependency "kms" {
  config_path = "../kms"
}

inputs = {
  name               = "kms-sops"
  use_fullname       = false
  policy_description = "Allow access to KMS key for Terragrunt secrets encryption/decryption with SOPS"
  role_description   = "IAM role with permissions to encrypt/decrypt secrets using KMS"

  principals = {
    AWS = ["arn:aws:iam::xxxx:root"]
  }

  policy_documents = [
    jsonencode(
      {
        "Statement" : [
          {
            "Sid" : "kmsencryptdecrypt",
            "Effect" : "Allow",
            "Action" : [
              "kms:Decrypt",
              "kms:Encrypt",
              "kms:DescribeKey",
              "kms:ReEncrypt*",
              "kms:GenerateDataKey*"
            ],
            "Resource" : dependency.kms.outputs.key_arn
          }
        ]
    })
  ]
}
