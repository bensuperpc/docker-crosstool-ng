ARG DOCKER_IMAGE=alpine:3.14
ARG CT_VERSION_GIT=master

FROM $DOCKER_IMAGE

ARG VERSION="1.0.0"
ENV VERSION=$VERSION

LABEL author="Bensuperpc <bensuperpc@gmail.com>"
LABEL mantainer="Bensuperpc <bensuperpc@gmail.com>"

RUN apk update && \
    apk add --no-cache \
        autoconf \
        automake \
        rsync \
        bison \
        build-base \
        curl \
        file \
        flex \
        gawk \
        git \
        gperf \
        help2man \
        libc-dev \
        libtool \
        ncurses-dev \
        patch \
        sed \
        texinfo \
        unzip \
        wget \
        xz \
        python3-dev

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
