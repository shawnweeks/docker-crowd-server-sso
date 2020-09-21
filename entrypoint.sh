#!/bin/bash

set -e
umask 0027

: ${JAVA_OPTS:=}
: ${CATALINA_OPTS:=}

export JAVA_OPTS="${JAVA_OPTS}"
export CATALINA_OPTS="${CATALINA_OPTS}"

startup() {
    echo Starting Jira Server
    ${CROWD_INSTALL_DIR}/bin/start-crowd.sh
    tail -F ${CROWD_HOME}/log/atlassian-crowd.log
}

shutdown() {
    echo Stopping Jira Server
    ${CROWD_INSTALL_DIR}/bin/stop-crowd.sh
}

trap "shutdown" INT
entrypoint.py
startup