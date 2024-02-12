resource "aws_s3_bucket" "codebuild_artifacts" {
  bucket        = "${local.name_prefix}-demo-artifacts"
  tags          = local.tags
  force_destroy = true # for this environment
}

resource "aws_s3_bucket_ownership_controls" "owner" {
  bucket = aws_s3_bucket.codebuild_artifacts.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "private" {
  depends_on = [aws_s3_bucket_ownership_controls.owner]

  bucket = aws_s3_bucket.codebuild_artifacts.id
  acl    = "private"
}