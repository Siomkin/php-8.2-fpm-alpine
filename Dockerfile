FROM php:8.2.13-fpm-alpine

ENV TZ=UTC

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN apk update && apk upgrade

# Install dependencies
RUN apk add mariadb-client ca-certificates postgresql-dev libssh-dev zip libzip-dev libxml2-dev jpegoptim optipng pngquant gifsicle libxslt-dev rabbitmq-c-dev icu-dev oniguruma-dev gmp-dev

RUN apk add freetype-dev libjpeg-turbo-dev libpng-dev jpeg-dev libwebp-dev

RUN apk add supervisor bash curl unzip git

RUN apk add --update linux-headers
RUN apk add --no-cache $PHPIZE_DEPS && pecl install xdebug-3.3.0 && docker-php-ext-enable xdebug

# Install extensions
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions zip opcache pdo_mysql pdo_pgsql mysqli bcmath sockets xsl exif intl gmp pcntl redis gd

#RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp && docker-php-ext-install gd

WORKDIR /var/www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
