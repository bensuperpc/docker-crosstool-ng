ARG DOCKER_IMAGE=ubuntu:20.04
ARG CT_VERSION_GIT=master

FROM $DOCKER_IMAGE

ARG VERSION="1.0.0"
ENV VERSION=$VERSION

LABEL author="Bensuperpc <bensuperpc@gmail.com>"
LABEL mantainer="Bensuperpc <bensuperpc@gmail.com>"

RUN apt-get update && apt-get -y install \
	build-essential \
    ninja-build \
	flex \
	autoconf \
	automake \
	texinfo \
	unzip \
	libtool-bin \
	libtool-doc \
	libncurses5-dev \
	bison \
	byacc \
    autogen \
    bash \
    bc \
    bzip2 \
    ca-certificates \
    curl \
    dirmngr \
    file \
    gettext \
    gzip \
    gnupg \
    initramfs-tools \
    make \
    ncurses-dev \
    pkg-config \
    pax \
    python3-distutils \
    python3-dev \
    sed \
	meson \
	gawk \
	rsync \
	lzip \
    ssh \
    tar \
    wget \
    xz-utils \
    zip \
    zlib1g-dev \
	help2man \
	git \
	--no-install-recommends \
	&& apt-get -y autoremove --purge && \
	rm -rf /var/lib/apt/lists/*

RUN git clone --recurse-submodules --remote-submodules https://github.com/crosstool-ng/crosstool-ng.git \
    && cd /crosstool-ng \
    && git checkout ${CT_VERSION_GIT} \
    && ./bootstrap \
    && ./configure --prefix=/usr/local \
    && make -j$(nproc) \
    && make install \
    && rm -rf /crosstool-ng \
    && cd / \
    && ct-ng --version

LABEL org.label-schema.schema-version="1.0" \
	  org.label-schema.build-date=$BUILD_DATE \
	  org.label-schema.name="bensuperpc/crosstool-ng" \
	  org.label-schema.description="build crosstool-ng toolchain" \
	  org.label-schema.version=$VERSION \
	  org.label-schema.vendor="Bensuperpc" \
	  org.label-schema.url="http://bensuperpc.com/" \
	  org.label-schema.vcs-url="https://github.com/bensuperpc/docker-crosstool-ng" \
	  org.label-schema.vcs-ref=$VCS_REF \
	  org.label-schema.docker.cmd="docker build -t bensuperpc/crosstool-ng -f Dockerfile ."

ENV CT_ALLOW_BUILD_AS_ROOT_SURE=1
ENV CT_PREFIX=/usr/src/myapp

VOLUME [ "/usr/src/myapp" ]
WORKDIR /usr/src/myapp
CMD ["ct-ng"]
