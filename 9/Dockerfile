FROM drupal:fpm

################################Custom##########################################
ENV DRUSH_VERSION 0.6.0

# set timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install the PHP extensions and other app we need
RUN apt-get update \
  && apt-get install -y git vim mariadb-client nginx\
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-install bcmath

# Install redis
RUN pecl install redis && docker-php-ext-enable redis

# php config for drupal
RUN { \
  echo 'memory_limit = 4096M'; \
  echo 'post_max_size = 30M'; \
  echo 'upload_max_filesize = 30M'; \
  } > /usr/local/etc/php/conf.d/php.ini

RUN sed -i "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm.sock/g" /usr/local/etc/php-fpm.d/www.conf

# install Composer globally
RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer

RUN set -eux; \
  # Install Drush
  curl -fsSL -o /usr/local/bin/drush "https://github.com/drush-ops/drush-launcher/releases/download/$DRUSH_VERSION/drush.phar" && \
  chmod +x /usr/local/bin/drush && \
  # Install Drupal Console
  curl https://drupalconsole.com/installer -L -o drupal.phar && \
  mv drupal.phar /usr/local/bin/drupal && \
  chmod +x /usr/local/bin/drupal && \
  rm -rf /etc/nginx/sites-enabled

ADD config/php-upload.ini /usr/local/etc/php/conf.d/php-uploads.ini
ADD config/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
ADD config/default.conf /etc/nginx/conf.d/
ADD config/drupal-web.conf /etc/nginx/conf.d/
ADD config/drupal.conf /etc/nginx/conf.d/

# Install rsyslog.
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ precise main universe" >> /etc/apt/source.list
RUN apt-get update
RUN apt-get -y install rsyslog
RUN { \
  echo 'local0.* /var/log/drupal.log'; \
  } > /etc/rsyslog.conf

EXPOSE 80
EXPOSE 443

# WORKDIR "/var/www"
# # Install Drupal
# RUN set -eux; \
#         rm -rf /var/www/html && \
#         composer create-project drupal/recommended-project drupal-download && \
#         cd drupal-download && \
#         composer require drush/drush && \
#         chown -R www-data:www-data web/sites web/modules web/themes

WORKDIR "/var/www/html"
ADD start.sh /start.sh
RUN set -eux; \
        chmod 755 /start.sh
CMD ["/start.sh"]
