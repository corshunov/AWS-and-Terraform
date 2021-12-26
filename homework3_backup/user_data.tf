locals {
  web_user_data = <<USERDATA
#!/bin/bash

sudo apt update -y
sudo apt install nginx awscli -y
sed -i "s/nginx/Grandpa's Whiskey $(hostname)/g" /var/www/html/index.nginx-debian.html
sed -i '15,23d' /var/www/html/index.nginx-debian.html
service nginx restart

echo "0 * * * * aws s3 cp /var/log/nginx/access.log s3://opsschool-nginx-access-log" > /var/spool/cron/crontabs/root

USERDATA
}
