FROM php:8.5.11-apache-trixie
LABEL maintainer="docker@public.swineson.me"

# install the Apache2 modules we need
RUN a2enmod rewrite expires headers substitute remoteip

# install the PHP extensions we need
RUN set -x \
	&& apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y libgmp-dev libpng-dev libjpeg-dev zlib1g-dev libcurl4-gnutls-dev libldb-dev libldap2-dev libmcrypt-dev libfreetype6-dev libbz2-dev libxml2-dev libzip-dev libpq-dev libmagickwand-dev libonig-dev libwebp-dev less sudo \
	&& rm -rf /var/lib/apt/lists/* \
	&& ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
	&& ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/libldap.so \
	&& ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/liblber.so \
	&& pecl install imagick \
	&& docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
	&& docker-php-ext-configure gmp \
	&& docker-php-ext-configure intl \
	&& docker-php-ext-configure mysqli --with-mysqli=mysqlnd \
	&& docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
	&& docker-php-ext-configure zip \
	&& docker-php-ext-install bcmath bz2 curl exif gd gettext gmp intl ldap mbstring mysqli pdo pdo_mysql pdo_pgsql pcntl soap sockets zip \
	&& docker-php-ext-enable imagick

COPY --chown=0:0 rootfs_overrides/. /

VOLUME /var/www/html

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh \
	&& chmod +x /usr/local/bin/docker-entrypoint.sh

# ENTRYPOINT resets CMD
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["apache2-foreground"]
