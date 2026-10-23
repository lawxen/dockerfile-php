ARG TAG_FROM

FROM drupal:${TAG_FROM}

ARG KEEP_DRUPAL_FILES
EXPOSE 80
EXPOSE 443

ENV PATH="$PATH:~/.composer/vendor/bin:/var/www/html/vendor/bin:/var/www/html/bin"
ADD config/start.sh /start.sh

# install the PHP extensions and other app we need
RUN apk add --no-cache \
    patch \
    iputils \
    git unzip \
    vim \
    wget \
    mariadb-client \
    postgresql-client \
    nginx \
    bash \
    linux-headers \
    autoconf \
    g++ \
    make \
    sudo; \
    update-ca-certificates; \
    git config --global http.sslVerify false; \
    apk add --no-cache $PHPIZE_DEPS; \
    rm -rf /var/cache/apk/*; \
    echo 'PS1="\u@$(hostname):\w$ "' >> ~/.bashrc; \
    docker-php-ext-install -j"$(nproc)" bcmath exif; \
    pecl channel-update pecl.php.net; \
    pecl install redis && docker-php-ext-enable redis && pecl clear-cache; \
    # geos 已从 PECL 下架，改从官方源码编译；固定 commit 保证可复现
    apk add --no-cache geos geos-dev; \
    ( set -e; \
      cd /tmp; \
      wget -q -O php-geos.tar.gz https://github.com/libgeos/php-geos/archive/1a1c6a95697359892886a2050570007754ce575e.tar.gz; \
      tar -xzf php-geos.tar.gz; \
      cd php-geos-1a1c6a95697359892886a2050570007754ce575e; \
      phpize; \
      ./configure --enable-geos; \
      make -j"$(nproc)"; \
      make install; \
      docker-php-ext-enable geos; \
    ) || exit 1; \
    rm -rf /tmp/php-geos-* /tmp/php-geos.tar.gz; \
    apk del geos-dev; \
    rm -rf /var/cache/apk/*; \
    sed -i "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm.sock/g" /usr/local/etc/php-fpm.d/www.conf; \
    chmod 755 /start.sh; \
    # clean soft link which break xdebug
    rm -rf /var/www/html; \
    mkdir -p /var/www/html; \
    if [ "${KEEP_DRUPAL_FILES}" = "1" ] ; then \
        cd /opt/drupal; \
        if [ "${TAG_FROM}" = "8.9.20-php7.4-fpm-alpine" ] ; then \
            composer require drush/drush:^10 drupal/admin_toolbar drupal/devel_php; \
        else \
            composer require drush/drush drupal/admin_toolbar drupal/devel_php; \
        fi; \
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