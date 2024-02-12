# Custom permissions for CodeBuild Project
resource "aws_iam_role" "service_role_project1" {
  path               = "/${var.app_name}/${var.environment}/"
  name               = "project1_service_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "managed" {
  # SSM
  statement {
    effect = "Allow"

    actions = [
      "ssm:GetParameters"
    ]

    resources = [
      "arn:aws:ssm:us-east-1:${local.account_id}:parameter/${var.app_name}/${var.environment}/*"
    ]
  }

  # CloudWatch
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:us-east-1:${local.account_id}:log-group:/aws/codebuild*",
      "arn:aws:logs:us-east-1:${local.account_id}:log-group:${local.name_prefix}*",
      "arn:aws:logs:us-east-1:${local.account_id}:log-group:${local.name_prefix}*:*"
    ]
  }

  # CodeCommit
  statement {
    effect = "Allow"

    actions = [
      "codecommit:GitPull",
    ]

    resources = [data.aws_codecommit_repository.demo.arn]
  }

  # S3Bucket to store Artifact
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]

    resources = [
      aws_s3_bucket.codebuild_artifacts.arn,
      "${aws_s3_bucket.codebuild_artifacts.arn}/*",
    ]
  }

  # CodeBuild reports
  statement {
    effect = "Allow"

    actions = [
      "codebuild:CreateReportGroup",
      "codebuild:CreateReport",
      "codebuild:UpdateReport",
      "codebuild:BatchPutTestCases",
      "codebuild:BatchPutCodeCoverages"
    ]

    resources = [
      "arn:aws:codebuild:us-east-1:${local.account_id}:report-group/*"
    ]
  }
}

resource "aws_iam_role_policy" "attach" {
  role   = aws_iam_role.service_role_project1.id
  policy = data.aws_iam_policy_document.managed.json
}
