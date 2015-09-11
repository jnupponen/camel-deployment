#!/bin/bash

# Download only once if file exists.
if [ ! -f apache-karaf.tar.gz ]; then
	wget http://www.nic.funet.fi/pub/mirrors/apache.org/karaf/3.0.4/apache-karaf-3.0.4.tar.gz -O apache-karaf.tar.gz
fi

# Stop the instance if running and remove old files.
apache-karaf/bin/stop
sleep 1
rm -rf apache-karaf

# Create fresh installation of Karaf and start Karaf.
mkdir apache-karaf
tar xvf apache-karaf.tar.gz --strip 1 -C apache-karaf/
apache-karaf/bin/start
sleep 1

# Copy dependencies in kar file and actual Camel route in jar bundle.
cp lib/camel-deployment-karaf-dependencies-kar-1.0-SNAPSHOT.kar apache-karaf/deploy
cp target/camel-deployment-bundle-1.0-SNAPSHOT.jar apache-karaf/deploy

exit
