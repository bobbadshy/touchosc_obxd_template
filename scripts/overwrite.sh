#!/bin/bash

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"

./decompress.sh || exit 1

mv "$XML_SOURCE" "$XML_SOURCE.bak"
cp -av "$XML_EXPORT" "$XML_SOURCE"
