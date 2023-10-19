FROM drupal:9-php7.4-fpm

# set timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install the PHP extensions and other app we need
RUN apt-get update \
  && apt-get install -y git vim wget mariadb-client nginx \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-install bcmath

# Install redis
RUN pecl install redis && docker-php-ext-enable redis

RUN sed -i "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm.sock/g" /usr/local/etc/php-fpm.d/www.conf

# install Composer globally
RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer

# RUN set -eux; \
#   # Install Drush
#   wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar \
#   && chmod +x drush.phar \
#   && mv drush.phar /usr/local/bin/drush \
#   # Install Drupal Console
#   && curl https://drupalconsole.com/installer -L -o drupal.phar \
#   && mv drupal.phar /usr/local/bin/drupal \
#   && chmod +x /usr/local/bin/drupal \

ADD config/php-upload.ini /usr/local/etc/php/conf.d/php-uploads.ini
ADD config/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf

RUN rm -rf /etc/nginx/sites-enabled/*
ADD config/nginx/*.conf /etc/nginx/sites-enabled/

# Install rsyslog.
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ precise main universe" >> /etc/apt/source.list
RUN apt-get update
RUN apt-get -y install rsyslog
RUN { \
  echo 'local0.* /var/log/drupal.log'; \
  } >> /etc/rsyslog.conf

EXPOSE 80
EXPOSE 443

# clean soft link which break xdebug
RUN set -eux; \
        rm -rf /opt && \
        rm -rf /var/www && \
        mkdir -p /var/www/html

ENV PATH=${PATH}:/var/www/html/vendor/bin
ENV PATH=${PATH}:/var/www/html/bin

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
