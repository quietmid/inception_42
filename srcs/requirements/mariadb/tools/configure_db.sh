#!/bin/bash

# Initialize the database with proper security settings
mysqld --user=mysql --bootstrap <<EOF
USE mysql;

# Remove anonymous users for security
DELETE FROM mysql.user WHERE User = '';

# Create database
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;

# Create and configure regular user
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';

# Create and configure admin user (if variables are set)
if [ ! -z "$MYSQL_ADMIN_USER" ] && [ ! -z "$MYSQL_ADMIN_PASSWORD" ]; then
    CREATE USER IF NOT EXISTS '$MYSQL_ADMIN_USER'@'%' IDENTIFIED BY '$MYSQL_ADMIN_PASSWORD';
    GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_ADMIN_USER'@'%';
fi

FLUSH PRIVILEGES;
EOF

# Start MariaDB in the foreground (as PID 1)
echo "MariaDB is ready to use"
exec mysqld_safe --user=mysql

