output "api_url" {
  description = "API Gateway URL endpoint"
  value       = aws_apigatewayv2_api.api.api_endpoint
}

output "execution_arn" {
  description = "Execution ARN of the API Gateway"
  value       = aws_apigatewayv2_api.api.execution_arn
}

