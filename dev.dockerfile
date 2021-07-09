FROM php:7.4-fpm

WORKDIR /var/www/html

RUN apt-get update \
    && apt-get install --quiet --yes --no-install-recommends \
    libzip-dev \
    unzip \
    autoconf \
    supervisor

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql zip


COPY --from=composer /usr/bin/composer /usr/bin/composer
COPY supervisord.conf /etc/supervisord.conf

# Create system user to run Composer and Artisan Commands
RUN groupadd --gid 1000 laravel \
    && useradd --uid 1000 -g laravel \
    -G www-data,root --shell /bin/bash \
    --create-home laravel

USER laravel
