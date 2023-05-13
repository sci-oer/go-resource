FROM scioer/base-resource:sha-40bb95e

LABEL org.opencontainers.version="v1.0.0"

LABEL org.opencontainers.image.authors="Marshall Asch <masch@uoguelph.ca> (https://marshallasch.ca)"
LABEL org.opencontainers.image.source="https://github.com/sci-oer/go-resource.git"
LABEL org.opencontainers.image.vendor="sci-oer"
LABEL org.opencontainers.image.licenses="GPL-3.0-only"
LABEL org.opencontainers.image.title="Go Offline Course Resouce"
LABEL org.opencontainers.image.description="This image is the go specific image that can be used to act as an offline resource for students to contain all the instructional matrial and tools needed to do the course content"
LABEL org.opencontainers.image.base.name="registry-1.docker.io/scioer/base-resource:sha-40bb95e"

USER root
RUN echo 'export PATH=$PATH:/usr/local/go/bin:/home/student/go/bin/\n' >> /etc/profile.d/02-go.sh

ARG GO_VERSION=1.20.4 \
    GO_KERNEL=0.7.5 \
    TARGETARCH

RUN curl -L "https://go.dev/dl/go$GO_VERSION.linux-$TARGETARCH.tar.gz" -o go.tar.gz \
    && tar -C /usr/local -xzf go.tar.gz

USER ${UNAME}
RUN export PATH=$PATH:/usr/local/go/bin \
  && go install github.com/gopherdata/gophernotes@v${GO_KERNEL} \
  && sudo mkdir -p /usr/local/share/jupyter/kernels/gophernotes \
  && cd /usr/local/share/jupyter/kernels/gophernotes \
  && sudo chown ${UID}:${UID} /usr/local/share/jupyter/kernels/gophernotes \
  && cp "$(go env GOPATH)"/pkg/mod/github.com/gopherdata/gophernotes@v${GO_KERNEL}/kernel/*  "." \
  && chmod +w ./kernel.json \
  && sed "s|gophernotes|$(go env GOPATH)/bin/gophernotes|" < kernel.json.in > kernel.json

RUN sudo mkdir /opt/static/go \
  && sudo chown ${UID}:${UID} /opt/static/go \
  && cp /usr/local/go/doc/* /opt/static/go/

# these three labels will change every time the container is built
# put them at the end because of layer caching

ARG VERSION=v1.0.0
LABEL org.opencontainers.image.version="$VERSION"

ARG VCS_REF
LABEL org.opencontainers.image.revision="${VCS_REF}"

ARG BUILD_DATE
LABEL org.opencontainers.image.created="${BUILD_DATE}"
