variable "app_name" {
  type        = string
  description = "Application name"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "dev_team_users" {
  type        = set(string)
  description = "List of developers users names"
}

variable "team_leaders_users" {
  type        = set(string)
  description = "List of the team leaders users names"
}

variable "sns_email_updates" {
  type = string
  description = "Email to subscribe respository updates"
}

# Maps in deep
# https://spacelift.io/blog/terraform-map-variable