FROM lawxen/php:7.4-nginx
#################################Copy from drupal##############################################################
# TODO switch to buster once https://github.com/docker-library/php/issues/865 is resolved in a clean way (either in the PHP image or in PHP itself)

# install the PHP extensions we need
RUN set -eux; \
	\
	if command -v a2enmod; then \
		a2enmod rewrite; \
	fi; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libfreetype6-dev \
		libjpeg-dev \
		libpng-dev \
		libpq-dev \
		libzip-dev \
	; \
	\
	docker-php-ext-configure gd \
		--with-freetype-dir=/usr \
		--with-jpeg-dir=/usr \
		--with-png-dir=/usr \
	; \
	\
	docker-php-ext-install -j "$(nproc)" \
		gd \
		opcache \
		pdo_mysql \
		pdo_pgsql \
		zip \
	; \
	\
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
	apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
		| awk '/=>/ { print $3 }' \
		| sort -u \
		| xargs -r dpkg-query -S \
		| cut -d: -f1 \
		| sort -u \
		| xargs -rt apt-mark manual; \
	\
	apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
	rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=60'; \
		echo 'opcache.fast_shutdown=1'; \
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# vim:set ft=dockerfile:
#################################End Copy from drupal##############################################################

#################################Install custom extention for drupal##############################################################
ENV DRUSH_VERSION 0.6.0

# install the PHP extensions we need
RUN apt-get update \
  && apt-get install -y git mariadb-client vim \
        && rm -rf /var/lib/apt/lists/* \
        && docker-php-ext-install bcmath

# php config for drupal
RUN { \
    echo 'memory_limit = 4096M'; \
    echo 'post_max_size = 30M'; \
    echo 'upload_max_filesize = 30M'; \
    } > /usr/local/etc/php/conf.d/php.ini

# install Composer globally
RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer

# Install redis
RUN pecl install redis -y && docker-php-ext-enable redis

# drush command
RUN curl -fsSL -o /usr/local/bin/drush "https://github.com/drush-ops/drush-launcher/releases/download/$DRUSH_VERSION/drush.phar" && \
    chmod +x /usr/local/bin/drush

#drupal console
RUN curl https://drupalconsole.com/installer -L -o drupal.phar && \
    mv drupal.phar /usr/local/bin/drupal && \
    chmod +x /usr/local/bin/drupal

# Install xdebug
RUN pecl install xdebug

ADD https://raw.githubusercontent.com/lawxen/dockerfile-php/master/drupal/nginx/7.4/docker-entrypoint /usr/local/bin/docker-entrypoint
ENTRYPOINT ["docker-entrypoint"]