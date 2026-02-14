
variable "aws_region" {
  default = "us-east-1"
}

variable "lambda_zip_path" {
  description = "Path to lambda zip file"
  type        = string
  default     = "../lambda/lambda.zip"
}