FROM lawxen/drupal:9-php7-ldap

RUN set -x \
    && apt-get update \
    && apt-get install -y gnupg2 

# Microsoft ODBC 17
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get -y install msodbcsql17
RUN apt-get -y install unixodbc-dev

# 7.4
RUN apt-get -y install php-pear php7.4-dev
RUN update-alternatives --set php /usr/bin/php7.4
RUN update-alternatives --set phar /usr/bin/phar7.4
RUN update-alternatives --set phar.phar /usr/bin/phar.phar7.4
RUN update-alternatives --set phpize /usr/bin/phpize7.4
RUN update-alternatives --set php-config /usr/bin/php-config7.4

RUN pecl uninstall -r sqlsrv
RUN pecl uninstall -r pdo_sqlsrv
RUN pecl -d php_suffix=7.4 install sqlsrv
RUN pecl -d php_suffix=7.4 install pdo_sqlsrv
RUN printf "; priority=30\nextension=sqlsrv.so\n" > /etc/php/7.4/mods-available/sqlsrv.ini
RUN printf "; priority=40\nextension=pdo_sqlsrv.so\n" > /etc/php/7.4/mods-available/pdo_sqlsrv.ini
RUN phpenmod -v 7.4 sqlsrv pdo_sqlsrv

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
#     && apt-get update \
#     && ACCEPT_EULA=Y apt-get install msodbcsql17 \
#     # optional: for bcp and sqlcmd
#     && ACCEPT_EULA=Y apt-get install mssql-tools \
#     && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile \
#     && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc \
#     && source ~/.bashrc \
#     # optional: for unixODBC development headers
#     && apt-get install unixodbc-dev \
#     # optional: kerberos library for debian-slim distributions
#     && apt-get install libgssapi-krb5-2 \

# RUN set -x \
#     && sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
#     && locale-gen \
#     && pecl config-set php_ini /etc/php/7.4/fpm/php.ini \
#     && pecl install sqlsrv \
#     && pecl install pdo_sqlsrv \
#     && printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/7.4/mods-available/sqlsrv.ini \
#     && printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/7.4/mods-available/pdo_sqlsrv.ini \

# RUN set -x \
#     && phpenmod -v 7.4 sqlsrv pdo_sqlsrv