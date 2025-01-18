#!/bin/bash
#
# Compresses all .xml files back into .tosc
#
# IMPORTANT! Run from repo root with:
#
# ./scripts/compress.sh
#

s="source/xml"
t="build/"

mkdir -p "$t"

# shellcheck disable=SC2044
for f in $(find $s -type f -name '*.xml'); do
  echo "Compressing $f to $t"
  # shellcheck disable=SC2086
  pigz -c -z < "$f" > "$t$(basename $f .xml).tosc"
done
