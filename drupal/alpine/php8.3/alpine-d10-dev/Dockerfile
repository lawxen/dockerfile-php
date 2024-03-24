FROM lawxen/drupal:php8.3-alpine-d10

########### DEV #############
# Install xdebug
# https://github.com/nvm-sh/nvm?tab=readme-ov-file#alpine-linux-313
RUN apk update \
  && apk add linux-headers \
  && rm -rf /var/cache/apk/*

RUN pecl install xdebug && docker-php-ext-enable xdebug && pecl clear-cache

# Preemptively creates log files, and give them to www-data
RUN cd /var/log \
  && touch php_error.log xdebug.log \
  && chown 1001:1001 php_error.log xdebug.log

# Config Xdebug
RUN { \
  # echo "[xdebug]"; \
  echo "xdebug.mode=debug"; \
  echo "xdebug.client_host=host.docker.internal"; \
  echo "xdebug.discover_client_host=true"; \
  echo "xdebug.start_with_request=yes"; \
  echo "xdebug.log=/var/log/xdebug.log"; \
  # echo "xdebug.idekey=PHPSTORM"; \
  } >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Install drupal coder and config it
RUN composer global require drupal/coder; \
    composer clear-cache

RUN { \
  echo "alias drupalcs=\"phpcs --standard=Drupal --extensions=\"php,module,inc,install,test,profile,theme,css,info,txt,md,yml\"\""; \
  echo "alias drupalcsp=\"phpcs --standard=DrupalPractice --extensions=\"php,module,inc,install,test,profile,theme,css,info,txt,md,yml\"\""; \
  echo "alias drupalcbf=\"phpcbf --standard=Drupal --extensions=\"php,module,inc,install,test,profile,theme,css,info,txt,md,yml\"\""; \
  } >> /root/.bashrc

# RUN apk update \
#   && apk add curl bash ca-certificates openssl ncurses coreutils python3 make gcc g++ libgcc linux-headers grep util-linux binutils findutils \
#   && rm -rf /var/cache/apk/*

# # Install Nodejs and sass
# RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

# RUN /bin/bash -c "source /root/.bashrc;nvm install --lts"; \
#     /bin/bash -c "source /root/.bashrc;npm install -g sass"; \
#     /bin/bash -c "source /root/.bashrc;npm install -g sass-convert"; \
#     # Enable yarn by Corepack
#     /bin/bash -c "source /root/.bashrc;corepack enable"; \
#     /bin/bash -c "source /root/.bashrc;npm cache clean --force"; \
#     /bin/bash -c "source /root/.bashrc;nvm cache clear";\ 
#     /bin/bash -c "source /root/.bashrc;yarn cache clean"