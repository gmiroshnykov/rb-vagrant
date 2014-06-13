#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -qq

# pre-configure MySQL root password for noninteractive installation
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password password root'
sudo debconf-set-selections <<< 'mysql-server-5.5 mysql-server/root_password_again password root'

# install APT packages
sudo apt-get install -qq -y vim screen curl python-dev python-setuptools \
  python-software-properties \
  apache2 libapache2-mod-wsgi \
  mysql-server libmysqlclient-dev memcached \
  patch git mercurial

pushd /opt/reviewboard-mercurial-hook
  npm install
popd

# import github.com's public key
ssh-keyscan github.com >> ~/.ssh/known_hosts

# allow setting RT_* env vars over SSH
echo 'AcceptEnv RT_*' | sudo tee -a /etc/ssh/sshd_config > /dev/null
sudo service ssh restart

# install Review Roard + rbbz extension
sudo easy_install --quiet python-memcached mysql-python
sudo easy_install --quiet -f http://downloads.reviewboard.org/releases/ReviewBoard/2.0/ -U ReviewBoard
sudo easy_install --quiet rbbz

# restart MySQL (why?)
sudo service mysql restart

# create RB MySQL uwer
mysqladmin --user=root --password=root create reviewboard
mysql --user=root --password=root --execute="GRANT ALL PRIVILEGES ON reviewboard.* TO 'reviewboard'@'localhost' IDENTIFIED BY 'reviewboard';"

# generate RB site
export RB_HOST="rb.dev"
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

# fix permissions for newly generated RB site
sudo chown -R www-data "/var/www/${RB_HOST}/htdocs/media/uploaded"
sudo chown -R www-data "/var/www/${RB_HOST}/htdocs/media/ext"
sudo chown -R www-data "/var/www/${RB_HOST}/htdocs/static/ext"
sudo chown -R www-data "/var/www/${RB_HOST}/data"

# enable RB site's vhost
sudo ln -sf "/var/www/${RB_HOST}/conf/apache-wsgi.conf" "/etc/apache2/sites-enabled/${RB_HOST}"
# remove default vhost
sudo rm /etc/apache2/sites-enabled/000-default
# restart apache
sudo service apache2 restart

echo "DONE: http://${RB_HOST}/"
