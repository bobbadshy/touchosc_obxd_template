#!/bin/bash
#
# Uncompresses the .tosc file into .xml
#

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"

echo -e "\n == Decompressing .tosc from $BUILDDIR to .xml in $EXPORTDIR ==\n"

source="$TOSC_BUILD"
target="$XML_EXPORT"

echo -e "Decompressing $source to $target ..\n"
pigz -c -d < "$source" > "$target"

echo -e "Formatting $target ..\n"
mv "$target" "$target.bak"
xmllint --format "$target.bak" > "$target"

echo -e "Done.\n"
