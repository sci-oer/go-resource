FROM scioer/base-resource:sha-40bb95e

LABEL org.opencontainers.version="v1.0.0"

LABEL org.opencontainers.image.authors="Marshall Asch <masch@uoguelph.ca> (https://marshallasch.ca)"
LABEL org.opencontainers.image.source="https://github.com/sci-oer/MY_LANGUAGE-resource.git"
LABEL org.opencontainers.image.vendor="sci-oer"
LABEL org.opencontainers.image.licenses="GPL-3.0-only"
LABEL org.opencontainers.image.title="MY_LANGUAGE Offline Course Resouce"
LABEL org.opencontainers.image.description="This image is the MY_LANGUAGE specific image that can be used to act as an offline resource for students to contain all the instructional matrial and tools needed to do the course content"
LABEL org.opencontainers.image.base.name="registry-1.docker.io/scioer/base-resource:sha-40bb95e"


USER root

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    LANGUAGE_SPECIFIC_DEPENDANCIES \
&& rm -rf /var/lib/apt/lists/*


COPY --chown=${UID}:${UID} langdocs/ /opt/static/

# install jupyter dependancies
RUN pip3 install LANGUAGE_SPECIFIC_JUPYTER_KERNEL

# Install jupyter kernels
RUN LANGUAGE_SPECIFIC_JUPYTER_KERNEL

USER ${UNAME}

# these three labels will change every time the container is built
# put them at the end because of layer caching

ARG VERSION=v1.0.0
LABEL org.opencontainers.image.version="$VERSION"

ARG VCS_REF
LABEL org.opencontainers.image.revision="${VCS_REF}"

ARG BUILD_DATE
LABEL org.opencontainers.image.created="${BUILD_DATE}"
