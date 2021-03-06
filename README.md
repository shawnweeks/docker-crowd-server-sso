### Download Software
```shell
export CROWD_VERSION=4.2.3
wget https://product-downloads.atlassian.com/software/crowd/downloads/atlassian-crowd-${CROWD_VERSION}.tar.gz
```

### Build Command
```shell
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
docker run --init -it --rm \
    --name crowd  \
    -v crowd-data:/var/atlassian/application-data/crowd \
    -p 8095:8095 \
    ${REGISTRY}/atlassian-suite/crowd-server-sso:${CROWD_VERSION}
```

### Simple SSL Run Command
```shell
export CONFLUENCE_VERSION=7.7.3
keytool -genkey -noprompt -keyalg RSA \
        -alias selfsigned -keystore keystore.jks -storepass changeit \
        -dname "CN=localhost" \
        -validity 360 -keysize 2048
docker run --init -it --rm \
    --name crowd  \
    -v crowd-data:/var/atlassian/application-data/crowd \
    -v $PWD/keystore.jks:/tmp/keystore.jks \
    -e ATL_TOMCAT_SCHEME=https \
    -e ATL_TOMCAT_SECURE=true \
    -e ATL_TOMCAT_SSL_ENABLED=true \
    -e ATL_TOMCAT_KEY_ALIAS=selfsigned \
    -e ATL_TOMCAT_KEYSTORE_FILE=/tmp/keystore.jks \
    -e ATL_TOMCAT_KEYSTORE_PASS=changeit \
    -p 8095:8095 \
    ${REGISTRY}/atlassian-suite/crowd-server-sso:${CROWD_VERSION}
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
| ATL_TOMCAT_PROXY_NAME | The reverse proxys full URL for crowd | None |
| ATL_TOMCAT_PROXY_PORT | The reverse proxy's port number | None |
| ATL_TOMCAT_SSL_ENABLED | Enable Tomcat SSL Support | None |
| ATL_TOMCAT_SSL_ENABLED_PROTOCOLS | Allowed SSL Protocols | TLSv1.2,TLSv1.3 |
| ATL_TOMCAT_KEY_ALIAS | Tomcat SSL Key Alias | None |
| ATL_TOMCAT_KEYSTORE_FILE | Tomcat SSL Keystore File | None |
| ATL_TOMCAT_KEYSTORE_PASSWORD | Tomcat SSL Keystore Password | None |
| ATL_TOMCAT_KEYSTORE_TYPE | Tomcat SSL Keystore Type | JKS |
| ATL_SSO_LOGIN_URL | Login URL for Custom SSO Support | None |
| ATL_CROWD_SSO_ENABLED | Enable Crowd SSO Support | false |
| JVM_MINIMUM_MEMORY | Set's Java XMS | None |
| JVM_MAXIMUM_MEMORY | Set's Java XMX | None |

### Additional
#### Auto-login
By default when SSO is enabled, the app will automatically redirect to the SSO login app when the user hits the login page. This can be disabled by passing a query paramter in the login page URL. `auto_login=false`

Too prevent login redirect loops, a cookie is created when the user first hits the login page. Any hits on the login page within one minute afterwards will require the user to click a link to initiate a login.