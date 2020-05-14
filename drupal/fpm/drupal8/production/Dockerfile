FROM drupal:8.7.8-fpm

ENV DRUSH_VERSION 0.6.0

# install the PHP extensions we need
RUN apt-get update \
  && apt-get install -y git mariadb-client vim \
        && rm -rf /var/lib/apt/lists/* \
        && docker-php-ext-install bcmath

# php config for drupal
RUN { \
    echo 'memory_limit = 4096M'; \
    echo 'post_max_size = 30M'; \
    echo 'upload_max_filesize = 30M'; \
    } > /usr/local/etc/php/conf.d/php.ini

# install Composer globally
RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer

# Install redis
RUN pecl install redis -y && docker-php-ext-enable redis

# drush command
RUN curl -fsSL -o /usr/local/bin/drush "https://github.com/drush-ops/drush-launcher/releases/download/$DRUSH_VERSION/drush.phar" && \
    chmod +x /usr/local/bin/drush

#drupal console
RUN curl https://drupalconsole.com/installer -L -o drupal.phar && \
    mv drupal.phar /usr/local/bin/drupal && \
    chmod +x /usr/local/bin/drupal
