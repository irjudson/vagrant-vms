#!/usr/bin/env bash

# Make a directory for nitrogen
mkdir nitrogen
cd nitrogen

# Get and configure the nitrogen service
git clone https://github.com/nitrogenjs/service.git
cd service
sudo npm install
cp /vagrant/nitrogen-service.conf /etc/init/nitrogen-service.conf
#start nitrogen-service
cd ..

# Get and configure the nitrogen admin app 
git clone https://github.com/nitrogenjs/admin.git
cd admin
npm install -g yo grunt-cli bower
npm install
bower --allow-root install
gem install compass
cp /vagrant/nitrogen-admin.conf /etc/init/nitrogen-admin.conf

# This is because xdg-open is a pain in the neck
cat Gruntfile.js | sed -e "s/localhost/0.0.0.0/" | sed -e "s/'open',//" > /tmp/Gruntfile.js
cp /tmp/Gruntfile.js ./Gruntfile.js
if [ "`hostname -d`" = "cloudapp.net" ]; then
  . /etc/environment
  cat app/scripts/app.js | sed -e "s/localhost/$HOST_NAME/" > /tmp/app.js
  cp /tmp/app.js app/scripts/app.js
fi
#start nitrogen-admin
cd ..

# Get and configure the nitrogen mqtt-gateway  
git clone https://github.com/nitrogenjs/mqtt.git
cd mqtt
npm install
cp /vagrant/nitrogen-mqtt.conf /etc/init/nitrogen-mqtt.conf
