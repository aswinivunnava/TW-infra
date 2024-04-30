#!/bin/bash

echo "Disabling SELinux..."
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

echo "Creating a link to load.php..."
sudo ln -s /usr/share/mediawiki-1.41.1/load.php /var/www/mediawiki/load.php

echo "Changing ownership of /usr/share/mediawiki-1.41.1 directory..."
sudo chown -R apache:apache /usr/share/mediawiki-1.41.1


