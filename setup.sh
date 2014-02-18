#!/usr/bin/env bash
export RB_HOST="rb.dev"

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -qq

sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'

sudo apt-get install -qq -y python-dev python-setuptools \
  apache2 libapache2-mod-wsgi \
  mysql-server libmysqlclient-dev memcached patch

sudo easy_install --quiet ReviewBoard python-memcached mysql-python

sudo service mysql restart

mysqladmin --user=root --password=root create reviewboard
mysql --user=root --password=root --execute="GRANT ALL PRIVILEGES ON reviewboard.* TO 'reviewboard'@'localhost' IDENTIFIED BY 'reviewboard';"

sudo rb-site install \
  --noinput \
  --domain-name=${RB_HOST} \
  --site-root=/ \
  --static-url=static/ \
  --media-url=media/ \
  --db-type=mysql \
  --db-name=reviewboard \
  --db-host=localhost \
  --db-user=reviewboard \
  --db-pass=reviewboard \
  --cache-type=memcached \
  --cache-info=localhost:11211 \
  --web-server-type=apache \
  --python-loader=wsgi \
  --admin-user=admin \
  --admin-password=admin \
  --admin-email=admin \
  /var/www/${RB_HOST}

sudo chown -R www-data "/var/www/${RB_HOST}/htdocs/media/uploaded"
sudo chown -R www-data "/var/www/${RB_HOST}/htdocs/media/ext"
sudo chown -R www-data "/var/www/${RB_HOST}/data"

sudo ln -sf "/var/www/${RB_HOST}/conf/apache-wsgi.conf" "/etc/apache2/sites-enabled/${RB_HOST}"
sudo service apache2 restart

echo "DONE: http://${RB_HOST}/"
