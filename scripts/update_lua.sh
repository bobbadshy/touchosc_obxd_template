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
  count=$(xmlstarlet sel -t -c \
    'count(//property/value[starts-with(text(), "--[[START '"$each"']]")])' \
    "$target")
  echo "Replacing $count times $each in $(basename "$target") ... "

  lua="$(<"$each")"
  xmlstarlet ed --inplace -u \
    '//property/value[starts-with(text(), "--[[START '"$each"']]")]' \
    -v "$lua" \
    "$target"
done

echo -e "\nDone.\n"
