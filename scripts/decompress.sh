#!/bin/bash
#
# Uncompresses the .tosc file into .xml
#
# IMPORTANT! Run from repo root with:
#
# ./scripts/decompress.sh
#

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

REPO=$(realpath "$MYDIR/..")
# shellcheck disable=SC2034
BUILDDIR=$(realpath "$MYDIR/../build")
# shellcheck disable=SC2034
SOURCEDIR=$(realpath "$MYDIR/../source")

cd "$MYDIR" || exit 1
mkdir -p "$REPO/export" || exit 1

s="$REPO/obxd.tosc"
t="$REPO/export/$(basename "$s" .tosc).xml"

echo "Decompressing $s to $t .."

pigz -c -d < "$s" > "$t"
