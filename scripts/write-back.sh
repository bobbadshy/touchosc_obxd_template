#!/bin/bash

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"

echo -e "\n == Overwriting source .xml with newly exported versions ..\n"

source="$XML_EXPORT"
target="$XML_SOURCE"

echo -e "Overwriting $target with $source .."
mv "$target" "$target.bak"
cp -av "$source" "$target"
echo
source="$XML_EXPORT_PLAIN"
target="$XML_SOURCE_PLAIN"

echo -e "Overwriting $target with $source .."
mv "$target" "$target.bak"
cp -av "$source" "$target"

echo -e "\nDone.\n"
