FROM lawxen/drupal:9-php7

RUN set -x \
    && apt-get update \
    && apt-get install -y libldap2-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
    && apt-get purge -y --auto-remove libldap2-dev

# RUN set -x \
#     && apt-get update \
#     && apt-get install -y gnupg2 

# # Microsoft ODBC 17
# RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
# RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
# RUN apt-get update
# RUN ACCEPT_EULA=Y apt-get -y install msodbcsql17
# RUN apt-get -y install unixodbc-dev

# RUN pecl uninstall -r sqlsrv
# RUN pecl uninstall -r pdo_sqlsrv
# RUN pecl -d php_suffix=7.4 install sqlsrv
# RUN pecl -d php_suffix=7.4 install pdo_sqlsrv
# RUN printf "; priority=30\nextension=sqlsrv.so\n" > /etc/php/7.4/mods-available/sqlsrv.ini
# RUN printf "; priority=40\nextension=pdo_sqlsrv.so\n" > /etc/php/7.4/mods-available/pdo_sqlsrv.ini
# RUN phpenmod -v 7.4 sqlsrv pdo_sqlsrv



# RUN set -x \
#     && apt-get update \
#     && apt-get install -y gnupg2 \
#     && apt-get install -y libldap2-dev \
#     && rm -rf /var/lib/apt/lists/* \
#     && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
#     && docker-php-ext-install ldap \
#     && apt-get purge -y --auto-remove libldap2-dev

# RUN set -x \
#     && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \

#     #Download appropriate package for the OS version
#     #Choose only ONE of the following, corresponding to your OS version

#     #Debian 10
#     && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list


# RUN set -x \
#     && apt-get update

# RUN ACCEPT_EULA=Y apt-get -y install msodbcsql17

# RUN set -x \
#     # && sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
#     # && locale-gen \
#     && pecl config-set php_ini /etc/php/7.4/fpm/php.ini \
#     && pecl install sqlsrv \
#     && pecl install pdo_sqlsrv \
#     && printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/7.4/mods-available/sqlsrv.ini \
#     && printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/7.4/mods-available/pdo_sqlsrv.ini

# RUN set -x \
#     && phpenmod -v 7.4 sqlsrv pdo_sqlsrv


WORKDIR /application

ENV ACCEPT_EULA=Y

# Fix debconf warnings upon build
ARG DEBIAN_FRONTEND=noninteractive

# Install selected extensions and other stuff
RUN apt-get update \
    && apt-get -y --no-install-recommends install apt-utils libxml2-dev gnupg apt-transport-https \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Install git
RUN apt-get update \
    && apt-get -y install git \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Install MS ODBC Driver for SQL Server
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && apt-get -y --no-install-recommends install msodbcsql17 unixodbc-dev \
    && pecl install sqlsrv \
    && pecl install pdo_sqlsrv \
    && echo "extension=pdo_sqlsrv.so" >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-pdo_sqlsrv.ini \
    && echo "extension=sqlsrv.so" >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/30-sqlsrv.ini \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Install required extensions
RUN docker-php-ext-install intl mysqli pdo
# WORKDIR /var/www/html