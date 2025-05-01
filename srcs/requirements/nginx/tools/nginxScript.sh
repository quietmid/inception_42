#!/bin/bash

# # check if the certificate is already created if not, create it
# if test -f "$CERTS_KEY"; then
# 	echo "SSL Certificate already exists"
# else
# 	echo "Creating SSL Certificate ... "
# 	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
# 		-keyout "$CERTS_KEY" \
# 		-out "$CERTS_CRT" \
# 		-subj "/C=FI/ST=Uusimaa/L=Helsinki/O=42/OU=Hive/CN=${DOMAIN_NAME}"
# 	echo "SSL Certificate created"
# fi

# Create SSL directory if it doesn't exist
mkdir -p /etc/nginx/ssl

echo "Is ssl certificate present?"

if test -f "$CERTS_KEY"; then
	echo "Yes, ssl certificate here!"
else
	echo "No, generating now..."
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout "$CERTS_KEY" -out "$CERTS_CRT" \
		-subj "/C=FI/ST=Uusimaa/L=Helsinki/O=42/OU=Hive/CN=${DOMAIN_NAME}"
	echo "SSL certificate generated"
fi

# creating user and adding them to a group 
if ! id "www-data" >/dev/null 2>&1; then
    adduser -D -H -s /sbin/nologin -g www-data www-data
fi

echo "Starting NGINX"
exec nginx -g 'daemon off;'