.PHONY: help build extract

CWD=$(shell pwd)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(word 1, $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

SCRIPTS_DIR=./scripts

export

extract:															## Extract .tosc from repo root into ./export folder.
	$(SCRIPTS_DIR)/decompress.sh

overwrite-xml:												## Extract and write to /source/xml as new reference.
	$(SCRIPTS_DIR)/overwrite.sh

build:																## Full build from xml and lua into .tosc file in repo root.
	$(SCRIPTS_DIR)/build.sh

build-low-spec:												## Build normal and extra low-spec, no eye.candy version.
	$(SCRIPTS_DIR)/build_plain.sh

start-dev: build											## Build and open directly in TouchOsc.
	$(SCRIPTS_DIR)/start-dev.sh

minify-lua:														## Minify all lua scripts.
	$(SCRIPTS_DIR)//minify_lua.sh

update-lua: minify-lua								## Minify lua, and update all in XML documents.
	$(SCRIPTS_DIR)//update_lua.sh
