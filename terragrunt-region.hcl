terragrunt_version_constraint = ">= 0.37, < 0.38"
terraform_version_constraint  = ">= 1.1, < 1.2"

locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl", "region.hcl"))

  # Extract the variables we need for easy access
  aws_account_name    = local.account_vars.locals.aws_account_name
  aws_account_id      = local.account_vars.locals.aws_account_id
  aws_assume_role_arn = local.account_vars.locals.aws_assume_role_arn
  region              = local.region_vars.locals.region
  remote_state_bucket = local.account_vars.locals.remote_state_bucket
  remote_state_region = local.account_vars.locals.remote_state_region
  environment         = local.environment_vars.locals.environment
}

# Generate a AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
  assume_role {
    role_arn = "${local.aws_assume_role_arn}"
  }
  default_tags {
    tags = {
      env = "${local.environment}"
      Terraform = "true"
    }
  }
}
EOF
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.remote_state_bucket
    key     = "${local.aws_account_name}-${local.aws_account_id}/${local.environment}/${local.region}/${path_relative_to_include()}/terraform.tfstate"
    region         = local.remote_state_region
    encrypt        = true
    dynamodb_table = "terragrunt-terraform-state-lock"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

inputs = merge(
  local.account_vars.locals,
  local.environment_vars.locals,
  local.region_vars.locals,
)
