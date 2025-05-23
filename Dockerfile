# The Archive machine is on a pretty old version of Debian because I don't think about updating very often.
FROM debian:10.13

EXPOSE 80

# Install Apache and Python.
RUN apt-get update -y
RUN apt-get install -y sudo apache2 apache2-dev python3 python3-pip libapache2-mod-wsgi-py3

RUN pip3 install markdown Jinja2 pytz mod-wsgi whoosh

# Copy over a script that creates the basic directory structure.
COPY --chmod=755 script/create-var-ifarchive.sh /tmp
RUN /tmp/create-var-ifarchive.sh

# Set up sudoers config. (Needed for the admin tool to run build-indexes-bg.)
COPY --chmod=440 config/sudoers_ifarch /etc/sudoers.d

# Set up Apache config.
COPY config/000-ifarchive.conf /etc/apache2/sites-available
RUN a2dissite 000-default
RUN a2ensite 000-ifarchive
RUN a2enmod headers
RUN a2enmod rewrite
RUN a2enmod cgid

# Copy over config file for our scripts.
COPY --chown=ifarchive:uploaders --chmod=640 config/ifarch.config /var/ifarchive/lib

# Copy over test data for the web server. (Maybe this should be a mount.)
COPY --chown=ifarchive ifarchive-ifmap-py/testdata/if-archive /var/ifarchive/htdocs/if-archive
COPY ifarchive-ifmap-py/testdata/set-timestamps.py /var/ifarchive/bin/testdata-set-timestamps.py

# Bang the timestamps on the (test) if-archive files.
RUN python3 /var/ifarchive/bin/testdata-set-timestamps.py /var/ifarchive/htdocs/if-archive

COPY --chmod=755 script/testframe-start.sh /var/ifarchive/bin

# This script does launch-time setup and then runs Apache (non-backgrounded).
CMD [ "/var/ifarchive/bin/testframe-start.sh" ]
