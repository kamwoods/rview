#!/usr/bin/env bash

WWW_ROOT=/var/www

echo "rview: Configuring rview web stack..."

 # Temporary: Create and perm-fix log file
echo "rview: Preparing log file"
sudo touch /var/log/rview.log
sudo chmod 666 /var/log/rview.log

if [ -d "$WWW_ROOT/run" ]; then
  rm -rf "$WWW_ROOT/run"
fi

mkdir "$WWW_ROOT/run"
chown www-data:www-data "$WWW_ROOT/run"
chmod 777 "$WWW_ROOT/run"

touch /var/log/uwsgi/emperor.log
chown www-data:www-data /var/log/uwsgi/emperor.log
chmod 666 /var/log/uwsgi/emperor.log

touch /var/log/uwsgi/app/rview.log
chown www-data:www-data /var/log/uwsgi/app/rview.log
chmod 666 /var/log/uwsgi/app/rview.log

cp /vagrant/uwsgi.conf /etc/init
cp /vagrant/uwsgi_config.ini /etc/uwsgi/apps-available/
ln -s /etc/uwsgi/apps-available/uwsgi_config.ini /etc/uwsgi/apps-enabled

# NGINX Setup
rm /etc/nginx/sites-enabled/default
cp /vagrant/nginx_config /etc/nginx/sites-available/
ln -s /etc/nginx/sites-available/nginx_config /etc/nginx/sites-enabled

# Start UWSGI and NGINX
echo "rview: Restarting nginx.....";
sudo systemctl restart nginx
#service nginx restart
echo "rview: Restarting usgi.....";
sudo systemctl restart uwsgi
#service uwsgi restart

# Give vagrant user access to www-data
usermod -a -G www-data vagrant
