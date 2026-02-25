# =============================================================================
# Stage 1: Composer dependencies
# =============================================================================
FROM composer:2 AS composer

WORKDIR /app

COPY composer.json composer.lock* ./
RUN composer install --no-dev --no-scripts --no-autoloader --prefer-dist

COPY . .
RUN composer dump-autoload --optimize --classmap-authoritative

# =============================================================================
# Stage 2: Production image
# =============================================================================
FROM php:8.3-fpm-alpine AS production

# Install system dependencies and PHP extensions
RUN apk add --no-cache \
        icu-libs \
        libpq \
        libzip \
    && apk add --no-cache --virtual .build-deps \
        icu-dev \
        libpq-dev \
        libzip-dev \
    && docker-php-ext-install \
        intl \
        opcache \
        pdo_pgsql \
        zip \
    && apk del .build-deps

# PHP configuration
COPY docker/php/php.ini /usr/local/etc/php/conf.d/app.ini

# Application code
WORKDIR /app

COPY --from=composer /app/vendor ./vendor
COPY . .

# Create var directory and set permissions
RUN mkdir -p var/cache var/log \
    && chown -R www-data:www-data var

# Warm up Symfony cache
RUN php bin/console cache:warmup --env=prod || true

USER www-data

EXPOSE 9000

CMD ["php-fpm"]

# =============================================================================
# Stage 3: Development image (with dev dependencies and Xdebug)
# =============================================================================
FROM production AS development

USER root

# Install dev dependencies
RUN apk add --no-cache --virtual .dev-deps \
        linux-headers \
        $PHPIZE_DEPS \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apk del .dev-deps

COPY --from=composer /usr/bin/composer /usr/bin/composer

USER www-data
