#!/bin/bash

echo -e "\n == Replacing .lua in .xml ==\n"

lua_files="build/lua_min"

cd "$lua_files" || exit

target="../../build/obxd.xml"
xml="../../source/xml/obxd.xml"

cp -a "$xml" "$target"

# shellcheck disable=SC2045
for each in $(ls -1); do
  echo -n "Replacing $each in $(basename $target) ... "
  mv "$target" "$target.tmp"
  lua="$(<"$each")"
  perl -e '
use strict;
use warnings;
my $i = 0;

while (<>) {
  $i += s|--\[\[START '"$each"'\]\].+?--\[\[END '"$each"'\]\]|'"$lua"'|g;
  print;
}

END {
  print STDERR "replaced $i\n";
};
' < "$target.tmp" > "$target"
done

rm "$target.tmp"

