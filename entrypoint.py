#!/usr/bin/python2

from entrypoint_helpers import env, gen_cfg, set_props

CROWD_HOME = env["CROWD_HOME"]
CROWD_INSTALL_DIR = env["CROWD_INSTALL_DIR"]

gen_cfg("server.xml.j2", "{}/apache-tomcat/conf/server.xml".format(CROWD_INSTALL_DIR))

# if "CROWD_SSO_ENABLED" in env and env["CROWD_SSO_ENABLED"] == "true":
#     gen_cfg("seraph-config.xml.j2", "{}/atlassian-jira/WEB-INF/classes/seraph-config.xml".format(CROWD_INSTALL_DIR))
#     gen_cfg("web.xml.j2", "{}/atlassian-jira/WEB-INF/web.xml".format(CROWD_INSTALL_DIR))
#     gen_cfg("login.jsp.j2", "{}/atlassian-jira/login.jsp".format(CROWD_INSTALL_DIR))
#     gen_cfg("crowd.properties.j2", "{}/atlassian-jira/WEB-INF/classes/crowd.properties".format(CROWD_INSTALL_DIR))
#     props = {
#         "jira.websudo.is.disabled":"true",
#         "jira.disable.login.gadget":"true",
#     }
#     set_props(props,"{}/jira-config.properties".format(CROWD_HOME))