module "ssm" {
  source = "./modules/ssm"

  parameter_name  = "/challenge/dynamic_string"
  parameter_value = "initial value"
}

module "apigateway" {
  source = "./modules/apigateway"

  lambda_invoke_arn = module.lambda.invoke_arn
}

module "lambda" {
  source = "./modules/lambda"

  lambda_zip_path = var.lambda_zip_path
  parameter_name  = module.ssm.parameter_name
  role_arn        = module.iam.role_arn
}

module "iam" {
  source    = "./modules/iam"
  role_name = "lambda_ssm_role"

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}