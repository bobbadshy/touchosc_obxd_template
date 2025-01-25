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

XML_EXPORT="$EXPORTDIR/$NAME_XML"
XML_EXPORT_PLAIN="$EXPORTDIR/${NAME_XML%.xml}_plain.xml"
XML_EXPORT_PRESETS="$EXPORTDIR/${NAME_XML%.xml}_presets.xml"

XML_EXPORT_PRESETSTORE="$EXPORTDIR/presetstore.xml"

XML_SOURCE="$SOURCEDIR/xml/$NAME_XML"
XML_SOURCE_PLAIN="$SOURCEDIR/xml/${NAME_XML%.xml}_plain.xml"

XML_BUILD="$BUILDDIR/$NAME_XML"
XML_BUILD_PLAIN="$BUILDDIR/${NAME_XML%.xml}_plain.xml"

TOSC_BUILD="$BUILDDIR/$NAME_TOSC"
TOSC_BUILD_PLAIN="$BUILDDIR/${NAME_TOSC%.tosc}_plain.tosc"
TOSC_BUILD_PRESETS="$BUILDDIR/${NAME_TOSC%.tosc}_presets.tosc"

TOSC_FINAL="$REPO/$NAME_TOSC"
TOSC_FINAL_PLAIN="$REPO/${NAME_TOSC%.tosc}_plain.tosc"
TOSC_FINAL_PRESETS="$REPO/${NAME_TOSC%.tosc}_presets.tosc"

TOSC_PRESETSTORE="$REPO/presetstore.tosc"

cd "$SCRIPTDIR" || exit 1
