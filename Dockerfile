# Atlassian Docker UIDs
# These are based on the UIDs found in the Official Images
# to maintain compatability as much as possible.
# Jira          2001
# Confluence    2002
# Bitbucket     2003
# Crowd         2004
# Bamboo        2005

ARG BASE_REGISTRY=registry.cloudbrocktec.com
ARG BASE_IMAGE=redhat/ubi/ubi7
ARG BASE_TAG=7.8

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

ENV CROWD_USER crowd
ENV CROWD_GROUP crowd
ENV CROWD_UID 2004
ENV CROWD_GID 2004

ENV CROWD_HOME /var/atlassian/application-data/crowd
ENV CROWD_INSTALL_DIR /opt/atlassian/crowd

ARG CROWD_VERSION
ARG DOWNLOAD_URL=https://product-downloads.atlassian.com/software/crowd/downloads/atlassian-crowd-${CROWD_VERSION}.tar.gz

RUN yum install -y java-11-openjdk-devel procps git python2 python2-jinja2 && \
    yum clean all

COPY [ "entrypoint.sh", "entrypoint.py", "entrypoint_helpers.py", "/tmp/scripts/" ]

# COPY [ "templates/*.j2", "/opt/jinja-templates/" ]

RUN mkdir -p ${CROWD_HOME}/shared && \
    mkdir -p ${CROWD_INSTALL_DIR} && \
    groupadd -r -g ${CROWD_GID} ${CROWD_GROUP} && \
    useradd -r -u ${CROWD_UID} -g ${CROWD_GROUP} -M -d ${CROWD_HOME} ${CROWD_USER} && \
    curl --silent -L ${DOWNLOAD_URL} | tar -xz --strip-components=1 -C "$CROWD_INSTALL_DIR" && \
    sed -i -e 's/-Xms\([0-9]\+[kmg]\) -Xmx\([0-9]\+[kmg]\)/-Xms\${JVM_MINIMUM_MEMORY:=\1} -Xmx\${JVM_MAXIMUM_MEMORY:=\2} \${JVM_SUPPORT_RECOMMENDED_ARGS} -Dcrowd.home=\${CROWD_HOME}/g' ${CROWD_INSTALL_DIR}/apache-tomcat/bin/setenv.sh && \
    chown -R "${CROWD_USER}:${CROWD_GROUP}" "${CROWD_INSTALL_DIR}" && \
    cp /tmp/scripts/* ${CROWD_INSTALL_DIR} && \
    chown -R "${CROWD_USER}:${CROWD_GROUP}" "${CROWD_HOME}" && \
    chmod 755 ${CROWD_INSTALL_DIR}/entrypoint.*

EXPOSE 8095

VOLUME ${CROWD_HOME}
USER ${CROWD_USER}
ENV JAVA_HOME=/usr/lib/jvm/java-11
ENV PATH=${PATH}:${CROWD_INSTALL_DIR}
WORKDIR ${CROWD_HOME}
ENTRYPOINT [ "entrypoint.sh" ]