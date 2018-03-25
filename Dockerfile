#
FROM php:7.2-fpm

#
ENV DEBIAN_FRONTEND noninteractive

#
RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

#
RUN apt-get update \
    && apt-get install -y apt-utils

#
RUN apt-get update \
    && apt-get install -y g++ \
    && apt-get install -y git \
    && apt-get install -y gnupg2 \
    && apt-get install -y pkg-config \
    && apt-get install -y wget

#
RUN apt-get update \
    && apt-get install -y libcurl4-openssl-dev \
    && apt-get install -y libfreetype6-dev \
    && apt-get install -y libgmp-dev \
    && apt-get install -y libicu-dev \
    && apt-get install -y libjpeg62-turbo-dev \
    && apt-get install -y libmagickwand-dev \
    && apt-get install -y libmcrypt-dev \
    && apt-get install -y libpng-dev \
    && apt-get install -y libpq-dev \
    && apt-get install -y libssl-dev \
    && apt-get install -y libzip-dev

#
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" >> /etc/apt/sources.list.d/pgdg.list
RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add - && apt-get update
RUN apt-get update \
    && apt-get install -y postgresql-client-10 \
    && apt-get install -y postgresql-doc-10 \
    && apt-get install -y postgresql-server-dev-10

#
RUN docker-php-ext-install dom
RUN docker-php-ext-install gd
RUN docker-php-ext-install iconv
RUN docker-php-ext-install intl
RUN docker-php-ext-install json
RUN docker-php-ext-install mbstring
RUN docker-php-ext-install pdo
RUN docker-php-ext-install pdo_pgsql
RUN docker-php-ext-install xml
RUN docker-php-ext-install zip

#
# RUN docker-php-ext-configure intl
#

#
#RUN pecl install mcrypt-1.0.1 \
#    && docker-php-ext-enable mcrypt-1.0.1

RUN pecl install imagick \
    && docker-php-ext-enable imagick

RUN pecl install redis \
    && docker-php-ext-enable redis

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

#
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#
RUN mkdir /app
RUN mkdir /app/storage
RUN chown -R www-data:www-data /app/storage

#
WORKDIR /app

#
COPY conf/php.ini /usr/local/etc/php/
