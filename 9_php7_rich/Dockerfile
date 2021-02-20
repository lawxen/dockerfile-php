FROM lawxen/drupal:9-php7

RUN set -x \
    && apt-get update \
    && apt-get install -y libldap2-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install ldap \
    && apt-get purge -y --auto-remove libldap2-dev

RUN set -x \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \

    #Download appropriate package for the OS version
    #Choose only ONE of the following, corresponding to your OS version

    #Debian 10
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list


RUN set -x \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install msodbcsql17 \
    # optional: for bcp and sqlcmd
    && ACCEPT_EULA=Y apt-get install mssql-tools \
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile \
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc \
    && source ~/.bashrc \
    # optional: for unixODBC development headers
    && apt-get install unixodbc-dev \
    # optional: kerberos library for debian-slim distributions
    && apt-get install libgssapi-krb5-2 \

RUN set -x \
    && sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && pecl config-set php_ini /etc/php/7.4/fpm/php.ini \
    && pecl install sqlsrv \
    && pecl install pdo_sqlsrv \
    && printf "; priority=20\nextension=sqlsrv.so\n" > /etc/php/7.4/mods-available/sqlsrv.ini \
    && printf "; priority=30\nextension=pdo_sqlsrv.so\n" > /etc/php/7.4/mods-available/pdo_sqlsrv.ini \

RUN set -x \
    && phpenmod -v 7.4 sqlsrv pdo_sqlsrv