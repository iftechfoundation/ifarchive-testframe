#!/bin/bash

# This runs when the Docker container is launched. If it's the first
# time, we do some initial setup work.

# (We can't do this work when the container is built, because it relies
# on scripts and config which are mounted via docker-compose. That stuff
# doesn't exist when the container is being built.)

if [ -e /var/ifarchive/lib/testframe-started ]; then
    
    echo 'Testframe already inited'
    
else
    
    echo 'Initing testframe...'
    
    # Initial setup for Archive index files
    /var/ifarchive/bin/make-master-index
    /var/ifarchive/bin/build-indexes

    # Initial setup for the admin tool and uploader
    python3 /var/ifarchive/wsgi-bin/admin.wsgi createdb
    python3 /var/ifarchive/wsgi-bin/admin.wsgi adduser fred fred@example.com password --roles admin
    
    # Initial setup for the search library
    python3 /var/ifarchive/wsgi-bin/search.wsgi build --create
    chown www-data:uploaders /var/ifarchive/lib/sql/*
    chmod 660 /var/ifarchive/lib/sql/*
    
    # Those setup commands created some logs; make sure they have the right owner.
    chown www-data:www-data /var/ifarchive/logs/search.log
    chown www-data:www-data /var/ifarchive/logs/admintool.log

    # Note so that the above code is once-only
    touch /var/ifarchive/lib/testframe-started
    
fi

echo 'Starting testframe...'

# Run Apache (with logs on stdout) as our front container process.
apachectl -D FOREGROUND
