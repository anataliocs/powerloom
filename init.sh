#!/bin/bash

# setting up git submodules
git submodule update --init --recursive

./snapshotter_autofill.sh || exit 1

# install python dependencies
pip3 install -r requirements.txt
python3 -m snapshotter.gunicorn_core_launcher & python3 -m snapshotter.system_event_detector &
