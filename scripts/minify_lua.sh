#!/bin/bash

echo -e "\n == Minify lua ==\n"

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck disable=SC2034
REPO=$(realpath "$MYDIR/..")
BUILDDIR=$(realpath "$MYDIR/../build")
SOURCEDIR=$(realpath "$MYDIR/../source")

echo -e "\n == Compress .xml to .tosc ==\n"

t="$BUILDDIR/lua_min"
mkdir -p "$t"

cd "$SOURCEDIR/lua_scripts" || exit 1

# shellcheck disable=SC2045
for each in $(ls -1); do
  echo -e "Minifying: $each >> $t/$(basename "$each")"
  lua=$(luamin -f "$each")
  echo -n "--[[START $each]]$lua--[[END $each]]" > "$t/$(basename "$each")";
done
