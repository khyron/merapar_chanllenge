resource "aws_ssm_parameter" "dynamic_string" {
  name  = var.parameter_name
  type  = "String"
  value = var.parameter_value
}
