 #!/bin/sh
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
