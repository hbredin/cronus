# dghubble/cronus

[dghubble/cronus](https://registry.hub.docker.com/u/dghubble/cronus/) is a Docker cron service for small clusters. It runs a set of cron jobs, such as curl'ing internal services. 

The image is based on [Debian](https://www.debian.org/releases/) Wheezy 7.7 (stable), provides `curl`, and ADDs the `cronfile` in downstream builds with `crontab`. The container will start a log and cron in the background and tail the logs in the foreground so that the container runs until stopped and Docker logs are populated.


## Usage

Use cronus by creating an image based FROM dghubble/cronus, but with your own cluster's cron jobs list:

    mkdir mycronus && cd mycronus

Create a Dockerfile:

    FROM dghubble/cronus
    MAINTAINER full name <email>

Create a `cronfile` and add cron jobs to it: 

    # cronfile
    0 * * * * curl --get http://192.168.59.103/              # every hour

The Docker log will show job starts by default, which are read from /var/log/syslog. If your job outputs information that should also be included in the Docker logs, append job output to /var/log/cron.log.

    * * * * * /bin/echo "hello world" >> /var/log/cron.log   # every minute

Currently, adding new jobs requires rebuilding your image, deploying the image, and recreating the container in the cluster.


## Docker Image

The latest Docker image has a size of 97.75 MB.


## Deployment

### Build

To build your Docker container based on cronus:

    docker build -t localhost:5000/cronus .

Push the image to an internal registry:

    # start localhost docker registry before continuing
    docker push localhost:5000/cronus

Alternately, if you're fine with your image being public on Docker Hub:

    docker build -t username/mycronus .
    docker push username/mycronus


## Run

To run the container directly:

    docker run -d localhost:5000/cronus

To run it in production, deploy a Kubernetes pod or replication controller.

## Limitations

* Adding new jobs requires rebuilding your image, deploying the image, and recreating the cronus container in the cluster
* Replicating the container does not increase cluster tolerance to container failures, cronus is not a distributed system
