FROM tutum/lamp:latest
MAINTAINER Nikolay Golub <nikolay.v.golub@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# Preparation
RUN \
  apt-get install sudo && \
  rm -fr /app/* && \
  apt-get update && apt-get install -yqq wget unzip php5-gd && \
  rm -rf /var/lib/apt/lists/* && \
  wget https://github.com/ethicalhack3r/DVWA/archive/v1.9.zip && \
  unzip /v1.9.zip && \
  rm -rf app/* && \
  cp -r /DVWA-1.9/* /app && \
  rm -rf /DVWA-1.9 && \
  sed -i "s/^\$_DVWA\[ 'db_user' \]     = 'root'/\$_DVWA[ 'db_user' ] = 'admin'/g" /app/config/config.inc.php && \
  echo "sed -i \"s/p@ssw0rd/\$PASS/g\" /app/config/config.inc.php" >> /create_mysql_admin_user.sh && \
  echo 'session.save_path = "/tmp"' >> /etc/php5/apache2/php.ini && \
  sed -ri -e "s/^allow_url_include.*/allow_url_include = On/" /etc/php5/apache2/php.ini && \
  chmod a+w /app/hackable/uploads && \
  chmod a+w /app/external/phpids/0.6/lib/IDS/tmp/phpids_log.txt && \
  sudo service apache2 stop && \
  wget https://files.trendmicro.com/products/CloudOne/ApplicationSecurity/1.0.2/agent-php/trend_app_protect-x86_64-Linux-gnu-4.2.1-20131106.so && \
  mv trend_app_protect-*.so "$(php -r 'echo ini_get ("extension_dir");')"/trend_app_protect.so && \
  echo '; Enable the extension \n extension = trend_app_protect.so \n \n ; Add key and secret from the Application Protection dashboard \n trend_app_protect.key = f093706e-ebb8-40c4-831c-9a105e5b56b5 \n trend_app_protect.secret = c1442a86-da00-448f-b2d6-422bada4bc7f' >> /etc/php5/apache2/php.ini && \
  sudo service apache2 restart

EXPOSE 80 3306
CMD ["/run.sh"]
