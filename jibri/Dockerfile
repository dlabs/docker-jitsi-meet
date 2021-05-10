ARG JITSI_REPO=jitsi
FROM ${JITSI_REPO}/base-java

#ARG CHROME_RELEASE=latest
#ARG CHROMEDRIVER_MAJOR_RELEASE=latest
ARG CHROME_RELEASE=78.0.3904.97
ARG CHROMEDRIVER_MAJOR_RELEASE=78

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# RUN \
# 	apt-dpkg-wrap apt-get update \
# 	&& apt-dpkg-wrap apt-get install -y libgl1-mesa-dri procps ffmpeg curl alsa-utils icewm xdotool xserver-xorg-input-void xserver-xorg-video-dummy \
# 	&& apt-cleanup

RUN \
	apt-dpkg-wrap apt-get update \
	&& apt-dpkg-wrap apt-get install -y libgl1-mesa-dri procps curl alsa-utils icewm xdotool xserver-xorg-input-void xserver-xorg-video-dummy \
	&& apt-cleanup


RUN \
	apt-get update -qq && apt-get -y install \
		autoconf \
		automake \
		build-essential \
		cmake \
		git-core \
		libass-dev \
		libfreetype6-dev \
		libgnutls28-dev \
		libunistring-dev \
		libsdl2-dev \
		libtool \
		libva-dev \
		libvdpau-dev \
		libvorbis-dev \
		libxcb1-dev \
		libxcb-shm0-dev \
		libxcb-xfixes0-dev \
		meson \
		ninja-build \
		pkg-config \
		texinfo \
		wget \
		yasm \
		zlib1g-dev

RUN \
	mkdir -p ~/ffmpeg_sources ~/bin

# Compile NASM
RUN \
	cd ~/ffmpeg_sources && \
	wget https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.bz2 && \
	tar xjvf nasm-2.15.05.tar.bz2 && \
	cd nasm-2.15.05 && \
	./autogen.sh && \
	PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" && \
	make && \
	make install

# Compile libx264
RUN \
	cd ~/ffmpeg_sources && \
	git -C x264 pull 2> /dev/null || git clone --depth 1 https://code.videolan.org/videolan/x264.git && \
	cd x264 && \
	PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure --prefix="$HOME/ffmpeg_build" --bindir="$HOME/bin" --enable-static --enable-pic && \
	PATH="$HOME/bin:$PATH" make && \
	make install

# Compile vpx
RUN \
	cd ~/ffmpeg_sources && \
	git -C libvpx pull 2> /dev/null || git clone --depth 1 https://chromium.googlesource.com/webm/libvpx.git && \
	cd libvpx && \
	PATH="$HOME/bin:$PATH" ./configure --prefix="$HOME/ffmpeg_build" --disable-examples --disable-unit-tests --enable-vp9-highbitdepth --as=yasm && \
	PATH="$HOME/bin:$PATH" make && \
	make install

# Compile libopus
RUN \
	cd ~/ffmpeg_sources && \
	git -C opus pull 2> /dev/null || git clone --depth 1 https://github.com/xiph/opus.git && \
	cd opus && \
	./autogen.sh && \
	./configure --prefix="$HOME/ffmpeg_build" --disable-shared && \
	make && \
	make install

# Compile FFMPEG
RUN \
	cd ~/ffmpeg_sources && \
	wget -O ffmpeg-snapshot.tar.bz2 https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
	tar xjvf ffmpeg-snapshot.tar.bz2 && \
	cd ffmpeg && \
	PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$HOME/ffmpeg_build/lib/pkgconfig" ./configure \
		--prefix="$HOME/ffmpeg_build" \
		--pkg-config-flags="--static" \
		--extra-cflags="-I$HOME/ffmpeg_build/include" \
		--extra-ldflags="-L$HOME/ffmpeg_build/lib" \
		--extra-libs="-lpthread -lm" \
		--ld="g++" \
		--bindir="$HOME/bin" \
		--enable-gpl \
		--enable-gnutls \
		--enable-libass \
		--enable-libfreetype \
		--enable-libopus \
		--enable-libvorbis \
		--enable-libvpx \
		--enable-libx264 \
		--enable-nonfree && \
	PATH="$HOME/bin:$PATH" make && \
	make install && \
	hash -r

RUN \
	rm -rf ~/ffmpeg_sources

RUN \
	source ~/.profile

RUN \
	cp "$HOME/bin/ffmpeg" /usr/local/bin/ffmpeg-bin

RUN \
	apt-get -f install libnss3 libnspr4

RUN \
	[ "${CHROME_RELEASE}" = "latest" ] \
	&& wget -q https://dl-ssl.google.com/linux/linux_signing_key.pub -O /etc/apt/trusted.gpg.d/google.asc \
	&& echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
	&& apt-dpkg-wrap apt-get update \
	&& apt-dpkg-wrap apt-get install -y google-chrome-stable \
	&& apt-cleanup \
	|| true

RUN \
        [ "${CHROME_RELEASE}" != "latest" ] \
        && curl -4so "/tmp/google-chrome-stable_${CHROME_RELEASE}-1_amd64.deb" "http://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_RELEASE}-1_amd64.deb" \
	&& apt-dpkg-wrap apt-get update \
        && apt-dpkg-wrap apt-get install -y "/tmp/google-chrome-stable_${CHROME_RELEASE}-1_amd64.deb" \
	&& apt-cleanup \
	|| true

RUN \
	[ "${CHROMEDRIVER_MAJOR_RELEASE}" = "latest" ] \
	&& CHROMEDRIVER_RELEASE="$(curl -4Ls https://chromedriver.storage.googleapis.com/LATEST_RELEASE)" \
	|| CHROMEDRIVER_RELEASE="$(curl -4Ls https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROMEDRIVER_MAJOR_RELEASE})" \
	&& curl -4Ls "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_RELEASE}/chromedriver_linux64.zip" \
	| zcat >> /usr/bin/chromedriver \
	&& chmod +x /usr/bin/chromedriver \
	&& chromedriver --version

RUN \
        apt-dpkg-wrap apt-get update \
        && apt-dpkg-wrap apt-get install -y jitsi-upload-integrations awscli s3cmd jq \
        && apt-cleanup

# The lines below can be used if DEB pacakge is present locally
# (avoids the need to upload DEB to S3)
COPY debs/jibri.deb /tmp/jibri.deb
RUN dpkg --ignore-depends=ffmpeg -i /tmp/jibri.deb

RUN \
	rm -rf ~/ffmpeg_build ~/ffmpeg_sources /tmp/jibri.deb

COPY rootfs/ /

RUN chmod +x /usr/local/bin/ffmpeg

VOLUME /config

