# name: dghubble/cronus
# version: 0.1
# description: image for a container that runs cluster cron jobs
# build: docker build -t dghubble/cronus .
# push: docker push dghubble/cronus

FROM debian:7.7
MAINTAINER Dalton Hubble <dghubble@gmail.com>

# Install the syslog, cron, and curl packages
RUN apt-get update -y \
    && apt-get install --no-install-recommends -y rsyslog cron curl \
    && rm -rf /var/lib/apt/lists/*

# Create the cron log file
RUN touch /var/log/cron.log

# Add top-level cronfile to image
ONBUILD ADD cronfile /etc/cronfile

# crontab install the cronfile
ONBUILD RUN crontab /etc/cronfile

# Start rsyslogd and cron in the background
# Use tail to show logs in Docker logs and keep container running
CMD rsyslogd && cron && tail -f /var/log/syslog /var/log/cron.log
