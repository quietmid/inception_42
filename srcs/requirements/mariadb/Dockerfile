FROM alpine:3.20.6

# Expose MariaDB port internally
EXPOSE 3306

# Install MariaDB with the required dependencies
RUN apk update && apk add --no-cache \
    mariadb \
    mariadb-client \
    mariadb-common \
    && rm -rf /var/cache/apk/*

# Create necessary directories with proper permissions
RUN mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld \
    && mkdir -p /var/lib/mysql \
    && chown -R mysql:mysql /var/lib/mysql \
    && chmod 750 /var/lib/mysql \

# Copy custom configuration files if any
COPY ./conf/my.cnf /etc/my.cnf.d/my.cnf
COPY ./tools/configure_db.sh /usr/local/bin/configure_db.sh

# give the correct permissions
# +x for executable, 644 for read only
RUN chmod +x /usr/local/bin/configure_db.sh \
    && chmod 644 /etc/my.cnf.d/my.cnf

# Define volume for persistent data
VOLUME ["/var/lib/mysql"]

# Run MariaDB properly as PID 1
ENTRYPOINT ["/usr/local/bin/configure_db.sh"]
