#!/bin/sh
username="apache"
# Check if the user already exists
if id "$username" &>/dev/null; then
    echo "User '$username' already exists"
else
    sudo adduser "$username"
fi
echo "$username:password" | sudo chpasswd

# Download Mediawiki archive
cd /home/"$username" || exit
sudo -u "$username" wget https://releases.wikimedia.org/mediawiki/1.41/mediawiki-1.41.1.tar.gz

cd /var/www
tar -zxf /home/username/mediawiki-1.41.1.tar.gz
ln -s mediawiki-1.41.1/ mediawiki
sudo chown -R apache:apache /var/www/mediawiki-1.41.1
sudo service httpd restart
