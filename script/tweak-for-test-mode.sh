#!/bin/bash

# Adjust a few files to support test mode. The important difference
# here is that everything is running on a single Apache virtual server,
# rather than being split up into subdomains.

cd /var/ifarchive

# Turn on testmode in the darkmode.js script. (This lets the theme cookie
# work outside the ifarchive.org domain.)
sed -i 's/const testmode = false/const testmode = true/' htdocs/misc/darkmode.js

# Adjust front-page links to be server-relative rather than pointing at
# production domains.
sed -i 's,https://search.ifarchive.org,,g' htdocs/index.html
sed -i 's,https://upload.ifarchive.org,,g' htdocs/index.html
