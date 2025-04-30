FROM alpine:3.20

# Install NGINX and OpenSSL for TLS/SSL support
RUN apk update && \
	apk add --no-cache nginx openssl

# Expose HTTPS ports
EXPOSE 443

# Create required directories
# this is where nginx store its PID and runtime files
# default.conf & ssl/tls cert files
RUN mkdir -p /etc/nginx/ssl

COPY ./conf/self-signed.conf /etc/nginx/snippets/self-signed.conf
# Copy custom NGINX configuration
# COPY <src> ... <dest> it makes sure the src files or directories are copied to the dest directory
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

COPY ./tools/nginxScript.sh /usr/local/bin/nginxScript.sh
RUN chmod +x /usr/local/bin/nginxScript.sh

# generate a self-signed certificate
ENTRYPOINT ["/usr/local/bin/nginxScript.sh"]