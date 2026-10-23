ARG TAG_FROM=php8.3
FROM lawxen/drupal:${TAG_FROM}

###########################################################################
# PHP OCI8 (targets PHP 8.3 only)
###########################################################################

ARG INSTALL_OCI8=true
ARG ORACLE_INSTANT_CLIENT_MIRROR=https://github.com/the-paulus/oracle-instantclient/raw/master/
ARG ORACLE_INSTANT_CLIENT_ARCH=x86_64
ARG ORACLE_INSTANT_CLIENT_MAJOR=18
ARG ORACLE_INSTANT_CLIENT_MINOR=3

ENV ORACLE_INSTANT_CLIENT_VERSION=${ORACLE_INSTANT_CLIENT_MAJOR}_${ORACLE_INSTANT_CLIENT_MINOR}
ENV LD_LIBRARY_PATH="/opt/oracle/instantclient_${ORACLE_INSTANT_CLIENT_VERSION}"
ENV OCI_HOME="/opt/oracle/instantclient_${ORACLE_INSTANT_CLIENT_VERSION}"
ENV OCI_LIB_DIR="/opt/oracle/instantclient_${ORACLE_INSTANT_CLIENT_VERSION}"
ENV OCI_INCLUDE_DIR="/opt/oracle/instantclient_${ORACLE_INSTANT_CLIENT_VERSION}/sdk/include"

# The base image (lawxen/drupal:php8.3) already ships wget/unzip and the
# $PHPIZE_DEPS build tools, so only the libaio runtime dependency is needed.
RUN if [ "$INSTALL_OCI8" = "true" ]; then \
      apt-get update -yqq \
      && apt-get install -yqq --no-install-recommends libaio-dev \
      && rm -rf /var/lib/apt/lists/* \
      # Debian 13 renamed the soname to libaio.so.1t64, but the Instant Client
      # still links against libaio.so.1 (same ABI on 64-bit platforms).
      && if [ ! -e "/usr/lib/$(uname -m)-linux-gnu/libaio.so.1" ]; then \
           ln -s libaio.so.1t64 "/usr/lib/$(uname -m)-linux-gnu/libaio.so.1"; \
         fi \
      # Install Oracle Instant Client
      && mkdir -p /opt/oracle \
      && wget -q -O /opt/oracle/instantclient-basic.zip ${ORACLE_INSTANT_CLIENT_MIRROR}instantclient-basic-linux.${ORACLE_INSTANT_CLIENT_ARCH}-${ORACLE_INSTANT_CLIENT_VERSION}.zip \
      && wget -q -O /opt/oracle/instantclient-sdk.zip ${ORACLE_INSTANT_CLIENT_MIRROR}instantclient-sdk-linux.${ORACLE_INSTANT_CLIENT_ARCH}-${ORACLE_INSTANT_CLIENT_VERSION}.zip \
      && unzip -q /opt/oracle/instantclient-basic.zip -d /opt/oracle \
      && unzip -q /opt/oracle/instantclient-sdk.zip -d /opt/oracle \
      && rm -f /opt/oracle/*.zip \
      # PECL channel metadata can be stale/broken; don't let that abort the build
      && (pecl channel-update pecl.php.net || true) \
      && (pecl clear-cache || true) \
      # oci8 3.4.1 is the version tested with PHP 8.2/8.3
      && echo "instantclient,${OCI_HOME}/" | pecl install oci8-3.4.1 \
      && docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,${OCI_HOME},${ORACLE_INSTANT_CLIENT_MAJOR}.${ORACLE_INSTANT_CLIENT_MINOR} \
      && docker-php-ext-install pdo_oci \
      && docker-php-ext-enable oci8 \
      # Fail the build here instead of shipping an image with a broken .so
      # (php -m reports PDO_OCI in upper case, so check via extension_loaded)
      && php -r 'exit(extension_loaded("oci8") ? 0 : 1);' \
      && php -r 'exit(extension_loaded("pdo_oci") ? 0 : 1);' \
      ;fi
