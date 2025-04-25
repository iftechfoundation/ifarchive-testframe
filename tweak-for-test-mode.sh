#!/bin/bash

# Adjust a few files to support test mode. The important difference
# here is that everything is running on a single Apache virtual server,
# rather than being split up into subdomains.

cd /var/ifarchive

sed -i 's/const testmode = false/const testmode = true/' htdocs/misc/darkmode.js

