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
  echo "Replacing $each in $(basename "$target") ... "

  lua="$(<"$each")"
  xmlstarlet ed --inplace -u \
    '//property/value[starts-with(text(), "--[[START '"$each"']]")]' \
    -v "$lua" \
    "$target"
done

echo

source="$XML_SOURCE_PLAIN"
target="$XML_EXPORT_PLAIN"

cp -a "$source" "$target" || exit 1

# shellcheck disable=SC2045
for each in  $(ls -1); do
  echo "Replacing $each in $(basename "$target") ... "

  lua="$(<"$each")"
  xmlstarlet ed --inplace -u \
    '//property/value[starts-with(text(), "--[[START '"$each"']]")]' \
    -v "$lua" \
    "$target"
done

echo -e "\nDone.\n"
