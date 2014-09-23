FROM tutum/lamp:latest
MAINTAINER Nikolay Golub <nikolay.v.golub@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Preparation
RUN rm -fr /app/*
RUN apt-get install -yqq wget unzip

# Deploy DVWA
RUN wget https://github.com/RandomStorm/DVWA/archive/v1.0.8.zip 
RUN unzip /v1.0.8.zip
RUN rm -rf app/*
RUN cp -r /DVWA-1.0.8/* /app
RUN rm -rf /DVWA-1.0.8

# Configure DB options and PHP options
RUN sed -i "s/^\$_DVWA\[ 'db_user' \] = 'root'/\$_DVWA[ 'db_user' ] = 'admin'/g" /app/config/config.inc.php
RUN echo "sed -i \"s/p@ssw0rd/\$PASS/g\" /app/config/config.inc.php" >> /create_mysql_admin_user.sh 
RUN echo 'session.save_path = "/tmp"' >> /etc/php5/apache2/php.ini 

EXPOSE 80 3306
CMD ["/run.sh"]
