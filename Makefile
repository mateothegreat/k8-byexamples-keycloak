#                                 __                 __
#    __  ______  ____ ___  ____ _/ /____  ____  ____/ /
#   / / / / __ \/ __ `__ \/ __ `/ __/ _ \/ __ \/ __  /
#  / /_/ / /_/ / / / / / / /_/ / /_/  __/ /_/ / /_/ /
#  \__, /\____/_/ /_/ /_/\__,_/\__/\___/\____/\__,_/
# /____                     matthewdavis.io, holla!
#

NS                  ?= infra
APP                 ?= keycloak
HOST                ?= keycloak.k8.yomateo.io
SERVICE_NAME        ?= keycloak
SERVICE_PORT        ?= 8080

KEYCLOAK_USER       ?= admin
KEYCLOAK_PASSWORD   ?= admin
KEYSTORE_PASSWORD   ?= secret

IMAGE               ?= jboss/keycloak:latest

MYSQL_DATABASE      ?= keycloak
MYSQL_USER          ?= keycloak
MYSQL_PASSWORD      ?= keycloak
MYSQL_ADDR          ?= mysql

export

## Install all resources
install:    secret-create install-deployment install-service install-ingress
## Delete all resources
delete:     secret-delete delete-deployment delete-service delete-ingress

## Create authentication secret
secret-create:

	@kubectl --namespace $(NS) create secret generic keycloak   --from-literal=keycloak_user=$(KEYCLOAK_USER)      		\
																--from-literal=keycloak_password=$(KEYCLOAK_PASSWORD)  	\
																--from-literal=keystore_password=$(KEYSTORE_PASSWORD)
## Delete authentication secret
secret-delete:

	@kubectl --namespace $(NS) delete secret keycloak

# LIB
install-%:
	@envsubst < manifests/$*.yaml | kubectl --namespace $(NS) apply -f -

delete-%:
	@envsubst < manifests/$*.yaml | kubectl --namespace $(NS) delete --ignore-not-found -f -

status-%:
	@envsubst < manifests/$*.yaml | kubectl --namespace $(NS) rollout status -w -f -

dump-%:
	envsubst < manifests/$*.yaml
## Find first pod and follow log output
logs:
	kubectl --namespace $(NS) logs -f $(shell kubectl get pods --all-namespaces -lapp=$(APP) -o jsonpath='{.items[0].metadata.name}')
describe:
	kubectl --namespace $(NS) describe pod/$(shell kubectl get pods --all-namespaces -lapp=$(APP) -o jsonpath='{.items[0].metadata.name}')

# Help Outputs
GREEN  		:= $(shell tput -Txterm setaf 2)
YELLOW 		:= $(shell tput -Txterm setaf 3)
WHITE  		:= $(shell tput -Txterm setaf 7)
RESET  		:= $(shell tput -Txterm sgr0)
help:

	@echo "\nUsage:\n\n  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}\n\nTargets:\n"
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-20s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@echo
# EOLIB
