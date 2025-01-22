#!/bin/bash

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"

./decompress.sh || exit 1

echo -e "\n == Overwriting source .xml with newly exported versions ..\n"

mv "$XML_SOURCE" "$XML_SOURCE.bak"
cp -av "$XML_EXPORT" "$XML_SOURCE"
cp -av "$XML_EXPORT_PRETTY" "$XML_SOURCE_PRETTY"

echo
