#!/bin/bash
echo -n "New SMTP_DOMAIN:"
read smtp_domain
echo -n "New SMTP_ADDRESS:"
read smtp_add
echo -n "New SMTP_USERNAME:"
read smtp_user
echo -n "New SMTP_PASSWORD:"
read smtp_pass

cat config/application.yml | egrep -v "^  SMTP_DOMAIN|^  SMTP_ADDRESS|^  SMTP_USERNAME|^  SMTP_PASSWORD" > config/application.yml.new

sed -i '/^  SMTP_PORT/a SMTP_DOMAIN: '$smtp_domain'' config/application.yml.new
sed -i '/^SMTP_DOMAIN/a SMTP_ADDRESS: '$smtp_add'' config/application.yml.new
sed -i '/^SMTP_ADDRESS/a SMTP_USERNAME: '$smtp_user'' config/application.yml.new
sed -i '/^SMTP_USERNAME/a SMTP_PASSWORD: '$smtp_pass'' config/application.yml.new

#mv config/application.yml config/application.yml.old
#mv config/application.yml.new config/application.yml
