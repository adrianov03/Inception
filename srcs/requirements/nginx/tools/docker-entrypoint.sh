#!/bin/bash
set -e

envsubst '${DOMAIN_NAME}' < /etc/nginx/templates/default.conf.template \
    > /etc/nginx/sites-available/default

ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

nginx -t

exec nginx -g 'daemon off;'
