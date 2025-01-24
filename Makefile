.PHONY: help build extract

CWD=$(shell pwd)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(word 1, $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

SCRIPTS_DIR=./scripts

export

extract:															## Extract build .tosc into ./export folder.
	$(SCRIPTS_DIR)/extract.sh

write-back:	extract										## Extract and write build back to /source/xml as new reference.
	$(SCRIPTS_DIR)/write-back.sh

build:																## Full build of xml and lua into build dir.
	$(SCRIPTS_DIR)/build.sh

start-dev: build											## Build and open build directly in TouchOsc.
	$(SCRIPTS_DIR)/start-dev.sh

deploy: build													## Full build and copy to repo root.
	$(SCRIPTS_DIR)/deploy.sh

minify-lua:														## Minify all lua scripts.
	$(SCRIPTS_DIR)/minify_lua.sh

update-lua: minify-lua								## Minify lua, and update all in XML documents.
	$(SCRIPTS_DIR)/update_lua.sh
