resource "aws_s3_bucket" "web_access_log" {
  bucket_prefix = "${var.access_log_bucket_name}-"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "web_access_log_block" {
  bucket                  = aws_s3_bucket.web_access_log.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
