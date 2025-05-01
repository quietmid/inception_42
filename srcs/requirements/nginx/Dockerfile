FROM alpine:3.20.6

RUN apk update && \
	apk add --no-cache nginx openssl 

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