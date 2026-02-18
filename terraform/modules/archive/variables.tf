variable "source_dir" {
  description = "Path of source files"
  type = string
}

variable "lambda_zip_output_path" {
  description = "Path where the generated Lambda zip file will be stored"
  type        = string
  default     = "lambda.zip"
}