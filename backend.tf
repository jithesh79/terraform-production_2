terraform {
  required_version = ">= 1.3.0"
  backend "s3" {
    bucket         = var.backend_s3_bucket
    key            = "${var.project_name}/terraform.tfstate"
    region         = var.region
    dynamodb_table = var.backend_dynamodb_table
    encrypt        = true
  }
}
