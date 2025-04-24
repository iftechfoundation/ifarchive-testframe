# The Archive machine is on a pretty old version of Debian because I don't think about updating very often.
FROM debian:10.13

EXPOSE 80

# Install Apache and Python.
RUN apt-get update -y
RUN apt-get install -y apache2 apache2-dev python3 python3-pip

# Copy over a script that creates the basic directory structure.
COPY --chmod=755 create-var-ifarchive.sh /tmp
RUN /tmp/create-var-ifarchive.sh

# Set up Apache config.
COPY 000-ifarchive.conf /etc/apache2/sites-available
RUN a2dissite 000-default
RUN a2ensite 000-ifarchive

# Copy over static files for the web server.
COPY --chown=ifarchive ifarchive-static/index.html /var/ifarchive/htdocs
COPY --chown=ifarchive ifarchive-static/misc /var/ifarchive/htdocs/misc

# Run Apache (with logs on stdout) as our front container process.
CMD [ "apachectl", "-D", "FOREGROUND" ]
