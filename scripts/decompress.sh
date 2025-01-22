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

echo -e "\n == Decompressing $TOSC_FINAL to $XML_EXPORT .."
pigz -c -d < "$TOSC_FINAL" > "$XML_EXPORT"

echo -e "\n == Creating well-formatted copy at $XML_EXPORT_PRETTY .."

xmllint --format "$XML_EXPORT" > "$XML_EXPORT_PRETTY"
