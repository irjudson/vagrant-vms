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
sudo apt-get install -yyq git emacs build-essential mongodb-server redis-server ruby1.9.1-dev libffi-dev curl xdg-utils lynx

# Install compass for ruby
sudo gem install compass

# Node install on ubuntu
# per: https://nodesource.com/blog/nodejs-v012-iojs-and-the-nodesource-linux-repositories
curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash -
sudo apt-get install -y nodejs

# Install nitrogen command line, it makes things easier
sudo npm install -g nitrogen-cli