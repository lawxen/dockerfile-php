 #!/bin/sh
sed -i "s#var/www/html/web#var/www/html/${DRUPAL_WEB_ROOT:-web}#" /etc/nginx/conf.d/default.conf

# Override server name for xdebug frendly on multiple sites debug simultaneously and https://github.com/nginx-proxy/nginx-proxy
if [ -n "${VIRTUAL_HOST}" ]; then
    sed -i "s/server_name _;/server_name ${VIRTUAL_HOST};/" /etc/nginx/conf.d/default.conf
fi

# Override server port for xdebug frendly on multiple sites debug simultaneously
if [ -n "${INSIDE_WEB_PORT}" ]; then
    sed -i "s/listen 80 default_server/listen ${INSIDE_WEB_PORT} default_server/" /etc/nginx/conf.d/default.conf
fi

# Override xdebug port for xdebug frendly on the situation: multiple sites be debugged simultaneously
if [ -n "${XDEBUG_CLIENT_PORT}" ]; then
    xdebugConfigPath='/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini'

    if [ -e $xdebugConfigPath ]; then
        if grep -q "xdebug.client_port" $xdebugConfigPath; then
            sed -i "s/^xdebug.client_port=.*$/xdebug.client_port=${XDEBUG_CLIENT_PORT}/" a.conf
        else
            echo "xdebug.client_port=${XDEBUG_CLIENT_PORT}" >> $xdebugConfigPath
        fi
    fi
fi

HTMLDIR=/var/www/html
if [ -d "/opt/drupal" ]; then
    if [ "`ls -A ${HTMLDIR}`" = "" ]; then
        mv -f /opt/drupal/* /opt/drupal/.[!.]* /var/www/html/
    fi
fi

# service rsyslog start
# service nginx start
php-fpm &
nginx -g 'daemon off;'