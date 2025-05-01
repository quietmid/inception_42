FROM alpine:3.20.6

RUN apk update && \
	apk add --no-cache nginx openssl 

# Create required directories
# this is where nginx store its PID and runtime files
# default.conf & ssl/tls cert files
RUN mkdir -p /etc/nginx/ssl && \
	mkdir -p /etc/nginx/snippets

RUN ls -la ./conf/
RUN ls -la ./tools/
# Copy configurations
COPY ./conf/self-signed.conf /etc/nginx/snippets/self-signed.conf
# Copy custom NGINX configuration
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
RUN chmod 644 /etc/nginx/nginx.conf

# Copy and prepare the script
COPY ./tools/nginxScript.sh /usr/local/bin/nginxScript.sh
RUN chmod +x /usr/local/bin/nginxScript.sh

# Expose HTTPS ports
EXPOSE 443

# Set the entrypoint
ENTRYPOINT ["/bin/sh", "/usr/local/bin/nginxScript.sh"]