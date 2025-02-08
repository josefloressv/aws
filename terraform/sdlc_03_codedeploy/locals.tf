locals {
  name_prefix = join("-", [var.app_name, var.environment])
  account_id  = data.aws_caller_identity.current.account_id
  tags = {
    Application = var.app_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}