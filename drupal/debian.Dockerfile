ARG TAG_FROM

FROM drupal:${TAG_FROM}

ARG KEEP_DRUPAL_FILES
EXPOSE 80
EXPOSE 443

ENV PATH="$PATH:~/.composer/vendor/bin:/var/www/html/vendor/bin:/var/www/html/bin"
ADD config/start.sh /start.sh

# install the PHP extensions and other app we need
RUN apt-get update; \
    apt-get install -y \
    iputils-ping \
    git \
    vim \
    wget \
    mariadb-client \
    nginx; \
    rm -rf /var/lib/apt/lists/*; \
    docker-php-ext-install bcmath; \
    pecl install redis && docker-php-ext-enable redis && pecl clear-cache; \
    sed -i "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm.sock/g" /usr/local/etc/php-fpm.d/www.conf; \
    sed -i "s/etc\/nginx\/sites-enabled/etc\/nginx\/http.d/g" /etc/nginx/nginx.conf; \
    chmod 755 /start.sh; \
    # clean soft link which break xdebug
    rm -rf /var/www/html; \
    mkdir -p /var/www/html; \
    if [ "${KEEP_DRUPAL_FILES}" = "1" ] ; then \
        cd /opt/drupal; \
        composer require drush/drush; \
        composer require drupal/admin_toolbar; \
        composer require drupal/devel_php; \
        composer clear-cache; \
        sed -i 's/"minimum-stability": "stable"/"minimum-stability": "dev"/g' /opt/drupal/composer.json; \
    else \
        # rm -rf /var/www/html/{,.[^.]}*; \
        rm -rf /opt/drupal; \
    fi

ADD config/php-config.ini /usr/local/etc/php/conf.d/php-config.ini
ADD config/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
ADD config/nginx/*.conf /etc/nginx/http.d/

WORKDIR "/var/www/html"
CMD ["/start.sh"]