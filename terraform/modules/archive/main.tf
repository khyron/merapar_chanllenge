# Generate python script zip file

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = var.lambda_zip_output_path
}