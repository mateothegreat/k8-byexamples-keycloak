<!--
#                                 __                 __
#    __  ______  ____ ___  ____ _/ /____  ____  ____/ /
#   / / / / __ \/ __ `__ \/ __ `/ __/ _ \/ __ \/ __  /
#  / /_/ / /_/ / / / / / / /_/ / /_/  __/ /_/ / /_/ /
#  \__, /\____/_/ /_/ /_/\__,_/\__/\___/\____/\__,_/
# /____                     matthewdavis.io, holla!
#
#-->

[![Clickity click](https://img.shields.io/badge/k8s%20by%20example%20yo-limit%20time-ff69b4.svg?style=flat-square)](https://k8.matthewdavis.io)
[![Twitter Follow](https://img.shields.io/twitter/follow/yomateod.svg?label=Follow&style=flat-square)](https://twitter.com/yomateod) [![Skype Contact](https://img.shields.io/badge/skype%20id-appsoa-blue.svg?style=flat-square)](skype:appsoa?chat)

# Deploy Keycloak 3.4 - no excuses!

> k8 by example -- straight to the point, simple execution.

Once you `make install` you will be able to reach your Keycloak UI via https://keycloak.deploy-1.svc.cluster.local (change namespace to fit).

Keycloak is configured to use a database backend for persistence (no persistentvolumes needed!).

## Usage

```sh
Usage:
  make <target>
Targets:

  install              Install all resources
  delete               Delete all resources

  secret-create        Create authentication secret
  secret-delete        Delete authentication secret

  logs                 Find first pod and follow log output
```

## Variables

```sh
NS                  ?= deploy-1
APP                 ?= keycloak
HOST                ?= keycloak.gcp.streaming-platform.com
SERVICE_NAME        ?= keycloak
SERVICE_PORT        ?= 8080

KEYCLOAK_USER       ?= admin
KEYCLOAK_PASSWORD   ?= admin
KEYSTORE_PASSWORD   ?= secret

IMAGE               ?= jboss/keycloak:latest

MYSQL_DATABASE      ?= keycloak
MYSQL_USER          ?= keycloak
MYSQL_PASSWORD      ?= keycloak
MYSQL_ADDR          ?= sandbox.streaming-platform.com
```

## Installation Example

```sh
$ make secret-create install status-deployment logs
secret "keycloak" created
deployment "keycloak" created
service "keycloak" created
ingress "gcp.streaming-platform.com" created
deployment "keycloak" successfully rolled out
kubectl --namespace deploy-1 logs -f keycloak-799b579494-6mm6c
Added 'admin' to '/opt/jboss/keycloak/standalone/configuration/keycloak-add-user.json', restart server to load user
=========================================================================

  Using MySQL database

=========================================================================

19:45:43,929 INFO  [org.jboss.modules] (main) JBoss Modules version 1.6.1.Final
19:45:44,090 INFO  [org.jboss.msc] (main) JBoss MSC version 1.2.7.SP1
19:45:44,303 INFO  [org.jboss.as] (MSC service thread 1-1) WFLYSRV0049: Keycloak 3.4.3.Final (WildFly Core 3.0.8.Final) starting

...

19:46:14,856 INFO  [org.jboss.as.server] (ServerService Thread Pool -- 45) WFLYSRV0010: Deployed "keycloak-server.war" (runtime-name : "keycloak-server.war")
19:46:14,934 INFO  [org.jboss.as.server] (Controller Boot Thread) WFLYSRV0212: Resuming server
19:46:14,939 INFO  [org.jboss.as] (Controller Boot Thread) WFLYSRV0060: Http management interface listening on http://127.0.0.1:9990/management
19:46:14,939 INFO  [org.jboss.as] (Controller Boot Thread) WFLYSRV0051: Admin console listening on http://127.0.0.1:9990
19:46:14,940 INFO  [org.jboss.as] (Controller Boot Thread) WFLYSRV0025: Keycloak 3.4.3.Final (WildFly Core 3.0.8.Final) started in 21477ms - Started 546 of 882 services (604 services are lazy, passive or on-demand)
```

## Cleanup

```sh
$ make delete secret-delete

deployment "keycloak" deleted
service "keycloak" deleted
ingress "gcp.streaming-platform.com" deleted
secret "keycloak" deleted
```

## See also

* https://github.com/jboss-dockerfiles/keycloak/tree/master/server
* https://github.com/keycloak/keycloak-quickstarts/tree/latest/app-angular2
