#!/usr/bin/env bash

systemctl stop rview
systemctl stop nginx
systemctl stop uwsgi
#service nginx stop
#service uwsgi stop

## vagrant ssh --command /vagrant/restart-dev.sh
WWW_ROOT=/var/www
CACHE_ROOT="$WWW_ROOT/.cache"
RVIEW_ROOT="$WWW_ROOT/rview"
RVIEW_TARGET="$RVIEW_ROOT/rview"
SOURCE_ROOT="/vagrant"
RVIEW_SOURCE="$SOURCE_ROOT/rview"
CONF_SOURCE="$SOURCE_ROOT/conf"
CONF_TARGET="$RVIEW_ROOT/conf"
if [ -d "$RVIEW_TARGET" ]; then
  find "$RVIEW_TARGET" -name "*.pyc" -type f -exec rm {} \;
fi

if [ -d "$RVIEW_TARGET" ]; then
  rm "$RVIEW_ROOT/"*.py
  find "$RVIEW_TARGET" -name "*.py" -type f -exec rm {} \;
fi

if [ -d "$CACHE_ROOT" ]; then
  find "$CACHE_ROOT" -name "*.pyc" -type f -exec rm {} \;
fi

cp -f "$SOURCE_ROOT/"*.py "$RVIEW_ROOT"
cp -fr "$RVIEW_SOURCE" "$RVIEW_ROOT"
cp -fr "$CONF_SOURCE" "$CONF_TARGET"

chown www-data:www-data "$RVIEW_ROOT/"*.py
chown -R www-data:www-data "$RVIEW_TARGET"
sudo rm /var/log/rview.log
sudo touch /var/log/rview.log
sudo chmod 666 /var/log/rview.log

systemctl start rview
systemctl start nginx
systemctl start uwsgi
#service nginx start
#service uwsgi start
