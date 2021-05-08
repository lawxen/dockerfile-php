 #!/bin/sh
service nginx start
php-fpm
service rsyslog start

HTMLDIR=/var/www/html
if [ "`ls -A ${HTMLDIR}`" = "" ]; then
  if [ -d "/var/www/drupal-download" ]; then
    mv /var/www/drupal-download/* /var/www/html/
    mv /var/www/drupal-download/.[!.]* /var/www/html/
  fi
fi

if [ -d "/var/www/drupal-download" ]; then
  rm -rf /var/www/drupal-download
fi
