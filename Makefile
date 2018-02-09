#                                 __                 __
#    __  ______  ____ ___  ____ _/ /____  ____  ____/ /
#   / / / / __ \/ __ `__ \/ __ `/ __/ _ \/ __ \/ __  /
#  / /_/ / /_/ / / / / / / /_/ / /_/  __/ /_/ / /_/ /
#  \__, /\____/_/ /_/ /_/\__,_/\__/\___/\____/\__,_/
# /____                     matthewdavis.io, holla!
#
include .make/Makefile.inc

NS                  ?= default
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
MYSQL_ADDR          ?= mysql.default.svc.cluster.local
export

## Create authentication secret
secret-create:

	@kubectl --namespace $(NS) create secret generic keycloak   --from-literal=keycloak_user=$(KEYCLOAK_USER)      		\
																--from-literal=keycloak_password=$(KEYCLOAK_PASSWORD)  	\
																--from-literal=keystore_password=$(KEYSTORE_PASSWORD)
## Delete authentication secret
secret-delete:

	@kubectl --namespace $(NS) delete secret keycloak

## Find first pod and follow log output
logs:
	kubectl --namespace $(NS) logs -f $(shell kubectl get pods --all-namespaces -lapp=$(APP) -o jsonpath='{.items[0].metadata.name}')
