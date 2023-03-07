FROM php:8.2-fpm

RUN apt -y update

RUN apt -y install libzip-dev libpng-dev unzip supervisor \
    && pecl install redis \
    && docker-php-ext-enable redis

RUN docker-php-ext-install zip pdo_mysql gd \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

COPY docker/php/zzz-docker.conf /usr/local/etc/php-fpm.d/zzz-docker.conf

COPY ./docker/php/supervisord.conf /etc/

# node install
ARG NODE_VERSION=18.x
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION | bash - \
  && apt-get install -y nodejs

# yarn install
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && apt-get install -y yarn

# Composer install
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
ENV PATH $PATH:/composer/vendor/bin

WORKDIR /var/www

RUN composer global require "laravel/installer"

RUN chown -R root:root . && chmod -R 777 /var/www/

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*
