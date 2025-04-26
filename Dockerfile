# The Archive machine is on a pretty old version of Debian because I don't think about updating very often.
FROM debian:10.13

EXPOSE 80

# Install Apache and Python.
RUN apt-get update -y
RUN apt-get install -y apache2 apache2-dev python3 python3-pip libapache2-mod-wsgi-py3

RUN pip3 install markdown Jinja2 pytz mod-wsgi whoosh

# Copy over a script that creates the basic directory structure.
COPY --chmod=755 create-var-ifarchive.sh /tmp
RUN /tmp/create-var-ifarchive.sh

# Set up Apache config.
COPY 000-ifarchive.conf /etc/apache2/sites-available
RUN a2dissite 000-default
RUN a2ensite 000-ifarchive
RUN a2enmod headers
RUN a2enmod rewrite
RUN a2enmod cgid

# Copy over config and template data for our scripts.
COPY --chown=ifarchive:uploaders --chmod=640 ifarch.config /var/ifarchive/lib
COPY --chown=ifarchive ifarchive-ifmap-py/lib /var/ifarchive/lib/ifmap
COPY --chown=ifarchive --chmod=775 ifarchive-upload-py/upload.py /var/ifarchive/cgi-bin
COPY --chown=ifarchive ifarchive-upload-py/lib /var/ifarchive/lib/uploader
COPY --chown=ifarchive --chmod=775 ifarchive-admintool/admin.wsgi /var/ifarchive/wsgi-bin
COPY --chown=ifarchive ifarchive-admintool/tinyapp /var/ifarchive/wsgi-bin/tinyapp
COPY --chown=ifarchive ifarchive-admintool/adminlib /var/ifarchive/wsgi-bin/adminlib
COPY --chown=ifarchive ifarchive-admintool/templates /var/ifarchive/lib/admintool
COPY --chown=ifarchive --chmod=775 ifarchive-search/search.wsgi /var/ifarchive/wsgi-bin
COPY --chown=ifarchive ifarchive-search/searchlib /var/ifarchive/wsgi-bin/searchlib
COPY --chown=ifarchive ifarchive-search/templates /var/ifarchive/lib/searchtpl

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

COPY --chmod=755 testframe-start.sh /var/ifarchive/bin

# This script does launch-time setup and then runs Apache (non-backgrounded).
CMD [ "/var/ifarchive/bin/testframe-start.sh" ]
