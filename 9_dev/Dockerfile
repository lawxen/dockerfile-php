FROM lawxen/drupal:9

# Install xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

RUN { \
    echo '[xdebug]'; \
    echo 'xdebug.remote_enable=1'; \
    echo 'xdebug.remote_handler=dbgp'; \
    echo 'xdebug.remote_host=host.docker.internal'; \
    echo 'xdebug.remote_port=9000'; \
    echo 'xdebug.remote_autostart=1'; \
    echo 'xdebug.remote_connect_back=1'; \
    echo 'xdebug.idekey=PHPSTORM'; \
    } >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini