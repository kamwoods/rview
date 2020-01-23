#!/usr/bin/python
# coding=UTF-8
#
# This file contains celery support code for the rview application.
#

from flask import Flask, current_app
from rview import app
from celery import Celery
import rview
from rview import *

# Originally defined in rview_default_settings.py. May need to be moved.
app.config['CELERY_BROKER_URL'] = 'amqp://guest@localhost//'
app.config['CELERY_RESULT_BACKEND'] = 'amqp://guest@localhost//'

celery = Celery(app.name, broker=app.config['CELERY_BROKER_URL'])
celery.conf.update(app.config)

@celery.task(bind=True)
def rviewIndexAsynchronously(self):
    """ The Celery worker task. Run in parallel with the rview app. When Lucene 
        indexes for disk images are generated, the main app (rview) calls this 
        worker thread which in turn, invokes the indexing routine.
        Invoked by the following command:
        $ celery -A rview_celery_task.celery  worker --loglevel=INFO
    """

    """ Background task to index the files """
    # print "[D]: Task_id: ", self.request.id
    with app.app_context():
        # print "Calling rviewIndexAllFiles..."
        # print "Current app: ", current_app.name
        rview.image_browse.rviewIndexAllFiles(self.request.id)

@celery.task(bind=True)
def rviewBuildDfxmlTableAsynchronously(self):
    """ Background task to build dfxml table """
    with app.app_context():
        # print "Calling dbBuildDb for DFXML..."
        # print "Current app: ", current_app.name
        rview.rview_db.dbBuildDb(self.request.id, bld_imgdb = False, bld_dfxmldb = True)

@celery.task(bind=True)
def rviewBuildAllTablesAsynchronously(self):
    """ Background task to build image and dfxml table """
    with app.app_context():
        # print "Calling dbBuildDb for DFXML..."
        # print "Current app: ", current_app.name
        rview.rview_db.dbBuildDb(self.request.id, bld_imgdb = True, bld_dfxmldb = True)
