variable "app_name" {
  type        = string
  description = "Application name"
}

variable "environment" {
  type        = string
  description = "Environment"
}
variable "codecommit_project1_existing_repository_name" {
  type        = string
  description = "CodeCommit existing repository name"
}
variable "codebuild_project1_name_suffix" {
  type        = string
  description = "CodeBuild Project Name Suffix"
}
