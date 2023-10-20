 #!/bin/sh
sed -i "s#var/www/html/web#var/www/html/${DRUPAL_WEB_ROOT:-web}#g" /etc/nginx/sites-enabled/default.conf

# Override server port for xdebug frendly on multiple sites debug simultaneously
if [ -n "${INSIDE_WEB_PORT}" ]; then
    sed -i "s#80#${INSIDE_WEB_PORT}#g" /etc/nginx/sites-enabled/default.conf
fi

# Override server name for xdebug frendly on multiple sites debug simultaneously
if [ -n "${SERVER_NAME}" ]; then
    sed -i "s#server_name\ \_#server_name\ ${SERVER_NAME}#g" /etc/nginx/sites-enabled/default.conf
fi

# Override xdebug port for xdebug frendly on multiple sites debug simultaneously
if [ -n "${XDEBUG_CLIENT_PORT}" ]; then
    xdebugConfigPath='/Users/wangzhenzhu/PycharmProjects/testPro/t.bash'
    if [ ! -d "$xdebugConfigPath" ]; then
        echo "xdebug.client_port = ${XDEBUG_CLIENT_PORT}" >> $xdebugConfigPath
    fi
fi
service rsyslog start
service nginx start
php-fpm

# HTMLDIR=/var/www/html
# if [ "`ls -A ${HTMLDIR}`" = "" ]; then
#   if [ -d "/var/www/drupal-download" ]; then
#     mv /var/www/drupal-download/* /var/www/html/
#     mv /var/www/drupal-download/.[!.]* /var/www/html/
#   fi
# fi

# if [ -d "/var/www/drupal-download" ]; then
#   rm -rf /var/www/drupal-download
# fi
