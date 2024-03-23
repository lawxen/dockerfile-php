FROM drupal:10-php8.1-fpm

# set timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install the PHP extensions and other app we need
RUN apt-get update \
  && apt-get install -y iputils-ping git vim wget mariadb-client nginx \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-install bcmath

# Install redis
RUN pecl install redis && docker-php-ext-enable redis

RUN sed -i "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm.sock/g" /usr/local/etc/php-fpm.d/www.conf

# install Composer globally
RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer

ADD config/php-config.ini /usr/local/etc/php/conf.d/php-config.ini
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
        rm -rf /var/www/html; \
        mv /opt/drupal /var/www/html

# Install drush
WORKDIR "/var/www/html"
RUN set -eux; \
        export COMPOSER_HOME="$(mktemp -d)"; \
        composer require drush/drush; \
        composer require drupal/admin_toolbar; \
        composer require drupal/devel; \
	      # delete composer cache
	      rm -rf "$COMPOSER_HOME"

RUN echo "export PATH=\"$PATH:$HOME/.composer/vendor/bin:/var/www/html/vendor/bin:/var/www/html/bin\""  >> /root/.bashrc

ADD start.sh /start.sh
RUN set -eux; \
        chmod 755 /start.sh
CMD ["/start.sh"]