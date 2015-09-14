#!/usr/bin/env bash

# Make a directory for nitrogen
mkdir nitrogen
cd nitrogen

npm install -g yo grunt-cli bower

# Install the registry service
git clone https://github.com/irjudson/registry.git
cd registry
npm install
cp /vagrant/nitrogen-registry.conf /etc/init/nitrogen-registry.conf
cd ..

# Install the messaging service
git clone https://github.com/irjudson/messaging.git
cd messaging
npm install
cp /vagrant/nitrogen-messaging.conf /etc/init/nitrogen-messaging.conf
cd ..

# Get and configure the nitrogen mqtt-gateway  
git clone https://github.com/nitrogenjs/mqtt.git
cd mqtt
npm install
cp /vagrant/nitrogen-mqtt.conf /etc/init/nitrogen-mqtt.conf
cd ..

# Get the client lib and configure it so admin can use it
git clone https://github.com/irjudson/client.git
cd client
npm install
bower --allow-root install
scripts/build-module
cd ..

# Get and configure the nitrogen admin app 
git clone https://github.com/irjudson/admin.git
cd admin
npm install
bower --allow-root install
cp ../client/browser/nitrogen-min.js app/
#cat app/index.html | sed -e 's%https://api.nitrogen.io/client/%%' > /tmp/index.html
#cp /tmp/index.html app/index.html 
cp /vagrant/nitrogen-admin.conf /etc/init/nitrogen-admin.conf
cd ..

# Start things up
start nitrogen-registry
start nitrogen-messaging
start nitrogen-mqtt
start nitrogen-admin
