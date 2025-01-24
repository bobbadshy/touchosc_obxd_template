#!/bin/bash

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"

source="$XML_SOURCE"
target="$XML_EXPORT"

echo -e "\n == Replacing minified .lua in $SOURCEDIR ==\n"

cd "$BUILDDIR_LUA" || exit 1

cp -a "$source" "$target" || exit 1

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
  $i += s|<!\[CDATA\[--\[\[START '"$each"'\]\].+?--\[\[END '"$each"'\]\]\]\]></value>|<![CDATA['"$lua"']]></value>|g;
  print;
}

END {
  print STDERR "replaced $i\n";
};
' < "$target.tmp" > "$target"
done

rm "$target.tmp"

echo

source="$XML_SOURCE_PLAIN"
target="$XML_EXPORT_PLAIN"

cp -a "$source" "$target" || exit 1

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
  $i += s|<!\[CDATA\[--\[\[START '"$each"'\]\].+?--\[\[END '"$each"'\]\]\]\]></value>|<![CDATA['"$lua"']]></value>|g;
  print;
}

END {
  print STDERR "replaced $i\n";
};
' < "$target.tmp" > "$target"
done

rm "$target.tmp"

echo -e "\nDone.\n"
