#!/bin/bash
#
# Compresses all .xml files back into .tosc
#
# IMPORTANT! Run from repo root with:
#
# ./scripts/compress.sh
#

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck disable=SC2034
REPO=$(realpath "$MYDIR/..")
BUILDDIR=$(realpath "$MYDIR/../build")
SOURCEDIR=$(realpath "$MYDIR/../source")

cd "$MYDIR" || exit 1

echo -e "\n == Compress .xml to .tosc ==\n"

s="$SOURCEDIR/xml/obxd.xml"
t="$BUILDDIR/$(basename "$s" .xml).tosc"

echo -e "Compressing $s >> $t"
pigz -c -z < "$s" > "$t"
