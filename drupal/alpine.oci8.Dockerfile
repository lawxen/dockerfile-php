ARG TAG_FROM=php8.3-alpine
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

# The base image (lawxen/drupal:php8.3-alpine) already ships wget/unzip and
# $PHPIZE_DEPS (gcc, make, autoconf, ...), so no extra build tools are needed.
# The Oracle Instant Client is built against glibc; on Alpine (musl) it needs
# gcompat (pulled in by libc6-compat), plus libnsl.so.1 which is not shipped.
RUN if [ "$INSTALL_OCI8" = "true" ]; then \
      apk add --no-cache libaio libnsl libc6-compat \
      && ln -sf /usr/lib/libnsl.so.3 /usr/lib/libnsl.so.1 \
      && ln -sf /usr/lib/libnsl.so.3 /usr/lib/libnsl.so.2 \
      # Install Oracle Instant Client
      && mkdir -p /opt/oracle \
      && wget -q -O /opt/oracle/instantclient-basic.zip ${ORACLE_INSTANT_CLIENT_MIRROR}instantclient-basic-linux.${ORACLE_INSTANT_CLIENT_ARCH}-${ORACLE_INSTANT_CLIENT_VERSION}.zip \
      && wget -q -O /opt/oracle/instantclient-sdk.zip ${ORACLE_INSTANT_CLIENT_MIRROR}instantclient-sdk-linux.${ORACLE_INSTANT_CLIENT_ARCH}-${ORACLE_INSTANT_CLIENT_VERSION}.zip \
      && unzip -q /opt/oracle/instantclient-basic.zip -d /opt/oracle \
      && unzip -q /opt/oracle/instantclient-sdk.zip -d /opt/oracle \
      && rm -f /opt/oracle/*.zip \
      # The channel baked into the base image may be stale ("has updated its
      # protocols"), which makes "pecl install" report no releases.
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
