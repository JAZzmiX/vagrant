#!/bin/bash
# Using Trusty64 Ubuntu

#
# Add Phalcon repository
#
sudo apt-add-repository -y ppa:phalcon/stable
sudo apt-get update

#
# MySQL with root:<no password>
#
export DEBIAN_FRONTEND=noninteractive
#
# PHP
#

sudo apt-get update && sudo apt-get install python-software-properties
sudo add-apt-repository ppa:ondrej/php5-5.69
sudo apt-get update && sudo apt-get upgrade

// cygwin

sudo apt-get install -y nginx nginx-extras
sudo apt-get install -y php5-cli php5-common php5-mysql php5-gd php5-fpm php5-cgi php5-fpm php-pear php5-mcrypt
sudo apt-get install -y php5-curl php5-intl php5-xdebug
sudo apt-get install -y mysql-server mysql-client
sudo cp /var/www/default /etc/nginx/sites-enabled/default
sudo service nginx restart
