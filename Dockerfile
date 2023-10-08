FROM php:8.1-fpm
RUN apt update -y
RUN apt install -y vim openssl libssl-dev wget zlib1g-dev libzip-dev nodejs npm
RUN cd /tmp && wget https://pecl.php.net/get/swoole-5.1.0.tgz && \
    tar zxvf swoole-5.1.0.tgz && \
    cd swoole-5.1.0  && \
    phpize  && \
    ./configure  --enable-openssl && \
    make && make install
RUN touch /usr/local/etc/php/conf.d/swoole.ini && echo 'extension=swoole.so' > /usr/local/etc/php/conf.d/swoole.ini
RUN docker-php-ext-install bcmath
RUN pecl install -o -f redis &&  rm -rf /tmp/pear && docker-php-ext-enable redis
RUN docker-php-ext-install zip
RUN docker-php-ext-install sockets
WORKDIR /var/www/app
COPY . .
#RUN cp .env.develop .env
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
RUN composer install
#EXPOSE 9501
#ENV TZ='Tehran-3:30'
#CMD ["/usr/local/bin/php", "/app/Start.php"]


