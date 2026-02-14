resource "aws_lambda_function" "html_service" {
  function_name = "html-service"
  runtime       = "python3.11"
  handler       = "app.lambda_handler"

  role = var.role_arn

  filename         = var.lambda_zip_path
  source_code_hash = filebase64sha256(var.lambda_zip_path)

  environment {
    variables = {
      PARAMETER_NAME = var.parameter_name
    }
  }
}
