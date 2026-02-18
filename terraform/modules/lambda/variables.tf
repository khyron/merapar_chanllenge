variable "lambda_zip_path" {
  description = "Path to the Lambda zip file"
  type        = string
}

variable "lambda_zip_hash" {
  description = "Base64 SHA256 hash of the Lambda zip"
  type        = string
}

variable "parameter_name" {
  description = "Name of the SSM parameter"
  type        = string
}

variable "role_arn" {
  description = "ARN of the IAM role for Lambda"
  type        = string
}

variable "api_execution_arn" {
  description = "Execution ARN of the API Gateway"
  type        = string
  default     = ""  # Default to empty
}