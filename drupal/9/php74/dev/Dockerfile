FROM lawxen/drupal:d9-php74

# Install xdebug newest xdebug3 needs >php8.0, so install 3.1.5 instead
RUN pecl install xdebug-3.1.5 && docker-php-ext-enable xdebug

# Install Xdebug
RUN touch /var/log/xdebug.log; \
    { \
    echo '[xdebug]'; \
    echo 'xdebug.mode=debug'; \
    echo 'xdebug.client_host=host.docker.internal'; \
    echo 'xdebug.start_with_request=yes'; \
    echo 'xdebug.discover_client_host=true'; \
    echo 'xdebug.log = /var/log/xdebug.log'; \
    # echo 'xdebug.idekey=PHPSTORM'; \
    } >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install drupal coder and config it
RUN set -eux; \
        composer global require drupal/coder; \
        { \
        echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"'; \
        echo 'alias drupalcs="phpcs --standard=Drupal --extensions='php,module,inc,install,test,profile,theme,css,info,txt,md,yml'"'; \
        echo 'alias drupalcsp="phpcs --standard=DrupalPractice --extensions='php,module,inc,install,test,profile,theme,css,info,txt,md,yml'"'; \
        echo 'alias drupalcbf="phpcbf --standard=Drupal --extensions='php,module,inc,install,test,profile,theme,css,info,txt,md,yml'"'; \
        } >> /root/.bashrc

# Install Nodejs and sass
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

# RUN /bin/bash -c "source /root/.bashrc"
RUN /bin/bash -c "source /root/.bashrc;nvm install --lts"
RUN /bin/bash -c "source /root/.bashrc;npm install -g sass"
# RUN /bin/bash -c "source /root/.bashrc;npm install apidoc -g"
