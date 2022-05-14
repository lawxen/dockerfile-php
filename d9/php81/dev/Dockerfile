FROM lawxen/drupal:d9-php81

# Install xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

RUN { \
    echo '[xdebug]'; \
    echo 'xdebug.mode=debug'; \
    echo 'xdebug.client_host=host.docker.internal'; \
    echo 'xdebug.start_with_request=yes'; \
    echo 'xdebug.discover_client_host=true'; \
    echo 'xdebug.log = /var/log/xdebug.log'; \
    # echo 'xdebug.idekey=PHPSTORM'; \
    } >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN set -eux; \
        composer global require drupal/coder && \
        composer global require dealerdirect/phpcodesniffer-composer-installer

RUN { \
    echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"'; \
    echo 'alias drupalcs="phpcs --standard=Drupal --extensions='php,module,inc,install,test,profile,theme,css,info,txt,md,yml'"'; \
    echo 'alias drupalcsp="phpcs --standard=DrupalPractice --extensions='php,module,inc,install,test,profile,theme,css,info,txt,md,yml'"'; \
    echo 'alias drupalcbf="phpcbf --standard=Drupal --extensions='php,module,inc,install,test,profile,theme,css,info,txt,md,yml'"'; \
    } >> /root/.bashrc

# Install Nodejs and sass
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# RUN /bin/bash -c "source /root/.bashrc"
RUN /bin/bash -c "source /root/.bashrc;nvm install --lts"
RUN /bin/bash -c "source /root/.bashrc;npm install -g sass"
# RUN /bin/bash -c "source /root/.bashrc;npm install apidoc -g"
RUN /bin/bash -c "source /root/.bashrc;npm install -g sass-convert"
