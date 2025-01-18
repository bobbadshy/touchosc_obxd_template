#!/bin/bash
#
# Uncompresses the .tosc file into .xml
#
# IMPORTANT! Run from repo root with:
#
# ./scripts/decompress.sh
#

s="obxd.tosc"
t=".export"

mkdir -p "$t"

echo "Decompressing $s to $t/$(basename $s .tosc).xml .."

pigz -c -d < "$s" > "$t/$(basename $s .tosc).xml"
