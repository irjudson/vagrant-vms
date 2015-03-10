#!/usr/bin/env bash

# Make a directory for nitrogen
mkdir nitrogen
cd nitrogen

# Get and configure the nitrogen service
git clone https://github.com/nitrogenjs/mqtt.git
cd mqtt
sudo npm install
cp /vagrant/nitrogen-mqtt.conf /etc/init/nitrogen-mqtt.conf
start nitrogen-mqtt
cd ..

