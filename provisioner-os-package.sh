#!/bin/sh
yum install -y centos-release-scl
yum install -y httpd24-httpd rh-php73 rh-php73-php rh-php73-php-mbstring rh-php73-php-mysqlnd rh-php73-php-gd rh-php73-php-xml mariadb-server mariadb 
systemctl start httpd24-httpd
systemctl enable httpd24-httpd
systemctl start mariadb
systemctl enable mariadb
