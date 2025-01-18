#!/bin/bash
#
# Uncompresses the .tosc file into .xml
#
# IMPORTANT! Run from repo root with:
#
# ./scripts/decompress.sh
#

t=".export/"

mkdir -p "$t"

for f in $(find . -maxdepth 1 -type f -name '*.tosc'); do
  echo "Decompressing $f to $t .. also formats the .xml a bit better to allow for better showing a git diff on it"
  # pigz -c -d < "$f" | sed -r 's#(<[a-z]+>)<#\1\n<#g' - > "$t$(basename $f .tosc).xml"
  # shellcheck disable=SC2086
  pigz -c -d < "$f" > "$t$(basename $f .tosc).xml"
done
