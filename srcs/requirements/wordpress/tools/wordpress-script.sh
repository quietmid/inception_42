#!/bin/sh
echo "entered wordpress script"
# Exit on any error
set -e

# go to wordpress directory where files are stored
cd /var/www/html

# Download and setup WP-CLI and make it executable
echo "Downloading WP-CLI..."
wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /tmp/wp-cli.phar || { echo "Failed to download wp-cli.phar"; exit 1; }
chmod +x /tmp/wp-cli.phar
mv /tmp/wp-cli.phar /usr/local/bin/wp

# Wait for MariaDB to be ready
echo "Waiting for MariaDB..."
until mysqladmin ping -h mariadb -u $WORDPRESS_DATABASE_USER --password=$WORDPRESS_DATABASE_USER_PASSWORD --silent; do
    echo "Waiting for MariaDB.. in loop"
    sleep 2
done

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