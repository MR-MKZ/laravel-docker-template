FROM php:8.2.11-apache

ARG PROJECT_DIR

# Install composer
RUN echo "\e[1;33mInstall COMPOSER\e[0m"
RUN cd /tmp \
   && curl -sS https://getcomposer.org/installer | php \
   && mv composer.phar /usr/local/bin/composer

RUN docker-php-ext-install pdo pdo_mysql

RUN apt-get update

# Install useful tools
RUN apt-get -y install apt-utils nano wget dialog vim

# Install important libraries
RUN echo "\e[1;33mInstall important libraries\e[0m"
RUN apt-get -y install --fix-missing \
    apt-utils \
    build-essential \
    git \
    curl \
    libcurl4 \
    libcurl4-openssl-dev \
    zlib1g-dev \
    libzip-dev \
    zip \
    libbz2-dev \
    locales \
    libmcrypt-dev \
    libicu-dev \
    libonig-dev \
    libxml2-dev


RUN mkdir /var/www/html/${PROJECT_DIR}

WORKDIR /var/www/html/${PROJECT_DIR}

COPY ./${PROJECT_DIR} .

RUN composer install

RUN chown -R www-data:www-data /var/www/html/${PROJECT_DIR}

RUN chmod -R 755 /var/www/html/${PROJECT_DIR}/storage

RUN php artisan key:generate

# RUN php artisan migrate