locals {
  remote_state_bucket = "apt304-dev-terragrunt-terraform-state"
  remote_state_region = "us-east-1"

  # The following variables must match the folder name
  aws_account_name    = "apt304-dev"
  aws_account_id      = "xxxx"
  aws_assume_role_arn = "arn:aws:iam::xxxx:role/OrganizationAccountAccessRole"
}
