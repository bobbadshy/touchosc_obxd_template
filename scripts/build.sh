#!/bin/bash

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"


echo -e "\n == Building TouchOSC layout ==\n"

mkdir -p "$BUILDDIR" || exit 1

./update_readme.sh && \
./minify_lua.sh && \
./update_lua.sh && \
./defaults.sh && \
./plain.sh && \
./compress.sh || exit 1

echo -e "\nBuild to $BUILDDIR done.\n"
