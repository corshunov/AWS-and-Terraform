locals {
  user_data = <<USERDATA
#!/bin/bash

sudo apt update -y
sudo apt install nginx awscli -y
sed -i "s/nginx/Grandpa's Whiskey $(hostname)/g" /var/www/html/index.nginx-debian.html
sed -i '15,23d' /var/www/html/index.nginx-debian.html

(echo "real_ip_header X-Forwarded-For;" | sudo tee -a /etc/nginx/conf.d/default.conf > /dev/null) && (echo "set_real_ip_from 0.0.0.0/0;" | sudo tee -a /etc/nginx/conf.d/default.conf > /dev/null)

service nginx restart

sudo touch /var/spool/cron/crontabs/ubuntu
sudo chmod 600 /var/spool/cron/crontabs/ubuntu
sudo chown ubuntu:crontab /var/spool/cron/crontabs/ubuntu

echo '0 * * * * aws s3 cp /var/log/nginx/access.log s3://${aws_s3_bucket.web_access_log.id}/access_$(hostname).log' | sudo tee /var/spool/cron/crontabs/ubuntu > /dev/null

USERDATA
}
