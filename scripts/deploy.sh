#!/bin/bash

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"

echo -e "\n == Copying to repo main dir at $REPO ==\n"

cp -av "$TOSC_BUILD" "$TOSC_FINAL"

cp -av "$TOSC_BUILD_PLAIN" "$TOSC_FINAL_PLAIN"

echo -e "\nDone.\n"
