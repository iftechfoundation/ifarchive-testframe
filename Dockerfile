# The Archive machine is on a pretty old version of Debian because I don't think about updating very often.
FROM debian:10.13

RUN apt-get update -y
RUN apt-get install -y apache2 apache2-dev python3 python3-pip

COPY --chmod=755 create-var-ifarchive.sh /tmp

RUN /tmp/create-var-ifarchive.sh
