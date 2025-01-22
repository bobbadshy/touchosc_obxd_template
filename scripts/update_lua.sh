#!/bin/bash

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"

echo -e "\n == Replacing minified .lua in .xml ==\n"

cd "$BUILDDIR_LUA" || exit 1

target="$XML_BUILD"
xml="$XML_SOURCE"

cp -a "$xml" "$target" || exit 1

# shellcheck disable=SC2045
for each in  $(ls -1); do
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
  # $i += s|--\[\[START '"$each"'\]\].+?--\[\[END '"$each"'\]\]|'"$lua"'|g;

rm "$target.tmp"

echo -e "\n == Replacing minified .lua in pretty-formatted .xml ==\n"


target="$XML_BUILD_PLAIN"
xml="$XML_SOURCE_PRETTY"

cp -a "$xml" "$target" || exit 1

# shellcheck disable=SC2045
for each in  $(ls -1); do
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
  # $i += s|--\[\[START '"$each"'\]\].+?--\[\[END '"$each"'\]\]|'"$lua"'|g;

rm "$target.tmp"

echo
