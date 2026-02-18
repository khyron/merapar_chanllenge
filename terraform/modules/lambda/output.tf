output "invoke_arn" {
  description = "ARN ofLambda function to invoke"
  value       = aws_lambda_function.html_service.invoke_arn
}

output "function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.html_service.function_name
}

output "function_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.html_service.arn
}