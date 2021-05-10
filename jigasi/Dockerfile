ARG JITSI_REPO=jitsi
FROM ${JITSI_REPO}/base-java

ENV GOOGLE_APPLICATION_CREDENTIALS /config/key.json

RUN \
	apt-dpkg-wrap apt-get update && \
	apt-dpkg-wrap apt-get install -y jq curl libxss1 && \
	apt-cleanup

# The lines below can be used if DEB pacakge is present locally
# (avoids the need to upload DEB to S3)
# COPY debs/jigasi.deb /tmp/jigasi.deb
# RUN dpkg -i /tmp/jigasi.deb

RUN \
	curl https://jearni-deb.s3-eu-west-1.amazonaws.com/jigasi_1.1-187-g8061c62-1_amd64.deb --output /tmp/jigasi.deb && \
	dpkg -i /tmp/jigasi.deb

COPY rootfs/ /

VOLUME ["/config", "/tmp/transcripts"]
