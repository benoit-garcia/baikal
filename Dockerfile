FROM        nginx:latest
MAINTAINER  Benoit <benoit@terra-art.net>

# Set Environement variables
ENV         LC_ALL=C
ENV         DEBIAN_FRONTEND=noninteractive

# Update package repository and install packages
RUN         apt-get -y update && \
            apt-get -y install supervisor php5-fpm php5-sqlite wget && \
            apt-get clean && \
            rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Fetch the latest software version from the official website if needed
RUN         test ! -d /usr/share/nginx/html/baikal-regular && \
            wget http://baikal-server.com/get/baikal-regular-0.2.7.tgz && \
            tar xvzf baikal-regular-0.2.7.tgz -C /usr/share/nginx/html && \
            chown -R www-data:www-data /usr/share/nginx/html/baikal-regular && \
            rm baikal-regular-0.2.7.tgz

# Add configuration files. User can provides customs files using -v in the image startup command line.
COPY        supervisord.conf /etc/supervisor/supervisord.conf
COPY        nginx.conf /etc/nginx/nginx.conf
COPY        php-fpm.conf /etc/php5/fpm/php-fpm.conf

# Expose HTTP port
EXPOSE      80

# Last but least, unleach the daemon!
ENTRYPOINT  ["/usr/bin/supervisord"]
