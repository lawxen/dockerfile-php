ARG TAG_FROM
FROM lawxen/drupal:${TAG_FROM}

ARG TAG_FROM

# Build and install the GEOS PHP extension.
# See https://git.osgeo.org/gitea/geos/php-geos
ARG PHP_GEOS_VERSION=dfe1ab17b0f155cc315bc13c75689371676e02e1
ADD https://github.com/libgeos/php-geos/archive/${PHP_GEOS_VERSION}.tar.gz /opt/php-geos.tar.gz
RUN apt-get update && apt-get install -y libgeos-dev \
  && ( tar xzf /opt/php-geos.tar.gz -C /opt/ \
    && cd /opt/php-geos-${PHP_GEOS_VERSION} \
    && ./autogen.sh \
    && ./configure \
    && make \
    && make install \
    )

# Install the and Exif PHP extensions.
RUN docker-php-ext-install exif
RUN docker-php-ext-enable exif geos