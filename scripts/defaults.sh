#!/bin/bash
#
# Compresses all .xml files back into .tosc
#

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"

function replace {
  echo -e "\n == Replacing some default values in $target ==\n"

  # Set movie frame to 1
  xmlstarlet ed -u '//property[value="movie"]/../property[key="tag"]/./value' -v "1" \
    <  "$target" \
    > "$target.tmp"
  mv "$target.tmp" "$target"

  echo -e "\nDone.\n"
}

target="$XML_EXPORT"
replace

target="$XML_EXPORT_PLAIN"
replace
