#!/bin/bash

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"


echo -e "\n == Building TouchOSC layout ==\n"

mkdir -p "$BUILDDIR" || exit 1

./update_readme.sh && \
./minify_lua.sh && \
./update_lua.sh && \
./plain.sh && \
./compress.sh || exit 1

echo -e "\n == Copying to repo main dir at $REPO ==\n"

cp -av "$TOSC_FINAL" "$TOSC_FINAL.bak"
cp -av "$TOSC_BUILD" "$TOSC_FINAL"

cp -av "$TOSC_FINAL_PLAIN" "$TOSC_FINAL_PLAIN.bak"
cp -av "$TOSC_BUILD_PLAIN" "$TOSC_FINAL_PLAIN"

echo -e "\nDone.\n"
