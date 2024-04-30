# TW-infra
## Task to configure  infra for MediaWiki on RHEL using Terraform.
you can find more information about the procedure in https://www.mediawiki.org/wiki/Manual:Running_MediaWiki_on_Red_Hat_Linux

## Terraform main file
* Using azure provider
* Taken resource_group as data source.
* Also provisioned resources like VNET, subnet, Key-valuts and  VM's for apache web server and also VM for db

## Configuration VM's using provisioners 
* Used file and remote-exec provisioners to configure web server and DB server as per documentation https://www.mediawiki.org/wiki/Manual:Running_MediaWiki_on_Red_Hat_Linux
