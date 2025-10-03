resource "aws_s3_bucket" "alb_logs" {
  bucket = "${var.project_name}-alb-logs"
  force_destroy = true

  tags = { Name = "${var.project_name}-alb-logs" }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.alb_logs.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.alb_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_lb_attribute" "access_logs" {
  load_balancer_arn = aws_lb.this.arn
  key               = "access_logs.s3.enabled"
  value             = "true"
}

resource "aws_lb_attribute" "access_logs_bucket" {
  load_balancer_arn = aws_lb.this.arn
  key               = "access_logs.s3.bucket"
  value             = aws_s3_bucket.alb_logs.bucket
}
