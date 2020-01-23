#!/usr/bin/env bash
# Set directory to install dir, this should be templated
cd /var/www/rview
# activate the virtual env
source venv/bin/activate
# Set config format to disable logging debug, comment out for full logging
export RVIEW_CONFIG='analyser'
# Run the analyser
python -m rview.image_analyser
