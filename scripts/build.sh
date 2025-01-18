#!/bin/bash

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

REPO=$(realpath "$MYDIR/..")
BUILDDIR=$(realpath "$MYDIR/../build")
SOURCEDIR=$(realpath "$MYDIR/../source")

cd "$MYDIR" || exit 1
mkdir -p "$BUILDDIR" || exit 1

./minify_lua.sh
./update_lua.sh
./compress.sh

echo
cp -av "$BUILDDIR/obxd.tosc" "$REPO/obxd.tosc"
cp -av "$SOURCEDIR/obxd_midi_mapping/TouchOsc.xml" "$REPO/TouchOsc.xml"

echo -e "\nDone.\n"