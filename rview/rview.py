#!/usr/bin/env python
# coding=UTF-8
#
"""
rview web application.

Initialisation module for package, kicks of the flask app.

"""
__version__ = '0.0.0'
import logging
# Load the application
from flask import Flask

from .utilities import sizeof_fmt, timestamp_fmt
APP = Flask(__name__)

# Get the appropriate config
from .config import configure_app # pylint: disable-msg=C0413
configure_app(APP)
APP.jinja_env.filters['sizeof_fmt'] = sizeof_fmt
APP.jinja_env.filters['timestamp_fmt'] = timestamp_fmt

# Configure logging across all modules
logging.basicConfig(filename=APP.config['LOG_FILE'], level=APP.config['LOG_LEVEL'],
                    format=APP.config['LOG_FORMAT'])
logging.info("Starting rview server.")

from .model import init_db # pylint: disable-msg=C0413
logging.debug("Configured logging.")
logging.info("Initialising database.")
init_db()

logging.info("Setting up application routes")
from .controller import ROUTES # pylint: disable-msg=W0403, W0611, C0413, C0411
