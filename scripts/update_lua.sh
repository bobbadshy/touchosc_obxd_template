#!/bin/bash

echo -e "\n == Replacing .lua in .xml ==\n"

lua_files="build/lua_min"

cd "$lua_files" || exit

target="../../build/obxd.xml"

xml="../../source/xml/obxd.xml"

for each in $(ls -1); do
  echo "Replacing $each ..."
  lua="$(<"$each")"
  perl -pe "s|\<value\>\<\!\[CDATA\[--\[\[START $each\]\].+?--\[\[END $each\]\]]\]\>\</value\>|$lua|" \
    < "$xml" \
    > "$target"

done
