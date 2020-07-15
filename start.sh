 #!/bin/sh
service nginx start
php-fpm

HTMLDIR=/var/www/html
if [ "`ls -A ${HTMLDIR}`" = "" ]; then
  if [ -d "/var/www/drupal9-download" ]; then
    mv /var/www/drupal9-download/* /var/www/html/
    mv /var/www/drupal9-download/.[!.]* /var/www/html/
  fi
fi

if [ -d "/var/www/drupal9-download" ]; then
  rm -rf /var/www/drupal9-download
fi
