#!/bin/bash

echo "Minify lua.."

cd "source/lua_scripts" || exit

t="../../build/lua_min"
mkdir -p "$t"

# shellcheck disable=SC2045
for each in $(ls -1); do
  luamin -f "$each" > "$t/$each";
done
