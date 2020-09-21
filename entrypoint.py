#!/usr/bin/python2

from entrypoint_helpers import env, gen_cfg, set_props

CROWD_HOME = env["CROWD_HOME"]
CROWD_INSTALL_DIR = env["CROWD_INSTALL_DIR"]

gen_cfg("server.xml.j2", "{}/apache-tomcat/conf/server.xml".format(CROWD_INSTALL_DIR))

if "CROWD_SSO_ENABLED" in env and env["CROWD_SSO_ENABLED"] == "true":
     gen_cfg("login.jsp.j2", "{}/crowd-webapp/console/login.jsp".format(CROWD_INSTALL_DIR))
