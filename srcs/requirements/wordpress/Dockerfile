FROM alpine:3.20.6

# Install required PHP extensions for WordPress
# - mariadb-client: MariaDB client, used to connect to the database and mysql commands tools
# - php83: PHP 8.3, basic php package
# - php83-fpm: PHP-FPM, FastCGI Process Manager for PHP, matches my www.cnf configuration
# - php83-phar: PHP Archive, PHP Archive, handles .phar files
# - php83-curl: cURL, PHP extension for cURL
# - php83-mysqli: MySQLi, PHP extension for MySQL, required for mariaDB connection
# - php83-iconv: iconv, PHP extension for iconv, charcater encode, different character encoding
# - php83-json: JSON, PHP extension for JSON, handles JSON data
# - wget: wget, command line tool for downloading files from the web
RUN apk update && apk add mariadb-client \
    php83 \
    php83-fpm \
    php83-phar \
    php83-curl \
    php83-mysqli \
    php83-iconv \
    php83-json \
    wget \
    && rm -rf /var/cache/apk/*

# Create www-data user and group
# -g www-data group name
# -S www-data system user name
# -D create user without home directory
# -S create system user
# -G www-data add user to www-data group
RUN adduser -S www-data -g www-data -D -G www-data

# Copy PHP-FPM configuration
# COPY ./conf/www.conf /usr/local/etc/php-fpm.d/www.conf 
COPY ./conf/www.conf /etc/php83/php-fpm.d/www.conf
# copy and set up wordpress script
COPY ./tools/wordpress-script.sh /usr/local/bin/wordpress-script.sh

RUN chmod +x /usr/local/bin/wordpress-script.sh

# Create necessary directories
RUN mkdir -p /var/www/wp /var/www/html \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Create php.ini with memory limit
RUN echo "memory_limit = 512M" > /etc/php83/php.ini \
    && chown www-data:www-data /etc/php83/php.ini \
    && chmod 644 /etc/php83/php.ini

# Ensure www-data has necessary permissions
RUN chown -R www-data:www-data /usr/local/bin \
    && chmod -R 755 /usr/local/bin

# Set working directory
WORKDIR /var/www/html

# Switch to www-data user
USER www-data

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start WordPress setup and PHP-FPM
ENTRYPOINT ["/usr/local/bin/wordpress-script.sh"]
