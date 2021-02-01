#!/bin/bash

set -e
umask 0027

export JVM_SUPPORT_RECOMMENDED_ARGS=${ATL_JAVA_ARGS}
export JVM_MINIMUM_MEMORY=${ATL_MIN_MEMORY}
export JVM_MAXIMUM_MEMORY=${ATL_MAX_MEMORY}

entrypoint.py

unset "${!ATL_@}"

set +e
flock -x -w 30 ${HOME}/.flock ${CROWD_INSTALL_DIR}/start_crowd.sh -fg &
CROWD_PID="$!"

echo "Crowd Started with PID ${CROWD_PID}"
wait ${CROWD_PID}

if [[ $? -eq 1 ]]
then
    echo "Crowd Failed to Aquire Lock! Exiting"
    exit 1
fi