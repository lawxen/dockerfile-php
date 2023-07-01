FROM lawxen/php:symfony-php81

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

# Install Nodejs and sass
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# RUN /bin/bash -c "source /root/.bashrc"
RUN /bin/bash -c "source /root/.bashrc;nvm install --lts"
RUN /bin/bash -c "source /root/.bashrc;npm install -g sass"
# RUN /bin/bash -c "source /root/.bashrc;npm install apidoc -g"
RUN /bin/bash -c "source /root/.bashrc;npm install -g sass-convert"
