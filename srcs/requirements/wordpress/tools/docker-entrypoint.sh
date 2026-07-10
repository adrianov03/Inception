#!/bin/bash
set -e

DB_PASSWORD=${MYSQL_PASSWORD}
WP_ADMIN_PASSWORD=${MYSQL_PASSWORD}

until mysqladmin ping -h mariadb -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent 2>/dev/null; do
    echo "Waiting for MariaDB..."
    sleep 2
done

if [ ! -f /var/www/html/wp-config.php ]; then
    wp core download --allow-root --path=/var/www/html

    wp config create \
        --allow-root \
        --path=/var/www/html \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost=mariadb:3306

    wp core install \
        --allow-root \
        --path=/var/www/html \
        --url="https://${DOMAIN_NAME}" \
        --title="${WP_TITLE}" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email

    wp user create \
        --allow-root \
        --path=/var/www/html \
        "${WP_USER}" "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_ADMIN_PASSWORD}"

    chown -R www-data:www-data /var/www/html
fi

exec php-fpm8.2 -F
