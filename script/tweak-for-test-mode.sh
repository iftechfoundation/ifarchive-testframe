#!/bin/bash

# Adjust a few files to support test mode. The important difference
# here is that everything is running on a single Apache virtual server,
# rather than being split up into subdomains.

cd /var/ifarchive

# Adjust front-page links to be server-relative rather than pointing at
# production domains.
cp htdocs/index-orig.html htdocs/index.html
sed -i 's,https://search.ifarchive.org,,g' htdocs/index.html
sed -i 's,https://upload.ifarchive.org,,g' htdocs/index.html
