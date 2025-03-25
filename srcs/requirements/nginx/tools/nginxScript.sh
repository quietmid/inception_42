#!/bin/bash

# check if the certificate is already created if not, create it
if test -f "$CERTS_KEY"; then
	echo "SSL Certificate already exists"
else
	echo "Creating SSL Certificate ... "
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout "$CERTS_KEY" \
		-out "$CERTS_CRT" \
		-subj "/C=FI/L=HELSINKI//O=HIVE/CN=$DOMAIN_NAME"
	echo "SSL Certificate created"
fi

# need to fill in the or append the selfsigned conf?

echo "ssl_certificate /etc/nginx/ssl/nginx.crt;" >> /etc/nginx/snippets/self-signed.conf
echo "ssl_certificate_key /etc/nginx/ssl/nginx.key;" >> /etc/nginx/snippets/self-signed.conf

exec nginx -g "daemon off;"