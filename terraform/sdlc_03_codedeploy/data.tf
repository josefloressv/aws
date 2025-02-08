data "aws_caller_identity" "current" {}
data "aws_codecommit_repository" "demo" {
  repository_name = var.codecommit_project1_existing_repository_name
}