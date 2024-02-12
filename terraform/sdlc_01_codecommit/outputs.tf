# CodeCommit
output "repo_clone_url_http" {
  value = aws_codecommit_repository.demo.clone_url_http
}

output "repo_clone_url_ssh" {
  value = aws_codecommit_repository.demo.clone_url_ssh
}

output "aws_console_login_url" {
  value = "https://${local.account_id}.signin.aws.amazon.com/console/?region=us-east-1"
}

output "devPass" {
  value = { for profile in aws_iam_user_login_profile.devPass : profile.user => profile.password }
}
# https://terraformguru.com/terraform-certification-using-azure-cloud/34-Output-Values-with-for_each-and-for-loops/
output "LeadersPass" {
  value = { for profile in aws_iam_user_login_profile.leaderPass : profile.user => profile.password }
}
