#!/bin/bash
# shellcheck disable=SC2034

#####
#
NAME="obxd"
#
#####

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

REPO=$(realpath "$SCRIPTDIR/..")

mkdir -p "$REPO/_build" || exit 1
BUILDDIR=$(realpath "$REPO/_build")

mkdir -p "$BUILDDIR/lua_min" || exit 1
BUILDDIR_LUA=$(realpath "$BUILDDIR/lua_min")

SOURCEDIR=$(realpath "$REPO/source")
SOURCEDIR_LUA=$(realpath "$SOURCEDIR/lua_scripts")

mkdir -p "$REPO/_export" || exit 1
EXPORTDIR=$(realpath "$REPO/_export")

NAME_XML="$NAME.xml"
NAME_TOSC="$NAME.tosc"

XML_SOURCE="$SOURCEDIR/xml/$NAME_XML"
XML_BUILD="$BUILDDIR/$NAME_XML"
XML_EXPORT="$EXPORTDIR/$NAME_XML"
TOSC_BUILD="$BUILDDIR/$NAME_TOSC"
TOSC_FINAL="$REPO/$NAME_TOSC"

cd "$SCRIPTDIR" || exit 1
