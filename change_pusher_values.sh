#!/bin/bash
echo -n "New PUSHER_APP id:"
read papp
echo -n "New PUSHER_KEY:"
read pkey
echo -n "New PUSHER_SECRET:"
read psecret
cat config/application.yml | egrep -v "PUSHER_APP|PUSHER_KEY|PUSHER_SECRET" > config/application.yml.new

sed -i '/PUSHER_ENCRYPTED/a PUSHER_APP: '$papp'' config/application.yml.new
sed -i '/PUSHER_APP/a PUSHER_KEY: '$pkey'' config/application.yml.new
sed -i '/PUSHER_KEY/a PUSHER_SECRET: '$psecret'' config/application.yml.new

#mv config/application.yml config/application.yml.old
#mv config/application.yml.new config/application.yml
