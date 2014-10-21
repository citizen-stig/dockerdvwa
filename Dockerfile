FROM tutum/lamp:latest
MAINTAINER Nikolay Golub <nikolay.v.golub@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Preparation
RUN \
  rm -fr /app/* && \
  apt-get install -yqq wget unzip && \
  wget https://github.com/RandomStorm/DVWA/archive/v1.0.8.zip  && \
  unzip /v1.0.8.zip && \
  rm -rf app/* && \
  cp -r /DVWA-1.0.8/* /app && \
  rm -rf /DVWA-1.0.8 && \
  sed -i "s/^\$_DVWA\[ 'db_user' \] = 'root'/\$_DVWA[ 'db_user' ] = 'admin'/g" /app/config/config.inc.php && \
  echo "sed -i \"s/p@ssw0rd/\$PASS/g\" /app/config/config.inc.php" >> /create_mysql_admin_user.sh  && \
  echo 'session.save_path = "/tmp"' >> /etc/php5/apache2/php.ini 

EXPOSE 80 3306
CMD ["/run.sh"]
