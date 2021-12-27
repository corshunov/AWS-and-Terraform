output "web_public_ips" {
  value = module.web_servers.web_public_ips
}

output "web_access_log_bucket" {
  value = module.web_servers.web_access_log_bucket
}
