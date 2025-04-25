# The Archive machine is on a pretty old version of Debian because I don't think about updating very often.
FROM debian:10.13

EXPOSE 80

# Install Apache and Python.
RUN apt-get update -y
RUN apt-get install -y apache2 apache2-dev python3 python3-pip

RUN pip3 install markdown Jinja2 pytz

# Copy over a script that creates the basic directory structure.
COPY --chmod=755 create-var-ifarchive.sh /tmp
RUN /tmp/create-var-ifarchive.sh

# Set up Apache config.
COPY 000-ifarchive.conf /etc/apache2/sites-available
RUN a2dissite 000-default
RUN a2ensite 000-ifarchive

# Copy over our scripts.
COPY --chmod=755 ifarchive-ifmap-py/make-master-index /var/ifarchive/bin
COPY --chmod=755 ifarchive-ifmap-py/make-master-index.py /var/ifarchive/bin
COPY --chmod=755 ifarchive-ifmap-py/ifmap.py /var/ifarchive/bin
COPY --chmod=755 ifarchive-ifmap-py/build-indexes /var/ifarchive/bin
COPY --chmod=755 ifarchive-ifmap-py/build-indexes-bg /var/ifarchive/bin

# Copy over config and template data for our scripts.
COPY --chown=ifarchive:uploaders --chmod=640 ifarch.config /var/ifarchive/lib
COPY --chown=ifarchive ifarchive-ifmap-py/lib /var/ifarchive/lib/ifmap

# Copy over static files for the web server.
COPY --chown=ifarchive ifarchive-static/index.html /var/ifarchive/htdocs
COPY --chown=ifarchive ifarchive-static/misc /var/ifarchive/htdocs/misc
COPY --chown=ifarchive ifarchive-ifmap-py/testdata/if-archive /var/ifarchive/htdocs/if-archive
COPY ifarchive-ifmap-py/testdata/set-timestamps.py /var/ifarchive/bin/testdata-set-timestamps.py

# Bang the timestamps on the (test) if-archive files.
RUN python3 /var/ifarchive/bin/testdata-set-timestamps.py /var/ifarchive/htdocs/if-archive

# Make any changes needed for test-frame mode.
COPY --chmod=755 tweak-for-test-mode.sh /tmp
RUN /tmp/tweak-for-test-mode.sh

# Initial setup for Archive index files
RUN /var/ifarchive/bin/make-master-index
RUN /var/ifarchive/bin/build-indexes

# Run Apache (with logs on stdout) as our front container process.
CMD [ "apachectl", "-D", "FOREGROUND" ]
