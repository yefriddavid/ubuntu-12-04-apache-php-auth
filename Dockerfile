FROM ubuntu:12.04
MAINTAINER Jeffrey Rios <yefriddavid@gmail.com>

RUN apt-get update
RUN apt-get -y upgrade

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 libapache2-mod-auth-mysql libapache2-mod-php5 php5-mysql php5-gd php-pear php-apc php5-curl php5-cli php5-mcrypt php5-ldap curl lynx-cur

# Enable apache mods.
#RUN php5enmod openssl
RUN a2enmod php5
RUN a2enmod rewrite
RUN a2enmod auth_mysql

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php5/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php5/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

EXPOSE 80

# Copy site into place.
#ADD app /var/www/site/app

# Update the default apache site with the config we created.
COPY apache-config/000-default.conf /etc/apache2/sites-enabled/000-default

# By default, simply start apache.
CMD /usr/sbin/apache2ctl -D FOREGROUND
