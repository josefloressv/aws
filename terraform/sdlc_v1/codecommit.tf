resource "aws_codecommit_repository" "demo" {
  repository_name = "demo"
  description     = "This is the Sample App Repository"
  tags            = local.tags
}

# protect master branch
resource "aws_codecommit_approval_rule_template" "approvers" {
  name        = "1-approver-rule-for-master"
  description = "Require a pull request before merging and at least 1 approver"

  content = jsonencode({
    Version               = "2018-11-08"
    DestinationReferences = ["main"]
    Statements = [{
      Type                    = "Approvers"
      NumberOfApprovalsNeeded = 1
      ApprovalPoolMembers = concat(
        ["arn:aws:iam::${local.account_id}:user/cloud_user"],
        [for user in var.team_leaders_users : "arn:aws:iam::${local.account_id}:user/${local.name_prefix}/${user}"]
      )
    }]
  })
}

resource "aws_codecommit_approval_rule_template_association" "approvers_demo" {
  approval_rule_template_name = aws_codecommit_approval_rule_template.approvers.name
  repository_name             = aws_codecommit_repository.demo.repository_name
}

# Create a trigger
# Note: Terraform currently can create only one trigger per repository, even if multiple aws_codecommit_trigger resources are defined.
# Moreover, creating triggers with Terraform will delete all other triggers in the repository (also manually-created triggers).
resource "aws_codecommit_trigger" "merge_to_main" {
  repository_name = aws_codecommit_repository.demo.repository_name

  trigger {
    name            = "merge_to_main"
    events          = ["updateReference"] # Event types include: all, updateReference (like push), createReference, deleteReference.
    branches        = ["main"]
    destination_arn = aws_sns_topic.repo_updates.arn
  }
}