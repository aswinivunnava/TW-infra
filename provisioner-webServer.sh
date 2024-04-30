#!/bin/sh
yum install -y centos-release-scl
yum install -y httpd24-httpd rh-php73 rh-php73-php rh-php73-php-mbstring rh-php73-php-mysqlnd rh-php73-php-gd rh-php73-php-xml
systemctl start httpd24-httpd
systemctl enable httpd24-httpd
username="apache"
# Check if the user already exists
if id "$username" &>/dev/null; then
    echo "User '$username' already exists"
else
    sudo adduser "$username"
fi
echo "$username:password" | sudo chpasswd
