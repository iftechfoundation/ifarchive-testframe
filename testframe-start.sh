#!/bin/bash

echo 'Starting testframe...'

# Run Apache (with logs on stdout) as our front container process.
apachectl -D FOREGROUND
