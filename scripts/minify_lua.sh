#!/bin/bash

echo -e "\n == Minify lua ==\n"

cd "source/lua_scripts" || exit

t="../../build/lua_min"
mkdir -p "$t"

# shellcheck disable=SC2045
for each in $(ls -1); do
  echo "Minifying $each ..."
  lua=$(luamin -f "$each")
  echo -n "--[[START $each]]$lua--[[END $each]]" > "$t/$each";
done
