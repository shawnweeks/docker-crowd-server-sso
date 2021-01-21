### Download Software
```shell
export CROWD_VERSION=4.1.1
wget https://product-downloads.atlassian.com/software/crowd/downloads/atlassian-crowd-${CROWD_VERSION}.tar.gz
```

### Build Command
```shell
export CROWD_VERSION=4.1.1
docker build \
    -t ${REGISTRY}/atlassian-suite/crowd-server-sso:${CROWD_VERSION} \
    --build-arg BASE_REGISTRY=${REGISTRY} \
    --build-arg CROWD_VERSION=${CROWD_VERSION} \
    .
```

### Push to Registry
```shell
docker push ${REGISTRY}/atlassian-suite/crowd-server-sso
```

### Simple Run Command
```shell
export CROWD_VERSION=4.1.1
docker run --init -it --rm \
    --name crowd  \
    -v crowd-data:/var/atlassian/application-data/crowd \
    -p 8095:8095 \
    ${REGISTRY}/atlassian-suite/crowd-server-sso:4.1.1
```

### SSO Run Command
```shell
# Run first and setup Crowd Directory
docker run --init -it --rm \
    --name crowd  \
    -v crowd-data:/var/atlassian/application-data/crowd \
    -p 8095:8095 \
    -e ATL_TOMCAT_SCHEME='https' \
    -e ATL_TOMCAT_SECURE='true' \
    -e ATL_PROXY_NAME='cloudbrocktec.com' \
    -e ATL_PROXY_PORT='443' \
    ${REGISTRY}/atlassian-suite/crowd-server-sso:4.1.1

# Run second after you've setup the crowd connection
docker run --init -it --rm \
    --name crowd  \
    -v crowd-data:/var/atlassian/application-data/crowd \
    -p 8095:8095 \
    -e ATL_TOMCAT_SCHEME='https' \
    -e ATL_TOMCAT_SECURE='true' \
    -e ATL_PROXY_NAME='cloudbrocktec.com' \
    -e ATL_PROXY_PORT='443' \
    -e CROWD_SSO_ENABLED='true' \
    -e CUSTOM_SSO_LOGIN_URL='https://cloudbrocktec.com/spring-crowd-sso/saml/login' \
    ${REGISTRY}/atlassian-suite/crowd-server-sso:4.1.1
```

### Environment Variables
| Variable Name | Description | Default Value |
| --- | --- | --- |
| ATL_TOMCAT_PORT | The port crowd listens on, this may need to be changed depending on your environment. | 8080 |
| ATL_TOMCAT_SCHEME | The protocol via which crowd is accessed | http |
| ATL_TOMCAT_SECURE | Set to true if `ATL_TOMCAT_SCHEME` is 'https' | false |
| ATL_PROXY_NAME | The reverse proxys full URL for crowd | None |
| ATL_PROXY_PORT | The reverse proxy's port number | None |
| CUSTOM_SSO_LOGIN_URL | Login URL for Custom SSO Support | None |
| CROWD_SSO_ENABLED | Enable Crowd SSO Support | false |
| JVM_MINIMUM_MEMORY | Set's Java XMS | None |
| JVM_MAXIMUM_MEMORY | Set's Java XMX | None |

### Additional
#### Auto-login
By default when SSO is enabled, the app will automatically redirect to the SSO login app when the user hits the login page. This can be disabled by passing a query paramter in the login page URL. `auto_login=false`

Too prevent login redirect loops, a cookie is created when the user first hits the login page. Any hits on the login page within one minute afterwards will require the user to click a link to initiate a login.