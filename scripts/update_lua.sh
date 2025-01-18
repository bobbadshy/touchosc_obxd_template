#!/bin/bash

echo -e "\n == Replacing .lua in .xml ==\n"

MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

# shellcheck disable=SC2034
REPO=$(realpath "$MYDIR/..")
BUILDDIR=$(realpath "$MYDIR/../build")
SOURCEDIR=$(realpath "$MYDIR/../source")

lua_files="$BUILDDIR/lua_min"

cd "$lua_files" || exit

target="$BUILDDIR/obxd.xml"
xml="$SOURCEDIR/xml/obxd.xml"

cp -a "$xml" "$target"

# shellcheck disable=SC2045
for each in $(ls -1); do
  echo -n "Replacing $each in $(basename "$target") ... "
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

