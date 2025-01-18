.PHONY: help build extract

CWD=$(shell pwd)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(word 1, $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

SCRIPTS_DIR=./scripts

export

build:				## Build into .tosc
	$(SCRIPTS_DIR)/build.sh

extract:			## Extract .tosc from repo root intro ./export folder
	$(SCRIPTS_DIR)/decompress.sh

overwrite-xml:			## Save the current .tosc as .xml in ./source
	$(SCRIPTS_DIR)/overwrite.sh

