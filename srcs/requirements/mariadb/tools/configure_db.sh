#!/bin/sh
set -e

echo "--- Ensuring correct permissions for /var/lib/mysql ---"
chown -R mysql:mysql /var/lib/mysql
chmod 750 /var/lib/mysql

echo "--- Checking MariaDB initialization ---"
# Only initialize if system tables don't exist
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "--- Initializing MariaDB system tables ---"
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql >/dev/null

    echo "--- Creating WordPress database and user ---"
    mysqld --user=mysql --bootstrap <<EOF
USE mysql;
FLUSH PRIVILEGES;

ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost');

CREATE DATABASE IF NOT EXISTS \`$WORDPRESS_DATABASE_NAME\` 
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS '$WORDPRESS_DATABASE_USER'@'%' 
  IDENTIFIED BY '$WORDPRESS_DATABASE_PASSWORD';
GRANT ALL PRIVILEGES ON \`$WORDPRESS_DATABASE_NAME\`.* 
  TO '$WORDPRESS_DATABASE_USER'@'%';

FLUSH PRIVILEGES;
EOF
else
    echo "--- MariaDB is already initialized ---"
fi

echo "--- Starting MariaDB server ---"
exec mysqld --user=mysql --defaults-file=/etc/my.cnf.d/my.cnf