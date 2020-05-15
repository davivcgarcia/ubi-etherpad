#
# Redistributable base image from Red Hat based on RHEL 8
#

FROM registry.access.redhat.com/ubi8/ubi

#
# Metadata information
#

LABEL name="Etherpad UBI Image" \
      vendor="Etherpad" \
      maintainer="Davi Garcia <davivcgarcia@gmail.com>" \
      build-date="2020-03-27" \
      version="${ETHERPAD_VERSION}" \
      release="1"

#
# Environment variables used for build/exec
#

ENV ETHERPAD_VERSION=1.8.3 \
    ETHERPAD_USER=etherpad \
    ETHERPAD_WEB_PORT=9001 \
    ETHERPAD_BASEDIR=/opt \
    ETHERPAD_WORKDIR=/opt/etherpad \
    ETHERPAD_DATADIR=/opt/etherpad/data \
    YUM_OPTS="--setopt=install_weak_deps=False --setopt=tsflags=nodocs"

#
# Copy helper scripts to image
#

COPY helpers/* /usr/bin/

#
# Install requirements and application
#

RUN yum install ${YUM_OPTS} -y nodejs nss_wrapper && \
    yum -y clean all && \
    cd ${ETHERPAD_BASEDIR} && \
    curl -L https://github.com/ether/etherpad-lite/archive/${ETHERPAD_VERSION}.tar.gz | tar -xz && \
    mv etherpad-lite-${ETHERPAD_VERSION} ${ETHERPAD_WORKDIR} && \
    mkdir ${ETHERPAD_DATADIR} && \
    cd ${ETHERPAD_WORKDIR}

#
# Prepare the image for running on OpenShift
#

RUN useradd -m -g 0 ${ETHERPAD_USER} && \
    chgrp -R 0 ${ETHERPAD_WORKDIR} ${ETHERPAD_DATADIR} && \
    chmod -R g+rwX ${ETHERPAD_WORKDIR} ${ETHERPAD_DATADIR}

USER ${ETHERPAD_USER}

#
# Set application execution parameters
#

EXPOSE ${ETHERPAD_WEB_PORT}
WORKDIR ${ETHERPAD_WORKDIR}

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["run-etherpad"]
