#!/bin/bash

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"

mkdir -p "$BUILDDIR" || exit 1

./minify_lua.sh && \
./update_lua.sh && \
./update_readme.sh && \
./compress.sh || exit 1

echo -e "\n == Copying to repo main dir at $TOSC_FINAL ..\n"

cp -av "$TOSC_BUILD" "$TOSC_FINAL"

echo -e "\nDone.\n"