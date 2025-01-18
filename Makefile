.PHONY: help

CWD=$(shell pwd)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(word 1, $(MAKEFILE_LIST)) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

SCRIPTS_DIR=./scripts

export

build:
	$(SCRIPTS_DIR)/build.sh

extract:
	$(SCRIPTS_DIR)/decompress.sh
