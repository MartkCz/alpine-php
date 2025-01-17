# https://github.com/jorge07/alpine-php
# https://dev.whatwedo.ch/whatwedo/php-alpine
FROM alpine:3.12 as main

ARG COMPOSER_VERSION=2.0.8

ADD https://packages.whatwedo.ch/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub

RUN apk --update add ca-certificates \
    && echo "@cast https://packages.whatwedo.ch/php-alpine/v3.12/php-8.0" >> /etc/apk/repositories \
    && apk add -U \
    # Packages
    tini \
    php8@cast \
    php8-dev@cast \
    php8-common@cast \
    php8-pdo@cast \
    php8-pdo_mysql@cast \
    php8-apcu@cast \
    php8-gd@cast \
    php8-xmlreader@cast \
    php8-bcmath@cast \
    php8-ctype@cast \
    php8-curl@cast \
    php8-exif@cast \
    php8-iconv@cast \
    php8-intl@cast \
    php8-mbstring@cast \
    php8-opcache@cast \
    php8-openssl@cast \
    php8-pcntl@cast \
    php8-phar@cast \
    php8-session@cast \
    php8-xml@cast \
    php8-xsl@cast \
    php8-zip@cast \
    php8-zlib@cast \
    php8-dom@cast \
    php8-fpm@cast \
    php8-sodium@cast \
    php8-memcached@cast \
    php8-redis@cast \
    php8-swoole@cast \
    php8-imagick@cast \
    # Vim \
    vim \
    curl \
    # Iconv Fix
    && apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted gnu-libiconv \
    # Binary php8 -> php \
    && ln -s /usr/bin/php8 /usr/bin/php \
    # Download composer.
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer --version=${COMPOSER_VERSION}

# Clean up
RUN rm -rf /var/cache/apk/*


ADD rootfs /

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["/usr/sbin/php-fpm8", "-R", "--nodaemonize"]

EXPOSE 9000

WORKDIR /app

############

#FROM main as dev
#
#ARG USER=root
#ARG PASSWORD=root
#
#RUN apk add -U --no-cache \
#        php8-pear \
#        openssh \
#        supervisor \
#        autoconf \
#        curl \
#        wget \
#        make \
#        zip \
#        php8-xdebug@cast \
#    # Delete APK cache.
#    && rm -rf /var/cache/apk/* \
#    # Create ssh user for dev.
#    && sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
#    && echo "${USER}:${PASSWORD}" | chpasswd \
#    && ssh-keygen -A \
#
#CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord/conf.d/supervisord.conf"]
#
#EXPOSE 22 9003
