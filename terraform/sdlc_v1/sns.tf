resource "aws_sns_topic" "repo_updates" {
  name = "${local.name_prefix}-codecommit-demo"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.repo_updates.arn
  protocol  = "email"
  endpoint  = var.sns_email_updates
}