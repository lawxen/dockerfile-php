ARG TAG_FROM=php8.3-fpm-alpine
FROM lawxen/drupal:${TAG_FROM}

RUN apk add --no-cache \
  linux-headers \
  autoconf \
  g++ \
  make \
  # python3\
  ; \
  rm -rf /var/cache/apk/*;

###########################################################################
# PHP OCI8:
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
ENV OCI_VERSION=${ORACLE_INSTANT_CLIENT_MAJOR}

RUN if [ ${INSTALL_OCI8} = true ]; then \
  # Install Oracle Instantclient
  mkdir /opt/oracle \
  && cd /opt/oracle \
  && wget ${ORACLE_INSTANT_CLIENT_MIRROR}instantclient-basic-linux.${ORACLE_INSTANT_CLIENT_ARCH}-${ORACLE_INSTANT_CLIENT_VERSION}.zip \
  && wget ${ORACLE_INSTANT_CLIENT_MIRROR}instantclient-sdk-linux.${ORACLE_INSTANT_CLIENT_ARCH}-${ORACLE_INSTANT_CLIENT_VERSION}.zip \
  && unzip /opt/oracle/instantclient-basic-linux.${ORACLE_INSTANT_CLIENT_ARCH}-${ORACLE_INSTANT_CLIENT_VERSION}.zip -d /opt/oracle \
  && unzip /opt/oracle/instantclient-sdk-linux.${ORACLE_INSTANT_CLIENT_ARCH}-${ORACLE_INSTANT_CLIENT_VERSION}.zip -d /opt/oracle \
  && if [ ${OCI_VERSION} -lt 18 ] ; then ln -s /opt/oracle/instantclient_${ORACLE_INSTANT_CLIENT_VERSION}/libclntsh.so.${ORACLE_INSTANT_CLIENT_MAJOR}.${ORACLE_INSTANT_CLIENT_MINOR} /opt/oracle/instantclient_${ORACLE_INSTANT_CLIENT_VERSION}/libclntsh.so ; fi\
  && if [ ${OCI_VERSION} -lt 18 ] ; then ln -s /opt/oracle/instantclient_${ORACLE_INSTANT_CLIENT_VERSION}/libclntshcore.so.${ORACLE_INSTANT_CLIENT_MAJOR}.${ORACLE_INSTANT_CLIENT_MINOR} /opt/oracle/instantclient_${ORACLE_INSTANT_CLIENT_VERSION}/libclntshcore.so ; fi \
  && if [ ${OCI_VERSION} -lt 18 ] ; then ln -s /opt/oracle/instantclient_${ORACLE_INSTANT_CLIENT_VERSION}/libocci.so.${ORACLE_INSTANT_CLIENT_MAJOR}.${ORACLE_INSTANT_CLIENT_MINOR} /opt/oracle/instantclient_${ORACLE_INSTANT_CLIENT_VERSION}/libocci.so ; fi \
  && rm -rf /opt/oracle/*.zip \
  # Install PHP extensions deps
  && apk add --no-cache \
  libaio-dev \
  freetds-dev \
  libnsl \
  libc6-compat && \
  ln -s /usr/lib/libnsl.so.3 /usr/lib/libnsl.so.1 && \
  ln -s /usr/lib/libnsl.so.3 /usr/lib/libnsl.so.2 && \
  ln -s /usr/lib/libc.so /usr/lib/libresolv.so.2 && \
  # Install PHP extensions
  if [ $(php -r "echo PHP_MAJOR_VERSION;") = "5" ]; then \
  echo 'instantclient,/opt/oracle/instantclient_${ORACLE_INSTANT_CLIENT_VERSION}/' | pecl install oci8-2.0.12; \
  elif [ $(php -r "echo PHP_MAJOR_VERSION;") = "7" ]; then \
  echo 'instantclient,/opt/oracle/instantclient_${ORACLE_INSTANT_CLIENT_VERSION}/' | pecl install oci8-2.2.0; \
  elif [ $(php -r "echo PHP_MAJOR_VERSION;") = "8" ] && [ $(php -r "echo PHP_MINOR_VERSION;") = "0" ]; then \
  echo "instantclient,/opt/oracle/instantclient_${ORACLE_INSTANT_CLIENT_VERSION}/" | pecl install oci8-3.0.1; \
  elif [ $(php -r "echo PHP_MAJOR_VERSION . PHP_MINOR_VERSION;") = "81" ]; then \
  echo "instantclient,/opt/oracle/instantclient_${ORACLE_INSTANT_CLIENT_VERSION}/" | pecl install oci8-3.2.1; \
  else \
  echo "instantclient,/opt/oracle/instantclient_${ORACLE_INSTANT_CLIENT_VERSION}/" | pecl install oci8; \
  fi \
  && docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/opt/oracle/instantclient_${ORACLE_INSTANT_CLIENT_VERSION},${ORACLE_INSTANT_CLIENT_MAJOR}.${ORACLE_INSTANT_CLIENT_MINOR} \
  && docker-php-ext-configure pdo_dblib --with-libdir=/lib/x86_64-linux-gnu \
  && docker-php-ext-install \
  pdo_oci \
  && docker-php-ext-enable \
  oci8 \
  ;fi