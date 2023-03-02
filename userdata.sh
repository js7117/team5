#!/bin/bash
sudo yum install httpd amazon-linux-extras -y
sudo yum update -y
sudo yum upgrade -y
sudo amazon-linux-extras install epel -y
sudo amazon-linux-extras enable php8.0
sudo yum clean metadata
sudo yum install php php-cli php-pdo php-fpm php-mysqlnd -y