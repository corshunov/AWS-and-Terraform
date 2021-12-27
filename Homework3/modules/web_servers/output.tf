output "web_public_ips" {
  value = aws_instance.web.*.public_ip
}

output "web_access_log_bucket" {
  value = aws_s3_bucket.web_access_log.id
}
