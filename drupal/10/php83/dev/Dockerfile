FROM lawxen/drupal:d10-php83

# Install xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Preemptively creates log files, and give them to www-data
RUN cd /var/log \
  && touch php_error.log xdebug.log \
  && chown 1001:1001 php_error.log xdebug.log

# Config Xdebug
RUN { \
    # echo '[xdebug]'; \
    echo 'xdebug.mode=debug'; \
    echo 'xdebug.client_host=host.docker.internal'; \
    echo 'xdebug.discover_client_host=true'; \
    echo 'xdebug.start_with_request=yes'; \
    echo 'xdebug.log = /var/log/xdebug.log'; \
    # echo 'xdebug.idekey=PHPSTORM'; \
    } >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install drupal coder and config it
RUN set -eux; \
        composer global require drupal/coder; \
        { \
        echo 'export PATH="$PATH:$HOME/.composer/vendor/bin"'; \
        echo 'alias drupalcs="phpcs --standard=Drupal --extensions=\"php,module,inc,install,test,profile,theme,css,info,txt,md,yml\""'; \
        echo 'alias drupalcsp="phpcs --standard=DrupalPractice --extensions=\"php,module,inc,install,test,profile,theme,css,info,txt,md,yml\""'; \
        echo 'alias drupalcbf="phpcbf --standard=Drupal --extensions=\"php,module,inc,install,test,profile,theme,css,info,txt,md,yml\""'; \
        } >> /root/.bashrc

# Install Nodejs and sass
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

# RUN /bin/bash -c "source /root/.bashrc"
RUN /bin/bash -c "source /root/.bashrc;nvm install --lts"
RUN /bin/bash -c "source /root/.bashrc;npm install -g sass"
# RUN /bin/bash -c "source /root/.bashrc;npm install apidoc -g"
RUN /bin/bash -c "source /root/.bashrc;npm install -g sass-convert"
# Enable yarn by Corepack
RUN /bin/bash -c "source /root/.bashrc;corepack enable"