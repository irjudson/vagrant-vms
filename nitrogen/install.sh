#!/usr/bin/env bash

# Disable ipv6
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p 

# Update/upgrade
sudo apt-get update
sudo apt-get upgrade

# Get linux packages needed for Nitrogen
sudo apt-get install -yyq git emacs build-essential mongodb-server redis-server ruby1.9.1-dev libffi-dev

# Manage node installation on ubuntu
sudo apt-get --purge remove node nodejs
sudo apt-get install -yyq nodejs
sudo update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
sudo apt-get install -yyq npm

# Install nitrogen command line, it makes things easier
sudo npm install -g nitrogen-cli