FROM alpine:3.20

EXPOSE 3306
# Install MariaDB
RUN apk update && apk add --no-cache mariadb mariadb-client

RUN mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld \
    && mkdir -p /var/lib/mysql \
    && chown -R mysql:mysql /var/lib/mysql

# Copy custom configuration files if any
COPY conf/ /etc/my.cnf.d/
COPY tools/ /docker-entrypoint-initdb.d/

# Expose MariaDB port internally

# Environment variables (default root password can be overridden)
ENV MYSQL_ROOT_PASSWORD=supersecret

# Define volume for persistent data
VOLUME ["/var/lib/mysql"]

# Run MariaDB properly as PID 1
ENTRYPOINT ["/usr/bin/mysqld_safe"]