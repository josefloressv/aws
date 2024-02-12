# Refining Access to Branches in AWS CodeCommit
# https://aws.amazon.com/blogs/devops/refining-access-to-branches-in-aws-codecommit/
# https://docs.aws.amazon.com/codecommit/latest/userguide/how-to-conditional-branch.html

# Define groups
resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/${local.name_prefix}/"
}

resource "aws_iam_group" "leaders" {
  name = "leaders"
  path = "/${local.name_prefix}/"
}

# Define users
resource "aws_iam_user" "developers" {
  for_each      = var.dev_team_users
  name          = each.value
  path          = "/${local.name_prefix}/"
  force_destroy = true

  tags = local.tags
}

resource "aws_iam_user" "leaders" {
  for_each      = var.team_leaders_users
  name          = each.value
  path          = "/${local.name_prefix}/"
  force_destroy = true

  tags = local.tags
}

# Define policies

resource "aws_iam_policy" "DenyChangesToMain" {
  name        = "DenyChangesToMain"
  path        = "/${local.name_prefix}/"
  description = "Deny changes to main for a particular users"
  tags        = local.tags

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Deny"
        Resource = aws_codecommit_repository.demo.arn
        Action = [
          "codecommit:GitPush",
          "codecommit:DeleteBranch",
          "codecommit:PutFile",
          "codecommit:MergeBranchesByFastForward",
          "codecommit:MergeBranchesBySquash",
          "codecommit:MergeBranchesByThreeWay",
          "codecommit:MergePullRequestByFastForward",
          "codecommit:MergePullRequestBySquash",
          "codecommit:MergePullRequestByThreeWay"
        ]
        Condition = {
          StringEqualsIfExists = {
            "codecommit:References" = [
              "refs/heads/main"
            ]
          }
          Null = {
            "codecommit:References" = "false"
          }
        }
      },
    ]
  })
}

data "aws_iam_policy" "AWSCodeCommitPowerUser" {
  name = "AWSCodeCommitPowerUser"
}

data "aws_iam_policy" "AWSCodeCommitFullAccess" {
  name = "AWSCodeCommitFullAccess"
}

# Attach users to groups
resource "aws_iam_user_group_membership" "devs" {
  for_each = var.dev_team_users
  user     = each.value

  groups = [
    aws_iam_group.developers.name
  ]
}
resource "aws_iam_user_group_membership" "leaders" {
  for_each = var.team_leaders_users
  user     = each.value

  groups = [
    aws_iam_group.leaders.name
  ]
}

# Attach policy to groups

# Devs limited permissions
resource "aws_iam_group_policy_attachment" "DevDeny" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.DenyChangesToMain.arn
}

resource "aws_iam_group_policy_attachment" "DevPower" {
  group      = aws_iam_group.developers.name
  policy_arn = data.aws_iam_policy.AWSCodeCommitPowerUser.arn
}

# Leaders full permissions
resource "aws_iam_group_policy_attachment" "DevFull" {
  group      = aws_iam_group.leaders.name
  policy_arn = data.aws_iam_policy.AWSCodeCommitFullAccess.arn
}

# Login passwords
resource "aws_iam_user_login_profile" "devPass" {
  for_each                = var.dev_team_users
  user                    = each.value
  password_reset_required = false
  password_length         = 8
  depends_on              = [aws_iam_user.developers]
}

resource "aws_iam_user_login_profile" "leaderPass" {
  for_each                = var.team_leaders_users
  user                    = each.value
  password_reset_required = false
  password_length         = 8
  depends_on              = [aws_iam_user.leaders]
}