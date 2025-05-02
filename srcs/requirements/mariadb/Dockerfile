FROM alpine:3.20.6

# Install required packages
RUN apk update && apk add --no-cache \
    mariadb \
    mariadb-client \
    mariadb-server-utils \
    && rm -rf /var/cache/apk/*

# Create necessary directories and set permissions
RUN mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld \
    && mkdir -p /var/lib/mysql \
    && chown -R mysql:mysql /var/lib/mysql \
    && mkdir -p /var/log/mysql \
    && chown -R mysql:mysql /var/log/mysql

# Copy configuration files
COPY ./conf/my.cnf /etc/my.cnf.d/my.cnf
COPY ./tools/configure_db.sh /usr/local/bin/configure_db.sh

# Set permissions
RUN chmod +x /usr/local/bin/configure_db.sh
RUN chmod 644 /etc/my.cnf.d/my.cnf

# Set environment variables
ENV MYSQL_PORT=3306

# Expose port
EXPOSE 3306

# Start MariaDB
CMD ["/usr/local/bin/configure_db.sh"]
