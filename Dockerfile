FROM php:fpm-alpine
RUN docker-php-ext-install pdo_mysql pdo opcache mysqli \
    && apk add --no-cache libpng-dev libxml2-dev \
    && docker-php-ext-install gd xml xmlrpc \
    && apk add --no-cache autoconf build-base \
    && pecl install igbinary \
    && docker-php-ext-enable igbinary \
    && pecl install msgpack \
    && docker-php-ext-enable msgpack \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk add --no-cache libmemcached-libs \
        libmemcached-dev \
        libevent-dev \
        zlib-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached \
    && apk del --no-cache autoconf \
        build-base \
        libmemcached-dev \
        libevent-dev \
        zlib-dev
