#!/bin/bash
#
# Compresses all .xml files back into .tosc
#

# read config
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/config.sh"

source="$XML_EXPORT"
target="$XML_EXPORT_PLAIN"

echo -e "\n == Removing eye-candy from $target ==\n"

#####
# All eye-candy backgrounds with extra design element were named "backdrop".
# Here, we manually delete those nodes from the xml file before compressing.
#
xmlstarlet ed -d '//node[@type="GROUP"]/children/node[properties/property[./value/text()="backdrop"]]' \
  <  "$source" \
  > "$target"

echo -e "\nDone.\n"
