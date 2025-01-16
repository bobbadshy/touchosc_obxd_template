#!/bin/bash

cd "lua_scripts" || exit

# shellcheck disable=SC2045
for each in $(ls -1); do
  luamin -f "$each" > ../lua_min"/$each";
done
