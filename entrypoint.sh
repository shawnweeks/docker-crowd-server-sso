#!/bin/bash

set -e
umask 0027

ls -lh ${CROWD_INSTALL_DIR}

: ${JAVA_OPTS:=}
: ${CATALINA_OPTS:=}

export JAVA_OPTS="${JAVA_OPTS}"
export CATALINA_OPTS="${CATALINA_OPTS}"

startup() {
    echo Starting Jira Server
    ${CROWD_INSTALL_DIR}/start_crowd.sh
    tail -F ${CROWD_HOME}/logs/atlassian-crowd.log
}

shutdown() {
    echo Stopping Jira Server
    ${CROWD_INSTALL_DIR}/stop_crowd.sh
}

trap "shutdown" INT
entrypoint.py
startup