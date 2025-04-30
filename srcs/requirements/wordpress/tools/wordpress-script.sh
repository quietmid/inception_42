#!/bin/sh

# Exit on any error
set -e

# Set PHP memory limit
echo "Setting PHP memory limit..."
echo "memory_limit = 512M" >> /etc/php83/php.ini

# go to wordpress directory where files are stored
cd /var/www/html

# Download and setup WP-CLI and make it executable
echo "Downloading WP-CLI..."
wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp || { echo "Failed to download wp-cli.phar"; exit 1; }
chmod +x /usr/local/bin/wp

# Wait for MariaDB to be ready
echo "Waiting for MariaDB..."
mariadb-admin ping --protocol=tcp --host=mariadb -u $WORDPRESS_DATABASE_USER --password=$WORDPRESS_DATABASE_USER_PASSWORD --wait=300

# Download WordPress core
echo "Downloading WordPress..."
wp core download --allow-root --path=/var/www/html

# Create wp-config.php
echo "Creating wp-config.php..."
wp config create \
    --dbname=$WORDPRESS_DATABASE_NAME \
    --dbuser=$WORDPRESS_DATABASE_USER \
    --dbpass=$WORDPRESS_DATABASE_USER_PASSWORD \
    --dbhost=mariadb \
    --force \
    --skip-check \
    --extra-php <<PHP
define('WP_HOME', 'https://$DOMAIN_NAME');
define('WP_SITEURL', 'https://$DOMAIN_NAME');
PHP

# Install WordPress
echo "Installing WordPress..."
wp core install \
    --url="$DOMAIN_NAME" \
    --title="$WORDPRESS_TITLE" \
    --admin_user="$WORDPRESS_ADMIN" \
    --admin_password="$WORDPRESS_ADMIN_PASSWORD" \
    --admin_email="$WORDPRESS_ADMIN_EMAIL" \
    --allow-root \
    --skip-email \

# Create additional user
echo "Creating WordPress user..."
wp user create \
    $WORDPRESS_USER \
    $WORDPRESS_USER_EMAIL \
    --user_pass=$WORDPRESS_USER_PASSWORD \
    --allow-root \

# Set proper permissions
echo "Setting permissions..."
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# Start PHP-FPM in foreground mode
echo "Starting PHP-FPM..."
exec php-fpm83 -F 