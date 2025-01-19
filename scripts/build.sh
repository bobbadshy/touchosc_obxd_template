#!/bin/bash

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"

mkdir -p "$BUILDDIR" || exit 1

./minify_lua.sh && \
./update_lua.sh && \
./compress.sh || exit 1

echo
cp -av "$TOSC_BUILD" "$TOSC_FINAL"

echo -e "\nDone.\n"