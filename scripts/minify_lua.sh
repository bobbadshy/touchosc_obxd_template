#!/bin/bash

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"

echo -e "\n == Minify lua ==\n"

cd "$SOURCEDIR_LUA" || exit 1

# shellcheck disable=SC2045
for each in $(ls -1); do
  echo -e "Minifying: $each >> $BUILDDIR_LUA/$(basename "$each")"
  lua=$(luamin -f "$each")
  echo -n "--[[START $each]]$lua--[[END $each]]" > "$BUILDDIR_LUA/$(basename "$each")";
done

echo -e "\nDone.\n"
