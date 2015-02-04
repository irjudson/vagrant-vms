#!/usr/bin/env bash

# Make a directory for nitrogen
mkdir nitrogen
cd nitrogen

# Start the registry
git clone https://github.com/nitrogenjs/registry.git
cd registry
sudo npm install
cp /vagrant/nitrogen-registry.conf /etc/init/nitrogen-registry.conf
#start nitrogen-registry
cd ..

# Start the front door
git clone https://github.com/nitrogenjs/frontdoor.git
cd frontdoor
sudo npm install
cp /vagrant/nitrogen-frontdoor.conf /etc/init/nitrogen-frontdoor.conf
#start nitrogen-frontdoor
cd ..

# Start the ingestion
git clone https://github.com/nitrogenjs/ingestion.git
cd ingestion
sudo npm install
cp /vagrant/nitrogen-ingestion.conf /etc/init/nitrogen-ingestion.conf
#start nitrogen-ingestion
cd ..

# Start the service
git clone https://github.com/nitrogenjs/consumption.git
cd consumption
sudo npm install
cp /vagrant/nitrogen-consumption.conf /etc/init/nitrogen-consumption.conf
#start nitrogen-consumption
cd ..

# Start the admin app 
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