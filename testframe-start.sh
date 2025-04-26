#!/bin/bash

if [ -e /var/ifarchive/lib/testframe-started ]; then
    # already set up
    echo 'Testframe already inited'
else
    echo 'Initing testframe...'
    # Initial setup for Archive index files
    /var/ifarchive/bin/make-master-index
    /var/ifarchive/bin/build-indexes
    # Initial setup for the search library
    python3 /var/ifarchive/wsgi-bin/search.wsgi build --create
    # Those setup commands created some logs; make sure they have the right owner.
    chown www-data:www-data /var/ifarchive/logs/search.log
    touch /var/ifarchive/lib/testframe-started
fi

echo 'Starting testframe...'

# Run Apache (with logs on stdout) as our front container process.
apachectl -D FOREGROUND
