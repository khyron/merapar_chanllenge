output "lambda_zip_path" {
  description = "Path of the generated Lambda zip file"
  value       = data.archive_file.lambda_zip.output_path
}

output "lambda_zip_base64sha256" {
  description = "Base64 SHA256 hash of the Lambda zip (used for Lambda updates)"
  value       = data.archive_file.lambda_zip.output_base64sha256
}

output "output_path" {
  value = data.archive_file.lambda_zip.output_path
}

output "output_base64sha256" {
  value = data.archive_file.lambda_zip.output_base64sha256
}
