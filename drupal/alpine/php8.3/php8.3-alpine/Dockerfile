FROM drupal:php8.3-fpm-alpine

# set timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install the PHP extensions and other app we need
RUN apk update \
  && apk add iputils git vim wget mariadb-client nginx autoconf g++ make \
  && rm -rf /var/cache/apk/* \
  && docker-php-ext-install bcmath

# Install redis
RUN pecl install redis && docker-php-ext-enable redis && pecl clear-cache

RUN sed -i "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm.sock/g" /usr/local/etc/php-fpm.d/www.conf

ADD drupal/config/php-config.ini /usr/local/etc/php/conf.d/php-config.ini
ADD drupal/config/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf

RUN rm -rf /etc/nginx/sites-enabled/*
ADD drupal/config/nginx/*.conf /etc/nginx/sites-enabled/

EXPOSE 80
EXPOSE 443

######## Web Folder with no drupal code ########
RUN set -eux; \
        # clean soft link which break xdebug
        rm -rf /var/www/html; \
        rm -rf /opt/drupal; \
        mkdir -p /var/www/html

ENV PATH="$PATH:~/.composer/vendor/bin:/var/www/html/vendor/bin:/var/www/html/bin"

ADD drupal/config/start.sh /start.sh
RUN set -eux; \
        chmod 755 /start.sh
CMD ["/start.sh"]
