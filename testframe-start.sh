#!/bin/bash

if [ -e /var/ifarchive/lib/testframe-started ]; then
    # already set up
    echo
else
    echo 'Initing testframe...'
    touch /var/ifarchive/lib/testframe-started
fi

echo 'Starting testframe...'

# Run Apache (with logs on stdout) as our front container process.
apachectl -D FOREGROUND
