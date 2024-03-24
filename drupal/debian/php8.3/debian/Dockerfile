FROM drupal:php8.3-fpm

# set timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install the PHP extensions and other app we need
RUN apt-get update \
  && apt-get install -y iputils-ping git vim wget mariadb-client nginx \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-install bcmath \
  && rm -rf /etc/nginx/sites-enabled/*

# Install redis
RUN pecl install redis && docker-php-ext-enable redis && pecl clear-cache

RUN sed -i "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm.sock/g" /usr/local/etc/php-fpm.d/www.conf

ADD drupal/debian/config/php-config.ini /usr/local/etc/php/conf.d/php-config.ini
ADD drupal/debian/config/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
ADD drupal/debian/config/nginx/*.conf /etc/nginx/sites-enabled/

# # Install rsyslog.
# RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ precise main universe" >> /etc/apt/source.list
# RUN apt-get update
# RUN apt-get -y install rsyslog
# RUN { \
#   echo 'local0.* /var/log/drupal.log'; \
#   } >> /etc/rsyslog.conf

EXPOSE 80
EXPOSE 443

######## Web Folder with no drupal code ########
RUN set -eux; \
        # clean soft link which break xdebug
        rm -rf /var/www/html; \
        rm -rf /opt/drupal; \
        mkdir -p /var/www/html

ENV PATH="$PATH:~/.composer/vendor/bin:/var/www/html/vendor/bin:/var/www/html/bin"

ADD drupal/debian/config/start.sh /start.sh
RUN set -eux; \
        chmod 755 /start.sh
WORKDIR "/var/www/html"
CMD ["/start.sh"]
