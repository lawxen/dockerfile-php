FROM drupal:7.67-fpm

ENV DRUSH_VERSION 8.3.0

# install the PHP extensions we need
RUN apt-get update \
  && apt-get install -y git mariadb-client vim \
        && rm -rf /var/lib/apt/lists/* \
        && docker-php-ext-install bcmath

# php config for drupal
RUN { \
    echo 'memory_limit = 2048M'; \
    echo 'post_max_size = 20M'; \
    echo 'upload_max_filesize = 20M'; \
    } > /usr/local/etc/php/conf.d/php.ini

# install Composer globally
RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer

# Install redis
RUN pecl install redis -y && docker-php-ext-enable redis

# drush command
RUN curl -fsSL -o /usr/local/bin/drush "https://github.com/drush-ops/drush/releases/download/$DRUSH_VERSION/drush.phar" && \
  chmod +x /usr/local/bin/drush