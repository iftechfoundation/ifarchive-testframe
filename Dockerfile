# The Archive machine is on a pretty old version of Debian because I don't think about updating very often.
FROM debian:10.13

# Install Apache and Python.
RUN apt-get update -y
RUN apt-get install -y apache2 apache2-dev python3 python3-pip

# Copy over a script that creates the basic directory structure.
COPY --chmod=755 create-var-ifarchive.sh /tmp
RUN /tmp/create-var-ifarchive.sh

# Copy over static files for the web server.
COPY --chown=ifarchive ifarchive-static/index.html /var/ifarchive/htdocs
COPY --chown=ifarchive ifarchive-static/misc /var/ifarchive/htdocs/misc
