FROM php:7.2-fpm

ADD ./php/www.conf /usr/local/etc/php-fpm.d/

RUN apt-get update && apt-get install -y \
    libxml2-dev \
    unixodbc-dev \
    gnupg2 \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/18.04/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y --allow-unauthenticated msodbcsql17

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql  \
    && pecl install -f sqlsrv pdo_sqlsrv xdebug \
    && docker-php-ext-enable sqlsrv pdo_sqlsrv xdebug

RUN usermod -u 1000 www-data

#/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 'Passw0rd
