#!/bin/bash

./scripts/minify_lua.sh
./scripts/update_lua.sh
./scripts/compress.sh

echo
cp -av build/obxd.tosc ./
cp -av source/obxd_midi_mapping/TouchOsc.xml ./

echo -e "\nDone.\n"