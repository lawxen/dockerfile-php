FROM drupal:7-php7.4-fpm

# set timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install the PHP extensions and other app we need
RUN apt-get update \
  && apt-get install -y git wget vim mariadb-client nginx\
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

# install drush, from http://docs.drush.org/en/8.x/install/
ENV DRUSH_VERSION 8.4.5
RUN wget https://github.com/drush-ops/drush/releases/download/$DRUSH_VERSION/drush.phar \
  && chmod +x drush.phar \
  && mv drush.phar /usr/local/bin/drush \
  && drush init -y

RUN set -eux; \
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
  } >> /etc/rsyslog.conf

EXPOSE 80
EXPOSE 443

WORKDIR "/var/www/html"
ADD start.sh /start.sh
RUN set -eux; \
        chmod 755 /start.sh
CMD ["/start.sh"]
