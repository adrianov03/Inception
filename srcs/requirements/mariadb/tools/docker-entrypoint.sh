#!/bin/bash
set -e

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

mysqld --user=mysql --skip-networking &
MYSQL_PID=$!

until mysqladmin ping --silent; do
    sleep 1
done

mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

kill $MYSQL_PID
wait $MYSQL_PID

exec mysqld --user=mysql
