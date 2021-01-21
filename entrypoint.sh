#!/bin/bash

set -e
umask 0027

: ${JAVA_OPTS:=}
: ${CATALINA_OPTS:=}

export JAVA_OPTS="${JAVA_OPTS}"
export CATALINA_OPTS="${CATALINA_OPTS}"

shutdownCleanup() {
    # Crowd might not have a lock but this won't hurt anything if it does.
    if [[ -f ${HOME}/.lock ]]
    then
        echo "Cleaning Up Crowd Locks"
        rm ${HOME}/.lock
    fi
}

entrypoint.py
trap "shutdownCleanup" INT
${CROWD_INSTALL_DIR}/start_crowd.sh -fg