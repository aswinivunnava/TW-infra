#!/bin/sh
yum install -y centos-release-scl
yum install -y mariadb-server mariadb 
systemctl start mariadb
systemctl enable mariadb
