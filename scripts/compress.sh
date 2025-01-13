#!/bin/bash
#
# Compresses all .xml files back into .tosc
#
# IMPORTANT! Run from repo root with:
#
# ./scripts/compress.sh
#

s="xml_export/"
t="newly_packed/"

mkdir -p "$t"

for f in $(find $s -type f -name '*.xml'); do
  echo "Compressing $f to $t .. also formats the .xml a bit better to allow for better showing a git diff on it"
  # shellcheck disable=SC2086
  pigz -c -z < "$f" > "$t$(basename $f .xml).tosc"
done
