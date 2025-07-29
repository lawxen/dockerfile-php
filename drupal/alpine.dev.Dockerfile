ARG TAG_FROM
FROM lawxen/drupal:${TAG_FROM}

ARG TAG_FROM

########### DEV #############
# Install xdebug
# https://github.com/nvm-sh/nvm?tab=readme-ov-file#alpine-linux-313
RUN pecl channel-update pecl.php.net; \
    if [[ "${TAG_FROM}" == *"p7.4"* ]] ; then \
    pecl install xdebug-3.1.5 && docker-php-ext-enable xdebug && pear clear-cache; \
    else \
    pecl install xdebug && docker-php-ext-enable xdebug && pear clear-cache; \
    fi; \
    # Install Nodejs and sass
    # curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash; \
    # /bin/bash -c "source /root/.bashrc;nvm install --lts && npm install -g sass && npm install -g sass-convert && nvm cache clear && npm cache clear"; \
    # Delete no needed packages
    # apk del \
    # linux-headers \
    # autoconf g++ \
    # make \
    # # python3 \
    # ;

# Preemptively creates log files, and give them to www-data
RUN cd /var/log \
    && touch php_error.log xdebug.log \
    && chown 1001:1001 php_error.log xdebug.log; \
    { \
    echo "xdebug.mode=debug"; \
    echo "xdebug.client_host=host.docker.internal"; \
    echo "xdebug.discover_client_host=true"; \
    echo "xdebug.start_with_request=yes"; \
    echo "xdebug.log=/var/log/xdebug.log"; \
    } >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install drupal coder and config it
RUN composer global require drupal/coder; \
    composer clear-cache; \
    { \
    echo "alias drupalcs=\"phpcs --standard=Drupal --extensions=\"php,module,inc,install,test,profile,theme,css,info,txt,md,yml\"\""; \
    echo "alias drupalcsp=\"phpcs --standard=DrupalPractice --extensions=\"php,module,inc,install,test,profile,theme,css,info,txt,md,yml\"\""; \
    echo "alias drupalcbf=\"phpcbf --standard=Drupal --extensions=\"php,module,inc,install,test,profile,theme,css,info,txt,md,yml\"\""; \
    } >> /root/.bashrc