# Jitsi Meet on Docker

![](resources/jitsi-docker.png)

[Jitsi](https://jitsi.org/) is a set of Open Source projects that allows you to easily build and deploy secure videoconferencing solutions.

[Jitsi Meet](https://jitsi.org/jitsi-meet/) is a fully encrypted, 100% Open Source video conferencing solution that you can use all day, every day, for free — with no account needed.

This repository contains the necessary tools to run a Jitsi Meet stack on [Docker](https://www.docker.com) using [Docker Compose](https://docs.docker.com/compose/).

## Installation

The installation manual is available [here](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker).


## Jearni - additional notes

We have a customly built image for the following components:

* Jigasi: swaps the official debian package for custom build DEB package and adds jearni specific environmental variables

* Prosody: contains updates to Prosody's configuration files, enabling CORS on dev/beta domains

## Running locally


### Rebuilding jigasi image

First, if any changes to Jigasi have been made, make sure you've built a new
version of the debian package and uploaded it to Jearni's `jearni-deb` S3 bucket.
Instructions can be found at https://github.com/dlabs/jigasi/tree/aws-transcription-and-audio-streaming.

In `jigasi/Dockerfile`, change the URL to point to newest version of deb file, e.g. `https://jearni-deb.s3-eu-west-1.amazonaws.com/jigasi_1.1-179-ga9a5de6-1_amd64.deb`.

From the root directory, run:

```
# Force the rebuild of the image - prosody only
FORCE_REBUILD=1 JITSI_SERVICES=jigasi make

# Tag the latest local jitsi/prosody image for AWS's container registry
docker tag jearni-jigasi:latest 476676892991.dkr.ecr.eu-west-1.amazonaws.com/jearni-jigasi:latest

# To enable AWS ECR image push, acquire login credentials for AWS ECR
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 476676892991.dkr.ecr.eu-west-1.amazonaws.com

# Push the image to AWS ECR
docker push 476676892991.dkr.ecr.eu-west-1.amazonaws.com/jearni-jigasi:latest
```

### Rebuilding prosody image

From the root directory, run:

```
# Force the rebuild of the image - prosody only
FORCE_REBUILD=1 JITSI_SERVICES=prosody make

# Tag the latest local jitsi/prosody image for AWS's container registry
docker tag jitsi/prosody:latest 476676892991.dkr.ecr.eu-west-1.amazonaws.com/jearni-prosody:latest

# To enable AWS ECR image push, acquire login credentials for AWS ECR
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 476676892991.dkr.ecr.eu-west-1.amazonaws.com

# Push the image to AWS ECR
docker push 476676892991.dkr.ecr.eu-west-1.amazonaws.com/jearni-prosody:latest
```

## TODO

* Support container replicas (where applicable).
* TURN server.

