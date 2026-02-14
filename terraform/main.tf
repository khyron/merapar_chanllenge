module "ssm" {
  source = "./modules/ssm"

  parameter_name  = "/challenge/dynamic_string"
  parameter_value = "initial value"
}
