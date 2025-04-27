#!/bin/bash

# Initial Archive setup.

# Create two users.
adduser --gecos INFO --disabled-password ifarchive
adduser --gecos INFO --disabled-password uploaders
adduser ifarchive uploaders
adduser www-data uploaders

# Create the directory tree that Archive files will live in.

mkdir /var/ifarchive
cd /var/ifarchive
mkdir bin doc lib logs htdocs incoming trash cgi-bin wsgi-bin
mkdir lib/sql lib/searchindex

chown ifarchive:ifarchive bin doc lib htdocs cgi-bin wsgi-bin
chown www-data:uploaders incoming trash
chown www-data:ifarchive logs

chmod 775 bin doc lib htdocs incoming trash cgi-bin wsgi-bin
chmod 770 logs

mkdir htdocs/misc htdocs/if-archive htdocs/indexes htdocs/metadata 
chown ifarchive:ifarchive htdocs/*
