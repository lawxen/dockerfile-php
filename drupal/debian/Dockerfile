ARG MY_PHP_VERSION
ARG MY_DRUPAL_VERSION

# FROM drupal:${DRUPAL_VERSION}-php${PHP_VERSION}-fpm
FROM drupal:${MY_DRUPAL_VERSION}-php${MY_PHP_VERSION}-fpm

ARG MY_PHP_VERSION
ARG MY_DRUPAL_VERSION
ARG KEEP_DRUPAL_FILES
EXPOSE 80
EXPOSE 443

# set timezone
ENV TZ=Asia/Shanghai
ENV PATH="$PATH:~/.composer/vendor/bin:/var/www/html/vendor/bin:/var/www/html/bin"
ADD config/php-config.ini /usr/local/etc/php/conf.d/php-config.ini
ADD config/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
ADD config/nginx/*.conf /etc/nginx/sites-enabled/
ADD config/start.sh /start.sh

# install the PHP extensions and other app we need
RUN apt-get update; \
    apt-get install -y iputils-ping git vim wget mariadb-client nginx; \
    rm -rf /var/lib/apt/lists/*; \
    docker-php-ext-install bcmath; \
    rm -rf /etc/nginx/sites-enabled/*; \
    pecl install redis && docker-php-ext-enable redis && pecl clear-cache; \
    sed -i "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm.sock/g" /usr/local/etc/php-fpm.d/www.conf; \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone; \
    chmod 755 /start.sh

ADD config/nginx/*.conf /etc/nginx/sites-enabled/

# clean soft link which break xdebug
RUN rm -rf /var/www/html; \
    mv /opt/drupal /var/www/html
WORKDIR "/var/www/html"
RUN if [ "${KEEP_DRUPAL_FILES}" = "1" ] ; then \
        export COMPOSER_HOME="$(mktemp -d)"; \
        composer require drush/drush; \
        composer require drupal/admin_toolbar; \
        composer require drupal/devel; \
        rm -rf "$COMPOSER_HOME"; \
    else \
        rm -rf /var/www/html/{,.[^.]}*; \
    fi

CMD ["/start.sh"]
