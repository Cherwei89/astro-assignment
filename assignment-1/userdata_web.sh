n#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo mv /var/www/html/index.html /var/www/html/index.html.bak
sudo echo "Hello! This is web tier server!" > /var/www/html/index.html