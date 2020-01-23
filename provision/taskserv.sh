#!/usr/bin/env bash
#
# Provision VM for rview
#

SCRIPT_PATH=$(dirname $(readlink -f $0 ) )

cd /var/www/rview
su vagrant -c "/var/www/rview/venv/bin/celery -A rview_celery_task.celery worker --concurrency=1 --loglevel=INFO &>> /tmp/celery.log &"

# Reference for non-vagrant:
# cd /vagrant
# su www-data -c "celery -A rview_celery_task.celery worker --concurrency=1 --loglevel=INFO &"
