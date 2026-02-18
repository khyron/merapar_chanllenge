module "archive" {
  source = "./modules/archive"

  source_dir             = "${path.module}/../lambda"
  lambda_zip_output_path = "${path.module}/lambda.zip"
}

module "ssm" {
  source = "./modules/ssm"

  parameter_name  = "/challenge/dynamic_string"
  parameter_value = "initial value"
}

module "iam" {
  source    = "./modules/iam"
  role_name = "lambda_ssm_role"

  policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}

module "lambda" {
  source = "./modules/lambda"

  lambda_zip_path   = module.archive.output_path
  lambda_zip_hash   = module.archive.output_base64sha256
  parameter_name    = module.ssm.parameter_name
  role_arn          = module.iam.role_arn
  # Start with empty, will be updated in second apply
  api_execution_arn = ""
}

module "apigateway" {
  source = "./modules/apigateway"

  lambda_invoke_arn     = module.lambda.invoke_arn
  lambda_function_name  = module.lambda.function_name
}




