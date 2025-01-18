#!/bin/bash

./scripts/minify_lua.sh
./scripts/update_lua.sh
./scripts/compress.sh

echo -e "\nDone.\n"