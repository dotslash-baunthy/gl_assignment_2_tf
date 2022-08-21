#!/bin/bash
yum update -y
yum -y remove httpd
yum -y remove httpd-tools
yum install -y nginx
service nginx start
echo "Congratulations - This instance is created with Terraform Template - " >> /usr/share/nginx/html/index.html
curl http://169.254.169.254/latest/meta-data/instance-id >> /usr/share/nginx/html/index.html