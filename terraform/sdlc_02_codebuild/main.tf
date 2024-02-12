resource "aws_codebuild_project" "buildFromCodeCommit" {
  name          = "${local.name_prefix}-build-${var.codebuild_project1_name_suffix}"
  description   = "Building Java Project from CodeCommit and push to S3 bucket"
  build_timeout = 5 # minutes
  badge_enabled = true
  service_role  = aws_iam_role.service_role_project1.arn
  tags          = local.tags

  # Source
  source {
    type            = "CODECOMMIT" # Valid values: CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB_ENTERPRISE, BITBUCKET, S3, NO_SOURCE.
    location        = data.aws_codecommit_repository.demo.clone_url_http
    git_clone_depth = 1

    # Buildspec
    buildspec = "CodeBuild_assets/buildspec.yml"
    git_submodules_config {
      fetch_submodules = false
    }
  }
  source_version = "refs/heads/main" # Branch, Git Tag, Commit ID

  # Environment
  environment {
    # Valid values: LINUX_CONTAINER, LINUX_GPU_CONTAINER, WINDOWS_SERVER_2019_CONTAINER, ARM_CONTAINER, LINUX_LAMBDA_CONTAINER, ARM_LAMBDA_CONTAINER
    type = "LINUX_CONTAINER"
    # Valid values:
    # When type is set to LINUX_CONTAINER: BUILD_GENERAL1_SMALL, BUILD_GENERAL1_MEDIUM, BUILD_GENERAL1_LARGE, BUILD_GENERAL1_2XLARGE, BUILD_LAMBDA_1GB,
    #   BUILD_LAMBDA_2GB, BUILD_LAMBDA_4GB, BUILD_LAMBDA_8GB, BUILD_LAMBDA_10GB. BUILD_GENERAL1_SMALL
    # When type is set to LINUX_GPU_CONTAINER: compute_type must be BUILD_GENERAL1_LARGE.
    # When type is set to LINUX_LAMBDA_CONTAINER or ARM_LAMBDA_CONTAINER: compute_type must be BUILD_LAMBDA_XGB.
    compute_type = "BUILD_GENERAL1_SMALL"
    # https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html#ec2-compute-images
    image = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    # Valid values: CODEBUILD, SERVICE_ROLE. When you use a cross-account or private registry image, you must use SERVICE_ROLE credentials.
    # When you use an AWS CodeBuild curated image, you must use CodeBuild credentials.
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "VAR1"
      value = "Value for Key 1"
    }

    environment_variable {
      name  = "SECRET1"
      value = aws_ssm_parameter.secret1.name
      type  = "PARAMETER_STORE"
    }
  }

  # Artifacts
  artifacts {
    type           = "S3"
    location       = aws_s3_bucket.codebuild_artifacts.bucket # /
    namespace_type = "NONE"                                   # valid values are BUILD_ID, NONE
    packaging      = "NONE"                                   # valid values are NONE, ZIP
  }

  # Logs
  logs_config {
    cloudwatch_logs {
      group_name  = "${local.name_prefix}-build-${var.codebuild_project1_name_suffix}-log-group"
      stream_name = "${local.name_prefix}-build-${var.codebuild_project1_name_suffix}-log-stream"
    }
  }
}
