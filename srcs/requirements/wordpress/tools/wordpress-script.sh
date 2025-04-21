#!/bin/sh

# Exit on any error
set -e

# Download WordPress
echo "Downloading WordPress..."
wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz

# Extract WordPress
echo "Extracting WordPress..."
tar -xzf /tmp/wordpress.tar.gz -C /var/www/wp
rm /tmp/wordpress.tar.gz

# Move WordPress files to html directory
echo "Moving WordPress files..."
mv /var/www/wp/wordpress/* /var/www/html/
rm -rf /var/www/wp

# Set proper permissions
echo "Setting permissions..."
chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;

# Create wp-config.php if it doesn't exist
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "Creating wp-config.php..."
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    
    # Replace database configuration
    sed -i "s/database_name_here/$MYSQL_DATABASE/g" /var/www/html/wp-config.php
    sed -i "s/username_here/$MYSQL_USER/g" /var/www/html/wp-config.php
    sed -i "s/password_here/$MYSQL_PASSWORD/g" /var/www/html/wp-config.php
    sed -i "s/localhost/mariadb/g" /var/www/html/wp-config.php
    
    # Add security keys
    sed -i "s/put your unique phrase here/$(openssl rand -base64 32)/g" /var/www/html/wp-config.php
fi

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec php-fpm 