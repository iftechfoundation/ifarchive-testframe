#!/bin/bash

adduser --gecos INFO --disabled-password ifarchive
adduser --gecos INFO --disabled-password uploaders

mkdir /var/ifarchive
cd /var/ifarchive
mkdir bin doc lib logs htdocs incoming trash cgi-bin wsgi-bin

chown ifarchive:ifarchive bin doc lib htdocs cgi-bin wsgi-bin
chown www-data:uploaders incoming trash
chown www-data:ifarchive logs

chmod 775 bin doc lib htdocs incoming trash cgi-bin wsgi-bin
chmod 770 logs
