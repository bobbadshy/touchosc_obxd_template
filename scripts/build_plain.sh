#!/bin/bash

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"

./build.sh && \
./plain.sh || exit 1

echo -e "\n == Copying to repo main dir at $TOSC_FINAL_PLAIN ..\n"

cp -av "$TOSC_BUILD_PLAIN" "$TOSC_FINAL_PLAIN"

echo -e "\nDone.\n"