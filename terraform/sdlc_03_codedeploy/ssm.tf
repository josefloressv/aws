resource "aws_ssm_parameter" "secret1" {
  name  = "/${var.app_name}/${var.environment}/secret1"
  type  = "SecureString"
  value = "ThisIsaSecret!"
  tags  = local.tags
}