#!/bin/bash

#
# Discover user/group used on execution
#

export USER_ID=$(id -u)
export GROUP_ID=$(id -g)

#
# Enables rootless execution
#

grep -v "^${ETHERPAD_USER}" /etc/passwd > "${ETHERPAD_WORKDIR}/nss_wrapper-passwd"
echo "${ETHERPAD_USER}:x:${USER_ID}:${GROUP_ID}:etherpad user:${ETHERPAD_WORKDIR}:/bin/bash" >> "${ETHERPAD_WORKDIR}/nss_wrapper-passwd"
export LD_PRELOAD=libnss_wrapper.so
export NSS_WRAPPER_PASSWD=${ETHERPAD_WORKDIR}/nss_wrapper-passwd
export NSS_WRAPPER_GROUP=/etc/group

#
# Expose common environment variables
#

export USER=${ETHERPAD_USER}
export HOME=${ETHERPAD_WORKDIR}
export LANG=en_US.UTF-8

#
# Executes user provided command instead of default
#

if [ "$1" != 'run-etherpad' ]; then
  exec "$@"
  exit $?
fi

#
# Executes default command defined on Dockerfile
#

NODE_ENV=production ${ETHERPAD_WORKDIR}/bin/run.sh 
exit $?