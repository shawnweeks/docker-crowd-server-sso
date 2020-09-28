#!/bin/bash

set -e
umask 0027

: ${JAVA_OPTS:=}
: ${CATALINA_OPTS:=}

export JAVA_OPTS="${JAVA_OPTS}"
export CATALINA_OPTS="${CATALINA_OPTS}"

entrypoint.py
${CROWD_INSTALL_DIR}/start_crowd.sh -fg