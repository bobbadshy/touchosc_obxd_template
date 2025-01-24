#!/bin/bash
#
# Compresses all .xml files back into .tosc
#
# IMPORTANT! Run from repo root with:
#
# ./scripts/compress.sh
#

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"

echo -e "\n == Compress .xml to .tosc ==\n"

echo -e "Compressing $XML_EXPORT >> $TOSC_BUILD"
xmllint --noblanks "$XML_EXPORT" > "$XML_EXPORT.tmp"
mv "$XML_EXPORT.tmp" "$XML_EXPORT"
pigz -c -z < "$XML_EXPORT" > "$TOSC_BUILD"

echo -e "Compressing $XML_EXPORT_PLAIN >> $TOSC_BUILD_PLAIN"
xmllint --noblanks "$XML_EXPORT_PLAIN" > "$XML_EXPORT_PLAIN.tmp"
mv "$XML_EXPORT_PLAIN.tmp" "$XML_EXPORT_PLAIN"
pigz -c -z < "$XML_EXPORT_PLAIN" > "$TOSC_BUILD_PLAIN"
