FROM lawxen/drupal:9-php7-ldap

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