#!/usr/bin/env bash

# Make a directory for nitrogen
mkdir nitrogen
cd nitrogen

npm install -g yo grunt-cli bower

# Start the registry service
git clone https://github.com/nitrogenjs/registry.git
cd registry
sudo npm install
cp /vagrant/nitrogen-registry.conf /etc/init/nitrogen-registry.conf
start nitrogen-registry
cd ..

# Start the messaging service
git clone https://github.com/nitrogenjs/messaging.git
cd messaging
sudo npm install
cp /vagrant/nitrogen-messaging.conf /etc/init/nitrogen-messaging.conf
start nitrogen-messaging
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
cat app/index.html | sed -e 's%https://api.nitrogen.io/client/%%' > /tmp/index.html
cp /tmp/index.html app/index.html 
cp /vagrant/nitrogen-admin.conf /etc/init/nitrogen-admin.conf

# This is because xdg-open is a pain in the neck
cat Gruntfile.js | sed -e "s/localhost/0.0.0.0/" | sed -e "s/'open',//" > /tmp/Gruntfile.js
cp /tmp/Gruntfile.js ./Gruntfile.js
if [ "`hostname -d`" = "cloudapp.net" ]; then
  . /etc/environment
  cat app/scripts/app.js | sed -e "s/localhost/$HOST_NAME/" > /tmp/app.js
  cp /tmp/app.js app/scripts/app.js
fi
start nitrogen-admin
cd ..
