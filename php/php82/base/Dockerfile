FROM php:8.2-fpm-bullseye

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
		libwebp-dev \
		libzip-dev \
	; \
	\
	docker-php-ext-configure gd \
		--with-freetype \
		--with-jpeg=/usr \
		--with-webp \
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
	} > /usr/local/etc/php/conf.d/opcache-recommended.ini

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/

### Above copy from https://github.com/docker-library/drupal/blob/master/10.0/php8.2/fpm-bullseye/Dockerfile

# set timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install the PHP extensions and other app we need
RUN apt-get update \
  && apt-get install -y git vim wget mariadb-client nginx \
  && rm -rf /var/lib/apt/lists/* \
  && docker-php-ext-install bcmath

# Install redis
RUN pecl install redis && docker-php-ext-enable redis

# php config for drupal
RUN { \
  echo 'memory_limit = 4096M'; \
  echo 'post_max_size = 30M'; \
  echo 'upload_max_filesize = 30M'; \
  } > /usr/local/etc/php/conf.d/php.ini

RUN sed -i "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm.sock/g" /usr/local/etc/php-fpm.d/www.conf

# install Composer globally
RUN curl -sS https://getcomposer.org/installer | php \
  && mv composer.phar /usr/local/bin/composer

ADD config/php-upload.ini /usr/local/etc/php/conf.d/php-uploads.ini
ADD config/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf

# Install rsyslog.
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ precise main universe" >> /etc/apt/source.list
RUN apt-get update
RUN apt-get -y install rsyslog
# RUN { \
#   echo 'local0.* /var/log/drupal.log'; \
#   } >> /etc/rsyslog.conf

EXPOSE 80
EXPOSE 443

WORKDIR "/var/www/html"
ADD start.sh /start.sh
RUN set -eux; \
        chmod 755 /start.sh
CMD ["/start.sh"]