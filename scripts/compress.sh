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

echo -e "Compressing $XML_BUILD >> $TOSC_BUILD"
pigz -c -z < "$XML_BUILD" > "$TOSC_BUILD"
