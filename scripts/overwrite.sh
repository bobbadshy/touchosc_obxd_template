#!/bin/bash

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

REPO=$(realpath "$MYDIR/..")
# shellcheck disable=SC2034
BUILDDIR=$(realpath "$MYDIR/../build")
# shellcheck disable=SC2034
SOURCEDIR=$(realpath "$MYDIR/../source")

cd "$MYDIR" || exit 1
./decompress.sh || exit 1

mv "$SOURCEDIR/xml/obxd.xml" "$SOURCEDIR/xml/obxd.xml.bak"
cp -av "$REPO/export/obxd.xml" "$SOURCEDIR/xml/obxd.xml"
