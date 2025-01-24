#!/bin/bash
#
# Uncompresses the .tosc file into .xml
#
# IMPORTANT! Run from repo root with:
#
# ./scripts/decompress.sh
#

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"

echo -e "\n == Decompressing .tosc to .xml ==\n"

source="$TOSC_FINAL"
target="$XML_EXPORT"

echo -e "Decompressing $source to $target ..\n"
pigz -c -d < "$source" > "$target"

# echo -e "Formatting $target ..\n"
# mv "$target" "$target.bak"
# xmllint --format "$target.bak" > "$target"

source="$TOSC_FINAL"
target="$XML_EXPORT_PLAIN"

echo -e "Decompressing $source to $target ..\n"
pigz -c -d < "$source" > "$target"

echo -e "Formatting $target ..\n"
mv "$target" "$target.bak"
xmllint --format "$target.bak" > "$target"

echo -e "\nDone.\n"
